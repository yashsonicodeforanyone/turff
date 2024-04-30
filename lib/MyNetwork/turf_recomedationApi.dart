import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:turfapp/MyModel/turf_recomedation.dart';


Future<RecomedationTurfModel?> fetchTurfRecommendations(String current_latitude,String current_longitude,String turf_id , String date,  List<String> selectedSlots) async {
  print("Recommendations");
  print("slot${selectedSlots}");
  var headers = {
    'Cookie': 'ci_session=pu0uvb1odhbe3p0s058hjduj32fmfbbq'
  };
  var request = http.MultipartRequest('POST', Uri.parse('https://taruff.shortlinker.in/api/turf_recomedation'));
  request.fields.addAll({
    'latitude': current_latitude,
    'longitude': current_longitude,
    'turf_id': turf_id,
    'date': date,
    'slot': selectedSlots.join(','),

  });
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    final String responseBody = await response.stream.bytesToString();
    final parsed = json.decode(responseBody);
    return RecomedationTurfModel.fromJson(parsed);
  } else {
    return null;
  }
}













































