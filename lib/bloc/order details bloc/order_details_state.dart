import 'package:kwik/models/order_model.dart';

abstract class OrderDetailsState {}

class OrderDetailsInitial extends OrderDetailsState {}

class OrderDetailsLoading extends OrderDetailsState {}

class OrderDetailsLoaded extends OrderDetailsState {
  final Order order;

  OrderDetailsLoaded(this.order);
}

class OrderDetailsError extends OrderDetailsState {
  final String message;

  OrderDetailsError(this.message);
}
