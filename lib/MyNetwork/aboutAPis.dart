import 'package:http/http.dart' as http;
import 'package:turfapp/MyModel/about_us.dart';
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'https://taruff.shortlinker.in/api';
  static const String sessionCookie = 'session=5m5ke32h3l6mojtjvh0oahiclbut3835';

  static Future<AboutUsModel> getAboutUsData() async {

    try {
      var headers = {'Cookie': sessionCookie};
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/get_pages'));
      request.fields.addAll({'name': 'about_us'});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseData = await response.stream.bytesToString();
        print("object${AboutUsModel.fromJson(jsonDecode(responseData))}");
        return AboutUsModel.fromJson(jsonDecode(responseData));
      } else {
        print("errorbgg h");
        throw Exception('Failed to load about us data');
      }
    } catch (e) {
      print("catch errror rjhujh");
      throw Exception('Failed to load about us data: $e');
    }
  }
}
