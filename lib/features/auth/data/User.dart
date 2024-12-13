class UserData {
  String? id;
  String? phoneNumber;
  String? name;
  String? email;
  String? userType;
  String? password;
  String? unitId;
  String? unitNo;
  // String? password;

  UserData({
    required this.id,
    required this.userType,
    required this.phoneNumber,
    required this.name,
    required this.email,
    required this.password,
    required this.unitId,
    required this.unitNo,
  });

  // A factory method to convert a Map to UserData object
  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'] ?? '',
      userType: map['userType'] ?? '',
      phoneNumber: map['phone'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      unitId: map['unitId'] ?? '',
      unitNo: map['unitNo'] ?? '',
    );
  }

  // A method to convert UserData object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userType': userType,
      'phoneNumber': phoneNumber,
      'name': name,
      'email': email,
      'password': password,
    };
  }
}


