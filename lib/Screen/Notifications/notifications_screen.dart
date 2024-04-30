import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turfapp/MyConstants/ShPrefConstants.dart';
import 'package:turfapp/MyModel/Notifications/notificatios.dart';
import 'package:turfapp/MyNetwork/notificationApi.dart';

class CustomerNotificationsScreen extends StatefulWidget {
  final String cstomer_id;

  final String usertype;
  const CustomerNotificationsScreen(
      {super.key, required this.cstomer_id, required this.usertype});

  @override
  State<CustomerNotificationsScreen> createState() =>
      _CustomerNotificationsScreenState();
}

class _CustomerNotificationsScreenState
    extends State<CustomerNotificationsScreen> {
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
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Notification",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<NotificationList?>(
              future: fetchNotifications(widget.cstomer_id, widget.usertype),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.data.isNotEmpty) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.data.length,
                    itemBuilder: (context, index) {

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Card(
                          margin: const EdgeInsets.only(top: 10),
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(15,),bottomLeft: Radius.circular(15,))
                          ),
                          child: Padding(
                            padding:  EdgeInsets.symmetric(
                                horizontal: width*0.030, vertical: height*0.020),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(snapshot.data!.data[index].message,  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    fontSize: 14),),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      DateFormat('dd-MM-yyyy hh:mma').format(
                                        DateTime.parse("${snapshot.data!.data[index].createdDate}"),
                                ),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green,
                                          fontSize: 12),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return  Center(child: Image.asset("assets/no_data.png",scale: 3,));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
