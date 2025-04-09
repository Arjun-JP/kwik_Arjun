import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/order%20details%20bloc/order_details_bloc.dart';
import 'package:kwik/bloc/order%20details%20bloc/order_details_event.dart';
import 'package:kwik/bloc/order%20details%20bloc/order_details_state.dart';
import 'package:kwik/models/order_model.dart';

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
    ThemeData theme = Theme.of(context);
    return BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
        builder: (context, state) {
      return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Order #{order.id}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            centerTitle: false,
            leading: InkWell(
                onTap: () => context.pop(),
                child: const Icon(Icons.arrow_back_ios_new_rounded)),
          ),
          body: (state is OrderDetailsLoading)
              ? const CircularProgressIndicator()
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
                          _buildActionButtons(theme: theme),
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
          'Arrived in ${orderdata.completedTime}',
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
              subtitle: Text(
                orderdata.products[index].productRef.productDescription,
                maxLines: 3,
              ),
              trailing: Column(
                children: [
                  Text(
                    "₹ ${orderdata.products[index].variant.sellingPrice}",
                    style: theme.textTheme.bodyLarge,
                  ),
                  Text("₹ ${orderdata.products[index].variant.mrp}",
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
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children: [
          //     Text(
          //       '₹${item.totalAmount}',
          //       style: theme.textTheme.bodyLarge,
          //     ),
          //     if (item.id != item.id)
          //       Text(
          //         '¥${item.id}',
          //         style: theme.textTheme.bodyLarge,
          //       ),
          //   ],
          // ),
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
        _buildBillRow(
            'Item Total',
            '₹ ${orderdata.totalAmount} ¥{order.gst.toStringAsFixed(2)}',
            theme),
        _buildBillRow('Handling Charge',
            '¥{order.handlingCharge.toStringAsFixed(2)}', theme),
        _buildBillRow('Delivery Fee',
            '¥{order.deliveryFee.toStringAsFixed(2)} ¥0', theme),
        const Divider(height: 24),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total Bill', style: TextStyle(fontWeight: FontWeight.bold)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '¥{order.total.toStringAsFixed(2)} ¥{(order.total - order.discount).toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Incl. all taxes and charges',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'SAVED ¥{order.discount.toStringAsFixed(2)}',
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(),
          child: const Text('Download Invoice / Credit Note'),
        ),
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
        _buildDetailRow('Order ID', '#{order.id}'),
        const SizedBox(height: 16),
        const Text('Receiver Details',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text("order.customer.name"),
        const Text("order.customer.phone"),
        const SizedBox(height: 16),
        const Text('Delivery Address',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text("order.customer.address"),
        const SizedBox(height: 16),
        _buildDetailRow(
          'Order Placed',
          " order.orderDate",
        ),
        _buildDetailRow('Order Arrived at', " order.deliveryDate"),
        const SizedBox(height: 16),
        const Text(
          'Need help with this order?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('Find your issue or reach out via chat'),
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

  Widget _buildActionButtons({required ThemeData theme}) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Rate Order'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Order Again'),
          ),
        ),
      ],
    );
  }
}
