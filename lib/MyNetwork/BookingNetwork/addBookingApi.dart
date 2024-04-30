import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:turfapp/MyConstants/ShPrefConstants.dart';
import 'package:turfapp/Screen/CustomerHistory/CustomerHistoryScreen.dart';

import '../../MyConstants/ShConstants.dart';
import '../../MyConstants/ShWidgetConsts.dart';


Future<String> addBooking(BuildContext
context,
    String turf_id,
    String customer_id,
    String date,
    List<String> slots,
    String current_latitude,
    String current_longitude,
    String advanced_amont_percentage,
    String per_slot_price,
    String advanced_amount,
    String total_amount,
    String contactNo,
    String user_type,
    ) async
{




  print("check_turf_slot>>>>>>>>>>>>>>>>>>");
  EasyLoading.show();


  Map<String, dynamic> formData = {
  "turf_id":turf_id,
  "customer_id":customer_id,
  "date":date,
    "slots": {},
    "current_latitude":current_latitude,
    "current_longitude":current_longitude,
    "advanced_amont_percentage":advanced_amont_percentage,
    "per_slot_price":per_slot_price,
    "advanced_amount":advanced_amount,
    "total_amount":total_amount,
  };

  // for(int x=0;x<slots.length;x++)
  //   {
  //
  //     formData["slots"][x] = slots[x];
  //   }


  try{
    // var response = await http.post(
    //   Uri.parse(BASE_URL+"/api/add_booking"),
    //   body: formData,
    // );


    var request = http.MultipartRequest('POST', Uri.parse(BASE_URL+'/api/add_booking'));

    request.fields['turf_id'] = turf_id;
    request.fields['customer_id'] = customer_id;
    request.fields['date'] = date;

    request.fields['current_latitude'] = current_latitude;
    request.fields['current_longitude'] = current_longitude;
    request.fields['advanced_amont_percentage'] = advanced_amont_percentage;
    request.fields['advanced_amount'] = advanced_amount;
    request.fields['total_amount'] = total_amount;
    request.fields['per_slot_price'] = per_slot_price;

    for(int x=0;x<slots.length;x++)
    {

      request.fields['slots[$x]'] = slots[x];
    }

    print("Request >>>>>>>>>>>>>>> "+request.fields.toString());

    http.StreamedResponse response = await request.send();
    var res = await http.Response.fromStream(response);
    print("addHotelApi >>>>"+res.body.toString());

    final responseData = jsonDecode(res.body);
    final message = responseData['message'];
    final status = responseData['status'];


    print("Login Response >>>>> status "+status.toString());
    if(status == 1)
    {
      print(">>> 1");
      showAlertSuccessonlyBooking(message, context,customer_id,user_type,contactNo);

      print("usertypr ====>>> ${user_type}");
      print("usertid ====>>> ${contactNo}");


      // Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerHistoryScreen(cstomer_id: customer_id,)));


    }
    else
    {
      print(">>> 2");

      showAlert(message, context, customer_id);
    }

    print("add_booking>>>>>>>>>>>>>>>>>> ** "+res.statusCode.toString());
    print("add_booking>>>>>>>>>>>>>>>>>> ** "+res.body.toString());



    EasyLoading.dismiss();
    return res.body;

  }
  catch(e)
  {

    EasyLoading.dismiss();
    print("add_booking>>>>>>>>>>>>>>>>>> Error "+e.toString());
    return "";

  }

  EasyLoading.dismiss();
  return "";
}