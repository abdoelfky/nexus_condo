import 'package:cloud_firestore/cloud_firestore.dart';

class RentalRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> fetchUnits() {
    return _firestore
        .collection('units')
        .where('is_rented', isEqualTo: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
  }

  Stream<List<Map<String, dynamic>>> fetchRentalBills() {
    return _firestore.collection('rentalBills').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['billId'] = doc.id; // Add document ID to the data
          return data;
        }).toList());
  }



  Future<void> generateBill(String unitId, String tenantId, String unitNumber, String amountDue) async {
    final now = DateTime.now();
    final currentMonth = '${now.year}-${now.month}'; // Format: YYYY-MM

    // Check if a bill already exists for the current month
    final existingBillsQuery = await _firestore
        .collection('rentalBills')
        .where('unitId', isEqualTo: unitId)
        .where('tenantId', isEqualTo: tenantId)
        .where('month', isEqualTo: currentMonth)
        .get();

    if (existingBillsQuery.docs.isEmpty) {
      // If no bill exists, create a new bill
      await _firestore.collection('rentalBills').add({
        'unitId': unitId,
        'tenantId': tenantId,
        'unitNumber': unitNumber,
        'amountDue': amountDue,
        'isPaid': false,
        'month': currentMonth, // Add the month to track
        'createdAt': now,      // Timestamp for reference
      });
    } else {
      print('A rental bill for this unit and tenant has already been generated this month.');

    }
  }


  Future<void> updateBillStatus(String billId, bool isPaid) async {
    await _firestore.collection('rentalBills').doc(billId).update({'isPaid': isPaid});
  }
}
