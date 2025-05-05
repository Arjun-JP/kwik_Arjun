import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/order%20details%20bloc/order_details_bloc.dart';
import 'package:kwik/bloc/order%20details%20bloc/order_details_event.dart';
import 'package:kwik/bloc/order%20details%20bloc/order_details_state.dart';
import 'package:kwik/bloc/order_bloc/order_bloc.dart';
import 'package:kwik/bloc/order_bloc/order_event.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/constants/format_time.dart';
import 'package:kwik/models/cart_model.dart';
import 'package:kwik/models/order_model.dart';
import 'package:kwik/widgets/shimmer/orderdetails_page_shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: use_key_in_widget_constructors
class OrderDetailsPage extends StatefulWidget {
  final String orderID;

  const OrderDetailsPage({super.key, required this.orderID});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  void initState() {
    context.read<OrderDetailsBloc>().add(FetchOrderDetails(widget.orderID));
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    ThemeData theme = Theme.of(context);
    return BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
        builder: (context, state) {
      return Scaffold(
          appBar: AppBar(
            title: Text(
              'Order #${state is OrderDetailsLoaded ? state.order.id : ""}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            centerTitle: false,
            leading: InkWell(
                onTap: () => context.pop(),
                child: const Icon(Icons.arrow_back_ios_new_rounded)),
          ),
          body: (state is OrderDetailsLoading)
              ? const OrderdetailsPageShimmer()
              : (state is OrderDetailsLoaded)
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildOrderHeader(
                              theme: theme, orderdata: state.order),
                          const SizedBox(height: 16),
                          _buildOrderItems(
                              theme: theme, orderdata: state.order),
                          const SizedBox(height: 24),
                          _buildBillSummary(
                              theme: theme, orderdata: state.order),
                          const SizedBox(height: 24),
                          _buildOrderDetails(
                              theme: theme, orderdata: state.order),
                          const SizedBox(height: 24),
                          _buildActionButtons(theme: theme, user: user),
                          const SizedBox(height: 35),
                        ],
                      ),
                    )
                  : const CircularProgressIndicator());
    });
  }

  Widget _buildOrderHeader(
      {required ThemeData theme, required Order orderdata}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Chip(
              label: Text(
                orderdata.orderStatus,
                style: theme.textTheme.bodyLarge,
              ),
              backgroundColor: Colors.green[50],
              labelStyle: const TextStyle(color: Colors.green),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          orderdata.orderStatus == "Delivered"
              ? 'Arrived in ${orderdata.completedTime}'
              : "Order placed time : ${formatIso8601Date(orderdata.orderPlacedTime != null ? orderdata.orderPlacedTime.toIso8601String() : "")}",
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildOrderItems(
      {required ThemeData theme, required Order orderdata}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          orderdata.products.length,
          (index) {
            return ListTile(
              leading: Image.network(
                  orderdata.products[index].productRef.productImages.first),
              title: Text(
                orderdata.products[index].productRef.productName,
                maxLines: 2,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orderdata.products[index].productRef.productDescription,
                    maxLines: 2,
                  ),
                  Text(
                    " ${orderdata.products[index].variant.qty} ${orderdata.products[index].variant.unit} x ${orderdata.products[index].quantity} unit",
                    maxLines: 2,
                  ),
                ],
              ),
              trailing: Column(
                children: [
                  Text(
                    "₹ ${(orderdata.products[index].variant.sellingPrice) * (orderdata.products[index].quantity)}",
                    style: theme.textTheme.bodyLarge,
                  ),
                  Text(
                      "₹ ${(orderdata.products[index].variant.mrp) * (orderdata.products[index].quantity)}",
                      style: theme.textTheme.bodyMedium!
                          .copyWith(decoration: TextDecoration.lineThrough))
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderItem(Order item, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.id,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text(item.id,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillSummary(
      {required ThemeData theme, required Order orderdata}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 10,
          children: [
            const Icon(
              Icons.receipt_outlined,
              color: Colors.blueGrey,
            ),
            Text('Bill Summary', style: theme.textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: 12),
        _buildBillRow('ItemS Total',
            '₹ ${calculateTotalSellingPrice(orderdata.products)}', theme),
        _buildBillRow('Delivery charge',
            '₹${orderdata.deliveryCharge.toStringAsFixed(2)} ', theme),
        _buildBillRow('Handling Charge',
            '₹${orderdata.handlingCharge!.toStringAsFixed(2)}', theme),
        _buildBillRow('High demand surge charge',
            '₹${orderdata.highDemandCharge!.toStringAsFixed(2)} ', theme),
        const Divider(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total Bill',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${orderdata.totalAmount.toStringAsFixed(2)} ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Incl. all taxes and charges',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'SAVED ',
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            Text(
              "₹${orderdata.totalSaved}",
              style: const TextStyle(
                  color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // TextButton(
        //   onPressed: () {},
        //   style: TextButton.styleFrom(),
        //   child: const Text('Download Invoice / Credit Note'),
        // ),
      ],
    );
  }

  Widget _buildBillRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyLarge,
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildOrderDetails(
      {required ThemeData theme, required Order orderdata}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Order Details',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildDetailRow('Order ID', orderdata.id),
        const SizedBox(height: 16),
        const SizedBox(height: 16),
        const Text('Delivery Address',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(
          orderdata.userAddress.addressType,
          style: theme.textTheme.bodyMedium,
        ),
        Text(
          orderdata.userAddress.floor,
          style: theme.textTheme.bodyMedium,
        ),
        Text(
          orderdata.userAddress.flatNoName,
          style: theme.textTheme.bodyMedium,
        ),
        Text(
          orderdata.userAddress.landmark,
          style: theme.textTheme.bodyMedium,
        ),
        Text(
          orderdata.userAddress.phoneNo,
          style: theme.textTheme.bodyMedium,
        ),
        Text(
          orderdata.userAddress.pincode,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        _buildDetailRow(
          'Order Placed at',
          formatIso8601Date(orderdata.orderPlacedTime != null
              ? orderdata.orderPlacedTime.toIso8601String()
              : ""),
        ),
        _buildDetailRow(
            'Order Arrived at',
            orderdata.orderStatus == "Delivered"
                ? formatIso8601Date(orderdata.completedTime != null
                    ? orderdata.completedTime!.toIso8601String()
                    : "")
                : orderdata.orderStatus == "Delivery failed"
                    ? "Delivery failed"
                    : " Processing"),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => openWhatsAppChat(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 255, 233, 227),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Need help with this order?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 2),
                    Text('Find your issue or reach out via chat'),
                  ],
                ),
                Icon(Icons.question_answer_rounded)
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildActionButtons({required ThemeData theme, required User? user}) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.buttonColorOrange,
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            child: Text(
              'Rate Order',
              style: theme.textTheme.bodyLarge!.copyWith(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              context
                  .read<OrderBloc>()
                  .add(Orderagain(orderid: widget.orderID, userId: user!.uid));
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            child: Text('Order Again',
                style: theme.textTheme.bodyLarge!
                    .copyWith(color: AppColors.buttonColorOrange)),
          ),
        ),
      ],
    );
  }
}

double calculateTotalSellingPrice(List<CartProduct> cartList) {
  double total = 0.0;
  for (var item in cartList) {
    total += item.sellingPrice * item.quantity;
  }
  return total;
}

Future<void> openWhatsAppChat() async {
  const whatsappUrl = 'https://wa.me/+918547062699';
  final uri = Uri.parse(whatsappUrl);

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch WhatsApp';
  }
}
