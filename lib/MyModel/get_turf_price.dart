// To parse this JSON data, do
//
//     final getTurfPriceModel = getTurfPriceModelFromJson(jsonString);

import 'dart:convert';

GetTurfPriceModel getTurfPriceModelFromJson(String str) => GetTurfPriceModel.fromJson(json.decode(str));

String getTurfPriceModelToJson(GetTurfPriceModel data) => json.encode(data.toJson());

class GetTurfPriceModel {
  int status;
  int price;
  String message;
  int perSlotPrice;


  GetTurfPriceModel({
    required this.status,
    required this.price,
    required this.message,
    required this.perSlotPrice,

  });

  factory GetTurfPriceModel.fromJson(Map<String, dynamic> json) => GetTurfPriceModel(
    status: json["status"]??'',
    price: json["price"]??'',
    message: json["message"]??'',
    perSlotPrice: json["per_slot_price"]??'',

  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "price": price,
    "message": message,
    "per_slot_price": perSlotPrice,

  };
}
