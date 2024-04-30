class PriceData {
  final String id;
  final String hourlyNumber;
  final String hourlyPrice;
  final String type; // Original type from API
  final String preselectedType; // Preselected type for form

  PriceData({
    required this.id,
    required this.hourlyNumber,
    required this.hourlyPrice,
    required this.type,
    required this.preselectedType,
  });

  PriceData.fromMap(Map<String, dynamic> map)
      : id = map['id'] as String,
        hourlyNumber = map['hourly_number'] as String,
        hourlyPrice = map['hourly_price'] as String,
        type = map['type'] as String,
        preselectedType = map['type'] as String; // Initialize preselectedType with type
}
