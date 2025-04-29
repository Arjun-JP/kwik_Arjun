abstract class OrderManagementState {}

class OrderInitial extends OrderManagementState {
  final String deliveryTypel = '';
}

class OrderPlacing extends OrderManagementState {}

class OrderPlaced extends OrderManagementState {
  final Map<String, dynamic> orderResponse;

  OrderPlaced({required this.orderResponse});
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

class OrderError extends OrderManagementState {
  final String message;

  OrderError({required this.message});
}
