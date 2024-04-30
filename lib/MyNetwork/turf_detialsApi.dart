// api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:turfapp/MyModel/Turf_detials/turf_detials.dart';

class ApiService {
  static const String _baseUrl =
      'https://taruff.shortlinker.in/api/get_taruff_list_by_id';

  Future<List<TurfDetials>> getTaruffList(String turfId) async {
    var headers = {
      'Cookie': 'ci_session=2j4d1vbv9lsmlthf65ksf3e3d5hh60c6'
    };
    var uri = Uri.parse(_baseUrl);
    var requestBody = {'id': turfId};

    var response = await http.post(uri, headers: headers, body: requestBody);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var taruffList = jsonResponse['data'] as List;
      return taruffList.map((json) => TurfDetials.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load taruff list');
    }
  }
}
