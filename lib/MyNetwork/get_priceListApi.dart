/*import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Map<String, String>>> fetchPriceList(String id) async {
  var headers = {
    'Cookie': 'session=s0ntuci4jslkmdm4kt7ogrn5sbnjtbq6'
  };
  var request = http.MultipartRequest('POST', Uri.parse('https://taruff.shortlinker.in/api/price_list_by_turf_id'));
  request.fields.addAll({
    'turf_id': id
  });

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    String responseBody = await response.stream.bytesToString();
    final List<dynamic> data = jsonDecode(responseBody)['data'];

    List<Map<String, String>> priceList = data.map((item) {
      return {
        'hourly_number': item['hourly_number'].toString(),
        'hourly_price': item['hourly_price'].toString(),
      };
    }).toList();

    return priceList;
  } else {
    throw Exception('Failed to load price list');
  }
}*/



import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchPriceList(String id) async {
  var headers = {
    'Cookie': 'session=s0ntuci4jslkmdm4kt7ogrn5sbnjtbq6'
  };
  var request = http.MultipartRequest('POST', Uri.parse('https://taruff.shortlinker.in/api/price_list_by_turf_id'));
  request.fields.addAll({
    'turf_id': id
  });

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    String responseBody = await response.stream.bytesToString();
    final List<dynamic> data = jsonDecode(responseBody)['data'];

    List<Map<String, dynamic>> priceList = data.map((item) {
      return {
        'hourly_number': item['hourly_number'].toString(),
        'hourly_price': item['hourly_price'].toString(),
        'type': item['type'],
      };
    }).toList();

    return priceList;
  } else {
    throw Exception('Failed to load price list');
  }
}

