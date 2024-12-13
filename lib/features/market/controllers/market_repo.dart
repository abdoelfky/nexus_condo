import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexus_condo/features/market/data/orderModel.dart';

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addOrder(OrderModel order) async {
    await _firestore.collection('orders').add(order.toMap());
  }

  Stream<List<OrderModel>> fetchOrders() {
    return _firestore.collection('orders').snapshots().map(
          (snapshot) => snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
          .toList(),
    );
  }

  Future<void> updateOrderStatus(String orderId, bool isProcessed) async {
    await _firestore
        .collection('orders')
        .doc(orderId)
        .update({'isProcessed': isProcessed});
  }
}
