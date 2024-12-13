class Complaint {
  final String id;
  final String name;
  final String phone;
  final String unitNo;
  final String message;
  final DateTime createdAt;

  Complaint({
    required this.id,
    required this.name,
    required this.phone,
    required this.unitNo,
    required this.message,
    required this.createdAt,
  });

  factory Complaint.fromFirestore(String id, Map<String, dynamic> data) {
    return Complaint(
      id: id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      unitNo: data['unitNo'] ?? '',
      message: data['message'] ?? '',
      createdAt: DateTime.parse(data['createdAt']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'phone': phone,
      'unitNo': unitNo,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
