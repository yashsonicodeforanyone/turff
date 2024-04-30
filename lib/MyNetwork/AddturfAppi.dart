import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:turfapp/MyConstants/ShPrefConstants.dart';
import 'package:turfapp/Screen/VendorSide/HomePage.dart';
import 'package:turfapp/Screen/VendorSide/view_turf_detials.dart';
import '../MyConstants/ShConstants.dart';
import '../MyConstants/ShWidgetConsts.dart';
import '../Screen/HomeScreen.dart';
addTurfApi(
    List<XFile> _imageFilerooms,
    String turfName,
    String user_id,
    String ContactNo,
    String address,
    String squarefit,
    String aboutus,
    String cancellationPrivacy,
    String perhoursPrice,
    List<String> sport_type,
    String latitude,
    String longitude,
    List<String> facilities,
    String usertype,
    BuildContext context,
    ) async {
  EasyLoading.show();

  // var request = http.MultipartRequest('POST', Uri.parse('https://hotelbooking.toools.website//api/add_hotel'));
  var request = http.MultipartRequest(
      'POST', Uri.parse(BASE_URL + '/api/add_taruff'));


  request.fields['user_id'] = user_id;
  request.fields['turf_name'] = turfName;
  request.fields['address'] = address;
  request.fields['contact_no'] = ContactNo;
  request.fields['latitude'] = latitude;
  request.fields['longitude'] = longitude;
  request.fields['squarefit'] = squarefit;
  request.fields['about_us']= aboutus;
  request.fields['cancellation_policy'] = cancellationPrivacy;
  request.fields['per_hour_amount'] = perhoursPrice;
  // request.fields['sport_type'] = selectSportType;


  //user_id:5576
  // turf_name:my turff
  // address:address
  // contact_no:9876543210
  // latitude:22.719568
  // longitude:75.857727
  // squarefit:2000
  // sport_type:baseball
  // facilities[]:food
  // facilities[]:shelter


//request.fields['room[]'] = '500';

  for (var i = 0; i < facilities.length; i++) {
    request.fields['facilities[$i]'] = facilities[i];
  }

  for (var i = 0; i < sport_type.length; i++) {
    request.fields['sport_type[$i]'] = sport_type[i];
  }


  try {
    _imageFilerooms.removeWhere((element) => element == File(""));


    print("GGG>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" +
        _imageFilerooms.length.toString());
    for (var i = 0; i < _imageFilerooms.length; i++) {
      // print("GGGGGG>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"+_imageFilerooms[i].path);
      bool flag = _imageFilerooms[i].path.isEmpty;
      print("GGGGGG>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" +
          _imageFilerooms[i].path.isEmpty.toString());

      if (_imageFilerooms[i].path.isEmpty == false) {
        File _imagefile2 = File(_imageFilerooms[i].path);
        request.files.add(await http.MultipartFile.fromPath(
            'images[$i]', _imagefile2.path));
      }


    }
  } catch (e) {
    print("Exception >>>>>>>>>>>>>>>>>>>>>>>.. $e");
  }

  print("request >>>>>>>>>>>>>> " + request.fields.toString());

  http.StreamedResponse response = await request.send();


  print("addHotelApi >>>>" + response.toString());
  print("addHotelApi >>>>" + response.statusCode.toString());
  EasyLoading.dismiss();
  if (response.statusCode == 200) {
    var res = await http.Response.fromStream(response);

    print("addHotelApi >>>>" + res.body.toString());

    final responseData = jsonDecode(res.body);
    final message = responseData['message'];
    final status = responseData['status'];


    print("Login Response >>>>> status " + status.toString());
    if (status == 1) {
      print(">>> 1");
      //showAlertSuccess(message, context);
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => HomeforAdmin(cutomerid: user_id,usertype: usertype, contactno: ContactNo,)));
    }
    else {
      print(">>> 2");

      showAlert(message, context, user_id);
    }
  }
  else {
    print(response.reasonPhrase);
  }

}