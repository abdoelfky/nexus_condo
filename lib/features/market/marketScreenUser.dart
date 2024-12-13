import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/core/shared_preferences/shared_preferences.dart';
import 'package:nexus_condo/core/widgets/PrimaryButton.dart';
import 'package:nexus_condo/core/widgets/background_screen.dart';
import 'package:nexus_condo/core/widgets/primary_app_bar.dart';
import 'package:nexus_condo/features/market/controllers/market_provider.dart';
import 'package:nexus_condo/features/market/data/orderModel.dart';

class MarketScreen extends ConsumerStatefulWidget {
  const MarketScreen({super.key});

  @override
  ConsumerState<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends ConsumerState<MarketScreen> {
  final TextEditingController _orderController = TextEditingController();
  String? selectedCategory;
  final List<String> categories = ['Pharmacy', 'Market', 'Grocery'];

  Future<void> submitOrder() async {
    if (selectedCategory == null || _orderController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields!')),
      );
      return;
    }

    final order = OrderModel(
      orderId: '',
      category: selectedCategory!,
      orderDetails: _orderController.text,
      userId: AppSettingsPreferences().id, // Replace with actual user ID
      userName: AppSettingsPreferences().name, // Replace with actual user name
      userPhone: AppSettingsPreferences().phoneNumber, // Replace with actual phone number
      unitNumber: AppSettingsPreferences().user().unitNo.toString(),
      isProcessed: false,
      createdAt: DateTime.now(),
    );

    await ref.read(orderRepositoryProvider).addOrder(order);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order submitted successfully!')),
    );

    _orderController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(title: ('Place Your Order')),
      body: BackgroundScreen(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Select Category'),
                value: selectedCategory,
                items: categories.map((category) {
                  return DropdownMenuItem(value: category, child: Text(category));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _orderController,
                decoration: const InputDecoration(
                  labelText: 'Write your order',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                onPressed: submitOrder,
                text: 'Submit Order',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
