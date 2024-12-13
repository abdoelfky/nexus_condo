import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // For formatting timestamp
import 'package:nexus_condo/core/constants/app_colors.dart';
import 'package:nexus_condo/core/widgets/background_screen.dart';
import 'package:nexus_condo/core/widgets/primary_app_bar.dart';
import '../../user/services/order_provider.dart';

class OrdersScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersStream = ref.watch(ordersProvider).getRequests();

    return Scaffold(
      appBar: PrimaryAppBar(
        title: ("Requests"),
      ),
      body: BackgroundScreen(
        child: StreamBuilder(
          stream: ordersStream,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
        
            if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
              return const Center(child: Text("No orders found."));
            }
        
            final orders = snapshot.data.docs;
        
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index].data();
                final orderId = orders[index].id;
        
                // Convert timestamp to readable format
                final timestamp = order['timestamp'] as Timestamp?;
                final date = timestamp != null
                    ? DateFormat('yyyy-MM-dd – hh:mm a').format(timestamp.toDate())
                    : "N/A";
        
                return Card(
                  color: AppColors.whiteColor,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Service Type and Timestamp
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Service: ${order['serviceType']}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
        
                          ],
                        ),
                        Text(
                          "Date: $date",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
        
                        // User Information
                        Text(
                          "Name: ${order['userName']}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          "Phone: ${order['userPhone']}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          "Unit: ${order['unitNumber']}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
        
                        // Service Details
                        Text(
                          "Details: ${order['details']}",
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        const SizedBox(height: 16),
        
                        // Accept/Reject Switch
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Status:",
                              style: TextStyle(fontSize: 14),
                            ),
                            Switch(
                              value: order['status'],
                              onChanged: (value) {
                                // Update status in Firebase
                                ref.read(ordersProvider).updateOrderStatus(
                                  orderId: orderId,
                                  status: value,
                                );
                              },
                            ),
                            Text(
                              order['status'] == true ? "Accepted" : "Pending",
                              style: TextStyle(
                                fontSize: 14,
                                color: order['status'] == true
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
