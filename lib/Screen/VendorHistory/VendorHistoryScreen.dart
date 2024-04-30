import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turfapp/MyConstants/ShPrefConstants.dart';
import 'package:turfapp/MyNetwork/BookingHistoryApi/customerBooking.dart';
import 'package:turfapp/MyNetwork/BookingHistoryApi/vendorBooking.dart';
import 'package:turfapp/MyNetwork/BookingNetwork/reject_boking.dart';
import 'package:turfapp/MyNetwork/BookingNetwork/statusChangesdApi.dart';

import '../../MyConstants/AppCustomDialog.dart';
import '../../MyConstants/ShImageConstants.dart';
import '../../MyConstants/ShWidgetConsts.dart';
import '../../MyModel/BookingModel.dart';
import '../../MyNetwork/BookingNetwork/deleteBookingId.dart';
class VendorHistoryScreen extends StatefulWidget {

  String turf_id;
  String user_type;
  VendorHistoryScreen({required this.turf_id,required this.user_type});

  @override
  State<VendorHistoryScreen> createState() => _VendorHistoryScreenState();
}

class _VendorHistoryScreenState extends State<VendorHistoryScreen> {

  List<Booking> listBooking=[];

  String _capitalizeFirstLetter(String status) {
    if (status == null || status.isEmpty) {
      return "";
    }

    List<String> words = status.split(" ");

    if (words.isEmpty) {
      return "";
    }

    String capitalizedFirstWord = words[0].substring(0, 1).toUpperCase() +
        words[0].substring(1).toLowerCase();

    for (int i = 1; i < words.length; i++) {
      capitalizedFirstWord += " " + words[i];
    }

    return capitalizedFirstWord;
  }


  late SharedPreferences prefs;
  String user_type = "";
  String contactNo = "";
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'cancel':
        return Colors.red;
      case 'approved':
        return Colors.green;
      default:
        return Colors.red;
    }
  }
  @override
  void initState() {
    super.initState();
    initalize();
    loaddata();

  }

  initalize() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      user_type = prefs.getString(sp_usertype).toString();
      contactNo = prefs.getString(sp_contact).toString();

      // user_type = widget.usertype.toString();
      print("number history ===>>${contactNo}");
      print("##>>>>>>>" + user_type);
      //admin/vendor/user
    });
  }


  showAlertDeleteDialog(BuildContext context, String id) {
    // set up the buttons
    Widget cancelButton = Container(

      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        child: Text("Cancel"),
        onTap:  () {
          Navigator.pop(context);
        },
      ),
    );
    Widget continueButton = Container(
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        child: Text("ok"),
        onTap:  () {

          deleteBookingID(context,id).then((value)  {

            final responseData = jsonDecode(value);
            final message = responseData['message'];
            final status = responseData['status'];

            if(status==1)
            {

              showAlertSuccess(message, context, widget.turf_id,user_type,contactNo);
              //loaddata();
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

          // Navigator.pop(context);
        },
      ),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete"),
      content: Text("Are you sure you want to delete?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((value) => {

      loaddata(),
    });
  }


  String? validateReason(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter reasons';
    }
    return null; // Return null if the input is valid
  }


  showAlertStatusChangedDialog(BuildContext context, String id, String status) {
    TextEditingController reasonController = TextEditingController();
    GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Key for the form

    // Function to validate the reason input field
    String? validateReason(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please provide a reason';
      }
      return null;
    }

    Widget cancelButton = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          child: Text("Cancel",style: TextStyle(color: Colors.white),),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );

    Widget continueButton = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          child: Text("OK",style: TextStyle(color: Colors.white),),
          onTap: () {
            if (status == "reject") {
              // Validate the form fields
              if (_formKey.currentState!.validate()) {
                // If validation passes, handle the reason
                String reason = reasonController.text;
                print("Reason vendor before api call: $reason");

                // Call cancelBookingApi with reason
                rejectBookingApi(context, id, reason).then((value) {
                  print("Reason vendor after api call: $reason");

                  final responseData = jsonDecode(value);
                  final message = responseData['message'];
                  final status = responseData['status'];

                  if (status == 1) {
                    print("reject Reason vendor: $reason");
                    Fluttertoast.showToast(
                      msg: message,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    Navigator.pop(context);
                  } else {
                    print("Reason vendor after api call: $reason");
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
              } else {
                // If validation fails, return
                return;
              }
            }
            if(status == "approved"){
              statusChangedApi(context, id, status).then((value) {
                final responseData = jsonDecode(value);
                final message = responseData['message'];
                final status = responseData['status'];

                if (status == 1) {
                  showAlertSuccess(message, context, widget.turf_id,contactNo,user_type);
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

            }
            },
        ),
      ),
    );

    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: status == "reject"
          ? Form(
        key: _formKey, // Assign the form key
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Are you sure you want to $status?", style: TextStyle(fontWeight: FontWeight.w500),),
            TextFormField(
              controller: reasonController,
              validator: validateReason,
              decoration: InputDecoration(
                hintText: "Enter reason...",
              ),
            ),
          ],
        ),
      )
          : Text("Are you sure you want to $status?",style: TextStyle(fontWeight: FontWeight.w500),),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((value) {
      loaddata();
    });
  }


  loaddata(){
    getVendorbookingApi(context, widget.turf_id).then((value){

      final responseData = jsonDecode(value);
      final message = responseData['message'];
      final status = responseData['status'];
      print("getCustomerBooking Response >>>>> "+status.toString());
      print("getCustomerBooking value >>>>> "+value.toString());
      if(status == 1)
      {

        TurfBookingModel model= turfBookingModelFromJson(value);
        print("getAllListApi body >>>>>jj "+model.booking.length.toString());
        //adminAuthFromJson(value).data.
        setState(() {
          listBooking=model.booking;

        });

      }
    });

  }



  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        title:  const Text(
          "History",
          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
          height: height,
          child:
          Column(
            children: [
              const SizedBox(height: 10,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  style: const TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),
                  keyboardType: TextInputType.text,
                  onChanged: ((value){
                    //searchFilterd(value);
                  }),

                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle:  const TextStyle(color: Colors.grey,fontSize: 14,fontWeight: FontWeight.w500),
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              listBooking.length==0?Container(
                height: height*0.7,
                 child: Center(child: Image.asset("assets/no_data.png",scale: 2,))

        // child: Center(child: Text("Record Not Found")),
              ):
              Container(
                height: height*0.78,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: listBooking.length,
                    itemBuilder: (context,index){

                      DateTime dateTime = DateTime.parse(listBooking[index].createddate.toString());

                      String createdDate = DateFormat('d MMM y, h:mm a').format(dateTime);
                      String dateString = listBooking[index].bookingDate.toString();
                      String dateOnlyString = dateString.split(" ")[0];
                      DateTime dateTimebook = DateTime.parse(dateOnlyString);

                      String formattedDate = DateFormat('dd-MM-yyyy').format(dateTimebook);

                      return Container(

                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15,top: 10),
                              child: Row(
                                children: [
                                  Text("Ordered on"),
                                  Text(" : ${createdDate}",style: TextStyle(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                            Card(
                              margin: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                              child: Container(
                                padding: EdgeInsets.all(1),

                                width: width,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
                                          child: Image.asset( "assets/turf.png",fit: BoxFit.cover,height: 130,width: 80,),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [


                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,

                                                      children: [
                                                        // Text(listBooking[index].turfName!,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 16)),
                                                        // SizedBox(height: 10,),
                                                        Text(
                                                            _capitalizeFirstLetter(
                                                                listBooking[index].turfName),
                                                            style: TextStyle(fontWeight: FontWeight.w500,
                                                                color: Colors.black,fontSize: 16)),

                                                      ],
                                                    ),
                                                    // SizedBox(height: 5,),
                                                    Row(

                                                      children: [
                                                        Text("Status : ",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.black,fontSize: 14)),
                                                        Text(
                                                          _capitalizeFirstLetter(
                                                              listBooking[index].status),
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w700,
                                                              color: _getStatusColor(listBooking[index].status),
                                                              fontSize: 16
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),


                                                Row(
                                                  children: [
                                                    Text("UserName :  ",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),

                                                    Text(
                                                        _capitalizeFirstLetter(
                                                            listBooking[index].bookingUserName),style: TextStyle(fontWeight: FontWeight.w700,fontSize: 14)),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text("UserContact : ",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),
                                                    Text(listBooking[index].bookingUserPhone,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 14),),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 10,top: 5),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Slots : ",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w400),),
                                                      Text(listBooking[index].slots.join('\n'),style: TextStyle(fontWeight: FontWeight.w600,color: Colors.black,fontSize: 14)),

                                                    ],
                                                  ),
                                                ),

                                                SizedBox(height: 2,),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 10),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(right: 10),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text("Booked On : ",style: TextStyle(fontWeight: FontWeight.w400,color: Colors.black)),
                                                                Text(formattedDate,style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),),

                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      Container(
                                                        margin: EdgeInsets.only(right: 0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text("Booking On : ",style: TextStyle(fontWeight: FontWeight.w400,color: Colors.black)),
                                                            Container(
                                                                width : width * 0.43,
                                                                child: Text(createdDate,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500))),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 2,),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 10),
                                                  child: Row(
                                                    children: [
                                                      Text("Advanced Per(%) : ",style: TextStyle(fontWeight: FontWeight.w400,color: Colors.black,fontSize: 14)),
                                                      Text(listBooking[index].advancedAmontPercentage,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
                                                    ],
                                                  ),
                                                ),

                                                Padding(
                                                  padding: const EdgeInsets.only(left: 10),
                                                  child: Row(

                                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                    children: [

                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text("Advanced Amount : ",style: TextStyle(fontWeight: FontWeight.w400,color: Colors.black,fontSize: 14)),
                                                          Text(listBooking[index].advancedAmount!,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize:14 )),

                                                        ],
                                                      ),

                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),


                                   /* SizedBox(height: 10,),
                                    // Container(height: 1,width: width,color: Colors.black12,),

                                    SizedBox(height: 2,),


                                    SizedBox(height: 10,),*/

                                    Visibility(
                                        visible: listBooking[index].status != "approved",

                                        child: Column(
                                          children: [
                                            Container(height: 1,width: width,color: Colors.black12,),
                                            SizedBox(height: 10,),

                                          ],
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(

                                        mainAxisAlignment: MainAxisAlignment.spaceAround,

                                        children: [
                                          Visibility(

                                            visible: listBooking[index].status != "cancel"&&listBooking[index].status != "reject" && listBooking[index].status != "approved",

                                            // visible: listBooking[index].status != "reject", // Only show if status is not "Cancel"

                                            child: InkWell(
                                              onTap: (){
                                                showAlertStatusChangedDialog(context,listBooking[index].id,"approved");
                                              },
                                              child:   Container(
                                                width: width * 0.42,
                                                child: Text('Approved',textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 13,color: Colors.white,
                                                      fontWeight: FontWeight.bold),),

                                                decoration: BoxDecoration(
                                                  color:Colors.green,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),


                                                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 2),

                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: listBooking[index].status != "cancel"&& listBooking[index].status != "reject" && listBooking[index].status != "approved",
                                            // visible: listBooking[index].status != "reject", // Only show if status is not "Cancel"
                                            child: InkWell(
                                              onTap: (){
                                                showAlertStatusChangedDialog(context,listBooking[index].id,"reject");
                                              },
                                              child:   Container(
                                                width: width * 0.42,
                                                child: Text('Reject',textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 13,color: Colors.white,
                                                      fontWeight: FontWeight.bold),),

                                                decoration: BoxDecoration(
                                                  color:Colors.redAccent,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),


                                                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 12),

                                              ),
                                            ),
                                          ),

                                          // SizedBox(height: 10,),
                                          Visibility(
                                            visible: listBooking[index].status == "cancel" || listBooking[index].status == "reject",
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Booking Cancelled :  ",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.red,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: width * 0.48,
                                                    child: Text(
                                                      maxLines: 5,
                                                      listBooking[index].cancelReason ,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontStyle: FontStyle.normal,
                                                          fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10,),

                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );

                    }),
              ),
            ],
          )
      ),
    );
  }
}
