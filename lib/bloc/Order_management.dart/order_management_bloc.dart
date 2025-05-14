import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/Order_management.dart/order_management_event.dart';
import 'package:kwik/bloc/Order_management.dart/order_management_state.dart';
import 'package:kwik/repositories/manage_order_repo.dart';

class OrderManagementBloc
    extends Bloc<OrderManagementEvent, OrderManagementState> {
  final OrderManagementRepository orderRepository;

  OrderManagementBloc({required this.orderRepository})
      : super(PlaceorderOrderInitial()) {
    on<PlaceOrder>(_onPlaceOrder);
    on<CreateorderOnlinePayment>(_onCreateOrderonlinepayment);
    on<CheckOrderStatus>(_onCheckOrderStatus);
    on<CheckLiveOrders>(_onCheckLiveOrders);
    on<UpdateDeliveryType>(_onUpdateDeliveryType);
  }

  Future<void> _onPlaceOrder(
      PlaceOrder event, Emitter<OrderManagementState> emit) async {
    emit(OrderPlacing());

    try {
      final response =
          await orderRepository.placeOrder(orderJson: event.orderJson);

      if (response['success']) {
        emit(OrderPlaced(orderResponse: response));
      } else {
        emit(PlaceorderOrderError(message: response['message']));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onCheckOrderStatus(
      CheckOrderStatus event, Emitter<OrderManagementState> emit) async {
    emit(OrderStatusLoading());
    try {
      final status = await orderRepository.getOrderStatus(event.orderId);
      emit(OrderStatusLoaded(status: status));
    } catch (e) {
      emit(PlaceorderOrderError(message: e.toString()));
    }
  }

  Future<void> _onCheckLiveOrders(
      CheckLiveOrders event, Emitter<OrderManagementState> emit) async {
    emit(LiveOrdersLoading());
    try {
      final orders = await orderRepository.getLiveOrders(event.userId);
      emit(LiveOrdersLoaded(orders: orders));
    } catch (e) {
      emit(PlaceorderOrderError(message: e.toString()));
    }
  }

  Future<void> _onUpdateDeliveryType(
      UpdateDeliveryType event, Emitter<OrderManagementState> emit) async {
    emit(DeliveryTypeUpdating());
    try {
      if (event.newDeliveryType == "instant") {
        emit(DeliveryTypeUpdated(
            deliveryType: "instant", selectedslot: event.selectedSlot));
      } else {
        emit(DeliveryTypeUpdated(
            deliveryType: "slot", selectedslot: event.selectedSlot));
      }
    } catch (e) {
      emit(PlaceorderOrderError(message: e.toString()));
    }
  }

  Future<void> _onCreateOrderonlinepayment(CreateorderOnlinePayment event,
      Emitter<OrderManagementState> emit) async {
    emit(CreateOrderOnlinepaymentLoading());

    try {
      final response = await orderRepository.createOrderOnlinepayment(
          uid: event.uid, orderJson: event.orderJson);

      if (response['success']) {
        emit(OrderPlacedOnline(orderResponse: response));
      } else {
        emit(PlaceorderOrderError(message: response['message']));
      }
    } catch (e) {
      print(e);
    }
  }
}
