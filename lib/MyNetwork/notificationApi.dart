/*
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:turfapp/MyModel/Notifications/notificatios.dart';



Future<List<NotificationList>> fetchNotifications() async {
  final response = await http.get(Uri.parse('YOUR_API_ENDPOINT'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['data'];
    return data.map((json) => NotificationList.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load notifications');
  }
}
*/



import 'dart:convert';
import 'package:http/http.dart' as http;

import '../MyModel/Notifications/notificatios.dart';

// getAnnoucementList
Future<NotificationList?> fetchNotifications(String userid, String type) async {
  var headers = {
    'Cookie': 'ci_session=kuttq9l77vg5k1ni4s2gb9rl61jml1r2'
  };
  var request = http.MultipartRequest('POST', Uri.parse('https://taruff.shortlinker.in/api/notification'));
  request.fields.addAll({
    'user_vendor_id': userid,
    'type': type
  });


  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {

    final str = await response.stream.bytesToString();
    print('directbooking========>>>  ${str}');
    return NotificationList.fromJson(jsonDecode(str));
  } else {
    return null;
  }
}