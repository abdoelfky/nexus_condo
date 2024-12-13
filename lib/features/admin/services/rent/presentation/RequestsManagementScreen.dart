import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/core/constants/app_colors.dart';
import 'package:nexus_condo/core/utils/dimensions.dart';
import 'package:nexus_condo/core/widgets/background_screen.dart';
import 'package:nexus_condo/core/widgets/primary_app_bar.dart';
import 'package:nexus_condo/features/admin/services/rent/controllers/requests_provider.dart';

class RequestsManagementScreen extends ConsumerStatefulWidget {
  const RequestsManagementScreen({super.key});

  @override
  _RequestsManagementScreenState createState() =>
      _RequestsManagementScreenState();
}

@override
class _RequestsManagementScreenState
    extends ConsumerState<RequestsManagementScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //
  //   // Trigger any initial logic using ref.read
  //   Future.microtask(() {
  //     ref.read(requestsProvider);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final requestsAsync = ref.watch(requestsProvider);

    return Scaffold(
      appBar: PrimaryAppBar(title: 'Rent Requests'),
      body: BackgroundScreen(
        child: requestsAsync.when(
          data: (requests) {
            // Filter pending requests
            final pendingRequests = requests
                .where((request) => request.status == 'Pending')
                .toList();

            if (pendingRequests.isEmpty) {
              return Center(
                child: Text(
                  'No pending requests',
                  style: TextStyle(
                      fontSize: Dimensions.fontSizeLarge,
                      color: AppColors.whiteTextColor),
                ),
              );
            }

            return ListView.builder(
              itemCount: pendingRequests.length,
              itemBuilder: (context, index) {
                final request = pendingRequests[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text('Unit ${request.unitNo}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('User: ${request.userEmail}'),
                        Text(
                          'Date: ${request.requestDate.toLocal()}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () => ref
                              .read(requestsProvider.notifier)
                              .admitRequest(request)
                              .then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Request admitted!'),
                              ),
                            );
                          }).catchError((e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => ref
                              .read(requestsProvider.notifier)
                              .declineRequest(request)
                              .then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Request declined!'),
                              ),
                            );
                          }).catchError((e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: Text('Error: $error'),
          ),
        ),
      ),
    );
  }
}
