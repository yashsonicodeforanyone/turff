import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:turfapp/MyConstants/ShConstants.dart';


Future<String> getTurfbyIdapi(BuildContext
context, String userId
    ) async
{
  print("userid ${userId}");
  // print(searchText);
  // EasyLoading.show();
  Map<String, dynamic> formData = {
    'user_id' : userId
  };
  try{
    var response = await http.post(
      Uri.parse(BASE_URL+"/api/get_taruff_list_by_user_id"),
      body: formData,
    );
    print("turfListApi userid >>>>>>>>>>>>>>>>>> ** "+response.statusCode.toString());
    print("turfListApi userid>>>>>>>>>>>>>>>>>> ** "+response.body.toString());
    print("turfListApi userid > >>>>>>>>>>>>>>>>> ** "+formData.toString());



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