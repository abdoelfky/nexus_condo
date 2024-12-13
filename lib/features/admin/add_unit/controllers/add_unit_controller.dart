import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final addUnitControllerProvider =
StateNotifierProvider<AddUnitController, bool>((ref) => AddUnitController());

class AddUnitController extends StateNotifier<bool> {
  AddUnitController() : super(false);

  Future<void> addUnit({
    required String unitNo,
    required String unitDetails,
    required String unitRoomNo,
    required String unitPricePerY,
    required String unitPricePerM,
    required String unitSpace,
    required List<String> imageUrls, // List of image URLs
  }) async {
    state = true; // Set loading to true
    try {
      final documentRef = FirebaseFirestore.instance.collection('units').doc();

      await documentRef.set({
        'unitNo': unitNo,
        'unitDetails': unitDetails,
        'unitRoomNo': unitRoomNo,
        'unitPricePerY': unitPricePerY,
        'unitPricePerM': unitPricePerM,
        'unitSpace': unitSpace,
        'images': imageUrls, // Save image URLs to Firestore
        'id': documentRef.id,
        'is_rented': false,
        'created_at': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to add unit: ${e.toString()}');
    } finally {
      state = false; // Set loading to false
    }
  }
}
