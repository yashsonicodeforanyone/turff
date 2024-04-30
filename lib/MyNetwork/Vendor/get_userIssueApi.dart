import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../MyModel/getuser_suportModel.dart';

Future<List<UserSuport>> fetchUserSupportList(String id) async {
  var headers = {
    'Cookie': 'session=m5b8o4ujvpp6ohrdkmudg6udcfjld901'
  };

  var request = http.MultipartRequest('POST', Uri.parse('https://taruff.shortlinker.in/api/support_list_by_turf_id'));
  request.fields.addAll({
    'turf_id': id,
  });

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    String responseBody = await response.stream.bytesToString();
    List<dynamic> jsonList = jsonDecode(responseBody)['data'];

    List<UserSuport> userSupportList = [];
    for (var jsonItem in jsonList) {
      userSupportList.add(UserSuport.fromJson(jsonItem));
    }

    return userSupportList;
  } else {
    throw Exception('Failed to load user support list');
  }
}
