import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:turfapp/MyConstants/ShConstants.dart';
import 'package:turfapp/MyModel/Profile/cus_getProfile_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart'; // Import get_storage package
import 'package:turfapp/MyModel/Profile/cus_getProfile_model.dart';


Future<UserProfile> fetchUserProfile(String userId) async {
  // Uri.parse(BASE_URL+"/api/booking_list_by_customer_id"),



  var url = Uri.parse(BASE_URL+'/api/get_user_by_id');
  var headers = {
    'Cookie': 'ci_session=7s1q4ptfgl1ae6h3l0hrb3tla59kf309',
  };

  var body = {
    'user_id': userId,
  };

  try {
    var response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      // return UserProfile.fromJson(jsonResponse['data']);
      var userProfile = UserProfile.fromJson(jsonResponse['data']);
      var box = GetStorage();
      await box.write('userProfile', userProfile.toJson());
      print("usedata === >> ${userProfile.toJson()}");
      var storedUserProfile = box.read('userProfile');
      print("Stored User Profile Data:");
      print(storedUserProfile);


      return userProfile;

    } else {
      throw Exception('Failed to load user profile data');
    }
  } catch (error) {
    throw Exception('Error fetching user profile data: $error');
  }
}




