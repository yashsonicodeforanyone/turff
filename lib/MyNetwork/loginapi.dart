import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

import '../MyConstants/ShConstants.dart';

Future<String> loginapi(BuildContext
context, String contactno
    ) async
{

  print("adminLoginApi>>>>>>>>>>>>>>>>>>"+contactno);
  EasyLoading.show();


  Map<String, dynamic> formData = {
    "phone": contactno,
  };


  try{
    var response = await http.post(
      Uri.parse(BASE_URL+"/api/login"),
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