import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import '../../MyConstants/ShConstants.dart';

Future<String> getCustomerBooking(BuildContext
context, String id, String searchText
    ) async
{
print("cus id =======${id}");
  EasyLoading.show();
  Map<String, dynamic> formData = {
    "customer_id": id,
    'search': searchText
  };
  try{
    var response = await http.post(
      Uri.parse(BASE_URL+"/api/booking_list_by_customer_id"),
      body: formData,
    );
    print("turfListApi vendore>>>>>>>>>>>>>>>>>> ** "+response.statusCode.toString());
    print("turfListApi>>>>>>>>>>>>>>>>>> ** "+response.body.toString());
    print("turfListApi>>>>>>>>>>>>>>>>>> ** "+formData.toString());
    EasyLoading.dismiss();
    return response.body;
  }
  catch(e)
  {
    EasyLoading.dismiss();
    print("turfListApi>>>>>>customer>>>>>>>>>>>> Error "+e.toString());
    return "";
  }

  EasyLoading.dismiss();
  return "";
}