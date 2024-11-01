class UserData {
  String? id;
  String? phoneNumber;
  String? name;
  String? email;
  String? userType;
  String? password;

  UserData({
    required this.id,
    required this.userType,
    required this.phoneNumber,
    required this.name,
    required this.email,
    required this.password,
  });

  // A factory method to convert a Map to UserData object
  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'] ?? '',
      userType: map['userType'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
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


