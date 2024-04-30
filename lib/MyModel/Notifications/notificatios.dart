// To parse this JSON data, do
//
//     final notificationList = notificationListFromJson(jsonString);

import 'dart:convert';

NotificationList notificationListFromJson(String str) => NotificationList.fromJson(json.decode(str));

String notificationListToJson(NotificationList data) => json.encode(data.toJson());

class NotificationList {
  int status;
  List<Datum> data;
  String message;

  NotificationList({
    required this.status,
    required this.data,
    required this.message,
  });

  factory NotificationList.fromJson(Map<String, dynamic> json) => NotificationList(
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
  String message;
  DateTime createdDate;

  Datum({
    required this.id,
    required this.message,
    required this.createdDate,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    message: json["message"],
    createdDate: DateTime.parse(json["created_date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "message": message,
    "created_date": createdDate.toIso8601String(),
  };
}
