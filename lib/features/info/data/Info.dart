class InfoModel {
  List<String?> body;

  InfoModel({
    required this.body,
  });

  // Factory method to create an InfoModel from a Map
  factory InfoModel.fromMap(Map<String, dynamic> map) {
    return InfoModel(
      body: List<String?>.from(map['body']),
    );
  }

  // Method to convert InfoModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'body': body,
    };
  }
}
