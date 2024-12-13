import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexus_condo/features/admin/services/rent/data/rent_request.dart';

final requestsProvider = AsyncNotifierProvider<RequestsNotifier, List<RentRequest>>(
  RequestsNotifier.new,
);

class RequestsNotifier extends AsyncNotifier<List<RentRequest>> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<List<RentRequest>> build() async {
    return _fetchRequests();
  }

  // Fetch requests from Firestore
  Future<List<RentRequest>> _fetchRequests() async {
    final snapshot = await _firestore.collection('rent_requests').get();
    return snapshot.docs
        .map((doc) => RentRequest.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  // Admit a request
  Future<void> admitRequest(RentRequest request) async {
    state = const AsyncValue.loading(); // Show loading indicator
    try {
      await _firestore.collection('rent_requests').doc(request.id).update({
        'status': 'Admitted',
      });

      await _firestore
          .collection('users')
          .doc(request.userId)
          .update({
        'unitId': request.unitId,
        'unitNo': request.unitNo,
        'admittedDate': DateTime.now().toIso8601String(),
      });
      await _firestore
          .collection('units')
          .doc(request.unitId)
          .update({
        'is_rented': true,
        'tenantId':request.userId
      });
      state = AsyncValue.data(await _fetchRequests());
    } catch (e) {
      // state = AsyncValue.error(e);
      throw();

    }
  }

  // Decline a request
  Future<void> declineRequest(RentRequest request) async {
    state = const AsyncValue.loading(); // Show loading indicator
    try {
      await _firestore.collection('rent_requests').doc(request.id).update({
        'status': 'Declined',
      });

      state = AsyncValue.data(await _fetchRequests());
    } catch (e) {
      throw();
    }
  }
}
