abstract class OrderManagementState {}

class PlaceorderOrderInitial extends OrderManagementState {
  final String deliveryTypel = '';
}

class OrderPlacing extends OrderManagementState {}

class OrderPlaced extends OrderManagementState {
  final Map<String, dynamic> orderResponse;

  OrderPlaced({required this.orderResponse});
}

class OrderPlacedOnline extends OrderManagementState {
  final Map<String, dynamic> orderResponse;

  OrderPlacedOnline({required this.orderResponse});
}

class OrderStatusLoading extends OrderManagementState {}

class OrderStatusLoaded extends OrderManagementState {
  final Map<String, dynamic> status;

  OrderStatusLoaded({required this.status});
}

class LiveOrdersLoading extends OrderManagementState {}

class LiveOrdersLoaded extends OrderManagementState {
  final List<dynamic> orders;

  LiveOrdersLoaded({required this.orders});
}

class DeliveryTypeUpdating extends OrderManagementState {}

class DeliveryTypeUpdated extends OrderManagementState {
  final String deliveryType;
  final String selectedslot;
  DeliveryTypeUpdated({required this.deliveryType, required this.selectedslot});
}

class PlaceorderOrderError extends OrderManagementState {
  final String message;

  PlaceorderOrderError({required this.message});
}

class CreateOrderOnlinepaymentLoading extends OrderManagementState {}

class CreateOrderOnlinepaymentplaced extends OrderManagementState {
  final Map<String, dynamic> orderResponse;

  CreateOrderOnlinepaymentplaced({required this.orderResponse});
}
