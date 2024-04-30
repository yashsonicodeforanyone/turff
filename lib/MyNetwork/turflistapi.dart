import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import '../MyConstants/ShConstants.dart';


Future<String> getturflistapi(BuildContext
context, String latitude,String longitude,String searchText,String userId
     ) async
{
print("userid ${userId}");
//5595
print(searchText);
  // EasyLoading.show();
  Map<String, dynamic> formData = {
    "latitude": latitude,
    "longitude": longitude,
    'search': searchText,
    'user_id' : userId
  };

  try{
    var response = await http.post(
      Uri.parse(BASE_URL+"/api/taruff_list"),
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