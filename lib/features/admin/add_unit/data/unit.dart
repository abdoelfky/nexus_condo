import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String docID;
  final String email;
  final String phone;
  final String name;
  final String userType;
  final DateTime createdAt;
  final bool isRented;

  UserModel({
    required this.docID,
    required this.email,
    required this.phone,
    required this.name,
    required this.userType,
    required this.createdAt,
    required this.isRented,
  });

  /// Factory constructor to create a `UserModel` from Firestore document data
  factory UserModel.fromMap(Map<String, dynamic> map, String documentID) {
    return UserModel(
      docID: documentID,
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      name: map['name'] ?? '',
      isRented: map['is_rented'] ?? false,
      userType: map['userType'] ?? 'user', // Default userType
      createdAt: (map['created_at'] as Timestamp).toDate(),
    );
  }

  /// Convert `UserModel` to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'docID': docID,
      'email': email,
      'phone': phone,
      'is_rented': isRented,
      'name': name,
      'userType': userType,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }
}
