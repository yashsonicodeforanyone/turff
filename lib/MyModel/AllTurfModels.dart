// To parse this JSON data, do
//
//     final allTurfModel = allTurfModelFromJson(jsonString);


import 'dart:convert';

AllTurfModel allTurfModelFromJson(String str) => AllTurfModel.fromJson(json.decode(str));

String allTurfModelToJson(AllTurfModel data) => json.encode(data.toJson());

class AllTurfModel {
  int status;
  List<TurfModel> data;
  String message;

  AllTurfModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory AllTurfModel.fromJson(Map<String, dynamic> json) => AllTurfModel(
    status: json["status"],
    data: List<TurfModel>.from(json["data"].map((x) => TurfModel.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class TurfModel {
  String id;
  String userId;
  String turfName;
  dynamic perHourAmount;
  String contactNo;
  String address;
  String latitude;
  String longitude;
  String squarefit;
  List<String> sportType;
  List<String>? facilities;
  DateTime createddate;
  List<String> images;
  int isTurfPin;
  double distance;

  bool get isPinned => isTurfPin == 1;


  TurfModel({
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
    required this.createddate,
    required this.images,
    required this.isTurfPin,
    required this.distance,
  });

  factory TurfModel.fromJson(Map<String, dynamic> json) => TurfModel(
    id: json["id"],
    userId: json["user_id"],
    turfName: json["turf_name"],
    perHourAmount: json["per_hour_amount"],
    contactNo: json["contact_no"],
    address: json["address"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    squarefit: json["squarefit"],
    // sportType: json["sport_type"],
    sportType: List<String>.from(json["sport_type"].map((x) => x)),
    facilities: List<String>.from(json["facilities"].map((x) => x)),
    createddate: DateTime.parse(json["createddate"]),
    images: List<String>.from(json["images"].map((x) => x)),
    isTurfPin: json["is_turf_pin"],
    distance: json["distance"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "turf_name": turfName,
    "per_hour_amount": perHourAmount,
    "contact_no": contactNo,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "squarefit": squarefit,
    "sport_type": sportType,
    "facilities": List<dynamic>.from(facilities!.map((x) => x)),
    "createddate": createddate.toIso8601String(),
    "images": List<dynamic>.from(images.map((x) => x)),
    "is_turf_pin": isTurfPin,
    "distance": distance,
  };
}
