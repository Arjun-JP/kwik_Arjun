import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/Cart_bloc/cart_bloc.dart';
import 'package:kwik/bloc/Cart_bloc/cart_event.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_bloc.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_event.dart';
import 'package:kwik/bloc/order_bloc/order_bloc.dart';
import 'package:kwik/bloc/order_bloc/order_event.dart';
import 'package:kwik/bloc/order_bloc/order_state.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/constants/format_time.dart';
import 'package:kwik/models/order_model.dart';
import 'package:kwik/widgets/shimmer/order_list_page_shimmer.dart';

class OrderListingPage extends StatefulWidget {
  @override
  State<OrderListingPage> createState() => _OrderListingPageState();
}

class _OrderListingPageState extends State<OrderListingPage> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<OrderBloc>().add(FetchOrders("s5ZdLnYhnVfAramtr7knGduOI872"));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text("Orders",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          leading: IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_left_rounded,
              size: 35,
            ),
            onPressed: () => context.pop(), // FIXED: added parentheses
          ),
        ),
        body: BlocBuilder<OrderBloc, OrderState>(builder: (context, state) {
          print(state is OrderLoaded ? state.orders.length : "0");
          if (state is OrderLoading) {
            return const OrderListPageShimmer();
          }
          if (state is OrderLoaded) {
            return Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      state.orders.length,
                      (index) => OrderCard(
                        orderData: state.orders[index],
                        theme: theme,
                      ),
                    ),
                  ),
                )),

                // bottomCartBanner(theme: theme, ctx: context),
              ],
            );
          } else if (state is Orderagainloading) {
            return Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      state.orders.length,
                      (index) => OrderCard(
                        orderData: state.orders[index],
                        theme: theme,
                      ),
                    ),
                  ),
                )),

                // bottomCartBanner(theme: theme, ctx: context),
              ],
            );
          } else if (state is Orderagaincompleted) {
            return Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      state.orders.length,
                      (index) => OrderCard(
                        orderData: state.orders[index],
                        theme: theme,
                      ),
                    ),
                  ),
                )),

                // bottomCartBanner(theme: theme, ctx: context),
              ],
            );
          } else if (state is Orderagainfaild) {
            return Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      state.orders.length,
                      (index) => OrderCard(
                        orderData: state.orders[index],
                        theme: theme,
                      ),
                    ),
                  ),
                )),

                // bottomCartBanner(theme: theme, ctx: context),
              ],
            );
          }
          return const SizedBox();
        }));
  }
}

// }

class OrderCard extends StatelessWidget {
  final Order orderData;
  final ThemeData theme;

  const OrderCard({super.key, required this.orderData, required this.theme});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return InkWell(
      onTap: () {
        context.push('/order/${orderData.id}');
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Images
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    orderData.products.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 247, 231),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Image.network(
                              orderData.products[index].productRef.productImages
                                  .first,
                              height: 80,
                              width: 80,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(
                              width: 100,
                              child: Text(
                                  orderData
                                      .products[index].productRef.productName,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                      color: Colors.black, fontSize: 10)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Order Status and Total
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      Text(orderData.orderStatus,
                          style: theme.textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w900,
                              color: orderData.orderStatus == "Order placed"
                                  ? Colors.orange
                                  : orderData.orderStatus == "Delivery failed"
                                      ? Colors.red
                                      : orderData.orderStatus == "Delivered"
                                          ? Colors.green
                                          : orderData.orderStatus == "Packing"
                                              ? const Color.fromARGB(
                                                  182, 86, 55, 240)
                                              : orderData.orderStatus ==
                                                      "Out for delivery"
                                                  ? Colors.blueGrey
                                                  : Colors.black)),
                      Text(
                          "Placed at ${formatIso8601Date(orderData.orderPlacedTime.toIso8601String())}",
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  Column(
                    spacing: 5,
                    children: [
                      Text(
                        " ₹${orderData.totalAmount}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 249, 200, 54),
                        ),
                        child: Text(
                          "saved  ₹${orderData.totalSaved}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
                      foregroundColor: Colors.black,
                    ),
                    child: const Text("Rate Order"),
                  ),
                  BlocListener<OrderBloc, OrderState>(
                    listenWhen: (previous, current) => current
                        is Orderagaincompleted, // only listen for this state
                    listener: (context, state) {
                      if (state is Orderagaincompleted) {
                        context.read<CartBloc>().add(SyncCartWithServer(
                            userId: "s5ZdLnYhnVfAramtr7knGduOI872"));
                        context
                            .read<NavbarBloc>()
                            .add(const UpdateNavBarIndex(3));
                        context.go('/cart');
                      }
                    },
                    child: BlocBuilder<OrderBloc, OrderState>(
                      builder: (context, state) {
                        if (state is Orderagainloading &&
                            state.orderid == orderData.id) {
                          return const SizedBox(
                            height: 35,
                            child: CircularProgressIndicator(
                              color: AppColors.buttonColorOrange,
                            ),
                          );
                        } else if (state is Orderagainfaild) {
                          return TextButton(
                            onPressed: () {
                              context.read<OrderBloc>().add(Orderagain(
                                  orderid: orderData.id,
                                  userId: "s5ZdLnYhnVfAramtr7knGduOI872"));
                            },
                            child: const Text(
                              "Order Again",
                              style: TextStyle(
                                  color: Colors.pink,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        }

                        return TextButton(
                          onPressed: () {
                            context.read<OrderBloc>().add(Orderagain(
                                orderid: orderData.id,
                                userId: "s5ZdLnYhnVfAramtr7knGduOI872"));
                          },
                          child: const Text(
                            "Order Again",
                            style: TextStyle(
                                color: Colors.pink,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
