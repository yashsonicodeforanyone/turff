/*
import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:turfapp/MyConstants/ShConstants.dart';

Future<void> submitBooking( String turf_id ,String name , String date , List<String> selectTimeList,
    String advanced_amont_percentage , String per_slot_price,String advanced_amount,
    String advanceAmountPre, String number,

    ) async {

  var headers = {
    'Cookie': 'ci_session=sinkmdg0tvujopu2chhmsh5lgpjmmk94'
  };
  var request = http.MultipartRequest(
      'POST',
      Uri.parse(BASE_URL+'/api/add_booking_by_vendor')
  );
  request.fields.addAll({
    'turf_id': turf_id,
    'name': name,
    'date': date,
    'slots[]': selectTimeList.join(''),
    'advanced_amont_percentage': advanced_amont_percentage,
    'per_slot_price': per_slot_price,
    'advanced_amount': advanced_amount,
    'total_amount': advanceAmountPre,
    'number': number,
    // "slots": selectTimeList.join(','),
  });
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    String responseBody = await response.stream.bytesToString();
    print("Response Body: $responseBody");

    Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
    if (jsonResponse['status'] == 1) {
      // Booking successful
      Fluttertoast.showToast(
        msg: "Booking successful: ${jsonResponse['message']}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      // Additional logic after successful booking
    } else {
      // Booking failed
      Fluttertoast.showToast(
        msg: "Booking failed: ${jsonResponse['message']}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  } else {
    // Response is not successful
    String responseBody = await response.stream.bytesToString();
    print("Response Body: $responseBody");

    Fluttertoast.showToast(
      msg: "Error: ${response.reasonPhrase}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

}
*/





import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:turfapp/Screen/VendorHistory/VendorHistoryScreen.dart';
// Import your home screen file


// Function to submit booking
Future<void> submitBooking(BuildContext context, String usertype, String turfId, String name, String date,
    List<String> selectedSlots, String advanceAmount, String perSlotPrice,
    String advancedAmount, String paymentAmount, String mobileNumber) async {
  var headers = {
    'Cookie': 'session=ra152mk9mne2gsp0kppqf7rjpld9hec8',
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  var request = http.MultipartRequest(
    'POST',
    Uri.parse('https://taruff.shortlinker.in/api/add_booking_by_vendor'),
  );

  request.headers.addAll(headers);
  request.fields['turf_id'] = turfId;
  request.fields['name'] = name;
  request.fields['date'] = date;
  request.fields['advanced_amont_percentage'] = advanceAmount;
  request.fields['per_slot_price'] = perSlotPrice;
  request.fields['advanced_amount'] = advancedAmount;
  request.fields['total_amount'] = paymentAmount;
  request.fields['number'] = mobileNumber;

  // Add each selected slot as a separate 'slots[]' field
  for (int i = 0; i < selectedSlots.length; i++) {
    request.fields['slots[$i]'] = selectedSlots[i];
  }

  try {
    final response = await request.send();

    if (response.statusCode == 200) {
      // Read the response as a string
      final responseBody = await response.stream.bytesToString();
      print(responseBody);
      Fluttertoast.showToast(
        msg: "Booking submitted successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => VendorHistoryScreen(
                  turf_id: turfId, user_type: usertype,
                  // user_type:
              ),
          ),
          (route)=>route.isFirst
      );

    } else {
      // If the server returns an error response, print the reason phrase
      print('Failed to submit booking: ${response.reasonPhrase}');
      Fluttertoast.showToast(
        msg: "Error: ${response.reasonPhrase}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  } catch (e) {
    // Catch any errors that occurred during the API call
    print('Error submitting booking: $e');

    // You can show an error message to the user here
  }
}
