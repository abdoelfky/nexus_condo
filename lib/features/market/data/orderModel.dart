import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String orderId;
  final String category;
  final String orderDetails;
  final String userId;
  final String userName;
  final String userPhone;
  final String unitNumber;
  final bool isProcessed;
  final DateTime createdAt;

  OrderModel({
    required this.orderId,
    required this.category,
    required this.orderDetails,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.unitNumber,
    required this.isProcessed,
    required this.createdAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String documentId) {
    return OrderModel(
      orderId: documentId,
      category: map['category'],
      orderDetails: map['orderDetails'],
      userId: map['userId'],
      userName: map['userName'],
      userPhone: map['userPhone'],
      unitNumber: map['unitNumber'],
      isProcessed: map['isProcessed'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'orderDetails': orderDetails,
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'unitNumber': unitNumber,
      'isProcessed': isProcessed,
      'createdAt': createdAt,
    };
  }
}
