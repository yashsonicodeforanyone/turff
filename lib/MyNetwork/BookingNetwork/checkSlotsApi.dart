import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

import '../../MyConstants/ShConstants.dart';

Future<String> checkSlotsType(BuildContext
context, String turf_id,String date
    ) async
{

  print("check_turf_slot>>>>>>>>>>>>>>>>>>");
  EasyLoading.show();


  Map<String, dynamic> formData = {
    "turf_id": turf_id,
    "date": date,
  };

  try{
    var response = await http.post(
      Uri.parse(BASE_URL+"/api/check_turf_slot"),
      body: formData,
    );
    print("check_turf_slot>>>>>>>>>>>>>>>>>> ** "+response.statusCode.toString());
    print("check_turf_slot>>>>>>>>>>>>>>>>>> ** "+formData.toString());
    print("check_turf_slot>>>>>>>>>>>>>>>>>> ** "+response.body.toString());
    EasyLoading.dismiss();
    return response.body;
  }
  catch(e)
  {

    EasyLoading.dismiss();
    print("check_turf_slot>>>>>>>>>>>>>>>>>> Error "+e.toString());
    return "";

  }

  EasyLoading.dismiss();
  return "";
}