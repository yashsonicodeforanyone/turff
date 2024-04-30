  import 'package:flutter/material.dart';
  import 'package:http/http.dart' as http;
  import 'package:shared_preferences/shared_preferences.dart';
  import 'package:turfapp/MyConstants/ShPrefConstants.dart';
  import 'dart:convert';

  import 'package:turfapp/MyModel/get_turfByIdModel.dart';





  Future<List<TurfbyId>> fetchTurfList(String id) async {
    var headers = {
      'Cookie': 'ci_session=5p5hejlfb62ft4d7qe0ibgbnbhvj0sso'
    };
    var request = http.MultipartRequest('POST', Uri.parse('https://taruff.shortlinker.in/api/get_taruff_list_by_user_id'));
    request.fields.addAll({
      'user_id': id
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();

      List<dynamic> data = jsonDecode(responseBody)['data'];

      List<TurfbyId> turfList = data.map((item) => TurfbyId.fromJson(item)).toList();

      // String responseBody = await response.stream.bytesToString();
      // List<dynamic> data = jsonDecode(responseBody)['data'];

      // List<TurfbyId> turfList = data.map((item) => TurfbyId.fromJson(item)).toList();


      // String idsString = turfList.map((turf) => turf.id.toString()).join(', ');

      // Extract IDs from turfList
      // List<String> ids = turfList.map((turf) => turf.id.toString()).toList();
      // String idsString = ids.join(', ');
      //
      // // Save IDs to shared preferences
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setStringList(sp_turfId, idsString);

      //new
      List<String> ids = turfList.map((turf) => turf.id.toString()).toSet().toList(); // Remove duplicates using Set
      ids.sort(); // Sort the list in ascending order

      String idsString = ids.join(', ');

// Save IDs String to shared preferences
      String firstId = turfList.first.id.toString();

// Save first ID to shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(sp_turfId, firstId);
      print('First ID saved to SharedPreferences: ${firstId}');

      /* List<String> ids = turfList.map((turf) => turfList.first.id.toString()).toList();
      String idsString = ids.join(', ');

      // Save IDs String to shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(sp_turfId, idsString);
      print('IDs saved to SharedPreferences: ${idsString}');*/
      return turfList;

    } else {
      throw Exception('Failed to load turf list');
    }
  }



