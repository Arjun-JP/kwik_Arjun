abstract class OrderManagementEvent {}

class PlaceOrder extends OrderManagementEvent {
  final Map<String, dynamic> orderJson;

  PlaceOrder({
    required this.orderJson,
  });
}

class CreateorderOnlinePayment extends OrderManagementEvent {
  final Map<String, dynamic> orderJson;
  final String uid;

  CreateorderOnlinePayment({required this.orderJson, required this.uid});
}

class CheckOrderStatus extends OrderManagementEvent {
  final String orderId;

  CheckOrderStatus({required this.orderId});
}

class CheckLiveOrders extends OrderManagementEvent {
  final String userId;

  CheckLiveOrders({required this.userId});
}

class UpdateDeliveryType extends OrderManagementEvent {
  final String newDeliveryType; // 'instant' or 'slot'
  final String selectedSlot;

  UpdateDeliveryType({
    required this.newDeliveryType,
    required this.selectedSlot,
  });
}
