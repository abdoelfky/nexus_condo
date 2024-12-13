import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/core/constants/app_colors.dart';
import 'package:nexus_condo/core/shared_preferences/shared_preferences.dart';
import 'package:nexus_condo/core/utils/dimensions.dart';
import 'package:nexus_condo/core/utils/gridItem.dart';
import 'package:nexus_condo/features/user/units/presentation/UserRentalBillScreen.dart';
import '../../home/presentation/widgets/GridScreen.dart';
import '../order_provider.dart';

class ItemGrid extends ConsumerWidget {
  ItemGrid({super.key});

  final List<GridItem> gridItems = [
    GridItem(
        color: AppColors.gridItemColor_1,
        text: "Rental Bills",
        icon: Icons.apartment),
    GridItem(
        color: AppColors.gridItemColor_2,
        text: "House Cleaning",
        icon: Icons.cleaning_services),
    GridItem(
        color: AppColors.gridItemColor_3,
        text: "Malfunctions Repair",
        icon: Icons.home_repair_service_sharp),
    GridItem(
        color: AppColors.gridItemColor_3,
        text: "Dry Clean",
        icon: Icons.dry_cleaning),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersRepo = ref.read(ordersProvider);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: Dimensions.paddingSizeExtraExtraSmall,
        mainAxisSpacing: Dimensions.paddingSizeSmall,
        childAspectRatio: 1.4,
      ),
      itemCount: gridItems.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserRentalBillScreen(
                        tenantId: AppSettingsPreferences().id),
                  ),
                );
                break;
              case 1:
                _confirmService(context, ordersRepo, "House Cleaning");
                break;
              case 2:
                _requestDetails(context, ordersRepo, "Malfunctions Repair");
                break;
              case 3:
                _requestDetails(context, ordersRepo, "Dry Clean");
                break;
              default:
                print("Unhandled index: $index");
            }
          },
          child: ItemCard(
            index: index,
            gridItems: gridItems,
          ),
        );
      },
    );
  }

  void _confirmService(context, OrdersRepository ordersRepo, String serviceType) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Request $serviceType"),
          content: const Text("Do you want to request this service?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _sendOrder(context, ordersRepo, serviceType, details: "House Cleaning");
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  void _requestDetails(BuildContext context, OrdersRepository ordersRepo,
      String serviceType) {
    final TextEditingController detailsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Request $serviceType"),
          content: TextField(
            controller: detailsController,
            decoration: const InputDecoration(
              labelText: "Enter details",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _sendOrder(
                  context,
                  ordersRepo,
                  serviceType,
                  details: detailsController.text,
                );
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendOrder(context, OrdersRepository ordersRepo,
      String serviceType,
      {required String details}) async {
    try {
      final userId = AppSettingsPreferences().id;
      final userName = AppSettingsPreferences().name;
      final userPhone = AppSettingsPreferences().user().phoneNumber;
      final unitNumber = AppSettingsPreferences().user().unitNo;

      await ordersRepo.addOrder(
        serviceType: serviceType,
        details: details,
        userId: userId,
        userName: userName,
        userPhone: userPhone!,
        unitNumber: unitNumber!,
      );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Order sent successfully!")),
      // );
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Failed to send order: $e")),
      // );
    }
  }
}
