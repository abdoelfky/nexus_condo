import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/core/constants/app_colors.dart';
import 'package:nexus_condo/core/widgets/background_screen.dart';
import 'package:nexus_condo/core/widgets/primary_app_bar.dart';
import 'package:nexus_condo/features/admin/services/rental_bills/controllers/rentalRepositoryProvider.dart';

class UserRentalBillScreen extends ConsumerWidget {
  final String tenantId;

  const UserRentalBillScreen({super.key, required this.tenantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rentalBillsAsync = ref.watch(rentalBillsProvider);
print(tenantId);
    return Scaffold(
      appBar: PrimaryAppBar(title: ('My Rental Bills')),
      body: BackgroundScreen(
        child: rentalBillsAsync.when(
          data: (bills) {
            final userBills = bills.where((bill) => bill['tenantId'] == tenantId).toList();
        
            if (userBills.isEmpty) {
              return const Center(child: Text('No bills available.'));
            }
        
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: userBills.length,
                itemBuilder: (context, index) {
                  final bill = userBills[index];
                  return Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.nexusShadowGreen.withOpacity(.15), // Shadow color
                          offset: Offset(0, 2), // Shadow position (bottom)
                          blurRadius: 10, // Shadow blur radius
                        ),
                      ]
                    ),
                    child: Card(
                      color: AppColors.backgroundColor,
                      child: ListTile(
                        title: Text('Unit ${bill['unitNumber']}'),
                        subtitle: Text('Amount Due: \$${bill['amountDue']}'),
                        trailing: bill['isPaid']
                            ? const Text('Paid', style: TextStyle(color: Colors.green))
                            : const Text('Unpaid', style: TextStyle(color: Colors.red)),
                      ),
                    ),
                  );
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }
}
