import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

import '../../MyConstants/ShConstants.dart';

Future<String> getVendorbookingApi(BuildContext
context, String id
    ) async
{

  EasyLoading.show();


  Map<String, dynamic> formData = {
    "turf_id": id,
  };
  try{
    var response = await http.post(
      Uri.parse(BASE_URL+"/api/booking_list_by_turf_id"),
      body: formData,
    );
    print("turfListApi>>>>>>>>>>>>>>>>>> ** "+response.statusCode.toString());
    print("turfListApi>>>>>>>>>>>>>>>>>> ** "+response.body.toString());
    print("turfListApi>>>>>>>>>>>>>>>>>> ** "+formData.toString());



    EasyLoading.dismiss();
    return response.body;

  }
  catch(e)
  {

    EasyLoading.dismiss();
    print("turfListApi>>>>>>>>>>>>>>>>>> Error "+e.toString());
    return "";

  }

  EasyLoading.dismiss();
  return "";
}