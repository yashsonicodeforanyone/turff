import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import '../MyConstants/ShConstants.dart';


Future<String> updateuserTypeScreen(BuildContext
context, String user_id,String usert_type
    ) async
{

  print("updateuserTypeScreen>>>>>>>>>>>>>>>>>>"+usert_type);
  EasyLoading.show();


  Map<String, dynamic> formData = {
    "userid": user_id,
    "type": usert_type,
  };
  try{
    var response = await http.post(
      Uri.parse(BASE_URL+"/api/update_usertype"),
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