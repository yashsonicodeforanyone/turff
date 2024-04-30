/*
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:turfapp/Screen/HomeScreen.dart';
import 'package:turfapp/Screen/VendorSide/HomePage.dart';

import '../MyConstants/ShImageConstants.dart';
import '../MyConstants/ShPrefConstants.dart';
import 'LoginScreen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late SharedPreferences prefs;

  bool isLogin=false;
  String name="";
  String profile_image="";
  @override
  void initState() {


    load();
    super.initState();
  }

  load()async{
    Timer(Duration(seconds: 5), () {
      initalize();
    });
  }



  initalize() async
  {
    prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey(sp_login)) {
      setState(() {
        isLogin = prefs.getBool(sp_login)!;
        String userId=prefs.getString(sp_userId).toString();
        String usertype = prefs.getString(sp_usertype).toString();
        String contactno = prefs.getString(sp_contact).toString();
       // name = prefs.getString(sp_name)!;
     //   profile_image = prefs.getString(sp_profile_image)!;
        print("isLogin>>>>>>>>>>>>>>>>>>>" + isLogin.toString());
    //    print("name>>>>>>>>>>>>>>>>>>>" + name.toString());
       print("contact>>>>>>>>>>>>>>>>>>>" + contactno.toString());
        if (isLogin) {
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => HomeforAdmin(cutomerid: userId,usertype: usertype,contactno: contactno,)));

        }
        else {
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) =>
                  LoginScreen(

                  )));
        }
      });
    }
    else
    {
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) =>
              LoginScreen(
              )));
    }
  }

  @override
  Widget build(BuildContext context) {

   */
/* var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Image.asset("assets/Gif/ezgif-2-b9747f946d.gif",
        height: height,
      ),
    );*//*



    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: height,
        width: width,// Set height to screen height
        child: Image.asset(
          "assets/Gif/ezgif-2-b9747f946d.gif",
          fit: BoxFit.cover, // Ensure image covers the entire area
        ),
      ),
    );

  }
}


*/




import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:turfapp/Screen/HomeScreen.dart';
import 'package:turfapp/Screen/VendorSide/HomePage.dart';

import '../MyConstants/ShImageConstants.dart';
import '../MyConstants/ShPrefConstants.dart';
import 'LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SharedPreferences prefs;

  bool isLogin = false;
  String name = "";
  String profile_image = "";

  @override
  void initState() {
    load();
    super.initState();
  }

  load() async {
    Timer(Duration(seconds: 5), () {
      initalize();
    });
  }

  initalize() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(sp_login)) {
      setState(() {
        isLogin = prefs.getBool(sp_login)!;
        String userId = prefs.getString(sp_userId).toString();
        String usertype = prefs.getString(sp_usertype).toString();
        String contactno = prefs.getString(sp_contact).toString();

        print("isLogin>>>>>>>>>>>>>>>>>>>" + isLogin.toString());
        print("contact>>>>>>>>>>>>>>>>>>>" + contactno.toString());

        if (isLogin) {
          if (usertype == "vendor") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeforAdmin(
                  cutomerid: userId,
                  usertype: usertype,
                  contactno: contactno,
                ),
              ),
            );
          } else if (usertype == "user") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  cutomerid: userId,
                  usertype: usertype,
                  contactno: contactno,
                ),
              ),
            );
          }
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        }
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: height,
        width: width, // Set height to screen height
        child: Image.asset(
          "assets/Gif/ezgif-2-b9747f946d.gif",
          fit: BoxFit.cover, // Ensure image covers the entire area
        ),
      ),
    );
  }
}
