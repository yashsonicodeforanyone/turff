import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

import '../../MyConstants/AppCustomDialog.dart';
import '../../MyConstants/ShImageConstants.dart';

Future<String> getAlladdressApi(BuildContext context, String search_text) async {

  EasyLoading.show();

  try {
    final response = await http.get(
      Uri.parse("https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search_text&key=AIzaSyBga08hxF1M7xcXViLjPivB9eZMcXZbB9k&sessiontoken=5622306"),

    );

    // Navigator.of(context).pop();
    EasyLoading.dismiss();

    if (response.statusCode == 200) {
      final responseBody = response.body;
      print("getAlladdressApi : " + responseBody);

      final responseData = jsonDecode(responseBody);

      return responseBody;
    } else if (response.statusCode == 401) {
      print("Session Expired from ChefList");
      final responseData = jsonDecode(response.body);
      final message = responseData['message'];
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CustomDialog(
          title: "Alert",
          description: "Session Expired",
          buttonText: "Okay",
          image: ic_alert,
          onTap: () {
            Navigator.of(context);
            // .pushAndRemoveUntil(
            //   MaterialPageRoute(builder: (context) => WelcomeScreen()),
            //       (Route<dynamic> route) => false,
            // );
          },
          colors: Colors.red,
        ),
      );

      return "";
    } else {
      print("getAlladdressApi Else" + response.body);
      final responseBody = response.body;
      // print(responseData);

      final responseData = jsonDecode(responseBody);
      final message = responseData['message'];


      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CustomDialog(
          title: "Alert",
          description: message,
          buttonText: "Okay",
          image: ic_alert,
          onTap: () {

            Navigator.pop(context);

          },
          colors: Colors.red,
        ),
      );
      return "";
    }
  } catch (e) {
    print(e);
    return "";
  }
}