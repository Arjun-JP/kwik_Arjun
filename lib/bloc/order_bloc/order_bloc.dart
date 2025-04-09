import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/models/order_model.dart';
import 'package:kwik/repositories/order_history_repo.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepository;

  OrderBloc({required this.orderRepository}) : super(OrderInitial()) {
    on<FetchOrders>(_onFetchOrders);
    on<Orderagain>(_onOrderagain);
  }

  Future<void> _onFetchOrders(
      FetchOrders event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final orders = await orderRepository.fetchOrders(event.userId);

      emit(OrderLoaded(orders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onOrderagain(Orderagain event, Emitter<OrderState> emit) async {
    if (state is! OrderLoaded) return;

    final currentState = state as OrderLoaded;
    List<Order> orderlist = currentState.orders;
    emit(Orderagainloading(orderlist, event.orderid));

    try {
      final success = await orderRepository.orderagain(
        userId: event.userId,
        orderID: event.orderid,
      );

      if (success) {
        emit(Orderagaincompleted(orderlist, event.orderid));
      } else {
        emit(Orderagainfaild(orderlist, event.orderid));
      }
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}
