import 'package:http/http.dart' as http;
import 'package:turfapp/MyModel/cancellation_policy.dart';
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'https://taruff.shortlinker.in/api';
  static const String sessionCookie = 'session=6quoti94spsuo79hu07gfgh4lsepoomn';

  static Future<CancellationPolicyModel> getCancellationPolicyData() async {
    try {
      var headers = {'Cookie': sessionCookie};
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/get_pages'));
      request.fields.addAll({'name': 'cancellation_policy'});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseData = await response.stream.bytesToString();
        return CancellationPolicyModel.fromJson(jsonDecode(responseData));
      } else {
        throw Exception('Failed to load cancellation policy data');
      }
    } catch (e) {
      throw Exception('Failed to load cancellation policy data: $e');
    }
  }
}
