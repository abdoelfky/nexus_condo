import 'package:flutter/material.dart';
import 'package:nexus_condo/core/widgets/PrimaryButton.dart';
import 'package:nexus_condo/core/widgets/primary_app_bar.dart';

class BillingScreen extends StatelessWidget {
  const BillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: ('Billing Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Enter your payment details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),

            // Card Number Field
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Card Number',
                hintText: '1234 5678 9876 5432',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.credit_card),
              ),
              keyboardType: TextInputType.number,
              maxLength: 19, // For the card number format (e.g., 1234 5678 9876 5432)
            ),
            SizedBox(height: 20),

            // Expiry Date Field
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'MM/YY',
                      hintText: 'MM/YY',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 5, // For the MM/YY format
                  ),
                ),
                SizedBox(width: 10),

                // CVV Field
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      hintText: '123',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 3, // For the CVV length
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Cardholder Name Field
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Cardholder Name',
                hintText: 'John Doe',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),

            // Billing Address Field
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Billing Address',
                hintText: '123 Main Street',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),

            // Submit Button
            PrimaryButton(
              text: 'Pay Now',
              onPressed: () {
                // Handle payment submission here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Proceeding with payment...')),
                );
              },

            ),
          ],
        ),
      ),
    );
  }
}

