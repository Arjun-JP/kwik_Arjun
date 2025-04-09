import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/order%20details%20bloc/order_details_event.dart';
import 'package:kwik/bloc/order%20details%20bloc/order_details_state.dart';
import 'package:kwik/models/order_model.dart';
import 'package:kwik/repositories/order_deiails_repo.dart';

class OrderDetailsBloc extends Bloc<OrderDetailsEvent, OrderDetailsState> {
  final OrderDeiailsRepo orderRepository;

  OrderDetailsBloc(this.orderRepository) : super(OrderDetailsInitial()) {
    on<FetchOrderDetails>((event, emit) async {
      emit(OrderDetailsLoading());
      try {
        final orderdata =
            await orderRepository.getorderdetails(orderID: event.orderId);

        Order order = Order.fromJson(orderdata["data"]);

        emit(OrderDetailsLoaded(order));
      } catch (e) {
        emit(OrderDetailsError('Failed to fetch order: ${e.toString()}'));
      }
    });
  }
}
