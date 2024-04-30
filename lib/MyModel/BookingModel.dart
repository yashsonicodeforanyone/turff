// To parse this JSON data, do
//
//     final turfBookingModel = turfBookingModelFromJson(jsonString);

import 'dart:convert';

TurfBookingModel turfBookingModelFromJson(String str) => TurfBookingModel.fromJson(json.decode(str));

String turfBookingModelToJson(TurfBookingModel data) => json.encode(data.toJson());

class TurfBookingModel {
  int status;
  List<Booking> booking;
  String message;

  TurfBookingModel({
    required this.status,
    required this.booking,
    required this.message,
  });

  factory TurfBookingModel.fromJson(Map<String, dynamic> json) => TurfBookingModel(
    status: json["status"],
    booking: List<Booking>.from(json["booking"].map((x) => Booking.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "booking": List<dynamic>.from(booking.map((x) => x.toJson())),
    "message": message,
  };
}

class Booking {
  String turfName;
  String taruffStatus;
  String taruffImg;
  String id;
  String turfId;
  String userId;
  List<String> slots;
  dynamic currentLatitude;
  dynamic currentLongitude;
  String advancedAmontPercentage;
  String perSlotPrice;
  String advancedAmount;
  String totalAmount;
  DateTime bookingDate;
  String isDelete;
  String status;
  String cancelReason;
  DateTime createddate;
  DateTime updatedate;
  String turfHonorName;
  String turfHonorPhone;
  String bookingUserName;
  String bookingUserPhone;
  String isdirectbooking;
  // "is_direct_booking": "1",


  Booking({
    required this.turfName,
    required this.taruffStatus,
    required this.taruffImg,
    required this.id,
    required this.turfId,
    required this.userId,
    required this.slots,
    required this.currentLatitude,
    required this.currentLongitude,
    required this.advancedAmontPercentage,
    required this.perSlotPrice,
    required this.advancedAmount,
    required this.totalAmount,
    required this.bookingDate,
    required this.isDelete,
    required this.status,
    required this.cancelReason,
    required this.createddate,
    required this.updatedate,
    required this.turfHonorName,
    required this.turfHonorPhone,
    required this.bookingUserName,
    required this.bookingUserPhone,
    required this.isdirectbooking,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    turfName: json["turf_name"]??'',
    taruffStatus: json["taruff_status"]??'',
    taruffImg: json["taruff_img"]??'',
    id: json["id"]??'',
    turfId: json["turf_id"]??'',
    userId: json["user_id"]??'',
    slots: List<String>.from(json["slots"].map((x) => x)),
    currentLatitude: json["current_latitude"]??'',
    currentLongitude: json["current_longitude"]??'',
    advancedAmontPercentage: json["advanced_amont_percentage"]??'',
    perSlotPrice: json["per_slot_price"]??'',
    advancedAmount: json["advanced_amount"]??'',
    totalAmount: json["total_amount"]??'',
    bookingDate: DateTime.parse(json["booking_date"]),
    isDelete: json["is_delete"]??'',
    status: json["status"]??'',
    cancelReason: json["cancel_reason"]??'',
    createddate: DateTime.parse(json["createddate"]),
    updatedate: DateTime.parse(json["updatedate"]),
    turfHonorName: json["turf_honor_name"]??'',
    turfHonorPhone: json["turf_honor_phone"]??'',
    bookingUserName: json["booking_user_name"]??'',
    bookingUserPhone: json["booking_user_phone"]??'',
    isdirectbooking:  json["is_direct_booking"]??'',
  );

  Map<String, dynamic> toJson() => {
    "turf_name": turfName,
    "taruff_status": taruffStatus,
    "taruff_img": taruffImg,
    "id": id,
    "turf_id": turfId,
    "user_id": userId,
    "slots": List<dynamic>.from(slots.map((x) => x)),
    "current_latitude": currentLatitude,
    "current_longitude": currentLongitude,
    "advanced_amont_percentage": advancedAmontPercentage,
    "per_slot_price": perSlotPrice,
    "advanced_amount": advancedAmount,
    "total_amount": totalAmount,
    "booking_date": "${bookingDate.year.toString().padLeft(4, '0')}-${bookingDate.month.toString().padLeft(2, '0')}-${bookingDate.day.toString().padLeft(2, '0')}",
    "is_delete": isDelete,
    "status": status,
    "cancel_reason": cancelReason,
    "createddate": createddate.toIso8601String(),
    "updatedate": updatedate.toIso8601String(),
    "turf_honor_name": turfHonorName,
    "turf_honor_phone": turfHonorPhone,
    "booking_user_name": bookingUserName,
    "booking_user_phone": bookingUserPhone,
    "is_direct_booking": isdirectbooking,

  };
}
