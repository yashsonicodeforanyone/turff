import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turfapp/MyConstants/ShPrefConstants.dart';
import 'package:turfapp/Screen/AddTurfScreen.dart';
import 'package:turfapp/Screen/HomeScreen.dart';

class WaitingApprovalScreen extends StatefulWidget {
  final String cutomerid;
  final String? usertype;
  final String? contactno;

  WaitingApprovalScreen({
    super.key,
    required this.cutomerid,
    this.usertype,
    this.contactno,
  });
  @override
  _WaitingApprovalScreenState createState() => _WaitingApprovalScreenState();
}

class _WaitingApprovalScreenState extends State<WaitingApprovalScreen> {
  bool isLoading = true;
  String user_type = "";
  String contactNo = "";
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initalize();
  }

  initalize() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      user_type = prefs.getString(sp_usertype).toString();
      contactNo = prefs.getString(sp_contact).toString();
      user_type = widget.usertype.toString();
    });

    _checkApprovalStatus();
  }

  Future<void> _checkApprovalStatus() async {
    var headers = {
      'Cookie': 'session=3nv27s7c9ba5umce6c1k076op5i1f7os'
    };
    var request = http.MultipartRequest('POST', Uri.parse('https://taruff.shortlinker.in/api/get_user_by_id'));
    request.fields.addAll({
      'user_id': widget.cutomerid
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseData = await response.stream.bytesToString();
      Map<String, dynamic> data = jsonDecode(responseData);

      print(data['data']['userstatus']);
      print("prachi==>");
      if (data['status'] == 1) {
        // Navigate to AddTurfScreen if userStatus is 0
        if (data['data']['userstatus'] == "0") {
          // User status is pending, stay on the same screen
          setState(() {
            isLoading = false;
          });
        } else if (data['data']['userstatus'] == "1") {
          // User status is approved, navigate to AddTurfScreen
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => AddTurfScreen(
                user_id: widget.cutomerid,
                usertype: user_type,
                contactno: widget.contactno,
              ),
            ),
                (route) => false,
          );
        } else if (data['data']['userstatus'] == "2") {
          // User status is rejected, show toast message
          Fluttertoast.showToast(
            msg: "You are rejected from admin side.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Navigator.pushReplacementNamed(context, '/login');
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  // Refresh screen every 1 minute
  void _refreshScreen() {
    Timer.periodic(Duration(seconds: 20), (timer) {
      _checkApprovalStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Call the function to refresh the screen
    _refreshScreen();

    return Scaffold(
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Text(
          "Please wait for admin approval.",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
