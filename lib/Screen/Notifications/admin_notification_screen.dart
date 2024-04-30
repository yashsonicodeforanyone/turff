import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turfapp/MyConstants/ShPrefConstants.dart';
import 'package:turfapp/MyModel/Notifications/notificatios.dart';
import 'package:turfapp/MyNetwork/notificationApi.dart';

class AdminNotificationsScreen extends StatefulWidget {
  final String usertype;

  final String userid;
  const AdminNotificationsScreen({super.key, required this.userid, required this.usertype });

  @override
  State<AdminNotificationsScreen> createState() => _AdminNotificationsScreenState();
}

class _AdminNotificationsScreenState extends State<AdminNotificationsScreen> {

  late SharedPreferences prefs;
  String user_type = "";
  String contactNo = "";

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
      print("number history ===>>${contactNo}");
      print("##>>>>>>>" + user_type);
      //admin/vendor/user
    });
  }

  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          Container(
            width: width,
            padding: EdgeInsets.only(top: 30, left: 10),
            height: 88,
            color: Colors.green,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_outlined, color: Colors.white, size: 30),
                ),
                Container(
                  margin: EdgeInsets.only(left: width * 0.2),
                  child: Text(
                    "Notifications",
                    style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<NotificationList?>(
              // future: fetchNotifications(widget.userid , ),
              future: fetchNotifications(widget.userid ,widget.usertype),

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.data.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Card(
                          color: Colors.white,
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                            child: Container(
                              child: Column(
                                children: [
                                  Text(snapshot.data!.data[index].message),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        snapshot.data!.data[index].createdDate.toString(),
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text('No notifications available'));
                }
              },
            ),
          ),
        ],
      ),

    );
  }
}
