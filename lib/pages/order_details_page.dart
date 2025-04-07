import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/Cart_bloc/cart_event.dart';
import 'package:kwik/bloc/order%20details%20bloc/order_details_bloc.dart';
import 'package:kwik/bloc/order%20details%20bloc/order_details_event.dart';

// ignore: use_key_in_widget_constructors
class OrderDetailsPage extends StatefulWidget {
  final String orderID;

  OrderDetailsPage({super.key, required this.orderID});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final Order order = Order(
    id: 'DDF8DBYGF71465',
    items: [
      OrderItem(
        name: 'Himalaya Ophthacare Eye Drops',
        quantity: '10 ml • 1 unit',
        price: 75.9,
        originalPrice: 100,
      ),
      OrderItem(
        name: 'Pepsi Soft Drink',
        quantity: '330 ml • 1 unit',
        price: 40,
        originalPrice: 40,
      ),
    ],
    deliveryTime: '6 MINS',
    status: 'Delivered',
    orderDate: DateTime(2025, 4, 2, 11, 11),
    deliveryDate: DateTime(2025, 4, 2, 11, 18),
    customer: Customer(
      name: 'Arjun',
      phone: '+91-8547062699',
      address:
          '1 floor, 3 Stage, 3rd D Cross Road, Basaveshwar Nagar, 3rd Stage, Basaveshwar Nagar, Bengaluru, Karnataka',
    ),
    itemTotal: 142.03,
    gst: 117.93,
    handlingCharge: 9.99,
    deliveryFee: 25,
    discount: 49.19,
    total: 177.11,
  );

  @override
  void initState() {
    // TODO: implement initState
    context.read<OrderDetailsBloc>().add(FetchOrderDetails(widget.orderID));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order #${order.id}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        leading: const Icon(Icons.arrow_back_ios_new_rounded),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderHeader(theme: theme),
            const SizedBox(height: 16),
            _buildOrderItems(theme: theme),
            const SizedBox(height: 24),
            _buildBillSummary(theme: theme),
            const SizedBox(height: 24),
            _buildOrderDetails(theme: theme),
            const SizedBox(height: 24),
            _buildActionButtons(theme: theme),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeader({required ThemeData theme}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Chip(
              label: Text(
                order.status,
                style: theme.textTheme.bodyLarge,
              ),
              backgroundColor: Colors.green[50],
              labelStyle: const TextStyle(color: Colors.green),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Arrived in ${order.deliveryTime}',
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildOrderItems({required ThemeData theme}) {
    return Container(
      color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${order.items.length} items in order',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),
          ...order.items.map((item) => _buildOrderItem(item, theme)).toList(),
        ],
      ),
    );
  }

  Widget _buildOrderItem(OrderItem item, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text(item.quantity,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '¥${item.price.toStringAsFixed(2)}',
                style: theme.textTheme.bodyLarge,
              ),
              if (item.originalPrice != item.price)
                Text(
                  '¥${item.originalPrice.toStringAsFixed(2)}',
                  style: theme.textTheme.bodyLarge,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBillSummary({required ThemeData theme}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Bill Summary',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildBillRow(
            'Item Total',
            '¥${order.itemTotal.toStringAsFixed(2)} ¥${order.gst.toStringAsFixed(2)}',
            theme),
        _buildBillRow('Handling Charge',
            '¥${order.handlingCharge.toStringAsFixed(2)}', theme),
        _buildBillRow('Delivery Fee',
            '¥${order.deliveryFee.toStringAsFixed(2)} ¥0', theme),
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
                  '¥${order.total.toStringAsFixed(2)} ¥${(order.total - order.discount).toStringAsFixed(2)}',
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
        Text(
          'SAVED ¥${order.discount.toStringAsFixed(2)}',
          style:
              const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {},
          child: const Text('Download Invoice / Credit Note'),
          style: TextButton.styleFrom(),
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

  Widget _buildOrderDetails({required ThemeData theme}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Order Details',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildDetailRow('Order ID', '#${order.id}'),
        const SizedBox(height: 16),
        const Text('Receiver Details',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(order.customer.name),
        Text(order.customer.phone),
        const SizedBox(height: 16),
        const Text('Delivery Address',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(order.customer.address),
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
            child: const Text('Rate Order'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Order Again'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}

class Order {
  final String id;
  final List<OrderItem> items;
  final String deliveryTime;
  final String status;
  final DateTime orderDate;
  final DateTime deliveryDate;
  final Customer customer;
  final double itemTotal;
  final double gst;
  final double handlingCharge;
  final double deliveryFee;
  final double discount;
  final double total;

  Order({
    required this.id,
    required this.items,
    required this.deliveryTime,
    required this.status,
    required this.orderDate,
    required this.deliveryDate,
    required this.customer,
    required this.itemTotal,
    required this.gst,
    required this.handlingCharge,
    required this.deliveryFee,
    required this.discount,
    required this.total,
  });
}

class OrderItem {
  final String name;
  final String quantity;
  final double price;
  final double originalPrice;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.originalPrice,
  });
}

class Customer {
  final String name;
  final String phone;
  final String address;

  Customer({
    required this.name,
    required this.phone,
    required this.address,
  });
}
