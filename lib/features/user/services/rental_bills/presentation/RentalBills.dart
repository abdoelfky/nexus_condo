import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/core/constants/app_colors.dart';
import 'package:nexus_condo/core/widgets/background_screen.dart';
import 'package:nexus_condo/core/widgets/primary_app_bar.dart';
import 'package:nexus_condo/features/admin/services/rental_bills/controllers/rentalRepositoryProvider.dart';

class AdminRentalBillsScreen extends ConsumerWidget {
  const AdminRentalBillsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rentalBillsAsync = ref.watch(rentalBillsProvider);

    return Scaffold(
      appBar: PrimaryAppBar(title:  ('Admin - Rental Bills')),
      body: BackgroundScreen(
        child: rentalBillsAsync.when(
          data: (bills) {
            if (bills.isEmpty) {
              return const Center(child: Text('No rental bills found.'));
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: bills.length,
                itemBuilder: (context, index) {
                  final bill = bills[index];
                  return Card(
                    child: ListTile(
                      title: Text('Unit ${bill['unitNumber']}'),
                      subtitle: Text('Amount Due: \$${bill['amountDue']}'),
                      trailing: Switch(
                        value: bill['isPaid'],
                        onChanged: (value) async {
                          final repository = ref.read(rentalRepositoryProvider);
                          await repository.updateBillStatus(bill['billId'], value);
                        },
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.whiteColor,
        onPressed: () async {
          // Generate bills for all rented units
          final unitsAsync = ref.read(unitsProvider);

          unitsAsync.whenData((units) async {
            final repository = ref.read(rentalRepositoryProvider);

            for (var unit in units) {
              await repository.generateBill(
                unit['id'],
                unit['tenantId'],
                unit['unitNo'],
                unit['unitPricePerM'],
              );
            }

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Rental bills generated!')),
            );
          });
        },
        child: const Icon(Icons.send,color: AppColors.buttonColor,),
      ),
    );
  }
}
