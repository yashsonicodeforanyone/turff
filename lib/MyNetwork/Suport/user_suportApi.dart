import 'dart:convert';
import 'package:http/http.dart' as http;

class APIService {
  static Future<Map<String, dynamic>> createSupportRequest({
    required String userVendorId,
    required String name,
    required String number,
    required String email,
    required String type,
    required String turfId,
    required String message,
  }) async {
    var headers = {
      'Cookie': 'ci_session=72pm8201jl1npe841iksgoo3jlphce4m'
    };
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://taruff.shortlinker.in/api/create_support'),
    );
    request.fields.addAll({
      'user_vendor_id': userVendorId,
      'name': name,
      'number': number,
      'email': email,
      'type': type,
      'turf_id': turfId,
      'message': message,
    });
    request.headers.addAll(headers);
    var response = await http.Response.fromStream(await request.send());
   print("dataaaa"+response.body);
    return json.decode(response.body);
  }

}
