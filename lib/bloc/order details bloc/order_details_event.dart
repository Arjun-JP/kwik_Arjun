abstract class OrderDetailsEvent {}

class FetchOrderDetails extends OrderDetailsEvent {
  final String orderId;

  FetchOrderDetails(this.orderId);
}
