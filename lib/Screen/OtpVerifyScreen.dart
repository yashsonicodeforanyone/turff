import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turfapp/MyNetwork/otpverify.dart';
import 'package:turfapp/Screen/HomeScreen.dart';
import 'package:turfapp/Screen/SelectUserTypeScreen.dart';
import 'package:turfapp/Screen/VendorSide/HomePage.dart';

import '../MyConstants/AppCustomDialog.dart';
import '../MyConstants/ShImageConstants.dart';
import '../MyConstants/ShPrefConstants.dart';
import '../MyConstants/ShWidgetConsts.dart';
import 'AddTurfScreen.dart';

class OtpVerifyScreen extends StatefulWidget {
  String otp;
  String contactno;
  OtpVerifyScreen({super.key, required this.otp, required this.contactno});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  TextEditingController phoneController = TextEditingController();

  String otp_show = "";
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();

    setState(() {
      otp_show = widget.otp;
    });

    initalize();
  }

  initalize() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          // height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalmargin20,
                    verticalmargin20,
                    verticalmargin20,
                    Image.asset(
                      ic_players,
                    ),
                    verticalmargin20,
                    // Container(
                    //   child: Text("Enter Mobile Number",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)   ,
                    //
                    // ),
                    verticalmargin20,

                    Center(
                        child: Text(
                      otp_show,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.black),
                    )),
                    const SizedBox(height: 10,),
                    Container(
                      height: height * 0.080,
                      padding: const EdgeInsets.only(top: 10),
                      child: OtpTextField(
                        //  margin: const EdgeInsets.only(right: 10),
                        fieldWidth: width*0.15,
                        filled: true,
                        obscureText: true,
                        textStyle: const TextStyle(
                            height: 0.8,
                            fontSize: 30,
                            color: Color.fromARGB(255, 180, 178, 178)),
                        fillColor: const Color.fromARGB(255, 244, 246, 247),
                        numberOfFields: 4,
                        borderColor: const Color.fromARGB(255, 196, 194, 194),
                        borderWidth: 1,
                        focusedBorderColor:
                            const Color.fromARGB(255, 196, 194, 194),
                        showFieldAsBox: true,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                        onCodeChanged: (String code) {
                          setState(() {
                            //isOtpFilled = false;
                            widget.otp = code;
                          });
                        },
                        onSubmit: (String verificationCode) {
                          setState(() {
                            //  isOtpFilled = true;
                            //enteredOtp = verificationCode;
                            widget.otp = verificationCode;
                          });
                        },
                      ),
                    ),

                    verticalmargin20,
                    SizedBox(
                      height: 10,
                    ),

                    InkWell(
                      onTap: () {
                        otpverifyapi(context, widget.contactno, widget.otp).then((value) {
                          final responseData = jsonDecode(value);
                          final message = responseData['message'];
                          final status = responseData['status'];

                          print("GGLogin Response >>>>> " + status.toString());
                          if (status == 1) {
                            prefs.setBool(sp_login, true);

                            final userid = responseData['userid'];
                            final user_type = responseData['UserTye'];

                            print("user_type>>>>>>>" + user_type);

                            prefs.setString(sp_userId, userid);
                            prefs.setString(sp_usertype, user_type);

                            print("user_type>hh>>>>>>" +
                                prefs.getString(sp_usertype).toString());

                            if (user_type == "null") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SelectUserTypeScreen(
                                    user_id: userid,
                                    contactno: widget.contactno,
                                  ),
                                ),
                              );
                            } else {
                              if (user_type == "vendor") {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeforAdmin(
                                      cutomerid: userid,
                                      usertype: user_type,
                                      contactno: widget.contactno,
                                    ),
                                  ),
                                      (route) => false,
                                );
                              } else if (user_type == "user") {
                                print("user type user ===>>${user_type}");
                                print("contactno ====>>${widget.contactno}");

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(
                                      cutomerid: userid,
                                      usertype: user_type,
                                      contactno: widget.contactno,
                                    ),
                                  ),
                                      (route) => false,
                                );
                              }
                            }
                          } else {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) => CustomDialog(
                                title: "Alert",
                                description: message,
                                buttonText: "Okay",
                                image: ic_alert,
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                colors: Colors.red,
                              ),
                            );
                          }
                        });
                      },
                      child: Container(
                        width: width,
                        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Center(
                          child: Text(
                            "Verify OTP",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),

                    /*    InkWell(
                      onTap: () {
                        otpverifyapi(context, widget.contactno, widget.otp)
                            .then((value) {
                          final responseData = jsonDecode(value);
                          final message = responseData['message'];
                          final status = responseData['status'];

                          print("GGLogin Response >>>>> " + status.toString());
                          if (status == 1) {
                            prefs.setBool(sp_login, true);

                            final userid = responseData['userid'];
                            final user_type = responseData['UserTye'];
                            // final contactno = responseData["contact_no"];

                            print("user_type>>>>>>>" + user_type);

                            prefs.setString(sp_userId, userid);
                            prefs.setString(sp_usertype, user_type);
                            // prefs.setString(sp_contact, contactno);

                            print("user_type>hh>>>>>>" +
                                prefs.getString(sp_usertype).toString());

                            if (user_type == "null") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SelectUserTypeScreen(
                                              user_id: userid,
                                              contactno: widget.contactno)));
                            } else {
                              if (user_type == "vendor") {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(
                                        cutomerid: userid,
                                        usertype: user_type,
                                        contactno: widget.contactno),
                                  ),
                                  (route) =>
                                      false, // Add the third argument, a condition to remove all routes until
                                );
                                // Navigator.push(context, MaterialPageRoute(
                                //     builder: (context) => AddTurfScreen(user_id: userid,usertype: user_type, contactno:widget.contactno)));
                              } //7444225555
                              else {
                                if (user_type == "user")
                                  print("user type user ===>>${user_type}");
                                print("contactno ====>>${widget.contactno}");
                                *//*Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => HomeScreen(cutomerid: userid,usertype: user_type,contactno : widget.contactno)));*//*

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(
                                        cutomerid: userid,
                                        usertype: user_type,
                                        contactno: widget.contactno),
                                  ),
                                  (route) =>
                                      false, // Add the third argument, a condition to remove all routes until
                                );
                              }
                            }
                            // final otp = responseData['otp'];

                            // Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectUserTypeScreen(user_id: userid,)));
                          } else {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) => CustomDialog(
                                title: "Alert",
                                description: message,
                                buttonText: "Okay",
                                image: ic_alert,
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                colors: Colors.red,
                              ),
                            );
                          }
                        });
                      },
                      child: Container(
                        width: width,
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Center(
                          child: Text(
                            "Verify OTP",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),*/
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(""),
                        Text(
                          "Resend OTP",
                          style: TextStyle(color: Colors.green),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Image.asset(
                ic_grass,
                fit: BoxFit.fill,
                height: 170,
                width: width,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
