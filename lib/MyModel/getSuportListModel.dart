// To parse this JSON data, do
//
//     final getSuportListModel = getSuportListModelFromJson(jsonString);

import 'dart:convert';

GetSuportListModel getSuportListModelFromJson(String str) => GetSuportListModel.fromJson(json.decode(str));

String getSuportListModelToJson(GetSuportListModel data) => json.encode(data.toJson());

class GetSuportListModel {
  int status;
  List<Datum> data;
  String message;

  GetSuportListModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory GetSuportListModel.fromJson(Map<String, dynamic> json) => GetSuportListModel(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class Datum {
  String id;
  String name;
  Email email;
  String reply;
  String userVendorId;
  String taruffId;
  String message;
  DateTime createdDate;

  Datum({
    required this.id,
    required this.name,
    required this.email,
    required this.reply,
    required this.userVendorId,
    required this.taruffId,
    required this.message,
    required this.createdDate,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    email: emailValues.map[json["email"]]!,
    reply: json["reply"],
    userVendorId: json["user_vendor_id"],
    taruffId: json["taruff_id"],
    message: json["message"],
    createdDate: DateTime.parse(json["created_date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": emailValues.reverse[email],
    "reply": reply,
    "user_vendor_id": userVendorId,
    "taruff_id": taruffId,
    "message": message,
    "created_date": createdDate.toIso8601String(),
  };
}

enum Email {
  EMPTY
}

final emailValues = EnumValues({
  " ": Email.EMPTY
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
