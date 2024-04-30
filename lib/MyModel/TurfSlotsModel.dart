// To parse this JSON data, do
//
//     final turfSlotsModel = turfSlotsModelFromJson(jsonString);

import 'dart:convert';

TurfSlotsModel turfSlotsModelFromJson(String str) => TurfSlotsModel.fromJson(json.decode(str));

String turfSlotsModelToJson(TurfSlotsModel data) => json.encode(data.toJson());

class TurfSlotsModel {
  int status;
  List<Slot> slots;
  String message;

  TurfSlotsModel({
    required this.status,
    required this.slots,
    required this.message,
  });

  factory TurfSlotsModel.fromJson(Map<String, dynamic> json) => TurfSlotsModel(
    status: json["status"],
    slots: List<Slot>.from(json["slots"].map((x) => Slot.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "slots": List<dynamic>.from(slots.map((x) => x.toJson())),
    "message": message,
  };
}

class Slot {
  String id;
  String turfName;
  dynamic perHourAmount;
  String contactNo;
  String address;
  String latitude;
  String longitude;
  String squarefit;
  List<String> sportType;
  List<String> facilities;
  List<String> slots;
  List<dynamic> slotPricePerHours;

  Slot({
    required this.id,
    required this.turfName,
    required this.perHourAmount,
    required this.contactNo,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.squarefit,
    required this.sportType,
    required this.facilities,
    required this.slots,
    required this.slotPricePerHours,
  });

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
    id: json["id"],
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
    slots: List<String>.from(json["slots"].map((x) => x)),
    slotPricePerHours: List<dynamic>.from(json["slot_price_per_hours"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "turf_name": turfName,
    "per_hour_amount": perHourAmount,
    "contact_no": contactNo,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "squarefit": squarefit,
    // "sport_type": sportType,
    "sport_type": List<dynamic>.from(sportType.map((x) => x)),

    "facilities": List<dynamic>.from(facilities.map((x) => x)),
    "slots": List<dynamic>.from(slots.map((x) => x)),
    "slot_price_per_hours": List<dynamic>.from(slotPricePerHours.map((x) => x)),
  };
}
