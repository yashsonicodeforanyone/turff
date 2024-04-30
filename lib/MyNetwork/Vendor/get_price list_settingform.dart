import 'dart:convert';
import'package:http/http.dart'as http;

Future<List<Map<String, dynamic>>> fetchPriceListwithSetting(String turfId) async {
  var headers = {
    'Cookie': 'session=oreda2l8n0enf89v0lmsgpe7qm7rr76u'
  };

  var body = {
    'turf_id': turfId,
  };

  var uri = Uri.parse('https://taruff.shortlinker.in/api/price_list_by_turf_id');
  var response = await http.post(
    uri,
    headers: headers,
    body: body,
  );

  if (response.statusCode == 200) {
    var jsonData = json.decode(response.body);
    List<Map<String, dynamic>> priceList = List<Map<String, dynamic>>.from(jsonData['data']);
    return priceList;
  } else {
    throw Exception('Failed to load price list');
  }
}
