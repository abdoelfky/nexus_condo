import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexus_condo/features/admin/units/data/unit.dart';

class UnitRepository {
  final FirebaseFirestore _firestore;

  UnitRepository(this._firestore);

  Future<List<Unit>> fetchUnits() async {
    final querySnapshot = await _firestore.collection('units').get();
    return querySnapshot.docs
        .map((doc) => Unit.fromMap(doc.id, doc.data()))
        .toList();
  }

  // Method to delete a unit from Firestore
  Future<void> deleteUnit(String unitId) async {
    try {
      await _firestore.collection('units').doc(unitId).delete();
    } catch (e) {
      throw Exception('Failed to delete unit: $e');
    }
  }
}
