import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/core/constants/app_colors.dart';
import 'package:nexus_condo/core/widgets/background_screen.dart';
import 'package:nexus_condo/core/widgets/primary_app_bar.dart';
import 'package:nexus_condo/features/market/controllers/market_provider.dart';

class AdminOrdersScreen extends ConsumerWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);

    return Scaffold(
      appBar: PrimaryAppBar(title: ('Manage Orders')),
      body: BackgroundScreen(
        child: ordersAsync.when(
          data: (orders) {
            if (orders.isEmpty) {
              return const Center(child: Text('No orders found'));
            }
        
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
        
                return Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.nexusShadowGreen.withOpacity(.1), // Shadow color
                        offset: Offset(1, 0), // Shadow position (bottom)
                        blurRadius: 50, // Shadow blur radius
                      ),
                    ]
                  ),
                  child: Card(
                    color: AppColors.backgroundColor,
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text('Order: ${order.orderDetails}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Category: ${order.category}'),
                          Text('Unit: ${order.unitNumber}'),
                          Text('User: ${order.userName} (${order.userPhone})'),
                        ],
                      ),
                      trailing: Switch(
                        value: order.isProcessed,
                        onChanged: (value) {
                          ref.read(orderRepositoryProvider).updateOrderStatus(order.orderId, value);
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}
