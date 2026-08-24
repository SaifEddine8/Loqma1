import 'package:flutter/material.dart';
import 'package:loqma/db/offers_db.dart';
import 'package:loqma/models/notification_model.dart';
import 'package:loqma/models/offer_model.dart';
import 'package:loqma/models/order_model.dart';
import 'package:loqma/models/user_model.dart'; 
import 'package:loqma/services/local_notification_services.dart';

class CartProvider with ChangeNotifier {
  final Map<String, Map<Offer, int>> _userCarts = {}; 
  
  String? _currentUserId;
  final List<OrderModel> _allOrders = [];

  double subTotal = 0.0;
  double tax = 0.0;

  List<OrderModel> get allOrders => _allOrders;

  Map<Offer, int> get _currentCart {
    final activeId = _currentUserId ?? "guest_user";
    return _userCarts.putIfAbsent(activeId, () => {});
  }

  List<Offer> get cartItems => _currentCart.keys.toList();
  Map<Offer, int> get fullCartMap => Map.from(_currentCart);

  double get total => subTotal + tax;

  int getQuantity(Offer offer) {
    Offer? target = _currentCart.keys.firstWhere((o) => o.id == offer.id, orElse: () => offer);
    return _currentCart[target] ?? 1;
  }

  List<OrderModel> getMyOrders(String userId) {
    return _allOrders.where((order) => order.userId == userId).toList();
  }

  void fetchUserCart(String userId) {
    _currentUserId = userId;
    
    if (!_userCarts.containsKey(userId)) {
      _userCarts[userId] = {};
    }

    sum();
  }

  void clearData() {
    _currentUserId = null;
    subTotal = 0.0;
    tax = 0.0;
    notifyListeners();
  }

  void addToCart(Offer offer) {
    bool isAlreadyInCart = _currentCart.keys.any((o) => o.id == offer.id);
    
    if (!isAlreadyInCart) {
      _currentCart[offer] = 1;
      sum();
    }
    notifyListeners();
  }
  
  void removeFromCart(Offer offer) {
    Offer? target = _currentCart.keys.firstWhere((o) => o.id == offer.id, orElse: () => offer);
    if (_currentCart.containsKey(target)) {
      _currentCart.remove(target);
      sum();
    }
    notifyListeners();
  } 

  void increament(Offer offer) {
    Offer? target = _currentCart.keys.firstWhere((o) => o.id == offer.id, orElse: () => offer);
    
    int maxAvailable = offersNotifier.value.firstWhere((o) => o.id == offer.id).quantity;

    if (_currentCart.containsKey(target)) {
      if (_currentCart[target]! < maxAvailable) {
        _currentCart[target] = _currentCart[target]! + 1;
        sum();
      } else {
        print("عذراً، لقد وصلت للحد الأقصى المتاح من هذه الوجبة في المطعم!");
      }
    }
  }

  void decreament(Offer offer) {
    Offer? target = _currentCart.keys.firstWhere((o) => o.id == offer.id, orElse: () => offer);
    if (_currentCart.containsKey(target) && _currentCart[target]! > 1) {
      _currentCart[target] = _currentCart[target]! - 1;
      sum();
    }
  }

  void sum() {
    subTotal = _currentCart.entries.fold<double>(
      0,
      (sum, item) => item.key.type == OfferType.donation ? sum + 0 : sum + (item.key.price! * item.value),
    );
    tax = subTotal * 0.05;
    notifyListeners();
  }

 
  OrderModel? processCheckout({
    required UserModel currentUser,
  }) {
    if (_currentCart.isEmpty) {
      print("Checkout failed: Cart is empty.");
      return null;
    }

    for (var entry in _currentCart.entries) {
      Offer cartOffer = entry.key;
      int requestedQty = entry.value;

      int index = offersNotifier.value.indexWhere((o) => o.id == cartOffer.id);
      if (index != -1) {
        int currentStock = offersNotifier.value[index].quantity;
        int newStock = (currentStock - requestedQty).clamp(0, currentStock);

        offersNotifier.value[index] = offersNotifier.value[index].copyWith(quantity: newStock);
      }
    }

    offersNotifier.value = List.from(offersNotifier.value);

    OrderModel receipt = OrderModel(
      orderId: DateTime.now().millisecondsSinceEpoch.toString().substring(5),
      userId: currentUser.id.toString(),
      userName: currentUser.fullName ?? 'Customer',
      userPhone: currentUser.phone ?? 'N/A',
      userAddress: currentUser.location?.address ?? 'Amman, Jordan',
      orderedItems: Map.from(_currentCart),
      totalPrice: total,
      orderDate: DateTime.now(),
      status: "in preparation", 
      volunteerId: null,
      volunteerName: null,
      volunteerPhone: null,
    );

    _allOrders.add(receipt);

    LocalNotificationService.createOrderNotifications(order: receipt);

    _currentCart.clear();
    subTotal = 0.0;
    tax = 0.0;
    notifyListeners();

    return receipt;
  }

  List<OrderModel> getAvailableOrdersForVolunteers() {
    return _allOrders.where((order) => order.volunteerId == null && order.status.toLowerCase() == "pending").toList();
  }

  List<OrderModel> getMyAcceptedDeliveries(String volunteerId) {
    return _allOrders.where((order) => order.volunteerId == volunteerId).toList();
  }

  void acceptOrder({
    required OrderModel order,
    required String volunteerId,
    required String volunteerName,
    required String volunteerPhone,
  }) {
    order.volunteerId = volunteerId;
    order.volunteerName = volunteerName;
    order.volunteerPhone = volunteerPhone;
    order.status = "in preparation";

    LocalNotificationService.createOrderNotifications(order: order);

    notifyListeners();
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final index = _allOrders.indexWhere((o) => o.orderId == orderId);
    if (index != -1) {
      _allOrders[index].status = newStatus;
      notifyListeners();
    }
  }
}
