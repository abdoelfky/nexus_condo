import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/core/constants/app_colors.dart';
import 'package:nexus_condo/core/constants/app_images.dart';
import 'package:nexus_condo/core/utils/dimensions.dart';
import 'package:nexus_condo/core/widgets/background_screen.dart';
import 'package:nexus_condo/features/admin/units/controllers/unit_controller.dart';
import 'unit_details.dart';

class UserUnitScreen extends ConsumerStatefulWidget {
  const UserUnitScreen({super.key});

  @override
  _UserUnitScreenState createState() => _UserUnitScreenState();
}

class _UserUnitScreenState extends ConsumerState<UserUnitScreen> {
  // Variables to store filter values
  double? _minPrice, _maxPrice;
  double? _minSpace, _maxSpace;
  int? _minRooms, _maxRooms;

  // GlobalKey for Scaffold to control drawer opening
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    ref.refresh(unitsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final unitsAsyncValue = ref.watch(unitsProvider);

    return Scaffold(
      key: _scaffoldKey, // Assign the scaffold key
      appBar: AppBar(
        backgroundColor: AppColors.appBarColor,
        title: Text(
          'Available Units',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: Dimensions.fontSizeLarge,
            fontWeight: FontWeight.bold,
            color: AppColors.whiteTextColor, // White text color for the title
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.whiteColor),
          onPressed: () {
            Navigator.pop(context); // Handle back button action
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.whiteColor),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer(); // Manually open the drawer
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primaryColor),
              child: Text(
                'Filters',
                style: TextStyle(color: AppColors.whiteTextColor, fontSize: 24),
              ),
            ),
            _buildFilterOption('Price', _minPrice, _maxPrice, (min, max) {
              setState(() {
                _minPrice = min;
                _maxPrice = max;
              });
            }),
            _buildFilterOption('Space (m²)', _minSpace, _maxSpace, (min, max) {
              setState(() {
                _minSpace = min;
                _maxSpace = max;
              });
            }),
            _buildFilterOption('Rooms', _minRooms?.toDouble(), _maxRooms?.toDouble(), (min, max) {
              setState(() {
                _minRooms = min?.toInt();
                _maxRooms = max?.toInt();
              });
            }),
          ],
        ),
      ),
      body: BackgroundScreen(
        child: unitsAsyncValue.when(
          data: (units) {
            // Filter only not rented units
            final notRentedUnits = units.where((unit) => !unit.isRented).toList();

            // Apply filters
            final filteredUnits = notRentedUnits.where((unit) {
              bool matchesPrice = (_minPrice == null ||
                  double.parse(unit.pricePerMonth) >= _minPrice!) &&
                  (_maxPrice == null ||
                      double.parse(unit.pricePerMonth) <= _maxPrice!);
              bool matchesSpace = (_minSpace == null ||
                  double.parse(unit.space) >= _minSpace!) &&
                  (_maxSpace == null || double.parse(unit.space) <= _maxSpace!);
              bool matchesRooms = (_minRooms == null ||
                  double.parse(unit.roomNo) >= _minRooms!) &&
                  (_maxRooms == null ||
                      double.parse(unit.roomNo) <= _maxRooms!);

              return matchesPrice && matchesSpace && matchesRooms;
            }).toList();

            if (filteredUnits.isEmpty) {
              return const Center(
                child: Text(
                  'No units available',
                  style: TextStyle(
                      color: AppColors.whiteTextColor,
                      fontSize: Dimensions.fontSizeExtraLarge),
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: filteredUnits.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 9,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                final unit = filteredUnits[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UserUnitDetailsScreen(unit: unit),
                    ),
                  ),
                  child: Card(
                    color: AppColors.backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    elevation: 4,
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          AppImages.placeHolder,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Unit ${unit.unitNo}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Space: ${unit.space} m²',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rooms: ${unit.roomNo}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '\$${unit.pricePerMonth} / Month',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.deepPurpleAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.whiteColor)),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  Widget _buildFilterOption(String label, dynamic minValue, dynamic maxValue,
      Function(double?, double?) onApply) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 18)),
          // Display the selected range value
          Text(
            '${minValue?.toStringAsFixed(0) ?? '0'} - ${maxValue?.toStringAsFixed(0) ?? '10000'}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          RangeSlider(
            values: RangeValues(minValue ?? 0, maxValue ?? 10000),
            min: 0,
            max: 10000,
            divisions: 100,
            labels: RangeLabels(
              minValue?.toString() ?? '0',
              maxValue?.toString() ?? '10000',
            ),
            onChanged: (RangeValues values) {
              onApply(values.start, values.end);
            },
            activeColor: Colors.black,  // Set active range color to black
            inactiveColor: Colors.grey,  // Set inactive range color to grey
          ),
        ],
      ),
    );
  }
}
