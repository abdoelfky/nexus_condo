import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ordersProvider = Provider((ref) => OrdersRepository());

class OrdersRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<void> updateOrderStatus({
    required String orderId,
    required bool status,
  }) async {
    try {
      await _firestore.collection("requests").doc(orderId).update({
        "status": status,
      });
      getRequests();
    } catch (e) {
      throw Exception("Failed to update order status: $e");
    }
  }

  Future<void> addOrder({
    required String serviceType,
    required String details,
    required String userId,
    required String userName,
    required String userPhone,
    required String unitNumber,
  }) async {
    try {
      final orderData = {
        "serviceType": serviceType,
        "details": details,
        "userId": userId,
        "userName": userName,
        "userPhone": userPhone,
        "status": false,
        "unitNumber": unitNumber,
        "timestamp": FieldValue.serverTimestamp(),
      };

      await _firestore.collection("requests").add(orderData);
    } catch (e) {
      throw Exception("Failed to add order: $e");
    }
  }

  Stream<QuerySnapshot> getRequests() {
    return _firestore
        .collection("requests")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }
}
