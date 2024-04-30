import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turfapp/MyConstants/ShImageConstants.dart';
import 'package:turfapp/MyConstants/ShPrefConstants.dart';
import 'package:turfapp/MyConstants/ShWidgetConsts.dart';
import 'package:turfapp/Screen/HomeScreen.dart';
import 'package:turfapp/Screen/VendorSide/vendor_wait.dart';

import '../MyNetwork/updateusertype.dart';
import 'AddTurfScreen.dart';

class SelectUserTypeScreen extends StatefulWidget {

  String user_id;
  String contactno;
   SelectUserTypeScreen({super.key,required this.user_id, required this.contactno});

  @override
  State<SelectUserTypeScreen> createState() => _SelectUserTypeScreenState();
}

class _SelectUserTypeScreenState extends State<SelectUserTypeScreen> {

  TextEditingController phoneController=TextEditingController();
  int selectedIndex=0;
  bool isApproved = false;

  Future<void> saveUserTypeToPrefs(String userType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(sp_usertype, userType);
  }


  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
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
                  Image.asset(ic_players,),
                  verticalmargin20,
                  Container(
                    child: Text("Select User Type",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)   ,
        
                  ),
                  verticalmargin20,
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
        
                     InkWell(
                       onTap:(){
                         setState(() {
                           selectedIndex=1;
                         });
                       },
                       child: Container(width: width*0.4,
                       height: width*0.4,
                         padding: EdgeInsets.all(10.0),
        
                         child:Column(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                               Container(),
                               Icon(selectedIndex==1?Icons.check_circle:Icons.circle_outlined,color:selectedIndex==1?Colors.green: Colors.black12,)
                             ],),
        
                             Icon(Icons.person,size: 50,color:selectedIndex==1?Colors.green: Colors.black12),
        
        
                             Text("Vendor",style: TextStyle(fontSize: 20,color:selectedIndex==1?Colors.green: Colors.black12),)
        
                           ],
                         ),
        
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.black12,width: 1)
                         ),
                       ),
                     ),
                     InkWell(
                       onTap:(){
                         setState(() {
                           selectedIndex=2;
                         });
                       },
        
                       child: Container(width: width*0.4,
                         height: width*0.4,
                         padding: EdgeInsets.all(10.0),
        
                         child:Column(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Container(),
                                 Icon(selectedIndex==2?Icons.check_circle:Icons.circle_outlined,color:selectedIndex==2?Colors.green: Colors.black12,)
                               ],),
                             Icon(Icons.people,size: 50,color:selectedIndex==2?Colors.green: Colors.black12),
                             Text("User",style: TextStyle(fontSize: 20,color:selectedIndex==2?Colors.green: Colors.black12),)
                           ],
                         ),
        
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(10.0),
                             border: Border.all(color: Colors.black12,width: 1)
                         ),
                       ),
                     ),
        
                   ],
                 ),
        
                  verticalmargin20,




                /*  InkWell(
                    onTap: () async {
        
                      String usertype="";
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setString(sp_usertype, usertype);
        
                      if(selectedIndex==1)
                        {
                          usertype="vendor";

                        }
                      else
                        {
                          usertype="user";
                        }
                      updateuserTypeScreen(context, widget.user_id, usertype).then((value) {
                        final responseData = jsonDecode(value);
                        final message = responseData['message'];
                        final status = responseData['status'];
                        print("updateuserTypeScreen Response >>>>> " + status.toString());
        
                        // Save usertype to SharedPreferences
                        saveUserTypeToPrefs(usertype);
                      print("updateuserTypeScreen Response >>>>> "+status.toString());
                          if (selectedIndex == 1 *//*&& isApproved*//*) {
                            print("user type vendore home======>> ${usertype}");
        
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddTurfScreen(user_id: widget.user_id, usertype: usertype),
                              ),
                                (route) => false,
                            );
                          }
                          else {
                            print("user type h======>> ${usertype}");
                            print("user number======>> ${widget.contactno}");
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                  cutomerid: widget.user_id,
                                  usertype: usertype,
                                  contactno: widget.contactno,
                                ),
                              ),
                                  (route) => false, // Add the third argument, a condition to remove all routes until
                            );                            }
                          });
                    },
                    child: Container(
                      width: width,
                      padding: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: Text("Continue", style: TextStyle(
        
                            fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ),*/



               /*   InkWell(
                    onTap: () async {
                      String usertype = selectedIndex == 1 ? "vendor" : "user";

                      updateuserTypeScreen(context, widget.user_id, usertype).then((value) {
                        final responseData = jsonDecode(value);
                        final message = responseData['message'];
                        final status = responseData['status'];
                        final userData = responseData['data']; // Access the "data" object
                        final userStatus = userData['userstatus']; // Get the "userstatus" value
                        // final userStatus_value = userData['']

                        print("updateuserTypeScreen Response >>>>> " + status.toString());

                        if (userStatus == "0") {
                          // User status is pending, navigate to waiting screen
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WaitingApprovalScreen(
                                cutomerid: widget.user_id,
                                usertype: usertype,
                                contactno: widget.contactno,
                              ),
                            ),
                                (route) => false,
                          );
                        } else if (userStatus == "1") {
                          // User status is approved, navigate to HomeScreen
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                cutomerid: widget.user_id,
                                usertype: usertype,
                                contactno: widget.contactno,
                              ),
                            ),
                                (route) => false,
                          );
                        } else if (userStatus == "2") {
                          // User status is rejected, show toast message and stay on the same screen
                          Fluttertoast.showToast(
                            msg: "You are rejected.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }

                        // Save usertype to SharedPreferences
                        saveUserTypeToPrefs(usertype);
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
                          "Continue",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),*/


                  InkWell(
                    onTap: () async {

                      String usertype="";
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setString(sp_usertype, usertype);

                      if(selectedIndex==1)
                      {
                        usertype="vendor";
                        /*   showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Vendor Approval"),
                                  content: Text("Please wait for admin approval."),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );*/

                        // Set up a timer to simulate a 5-minute waiting period
/*
                            Timer(Duration(minutes: 5), () {
                              // After 5 minutes, close the dialog and proceed to AddTurfScreen

                              setState(() {
                                isApproved = true; // Mark vendor as approved
                              });
                            });
*/
                      }
                      else
                      {
                        usertype="user";
                      }
                      updateuserTypeScreen(context, widget.user_id, usertype).then((value) {
                        final responseData = jsonDecode(value);
                        final message = responseData['message'];
                        final status = responseData['status'];
                        print("updateuserTypeScreen Response >>>>> " + status.toString());

                        // Save usertype to SharedPreferences
                        saveUserTypeToPrefs(usertype);
                        print("updateuserTypeScreen Response >>>>> "+status.toString());
                        if (selectedIndex == 1 /*&& isApproved*/) {
                          print("user type vendore home======>> ${usertype}");

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WaitingApprovalScreen(
                                cutomerid: widget.user_id,
                                usertype: usertype,
                                contactno: widget.contactno,
                              ),
                            ),
                                (route) => false,
                          );
                        }
                        else {
                          print("user type h======>> ${usertype}");
                          print("user number======>> ${widget.contactno}");
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                cutomerid: widget.user_id,
                                usertype: usertype,
                                contactno: widget.contactno,
                              ),
                            ),
                                (route) => false, // Add the third argument, a condition to remove all routes until
                          );                            }
                      });
                    },
                    child: Container(
                      width: width,
                      padding: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: Text("Continue", style: TextStyle(

                            fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ),


                ],
              ),
            ),
        
            Image.asset(ic_grass,fit: BoxFit.fill,height: 100,width: width,),
        
        
            // Container(
            //   height: 75,
            //   padding: const EdgeInsets.only(top: 30),
            //   child: OtpTextField(
            //     margin: const EdgeInsets.only(right: 10),
            //     fieldWidth: 50,
            //     filled: true,
            //     obscureText: true,
            //     textStyle: const TextStyle(
            //         height: 0.8,
            //         fontSize: 30,
            //         color: Color.fromARGB(255, 180, 178, 178)),
            //     fillColor: const Color.fromARGB(255, 244, 246, 247),
            //     numberOfFields: 4,
            //     borderColor: const Color.fromARGB(255, 196, 194, 194),
            //     borderWidth: 1,
            //     focusedBorderColor:
            //     const Color.fromARGB(255, 196, 194, 194),
            //     showFieldAsBox: true,
            //     borderRadius:
            //     const BorderRadius.all(Radius.circular(10.0)),
            //     onCodeChanged: (String code) {
            //       setState(() {
            //         isOtpFilled = false;
            //       });
            //     },
            //     onSubmit: (String verificationCode) {
            //       setState(() {
            //         isOtpFilled = true;
            //         enteredOtp = verificationCode;
            //       });
            //     },
            //   ),
            // ),
        
          ],
        ),
      ),

    );
  }
}
