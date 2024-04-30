// To parse this JSON data, do
//
//     final aboutUsModel = aboutUsModelFromJson(jsonString);

import 'dart:convert';

AboutUsModel aboutUsModelFromJson(String str) => AboutUsModel.fromJson(json.decode(str));

String aboutUsModelToJson(AboutUsModel data) => json.encode(data.toJson());

class AboutUsModel {
  int status;
  List<Datum> data;
  String message;

  AboutUsModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory AboutUsModel.fromJson(Map<String, dynamic> json) => AboutUsModel(
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
  String content;

  Datum({
    required this.id,
    required this.name,
    required this.content,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    content: json["content"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "content": content,
  };
}
