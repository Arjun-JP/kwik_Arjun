import 'package:equatable/equatable.dart';
import 'package:kwik/models/order_model.dart';

abstract class OrderState extends Equatable {
  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final List<Order> orders;

  OrderLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

class OrderError extends OrderState {
  final String message;

  OrderError(this.message);

  @override
  List<Object> get props => [message];
}

class Orderagainloading extends OrderState {
  final List<Order> orders;
  final String orderid;

  Orderagainloading(this.orders, this.orderid);

  @override
  List<Object> get props => [orders, orderid];
}

class Orderagaincompleted extends OrderState {
  final List<Order> orders;
  final String orderid;

  Orderagaincompleted(this.orders, this.orderid);

  @override
  List<Object> get props => [orders, orderid];
}

class Orderagainfaild extends OrderState {
  final List<Order> orders;
  final String orderid;

  Orderagainfaild(this.orders, this.orderid);

  @override
  List<Object> get props => [orders, orderid];
}
