import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';


void replyApi(String id, String message) async {
  var headers = {
    'Cookie': 'ci_session=plslbv9pflu71g73n0u0mkks7ufof0b0'
  };

  var request = http.MultipartRequest('POST', Uri.parse('https://taruff.shortlinker.in/api/support_reply'));
  request.fields.addAll({
    'id': id,
    'message': message,
  });

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    // Response ka JSON format read karne ke liye
    String responseBody = await response.stream.bytesToString();

    // JSON String ko JSON object mein convert karne ka kaam
    Map<String, dynamic> jsonResponse = json.decode(responseBody);

    // "status" aur "message" values ko extract karne
    int status = jsonResponse['status'];
    String responseMessage = jsonResponse['message'];

    // Ab aap jo bhi karna chahte hain, status aur message ke basis par kar sakte hain
    if (status == 1) {
      _showToast("Success: $responseMessage");
    } else {
      _showToast("Error: $responseMessage");
    }
  } else {
    // _showToast(response.reasonPhrase);
  }
}

void _showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.green, // Change color based on success or error
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
