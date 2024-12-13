import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/core/constants/app_colors.dart';
import 'package:nexus_condo/core/constants/app_images.dart';
import 'package:nexus_condo/core/utils/dimensions.dart';
import 'package:nexus_condo/core/widgets/background_screen.dart';
import 'package:nexus_condo/features/admin/add_unit/presentation/add_unit_screen.dart';
import 'package:nexus_condo/features/admin/units/controllers/unit_controller.dart';
import 'package:nexus_condo/features/admin/units/data/unit.dart';
import 'unit_details.dart';

class UnitListScreen extends ConsumerStatefulWidget {
  const UnitListScreen({super.key});

  @override
  _UnitListScreenState createState() => _UnitListScreenState();
}

class _UnitListScreenState extends ConsumerState<UnitListScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    ref.refresh(unitsProvider); // Refresh data when the screen is first loaded
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addObserver(this); // Listen to app lifecycle
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.refresh(unitsProvider); // Refresh data when screen is opened
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer when the widget is disposed
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      ref.refresh(unitsProvider); // Refresh data when screen comes into focus
    }
  }

  @override
  Widget build(BuildContext context) {
    final unitsAsyncValue = ref.watch(unitsProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: AppColors.whiteTextColor, // Set the back icon color to white
          ),
          title: const Text(
            'Explore Units',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: Dimensions.fontSizeLarge,
                fontWeight: FontWeight.bold,
                color: AppColors.whiteTextColor),
          ),
          centerTitle: true,
          backgroundColor: AppColors.appBarColor,
          elevation: 4,
          bottom: TabBar(
            labelColor: AppColors.whiteTextColor,
            unselectedLabelColor: AppColors.greyColor,
            controller: _tabController,
            indicatorColor: Colors.white,
            tabs: const [
              Tab(
                text: 'Not Rented',
              ),
              Tab(text: 'Rented'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.appBarColor,
          child: const Icon(Icons.add, color: AppColors.whiteColor),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddUnitScreen(),
            ),
          ),
        ),
        body: BackgroundScreen(
          child: unitsAsyncValue.when(
            data: (units) {
              // Split the units into rented and not rented
              final notRentedUnits = units.where((unit) => !unit.isRented).toList();
              final rentedUnits = units.where((unit) => unit.isRented).toList();

              return TabBarView(
                controller: _tabController,
                children: [
                  // Not Rented Units View
                  _buildUnitsGrid(context, notRentedUnits),
                  // Rented Units View
                  _buildUnitsGrid(context, rentedUnits),
                ],
              );
            },
            loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.whiteColor)),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
          ),
        ),
      ),
    );
  }

  Widget _buildUnitsGrid(BuildContext context, List<Unit> units) {
    if (units.isEmpty) {
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
      itemCount: units.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final unit = units[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UnitDetailsScreen(unit: unit),
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
                Stack(
                  children: [
                    Image.asset(
                      AppImages.placeHolder,
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          _showDeleteConfirmationDialog(unit.id);
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 16,
                          child: const Icon(
                            Icons.delete,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
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
  }

  // Confirmation Dialog
  void _showDeleteConfirmationDialog(String unitId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Unit'),
          content: const Text('Are you sure you want to delete this unit?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _deleteUnit(unitId);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUnit(String unitId) async {
    try {
      await ref.read(unitRepositoryProvider).deleteUnit(unitId);
      ref.refresh(unitsProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Unit deleted successfully'),
            backgroundColor: AppColors.successColor),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting unit: $e'),
          backgroundColor: AppColors.errorColor,
        ),
      );
    }
  }
}
