import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:turfapp/MyConstants/ShConstants.dart';

class ApiService {
  final String vendorId;
  ApiService({required this.vendorId});

  Future<List<Map<String, dynamic>>> fetchMessages() async {
    var headers = {
      'Cookie': 'ci_session=8c8badik2p2qvvdf5kmc0d2cqssmdjd2'
    };

    var request = http.MultipartRequest('POST', Uri.parse(BASE_URL+'/api/support_list'));
    request.fields.addAll({
      'user_vendor_id': vendorId,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      print(responseBody);

      final Map<String, dynamic> parsedResponse = json.decode(responseBody);
      final List<dynamic> data = parsedResponse['data'];

      List<Map<String, dynamic>> fetchedMessages = data.map((message) {
        DateTime createDate = DateTime.parse(message['created_date'].toString()).toLocal();
        String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(createDate);
        return {
          'title': message['name'].toString(),
          'message': message['message'].toString(),
          'reply': message['reply'].toString(),
          'create_date': formattedDate,
        };
      }).toList();

      return fetchedMessages;
    } else {
      throw Exception('Failed to fetch messages');
    }
  }
}
