/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:turfapp/Screen/suport/suport_and_help.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turfapp/MyConstants/ShPrefConstants.dart';

class GetSuportMsg extends StatefulWidget {
  final String cutomerid;
  final String usertype;

  const GetSuportMsg({Key? key, required this.cutomerid, required this.usertype}) : super(key: key);

  @override
  State<GetSuportMsg> createState() => _GetSuportMsgState();
}

class _GetSuportMsgState extends State<GetSuportMsg> {
  late SharedPreferences prefs;
  String user_type = "";
  String contactNo = "";
  List<Map<String, String>> messages = [];

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      user_type = prefs.getString(sp_usertype).toString();
      contactNo = prefs.getString(sp_contact).toString();
    });

    // Fetch messages from API
    fetchMessagesFromAPI();
  }

  void fetchMessagesFromAPI() async {
    var headers = {
      'Cookie': 'ci_session=8c8badik2p2qvvdf5kmc0d2cqssmdjd2'
    };

    var request = http.MultipartRequest('POST', Uri.parse('https://taruff.shortlinker.in/api/support_list'));
    request.fields.addAll({
      'user_vendor_id': '5595'
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      print(responseBody);

      // Parse the response
      final Map<String, dynamic> parsedResponse = json.decode(responseBody);
      final List<dynamic> data = parsedResponse['data'];

      List<Map<String, String>> fetchedMessages = data.map((message) {
        return {
          'title': message['name'].toString(),
          'message': message['message'].toString(),
          'reply': message['reply'].toString(),
          'create_date' : messages[''].toString(),
        };
      }).toList();

      setState(() {
        messages = fetchedMessages;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          "Message List",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body: Container(
        height: height * 0.77,
        // color: Colors.grey,
        child: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: ListTile(
                    title: Row(
                      children: [
                        Text("Title :",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),

                        Text(
                          messages[index]['title']!,
                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("Message :",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
                              Text(
                                messages[index]['message']!,
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Vendor Reply: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  // color: Colors.green,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  messages[index]['reply']!,
                                  style: TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [

                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SupportForm(
                usertype: user_type,
                cutomerid: widget.cutomerid,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
*/



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:turfapp/MyNetwork/Suport/get_user_suportApi.dart';
import 'package:turfapp/Screen/suport/suport_and_help.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turfapp/MyConstants/ShPrefConstants.dart';
import 'package:turfapp/Screen/suport/suport_vendor.dart';

class GetSuportMsg extends StatefulWidget {
  final String cutomerid;
  final String usertype;

  const GetSuportMsg({Key? key, required this.cutomerid, required this.usertype}) : super(key: key);

  @override
  State<GetSuportMsg> createState() => _GetSuportMsgState();
}

class _GetSuportMsgState extends State<GetSuportMsg> {
  late SharedPreferences prefs;
  String user_type = "";
  String contactNo = "";
  // List<Map<String, String>> messages = [];
  List<Map<String, dynamic>> messages = [];
  // final ApiService apiService = ApiService(vendorId: widget.cutomerid);
  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(vendorId: widget.cutomerid);
    initialize();
  }

  initialize() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      user_type = prefs.getString(sp_usertype).toString();
      contactNo = prefs.getString(sp_contact).toString();
    });

    // Fetch messages from API
    fetchMessagesFromAPI();
  }


  void fetchMessagesFromAPI() async {
    try {
      List<Map<String, dynamic>> fetchedMessages = await apiService.fetchMessages();

      setState(() {
        messages = fetchedMessages;
      });
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  String _convertDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString).toLocal();
    dateTime = dateTime.add(Duration(hours: 5, minutes: 30)); // Adding IST offset
    String formattedDate = DateFormat('dd MMM, yyyy  hh:mm a').format(dateTime);
    // var formatter = DateFormat('MMM dd, yyyy - hh:mm a');

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Messages",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),

      body: Container(
        height: height * 0.8,
        // color: Colors.grey,
        child:ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: messages.length > 0 ? messages.length : 1,
          itemBuilder: (BuildContext context, int index) {
            if (messages.isEmpty) {
              return  Container(
                height: height ,
                  child: Center(child: Image.asset("assets/no_data.png",scale: 2,)));
            }

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,),
              child: Card(
                // elevation: 1,
                margin: const EdgeInsets.only(top: 10),
                elevation: 0,
                shape: const RoundedRectangleBorder(
                    // borderRadius: BorderRadius.only(topRight: Radius.circular(15,),bottomLeft: Radius.circular(15,))
            borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(40),
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(0),)
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: ListTile(
                    title: Row(
                      children: [
                        Text(
                          "Title :",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,color: Colors.black),
                        ),
                        Text(
                          messages[index]['title']!,
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13,color: Colors.black),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                "Message : ",
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,color: Colors.black),
                              ),
                              Container(
                                width: width * 0.6,
                                child: Text(
                                  messages[index]['message']!,
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13,color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Reply: ',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,color: Colors.black),
                              ),
                              Expanded(
                                child: Text(
                                  messages[index]['reply']!,
                                  style: TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                // messages[index]['create_date']!,
                                _convertDate(messages[index]['create_date']!),

                                style: TextStyle(fontSize: 13, color: Colors.green,fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        )

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(user_type == "user"){
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => SupportForm(
                    usertype: user_type,
                    cutomerid: widget.cutomerid,
                  ),
                ),
                    (route)=> route.isFirst
            );

          }
          if (user_type == "vendor")
{
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => VendoreSuportForm(
          usertype: user_type,
          cutomerid: widget.cutomerid,
        ),
      ),
          (route)=> route.isFirst
  );

}
        },
        child:  Icon(Icons.add,color: Colors.white,),
        backgroundColor: Colors.green,
      ),
    );
  }
}
