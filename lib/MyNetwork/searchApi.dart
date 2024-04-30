/*
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? selectedTurfId;
  List<Map<String, dynamic>> turfList = []; // List to store turf names and IDs

  @override
  void initState() {
    super.initState();
    fetchTurfList(); // Fetch list of turfs from API
  }

  Future<void> fetchTurfList() async {
    var headers = {
      'Cookie': 'ci_session=1444hm725l9r5jiumps0u2movc5hooem'
    };
    var request = http.MultipartRequest('POST', Uri.parse('https://taruff.shortlinker.in/api/booking_list_by_customer_id'));
    request.fields.addAll({'customer_id': '5638'});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseData = jsonDecode(responseBody);
      if (responseData['status'] == 1) {
        List<dynamic> bookingList = responseData['booking'];
        setState(() {
          turfList = bookingList.map<Map<String, dynamic>>((booking) {
            return {
              'id': booking['turf_id'],
              'name': booking['turf_name']
            };
          }).toList();
        });
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dropdown Example'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField<String>(
            value: selectedTurfId,
            items: turfList.map<DropdownMenuItem<String>>((turf) {
              return DropdownMenuItem<String>(
                value: turf['id'].toString(),
                child: Text(turf['name']),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                selectedTurfId = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a turf';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Select turf',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
          ),
        ),
      ),
    );
  }
}
*/
