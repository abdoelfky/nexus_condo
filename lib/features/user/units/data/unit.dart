class Unit {
  final String id;
  final String unitNo;
  final String space;
  final String roomNo;
  final String details;
  final String pricePerMonth;
  final String pricePerYear;
  final bool isRented;
  final List<String> imageUrls;

  Unit({
    required this.id,
    required this.isRented,
    required this.unitNo,
    required this.space,
    required this.roomNo,
    required this.details,
    required this.pricePerMonth,
    required this.pricePerYear,
    required this.imageUrls,
  });

  factory Unit.fromMap(String id, Map<String, dynamic> data) {
    return Unit(
      id: id,
      unitNo: data['unitNo'] ?? '',
      space: data['unitSpace'] ?? '',
      roomNo: data['unitRoomNo'] ?? '',
      details: data['unitDetails'] ?? '',
      pricePerMonth: data['unitPricePerM'] ?? '',
      isRented: data['is_rented'] ?? false,
      pricePerYear: data['unitPricePerY'] ?? '',
      imageUrls: List<String>.from(data['images'] ?? []),
    );
  }
}
