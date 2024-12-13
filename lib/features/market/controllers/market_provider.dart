import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_condo/features/market/controllers/market_repo.dart';
import 'package:nexus_condo/features/market/data/orderModel.dart';

// Order Repository Provider
final orderRepositoryProvider = Provider((ref) => OrderRepository());

// Stream Provider for Orders
final ordersProvider = StreamProvider<List<OrderModel>>((ref) {
  return ref.read(orderRepositoryProvider).fetchOrders();
});
