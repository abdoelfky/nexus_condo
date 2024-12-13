import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/core/widgets/background_screen.dart';
import 'package:nexus_condo/core/widgets/primary_app_bar.dart';
import 'package:nexus_condo/features/help/controllers/help_provider.dart';


class AdminComplaintsScreen extends ConsumerWidget {
  const AdminComplaintsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final complaintsAsync = ref.watch(complaintsProvider);

    return Scaffold(
      appBar: PrimaryAppBar(
        title: 'User Complaints',
      ),
      body: BackgroundScreen(
        child: complaintsAsync.when(
          data: (complaints) => complaints.isEmpty
              ? const Center(child: Text('No complaints available'))
              : ListView.builder(
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final complaint = complaints[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text('Unit ${complaint.unitNo}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${complaint.name}'),
                      Text('Phone: ${complaint.phone}'),
                      Text('Message: ${complaint.message}'),
                      Text(
                        'Date: ${complaint.createdAt.toLocal()}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text('Error: $error'),
          ),
        ),
      ),
    );
  }
}
