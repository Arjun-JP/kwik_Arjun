import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchOrders extends OrderEvent {
  final String userId;

  FetchOrders(this.userId);

  @override
  List<Object> get props => [userId];
}

class Orderagain extends OrderEvent {
  final String userId;
  final String orderid;
  Orderagain({required this.userId, required this.orderid});

  @override
  List<Object> get props => [userId, orderid];
}
