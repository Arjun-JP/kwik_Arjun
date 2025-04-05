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
