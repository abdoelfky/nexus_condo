import 'package:flutter/material.dart';
import 'package:nexus_condo/core/constants/app_colors.dart';
import 'package:nexus_condo/core/utils/dimensions.dart';
import 'package:nexus_condo/features/user/home/data/User.dart';

class ItemGrid extends StatelessWidget {
  ItemGrid({super.key});
  final List<GridItem> gridItems = [
    GridItem(color: AppColors.gridItemColor_1, text: "Rent", icon: Icons.home),
    GridItem(color: AppColors.gridItemColor_2, text: "Services", icon: Icons.home_repair_service_sharp),
    GridItem(color: AppColors.gridItemColor_3, text: "Requests", icon: Icons.miscellaneous_services_outlined),
    GridItem(color: AppColors.gridItemColor_4, text: "Market", icon: Icons.storefront),
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
        return ItemCard(index: index,gridItems: gridItems,);
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
        padding: const EdgeInsets.symmetric(horizontal:  Dimensions.paddingSizeSmall),
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
            SizedBox(height: Dimensions.paddingSizeExtraSmall,),
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
