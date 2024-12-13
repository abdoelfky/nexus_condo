import 'package:flutter/material.dart';
import 'package:nexus_condo/core/constants/app_colors.dart';
import 'package:nexus_condo/core/shared_preferences/shared_preferences.dart';
import 'package:nexus_condo/core/utils/dimensions.dart';
import 'package:nexus_condo/core/utils/gridItem.dart';
import 'package:nexus_condo/features/admin/add_user/presentation/add_user_screen.dart';
import 'package:nexus_condo/features/admin/services/services_screen.dart';
import 'package:nexus_condo/features/admin/units/presentation/units.dart';
import 'package:nexus_condo/features/chat/ChatScreen.dart';
import 'package:nexus_condo/features/help/presentation/AdminHelpScreen.dart';

class ItemGrid extends StatelessWidget {
  ItemGrid({super.key});

  final List<GridItem> gridItems = [
    GridItem(
        color: AppColors.gridItemColor_1,
        text: "Add User",
        icon: Icons.person_add_outlined),
    GridItem(
        color: AppColors.gridItemColor_2,
        text: "Units",
        icon: Icons.maps_home_work_rounded),
    GridItem(
        color: AppColors.gridItemColor_3,
        text: "Services",
        icon: Icons.miscellaneous_services_outlined),
    GridItem(
        color: AppColors.gridItemColor_4,
        text: "Chat",
        icon: Icons.chat),
    GridItem(color: AppColors.gridItemColor_5, text: "Help", icon: Icons.help),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 items per row
        crossAxisSpacing: Dimensions.paddingSizeExtraExtraSmall,
        mainAxisSpacing: Dimensions.paddingSizeSmall,
        childAspectRatio: 1.4, // Adjust the item size ratio
      ),
      itemCount: gridItems.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () {
              switch (index) {
                case 0:
                  // Navigate to Add User screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddUserScreen()),
                  );
                  break;
                case 1:
                  // Navigate to Add Units screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UnitListScreen()),
                    );
                  break;
                case 2:
                  // Handle Requests action
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AdminServicesScreen()),
                    );
                  break;
                case 3:
                  // Navigate to Market screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  GroupChatScreen(userId:AppSettingsPreferences().id ,userName:AppSettingsPreferences().name ,)),
                    );
                  break;
                case 4:
                  // Navigate to Help screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AdminComplaintsScreen()),
                    );
                  break;
                default:
                  // Handle unexpected index
                  print("Invalid grid item index: $index");
              }
            },
            child: ItemCard(
              index: index,
              gridItems: gridItems,
            ));
      },
    );
  }
}

class ItemCard extends StatelessWidget {
  final int index;
  final List<GridItem> gridItems;

  const ItemCard({required this.index, super.key, required this.gridItems});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      color: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge)),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  gridItems[index].icon,
                  size: Dimensions.iconSizeLarge,
                  color: gridItems[index].color,
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    // Background color of the circular notification
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        // Shadow color for notification icon
                        blurRadius: 4,
                        // Shadow blur radius
                        offset: const Offset(
                            0, 2), // Shadow offset for notification icon
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                          fontSize: Dimensions.fontSizeLarge,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Dimensions.paddingSizeExtraSmall,
            ),
            Text(
              gridItems[index].text,
              style: const TextStyle(
                  fontSize: Dimensions.fontSizeDefault,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
