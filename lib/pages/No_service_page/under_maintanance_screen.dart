// No Service Page
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/models/warehouse_model.dart';

class UnderMaintananceScreen extends StatelessWidget {
  final WarehouseModel warehouse;
  const UnderMaintananceScreen({super.key, required this.warehouse});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5,
              children: [
                const Icon(
                  Icons.location_off,
                  size: 80,
                  color: Colors.red,
                ),
                const SizedBox(height: 10),
                Text(
                  "Service Not Available",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                Text(
                  "Thank you for your interest!",
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                Text(
                  warehouse.warehouseDescription,
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Fill color
                    foregroundColor: const Color(0xffFF592E), // Text color
                    side: const BorderSide(
                        color: Color(0xffFF592E)), // Outer line
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Border radius
                    ),
                  ),
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    context.push('/help');
                  },
                  child: const Text("Contact Us"),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// We currently don't have service in your area.
