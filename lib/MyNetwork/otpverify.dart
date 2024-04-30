import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

import '../MyConstants/ShConstants.dart';


Future<String> otpverifyapi(BuildContext
context, String contactno,String otp
    ) async
{
  print("adminLoginApi>>>>>>>>>>>>>>>>>>"+contactno);
  EasyLoading.show();
  Map<String, dynamic> formData = {
    "phone": contactno,
    "otp": otp,
  };
  try{
    var response = await http.post(
      Uri.parse(BASE_URL+"/api/otp_verify"),
      body: formData,
    );
    print("adminLoginApi>>>>>>>>>>>>>>>>>> ** "+response.statusCode.toString());
    print("adminLoginApi>>>>>>>>>>>>>>>>>> ** "+response.body.toString());



    EasyLoading.dismiss();
    return response.body;

  }
  catch(e)
  {

    EasyLoading.dismiss();
    print("adminLoginApi>>>>>>>>>>>>>>>>>> Error "+e.toString());
    return "";

  }

  EasyLoading.dismiss();
  return "";
}