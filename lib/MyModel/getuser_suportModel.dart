// To parse this JSON data, do
//
//     final getUserSuportListModel = getUserSuportListModelFromJson(jsonString);

import 'dart:convert';

GetUserSuportListModel getUserSuportListModelFromJson(String str) => GetUserSuportListModel.fromJson(json.decode(str));

String getUserSuportListModelToJson(GetUserSuportListModel data) => json.encode(data.toJson());

class GetUserSuportListModel {
  int status;
  List<UserSuport> data;
  String message;

  GetUserSuportListModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory GetUserSuportListModel.fromJson(Map<String, dynamic> json) => GetUserSuportListModel(
    status: json["status"],
    data: List<UserSuport>.from(json["data"].map((x) => UserSuport.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class UserSuport {
  String id;
  String name;
  String email;
  String reply;
  String userVendorId;
  String taruffId;
  String message;
  DateTime createdDate;

  UserSuport({
    required this.id,
    required this.name,
    required this.email,
    required this.reply,
    required this.userVendorId,
    required this.taruffId,
    required this.message,
    required this.createdDate,
  });

  factory UserSuport.fromJson(Map<String, dynamic> json) => UserSuport(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    reply: json["reply"],
    userVendorId: json["user_vendor_id"],
    taruffId: json["taruff_id"],
    message: json["message"],
    createdDate: DateTime.parse(json["created_date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "reply": reply,
    "user_vendor_id": userVendorId,
    "taruff_id": taruffId,
    "message": message,
    "created_date": createdDate.toIso8601String(),
  };
}
