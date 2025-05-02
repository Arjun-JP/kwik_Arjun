import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/Order_management.dart/order_management_event.dart';
import 'package:kwik/bloc/Order_management.dart/order_management_state.dart';
import 'package:kwik/repositories/manage_order_repo.dart';

class OrderManagementBloc
    extends Bloc<OrderManagementEvent, OrderManagementState> {
  final OrderManagementRepository orderRepository;

  OrderManagementBloc({required this.orderRepository}) : super(OrderInitial()) {
    on<PlaceOrder>(_onPlaceOrder);
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
      emit(OrderPlaced(orderResponse: response));
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }

  Future<void> _onCheckOrderStatus(
      CheckOrderStatus event, Emitter<OrderManagementState> emit) async {
    emit(OrderStatusLoading());
    try {
      final status = await orderRepository.getOrderStatus(event.orderId);
      emit(OrderStatusLoaded(status: status));
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }

  Future<void> _onCheckLiveOrders(
      CheckLiveOrders event, Emitter<OrderManagementState> emit) async {
    emit(LiveOrdersLoading());
    try {
      final orders = await orderRepository.getLiveOrders(event.userId);
      emit(LiveOrdersLoaded(orders: orders));
    } catch (e) {
      emit(OrderError(message: e.toString()));
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
      emit(OrderError(message: e.toString()));
    }
  }
}
