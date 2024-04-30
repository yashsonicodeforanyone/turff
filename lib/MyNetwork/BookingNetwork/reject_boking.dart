import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

import '../../MyConstants/ShConstants.dart';

Future<String> rejectBookingApi(BuildContext
context, String booking_id, String reason
    ) async
{
  print("api call ${reason}>>>>>>>>>>>>>>>>>>");
  EasyLoading.show();
  Map<String, dynamic> formData = {
    "booking_id": booking_id,
    'reason': reason
  };
  try{
    var response = await http.post(
      Uri.parse(BASE_URL+"/api/booking_reject_by_booking_id"),
      body: formData,
    );
    print("reject>>>>>>>>>>>>>>>>>> ** "+response.statusCode.toString());
    print("reject>>>>>>>>>>>>>>>>>> ** "+formData.toString());
    print("booking_delete>>>>>>>>>>>>>>>>>> ** "+response.body.toString());
    EasyLoading.dismiss();
    return response.body;
  }
  catch(e)
  {
    EasyLoading.dismiss();
    print("reject>>>>>>>>>>>>>>>>>> Error "+e.toString());
    return "";
  }
  EasyLoading.dismiss();
  return "";
}






