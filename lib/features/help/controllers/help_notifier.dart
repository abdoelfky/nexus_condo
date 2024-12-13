import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/features/help/data/complaintModel.dart';

class HelpNotifier {
  final _firestore = FirebaseFirestore.instance;

  Future<bool> submitComplaint(Complaint complaint) async {
    try {
      await _firestore.collection('complaints').add(complaint.toFirestore());
      return true;
    } catch (e) {
      return false;
    }
  }
}

final helpProvider = Provider.autoDispose<HelpNotifier>((ref) => HelpNotifier());
