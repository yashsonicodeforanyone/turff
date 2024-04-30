// To parse this JSON data, do
//
//     final getTurfDetialsModel = getTurfDetialsModelFromJson(jsonString);

import 'dart:convert';

GetTurfDetialsModel getTurfDetialsModelFromJson(String str) => GetTurfDetialsModel.fromJson(json.decode(str));

String getTurfDetialsModelToJson(GetTurfDetialsModel data) => json.encode(data.toJson());

class GetTurfDetialsModel {
  int status;
  List<TurfDetials> data;
  String message;

  GetTurfDetialsModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory GetTurfDetialsModel.fromJson(Map<String, dynamic> json) => GetTurfDetialsModel(
    status: json["status"],
    data: List<TurfDetials>.from(json["data"].map((x) => TurfDetials.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class TurfDetials {
  String id;
  String userId;
  String turfName;
  String perHourAmount;
  String contactNo;
  String address;
  String latitude;
  String longitude;
  String squarefit;
  List<String> sportType;
  List<String> facilities;
  String aboutUs;
  String cancellationPolicy;
  String status;
  DateTime createddate;
  List<String> images;

  TurfDetials({
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

  factory TurfDetials.fromJson(Map<String, dynamic> json) => TurfDetials(
    id: json["id"],
    userId: json["user_id"],
    turfName: json["turf_name"],
    perHourAmount: json["per_hour_amount"],
    contactNo: json["contact_no"],
    address: json["address"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    squarefit: json["squarefit"],
    sportType: List<String>.from(json["sport_type"].map((x) => x)),
    facilities: List<String>.from(json["facilities"].map((x) => x)),
    aboutUs: json["about_us"],
    cancellationPolicy: json["cancellation_policy"],
    status: json["status"],
    createddate: DateTime.parse(json["createddate"]),
    images: List<String>.from(json["images"].map((x) => x)),
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
    "sport_type": List<dynamic>.from(sportType.map((x) => x)),
    "facilities": List<dynamic>.from(facilities.map((x) => x)),
    "about_us": aboutUs,
    "cancellation_policy": cancellationPolicy,
    "status": status,
    "createddate": createddate.toIso8601String(),
    "images": List<dynamic>.from(images.map((x) => x)),
  };
}
