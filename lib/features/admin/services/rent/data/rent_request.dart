class RentRequest {
  final String id;
  final String unitId;
  final String unitNo;
  final String userId;
  final String userEmail;
  final DateTime requestDate;
  final String status;

  RentRequest({
    required this.id,
    required this.unitId,
    required this.unitNo,
    required this.userId,
    required this.userEmail,
    required this.requestDate,
    required this.status,
  });

  factory RentRequest.fromFirestore(
      Map<String, dynamic> data,
      String documentId,
      ) {
    return RentRequest(
      id: documentId,
      unitId: data['unitId'],
      unitNo: data['unitNo'],
      userId: data['userId'],
      userEmail: data['userEmail'],
      requestDate: DateTime.parse(data['requestDate']),
      status: data['status'],
    );
  }

  Map<String, dynamic> toFirestore() => {
    'unitId': unitId,
    'unitNo': unitNo,
    'userId': userId,
    'userEmail': userEmail,
    'requestDate': requestDate.toIso8601String(),
    'status': status,
  };
}
