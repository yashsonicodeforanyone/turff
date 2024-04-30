import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http ;



import 'package:fluttertoast/fluttertoast.dart';

Future<void> deleteImage(String imageUrl) async {
  print("image url : ${imageUrl}");
  try {
    var headers = {
      'Cookie': 'session=mj0fiv48ck7demevrp8orkd3og701cm3',
    };

    var request = http.MultipartRequest('POST', Uri.parse('https://taruff.shortlinker.in/api/image_delete_by_link'));
    request.fields.addAll({
      'link': imageUrl,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // Image delete API successful

      String responseBody = await response.stream.bytesToString();
      print("Image Delete not found: $responseBody");

      // Check if status is 1 for successful deletion
      var jsonResponse = jsonDecode(responseBody);
      if (jsonResponse['status'] == 1) {
        print("Image Delete Successful: $responseBody");
        // Show toast message
        Fluttertoast.showToast(
          msg: "Image Deleted Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      // Image delete API failed
      print("Image Delete Failed: ${response.reasonPhrase}");
    }
  } catch (e) {
    // Handle network errors
    print("Error deleting image: $e");
  }
}
