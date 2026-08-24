import 'package:loqma/models/offer_model.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final String userName;
  final String userPhone;
  final String userAddress; 
  final Map<Offer, int> orderedItems;
  final double totalPrice;
  final DateTime orderDate;
  
  String status; 
  String? volunteerId;
  String? volunteerName;
  String? volunteerPhone;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.userAddress,
    required this.orderedItems,
    required this.totalPrice,
    required this.orderDate,
    this.status = "Pending",
    this.volunteerId,
    this.volunteerName,
    this.volunteerPhone,
  });
}
