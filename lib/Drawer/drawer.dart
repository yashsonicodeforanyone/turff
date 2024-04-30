import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:get_storage/get_storage.dart';
import 'package:turfapp/Drawer/about_us.dart';
import 'package:turfapp/Drawer/privacy_policy.dart';
import 'package:turfapp/MyModel/Profile/cus_getProfile_model.dart';
import 'package:turfapp/MyNetwork/Profile/cus_profile.dart';
import 'package:turfapp/Screen/AddTurfScreen.dart';
import 'package:turfapp/Screen/Admin/user_list.dart';
import 'package:turfapp/Screen/Admin/turf_list.dart';
import 'package:turfapp/Screen/Admin/vendor_list.dart';
import 'package:turfapp/Screen/CustomerHistory/CustomerHistoryScreen.dart';
import 'package:turfapp/Screen/LoginScreen.dart';
import 'package:turfapp/Screen/VendorHistory/VendorHistoryScreen.dart';
import 'package:turfapp/Screen/VendorSide/HomePage.dart';
import 'package:turfapp/Screen/VendorSide/addturf_home.dart';
import 'package:turfapp/Screen/VendorSide/direct_booking.dart';
import 'package:turfapp/Screen/VendorSide/get_user_suport_form.dart';
import 'package:turfapp/Screen/VendorSide/setting.dart';
import 'package:turfapp/Screen/VendorSide/view_turf_detials.dart';
import 'package:turfapp/Screen/cus/get_suportdata.dart';
import 'package:turfapp/Screen/profile_screen.dart';
import 'package:turfapp/Screen/suport/suport_and_help.dart';
import 'package:turfapp/Screen/suport/suport_vendor.dart';

import "../MyConstants/custom_dialog.dart";
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:location/location.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MyConstants/ShPrefConstants.dart';
import '../MyModel/AllTurfModels.dart';

final box = GetStorage();

class DrawerComponent extends StatefulWidget {
  final String cstomer_id;
  final String? usertype;
  final String? contactno;
  final String turf_id;
  const DrawerComponent(
      {super.key,
      required this.cstomer_id,
      this.usertype,
      this.contactno,
      required this.turf_id});
  @override
  State<DrawerComponent> createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  final _boxHeight = 150.0;
  List<TurfModel> list_turf = [];
  late SharedPreferences prefs;
  String current_latitude = "";
  String current_longitude = "";
  String user_type = "";
  String contactNo = "";
  String turf_id = "";
  List<UserProfile> profile_date = [];

  showDialog(BuildContext context) {
    return showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
            insetPadding: EdgeInsets.symmetric(horizontal: 10),
            title: Text(
              "Are you sure",
              style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 18),
              textAlign: TextAlign.center,
            ),
            content: Text(
              "Do you want to Log-out?",
              style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 15),
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text(
                  "NO",
                  style: TextStyle(fontWeight: FontWeight.w500,color: Colors.green,fontSize: 15),
                ),
              ),
              TextButton(
                onPressed: (){
                  prefs.setBool(sp_login, false);
                  print("sp_login>>>>>>>>>>>>>>>>>>>>>>>> 1 " +
                      prefs.getBool(sp_login).toString());
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text(
                  "YES",
                  style: TextStyle(fontWeight: FontWeight.w500,color: Colors.green,fontSize: 15),
                ),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    initalize();
    _futureUserProfile =
        fetchUserProfile(widget.cstomer_id); // Pass the user ID here

    // getCurrentLocation();
  }

  late Future<UserProfile> _futureUserProfile;

  /* @override
  void initState() {
    super.initState();
    _futureUserProfile = fetchUserProfile('5700'); // Pass the user ID here
  }*/


  initalize() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      user_type = prefs.getString(sp_usertype).toString();
      contactNo = prefs.getString(sp_contact).toString();
      turf_id = prefs.getString(sp_turfId).toString();
      user_type = widget.usertype.toString();
      print("number history ===>>${contactNo}");
      print("##>>>>>>>" + user_type);
      //admin/vendor/user
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Drawer(
      width: width * 0.75,
      child: ListView(
        // Important: Remove any padding from the ListView.
        children: [
          SizedBox(
            height: height * 0.15,
            child: DrawerHeader(
              margin: const EdgeInsets.all(10),
                decoration:  BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.green,
                ),
                child: FutureBuilder<UserProfile>(
                  future: _futureUserProfile,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child:
                              CircularProgressIndicator()); // Show loading indicator while fetching data
                    } else if (snapshot.hasError) {
                      return Container();
                    } else {
                      return ListTile(
                        horizontalTitleGap: 10,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 0,),
                        leading: CachedNetworkImage(
                          imageUrl: snapshot.data!.image,
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                            backgroundImage: imageProvider,
                            radius: width * 0.07,
                          ),
                          placeholder: (context, url) => CircleAvatar(
                            radius: width * 0.07,
                            child: const CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => CircleAvatar(
                            backgroundImage:
                                const AssetImage("assets/profilegrey.jpg"),
                            radius: width * 0.08,
                          ),
                        ),
                        title: Text(
                          snapshot.data!.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          snapshot.data!.phone,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                          ),
                        ),
                      );
                    }
                  },
                )),
          ),

          //profile
          ListTile(
            visualDensity: VisualDensity.compact,
            title: const Text(
              'Profile ',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 17),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: 18,
            ),
            onTap: () {
              print("user ${user_type}");
              // ProfileForm
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileForm(
                      user_id: widget.cstomer_id,
                      usertype: user_type,
                      contactno: widget.contactno),
                ),
              );
            },
          ),

/*
          ListTile(
            visualDensity: VisualDensity.compact,
            title: const Text(
              'Add turf ',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 17),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: 18,
            ),
            onTap: () {
              print("user ${user_type}");
              // ProfileForm
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTurfScreen(
                      user_id: widget.cstomer_id,
                      usertype: user_type,
                      contactno: widget.contactno),
                ),
              );
            },
          ),*/

          if (widget.usertype == "vendor")
            ListTile(
              visualDensity: VisualDensity.compact,
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 18,
              ),
              title: const Text(
                'Direct Turf Booking',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 17),
              ),
              onTap: () {
                print("==========>usertype add turf ${user_type}");
                print("turf id ${turf_id}");
                print("turf id direct ${turf_id}");
                // print("turfList $turfList");
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingForm(
                      usertype: user_type,
                      cutomerid: widget.cstomer_id,
                      turf_id: turf_id,
                      // turfList: turfList,
                    ),
                  ),
                    (route) => route.isFirst
                );
              },
            ),

          //history
          // if (user_type == "user")
          ListTile(
            visualDensity: VisualDensity.compact,
            title: const Text(
              'My Booking',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 17),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: 18,
            ),
            onTap: () {
              print("User type history: $user_type");
              print("Customer ID: ${widget.cstomer_id}");
              print("contact ===> ${widget.contactno}");

              if (user_type == "user") {
                print("Navigating to CustomerHistoryScreen");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomerHistoryScreen(
                      cstomer_id: widget.cstomer_id,
                      contactno: widget.contactno.toString(),
                      usertype: user_type,
                    ),
                  ),
                );
              } else if (user_type == "vendor") {
                print("Navigating to VendorHistoryScreen");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VendorHistoryScreen(
                      turf_id: turf_id,
                      user_type: user_type
                    ),
                  ),
                );
              }
            },
          ),

          ListTile(
            visualDensity: VisualDensity.compact,
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: 18,
            ),
            title: const Text(
              'Support & Help',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 17),
            ),
            onTap: () {
              print("User type suport: $user_type");
              print("Customer ID: ${widget.cstomer_id}");

              if (user_type == "user") {
                print("Navigating to CustomerHistoryScreen");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SupportForm(
                        usertype: user_type, cutomerid: widget.cstomer_id),
                  ),
                );
              } else if (user_type == "vendor") {
                print("Navigating to VendorHistoryScreen");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VendoreSuportForm(
                        usertype: widget.usertype,
                        cutomerid: widget.cstomer_id),
                  ),
                );
              }
            },
          ),
          ListTile(
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: 18,
            ),
            visualDensity: VisualDensity.compact,
            title: const Text(
              'Support Message',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 17),
            ),
            onTap: () {
              print("User type suport: $user_type");
              print("Customer ID: ${widget.cstomer_id}");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GetSuportMsg(
                    cutomerid: widget.cstomer_id,
                    usertype: user_type,
                  ),
                ),
              );
            },
          ),

          // about us
          ListTile(
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: 18,
            ),
            visualDensity: VisualDensity.compact,
            title: const Text(
              'About Us',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 17),
            ),
            onTap: () {
              print("User type suport: $user_type");
              print("Customer ID: ${widget.cstomer_id}");
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutUsPage(
                    cutomerid: widget.cstomer_id,
                    usertype: user_type,
                  ),
                ),
                  (route) => route.isFirst
              );
            },
          ),
// privacy policy
          ListTile(
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: 18,
            ),
            visualDensity: VisualDensity.compact,
            title: const Text(
              'Privacy Policy',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 17),
            ),
            onTap: () {
              print("User type suport: $user_type");
              print("Customer ID: ${widget.cstomer_id}");
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrivacyPolicyPage(
                      cutomerid: widget.cstomer_id,
                      usertype: user_type,
                    ),
                  ),
                      (route) => route.isFirst
              );
            },
          ),

         /* if (user_type == "vendor")
            ListTile(
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 18,
              ),
              visualDensity: VisualDensity.compact,
              title: const Text(
                'Get User issue',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 17),
              ),
              onTap: () {
                print("User type suport: $user_type");
                print("Customer ID: ${widget.cstomer_id}");
                print(turf_id);
                if (user_type == "vendor") {
                  print("Navigating to VendorHistoryScreen");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserSuportFormData(
                          usertype: user_type,
                          cutomerid: widget.cstomer_id,
                          turf_id: turf_id),
                    ),
                  );
                }
              },
            ),*/
          //setting
          if (user_type == "vendor")
            ListTile(
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 18,
              ),
              visualDensity: VisualDensity.compact,
              title: const Text(
                'Setting',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 17),
              ),
              onTap: () {
                print("User type suport: $user_type");
                print("Customer ID: ${widget.cstomer_id}");
                print("turf id ${turf_id}");
                print("turf id setting ${turf_id}");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingScreen(
                      cutomerid: widget.cstomer_id,
                      usertype: user_type,
                      turfid :turf_id
                    ),
                  ),
                );
              },
            ),

          if (user_type == "admin")
            ListTile(
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 18,
              ),
              visualDensity: VisualDensity.compact,
              title: const Text(
                'vendor list',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 17),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VendorListScreen(
                      usertype: widget.usertype,
                      // cutomerid: widget.cstomer_id
                    ),
                  ),
                );

                /*showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialog(); // Use your custom dialog widget
                  },
                );*/
              },
            ),
          if (user_type == "admin")
            ListTile(
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 18,
              ),
              visualDensity: VisualDensity.compact,
              title: const Text(
                'Turf list',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 17),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TurfList(
                        // usertype: widget.usertype,
                        // cutomerid: widget.cstomer_id
                        ),
                  ),
                );
              },
            ),

          if (user_type == "admin")
            ListTile(
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 18,
              ),
              visualDensity: VisualDensity.compact,
              title: const Text(
                'Bloked ',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 17),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlockUserScreen(
                        // usertype: widget.usertype,
                        // cutomerid: widget.cstomer_id
                        ),
                  ),
                );
              },
            ),
          /*

      //create tournament
          ListTile(
            title: const Text(
              'Create Tournament',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialog(); // Use your custom dialog widget
                },
              );
            },
          ),
      //Request Challenge Mode
          ListTile(
            title: const Text(
              'Request Challenge Mode',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialog(); // Use your custom dialog widget
                },
              );
            },
          ),
          ListTile(
            title: const Text(
              'Change Password',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialog(); // Use your custom dialog widget
                },
              );
            },
          ),

          //create turf team
          ListTile(
            title: const Text(
              'Create Turf Team',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialog(); // Use your custom dialog widget
                },
              );
            },
          ),
          //reward points
          ListTile(
            title: const Text(
              'Reward Points',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialog(); // Use your custom dialog widget
                },
              );
            },
          ),
          //net monitoring
          ListTile(
            title: const Text(
              'Net Monitoring',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialog(); // Use your custom dialog widget
                },
              );
            },
          ),
          // Booking list
          ListTile(
            title: const Text(
              ' Booking List',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialog(); // Use your custom dialog widget
                },
              );
            },
          ),
      */

          SizedBox(
            height: height * 0.03,
          ),
          InkWell(
            onTap: () {
              showDialog(context);
            },
            child: Container(
              height: height * 0.050,
              width: width * 0.02,
              margin: EdgeInsets.only(left: width*0.040,right: width*0.07),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.green,width: 1),
                  borderRadius: BorderRadius.circular(05)),
              child: const Center(
                child: Text(
                  'Log-Out',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                      fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

