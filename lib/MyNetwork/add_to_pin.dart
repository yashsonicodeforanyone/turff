import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;

Future<void> addToPin(String userId, String turfId) async {

  var headers = {
    'Cookie': 'ci_session=416r8vkbtdb57mn1ummuvd8vpd65p54f'
  };
  var uri = Uri.parse('https://taruff.shortlinker.in/api/add_taruff_as_pin');
  var request = http.MultipartRequest('POST', uri);
  request.fields.addAll({
    'user_id': turfId,
    'turf_id': userId,
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  String message = '';

  if (response.statusCode == 200) {
    // Parse the response body
    String responseBody = await response.stream.bytesToString();
    Map<String, dynamic> jsonResponse = jsonDecode(responseBody);

    print("pin responce ===>${responseBody}");

    // Extract the message
    if (jsonResponse.containsKey('message')) {
      message = jsonResponse['message'];
    } else {
      message = 'Unknown message';
    }
    print(message);
  } else {
    // If there's an error, set a default error message
    message = 'Failed to add to pin';
  }

  // Show the message using Fluttertoast
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: response.statusCode == 200 ? Colors.green : Colors.red, // Change color based on success or failure
    textColor: Colors.black,
  );
}
