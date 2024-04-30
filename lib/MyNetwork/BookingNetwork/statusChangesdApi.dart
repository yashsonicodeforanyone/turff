import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import '../../MyConstants/ShConstants.dart';

Future<String> statusChangedApi(BuildContext
context,
    String booking_id,
    String status,
    ) async
{
  print("check_turf_slot>>>>>>>>>>>>>>>>>>");
  EasyLoading.show();
  Map<String, dynamic> formData = {
    "booking_id": booking_id,
    "status": status,
  };

  try{
    var response = await http.post(
      Uri.parse(BASE_URL+"/api/booking_status_change_by_admin"),
      body: formData,
    );
    print("booking_delete>>>>>>>>>>>>>>>>>> ** "+response.statusCode.toString());
    print("booking_delete>>>>>>>>>>>>>>>>>> ** "+formData.toString());
    print("booking_delete>>>>>>>>>>>>>>>>>> ** "+response.body.toString());



    EasyLoading.dismiss();
    return response.body;

  }
  catch(e)
  {

    EasyLoading.dismiss();
    print("booking_delete>>>>>>>>>>>>>>>>>> Error "+e.toString());
    return "";

  }

  EasyLoading.dismiss();
  return "";
}