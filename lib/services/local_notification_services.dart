import 'package:loqma/models/notification_model.dart';
import 'package:loqma/models/order_model.dart';

class LocalNotificationService {
  static final List<NotificationModel> _allNotifications = [];

  static List<NotificationModel> getNotificationsForUser(String userId) {
    return _allNotifications
        .where((notification) => notification.receiverId == userId)
        .toList();
  }

  static void createOrderNotifications({required OrderModel order}) {
    final now = DateTime.now().microsecondsSinceEpoch;

    _allNotifications.insert(
      0,
      NotificationModel(
        id: '${now}_user',
        title: 'Order Confirmed',
        message: 'Your order #${order.orderId} has been placed successfully.',
        date: DateTime.now(),
        receiverId: order.userId,
        order: order,
      ),
    );

    if (order.volunteerId != null && order.volunteerId!.isNotEmpty) {
      _allNotifications.insert(
        0,
        NotificationModel(
          id: '${now + 1}_volunteer',
          title: 'New Delivery Assigned',
          message: 'You have a new delivery order #${order.orderId} to fulfill.',
          date: DateTime.now(),
          receiverId: order.volunteerId!,
          order: order,
        ),
      );
    }
  }

  static void addPenaltyNotification({
    required String userId,
    required double penaltyAmount,
    required String offerTitle,
  }) {
    _allNotifications.insert(
      0,
      NotificationModel(
        id: '${DateTime.now().microsecondsSinceEpoch}_penalty',
        title: 'Fine Applied',
        message:
            'A penalty fee of $penaltyAmount JOD was charged for failing to pick up: $offerTitle.',
        date: DateTime.now(),
        receiverId: userId,
        penaltyAmount: penaltyAmount,
      ),
    );
  }

  static void clearAllForUser(String userId) {
    _allNotifications.removeWhere((n) => n.receiverId == userId);
  }
}
