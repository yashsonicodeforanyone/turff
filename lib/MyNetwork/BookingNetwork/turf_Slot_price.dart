/*
import 'dart:convert';
import 'package:http/http.dart'as http;

class TurfPriceService {
  static Future<double> fetchTurfPrice(String turf_id,List<String> selectedSlots) async {
    print("turf id ===>> ${turf_id}");
    print("turf id ===>> ${selectedSlots}");

    try {
      var headers = {'Cookie': 'session=qkt80k4as6rkml8lh85s9g6m67afsrjm'};
      var body = {'turf_id': turf_id, 'slot': selectedSlots.join(',')};

      var response = await http.post(
        Uri.parse('https://taruff.shortlinker.in/api/turf_price_caclculation'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // Decode the response
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        print("json ==${jsonResponse}");

        // Extract the price as a double
        double price = double.parse(jsonResponse.toString());



        // Return the parsed price
        return price;
      } else {
        throw Exception('Failed to fetch turf price: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching turf price: $e');
    }
  }
}
*/




import 'dart:convert';
import 'package:http/http.dart'as http;

class TurfPriceService {
  static Future<Map<String, dynamic>> fetchTurfPrice(String turf_id, List<String> selectedSlots) async {
    try {
      var headers = {'Cookie': 'session=qkt80k4as6rkml8lh85s9g6m67afsrjm'};
      var body = {'turf_id': turf_id, 'slot': selectedSlots.join(',')};

      var response = await http.post(
        Uri.parse('https://taruff.shortlinker.in/api/turf_price_caclculation'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // Decode the response
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        print("json == $jsonResponse");

        // Return the parsed response
        return jsonResponse;
      } else {
        throw Exception('Failed to fetch turf price: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching turf price: $e');
    }
  }
}
