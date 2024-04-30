import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turfapp/MyConstants/ShImageConstants.dart';
import 'package:turfapp/MyConstants/ShWidgetConsts.dart';
import 'package:turfapp/MyNetwork/loginapi.dart';
import 'package:turfapp/Screen/OtpVerifyScreen.dart';

import '../MyConstants/AppCustomDialog.dart';
import '../MyConstants/ShPrefConstants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();

  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();

    /*  setState(() {
      // phoneController=widget.;
    });*/

    initalize();
  }

  initalize() async {
    prefs = await SharedPreferences.getInstance();
  }

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Define GlobalKey

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
              Form(
                key: _formKey, // Assign GlobalKey to the Form
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      SizedBox(height: 20),
                      SizedBox(height: 20),
                      Image.asset(ic_players),
                      SizedBox(height: 20),
                      Text(
                        "Enter Mobile Number",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: phoneController,
                        style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: InputDecoration(
                          hintText: 'Enter Mobile Number',
                          prefixIcon: const Icon(Icons.phone,color: Colors.grey,size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.green),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10)
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a mobile number';
                          }
                          if (value.length != 10) {
                            return 'Mobile number must be 10 digits';
                          }
                          return null; // Return null if the validation is successful
                        },
                      ),
                      SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        child: InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              loginapi(context, phoneController.text)
                                  .then((value) {
                                final responseData = jsonDecode(value);
                                final message = responseData['message'];
                                final status = responseData['status'];
                                print("GGLogin Response >>>>> " +
                                    status.toString());
                                if (status == 1) {
                                  prefs.setBool(sp_login, true);
                                  final otp = responseData['otp'];
                                  final contactno = responseData["contact_no"];
                                  print(
                                      "mobile numbr =====>> #${phoneController.text}");

                                  prefs.setString(
                                      sp_contact, phoneController.text);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OtpVerifyScreen(
                                                otp: otp.toString(),
                                                contactno: phoneController.text,
                                              )));
                                } else {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) =>
                                        CustomDialog(
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
                            }
                          },
                          child: Container(
                            width: width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 10),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Center(
                              child: Text(
                                "Send OTP",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              /* Container(
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
                      child: Text("Enter Mobile Number",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)   ,

                    ),
                    verticalmargin20,
                    verticalmargin20,
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      decoration: InputDecoration(
                        hintText: 'Enter Mobile Number',
                        suffixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.green), // Set the border color here
                        ),
                      ),
                    ),

                    verticalmargin20,
                    InkWell(
                      onTap: (){


                        loginapi(
                            context, phoneController.text
                        )
                            .then((value)
                        {


                          final responseData = jsonDecode(value);
                          final message = responseData['message'];
                          final status = responseData['status'];



                          print("GGLogin Response >>>>> "+status.toString());
                          if(status == 1)
                          {

                            prefs.setBool(sp_login, true);

                            final otp = responseData['otp'];
                            final contactno = responseData["contact_no"];
                            print("mobile numbr =====>> #${phoneController.text}");

                            prefs.setString(sp_contact, phoneController.text);


                            Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpVerifyScreen(otp: otp.toString(), contactno: phoneController.text,)));

                          }
                          else
                          {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) =>
                                  CustomDialog(

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

                        padding: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.green,

                            borderRadius: BorderRadius.all(Radius.circular(10))),

                        child: Center(
                          child: Text("Send Otp", style: TextStyle(

                              fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ),

                  ],
                ),
              ),*/

              Image.asset(
                ic_grass,
                fit: BoxFit.fill,
                height: 180,
                width: width,
              ),

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
      ),
    );
  }
}
