import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:turfapp/MyConstants/ShConstants.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:turfapp/MyConstants/ShPrefConstants.dart';
import 'package:turfapp/Screen/HomeScreen.dart';
import 'package:turfapp/Screen/VendorSide/HomePage.dart';
import 'package:turfapp/Screen/VendorSide/view_turf_detials.dart';



editTurfApi(
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
    String turf_id,
    BuildContext context,
    ) async {

  EasyLoading.show();

  var request = http.MultipartRequest(
      'POST', Uri.parse(BASE_URL + '/api/edit_taruff'));

  request.fields['user_id'] = user_id;
  request.fields['turf_name'] = turfName;
  request.fields['address'] = address;
  request.fields['contact_no'] = ContactNo;
  request.fields['latitude'] = latitude;
  request.fields['longitude'] = longitude;
  request.fields['squarefit'] = squarefit;
  // request.fields['sport_type'] = selectSportType;
  request.fields['turf_id'] = turf_id; // Add turf_id for editing
  request.fields['about_us']= aboutus;
  request.fields['cancellation_policy'] = cancellationPrivacy;
  request.fields['per_hour_amount'] = perhoursPrice;



  for (var i = 0; i < facilities.length; i++) {
    request.fields['facilities[$i]'] = facilities[i];
  }


  for (var i = 0; i < sport_type.length; i++) {
    request.fields['sport_type[$i]'] = sport_type[i];
  }

  try {
    _imageFilerooms.removeWhere((element) => element == File(""));

    for (var i = 0; i < _imageFilerooms.length; i++) {
      if (_imageFilerooms[i].path.isEmpty == false) {
        File _imagefile2 = File(_imageFilerooms[i].path);
        request.files.add(await http.MultipartFile.fromPath(
            'images[$i]', _imagefile2.path));
      }
    }
  } catch (e) {
    print("Exception >>>>>>>>>>>>>>>>>>>>>>>.. $e");

  }


  // Print all the posted data
  print("Request Fields >>>>");
  print("user_id: $user_id");
  print("turf_name: $turfName");
  print("address: $address");
  print("contact_no: $ContactNo");
  print("latitude: $latitude");
  print("longitude: $longitude");
  print("squarefit: $squarefit");
  print("turf_id: $turf_id");
  print("about_us: $aboutus");
  print("cancellation_policy: $cancellationPrivacy");
  print("per_hour_amount: $perhoursPrice");

  for (var i = 0; i < facilities.length; i++) {
    print("facilities[$i]: ${facilities[i]}");
  }

  for (var i = 0; i < sport_type.length; i++) {
    print("sport_type[$i]: ${sport_type[i]}");
  }

  print("Request Files >>>>");
  for (var i = 0; i < request.files.length; i++) {
    print("images[$i]: ${request.files[i].filename}");
  }

  print("Request URL >>>> ${request.url}");
  print("Request Method >>>> ${request.method}");



  print("request >>>>>>>>>>>>>> " + request.fields.toString());

  http.StreamedResponse response = await request.send();

  print("editTurfApi >>>>" + response.toString());
  print("editTurfApi >>>>" + response.statusCode.toString());
  EasyLoading.dismiss();
  if (response.statusCode == 200) {
    var res = await http.Response.fromStream(response);

    print("editTurfApi >>>>" + res.body.toString());

    final responseData = jsonDecode(res.body);
    final message = responseData['message'];
    final status = responseData['status'];

    
    print("Edit Response >>>>> status " + status.toString());
    if (status == 1) {
      print(">>> 1");
      // Show success message or navigate to success screen
      // For example:
      // Navigator.push(context, MaterialPageRoute(
      //     builder: (context) => SuccessScreen()));
      print("Edit Response >>>>> status " + status.toString());

      Navigator.push(context, MaterialPageRoute(
          builder: (context) => HomeforAdmin(cutomerid: user_id,usertype: usertype, contactno: ContactNo,)));
    }
    else {
      print(">>> 2");
      // Handle error message
    }
  }
  else {
    print(response.reasonPhrase);
  }
}


