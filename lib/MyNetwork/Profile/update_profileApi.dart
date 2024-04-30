import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:turfapp/MyConstants/ShConstants.dart';


/*
Future<String> updateProfile(BuildContext
context, String name, String id
    ) async
{

  print("adminLoginApi>>>>>>>>>>>>>>>>>>"+name);
  EasyLoading.show();



  Map<String, dynamic> formData = {

    'user_id': id,
    'name':name,
  };


  try{
    var response = await http.post(
      Uri.parse('https://taruff.shortlinker.in/api/update_profile'),

      body: formData,

    );
    print("adminLoginApi>>>>>>>>>>>>>>>>>> ** "+response.statusCode.toString());
    print("adminLoginApi>>>>>>>>>>>>>>>>>> ** "+response.body.toString());



    EasyLoading.dismiss();
    return response.body;

  }
  catch(e)
  {

    EasyLoading.dismiss();
    print("adminLoginApi>>>>>>>>>>>>>>>>>> Error "+e.toString());
    return "";

  }

  EasyLoading.dismiss();
  return "";
}
*/

Future<Map<String, dynamic>> updateProfile(BuildContext
  context,  String id,String name, File? imageFile )
  async {
    var headers = {
      'Cookie': 'ci_session=72pm8201jl1npe841iksgoo3jlphce4m'
    };
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://taruff.shortlinker.in/api/create_support'),
    );
    request.fields.addAll({
      'user_id': id,
      'name':name,
    });

    // Add image file if it is not null
    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('img', imageFile!.path));
    }


    request.headers.addAll(headers);
    var response = await http.Response.fromStream(await request.send());
    return json.decode(response.body);
  }

