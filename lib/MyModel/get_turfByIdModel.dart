class TurfbyId {
final  String id;
  final String userId;
 final  String turfName;
final String perHourAmount;
final String contactNo;
final String address;
final String latitude;
final String longitude;
final String squarefit;
final List<String> sportType;
final List<String> facilities;
final  String aboutUs;
final String cancellationPolicy;
final String status;
final String createddate;
final List<String> images;



  TurfbyId({
    required this.id,
    required this.userId,
    required this.turfName,
    required this.perHourAmount,
    required this.contactNo,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.squarefit,
    required this.sportType,
    required this.facilities,
    required this.aboutUs,
    required this.cancellationPolicy,
    required this.status,
    required this.createddate,
    required this.images,
  });

  factory TurfbyId.fromJson(Map<String, dynamic> json) {
    return TurfbyId(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      turfName: json['turf_name'] ?? '',
      perHourAmount: json["per_hour_amount"],
      contactNo: json['contact_no'] ?? '',
      address: json['address'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      squarefit: json['squarefit'] ?? '',
      sportType: List<String>.from(json['sport_type'] ?? []),
      facilities: List<String>.from(json['facilities'] ?? []),
      aboutUs: json["about_us"],
      cancellationPolicy: json["cancellation_policy"],
      status: json["status"],
      createddate: json['createddate'] ?? '',
      images: List<String>.from(json['images'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'turf_name': turfName,
      "per_hour_amount": perHourAmount,
      'contact_no': contactNo,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'squarefit': squarefit,
      'sport_type': sportType,
      'facilities': facilities,
      "about_us": aboutUs,
      "cancellation_policy": cancellationPolicy,
      "status": status,
      'createddate': createddate,
      'images': images,
    };
  }
}
