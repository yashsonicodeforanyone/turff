/*

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turfapp/MyConstants/ShPrefConstants.dart';
import 'package:turfapp/MyNetwork/BookingHistoryApi/customerBooking.dart';
import 'package:turfapp/MyNetwork/BookingNetwork/cancelBookingApi.dart';
import 'package:turfapp/Screen/HomeScreen.dart';
import '../../MyConstants/AppCustomDialog.dart';
import '../../MyConstants/ShImageConstants.dart';
import '../../MyConstants/ShWidgetConsts.dart';
import '../../MyModel/BookingModel.dart';
import '../../MyNetwork/BookingNetwork/deleteBookingId.dart';

class CustomerHistoryScreen extends StatefulWidget {
  String cstomer_id;
  String? usertype;
  String contactno;
  String ? reason;
  String ? id;
  CustomerHistoryScreen({required this.cstomer_id, this.usertype, required this.contactno, this.id,this.reason});

  @override
  State<CustomerHistoryScreen> createState() => _CustomerHistoryScreenState();
}

class _CustomerHistoryScreenState extends State<CustomerHistoryScreen> {
  TextEditingController FilterController = TextEditingController();
  List<Booking> listBooking=[];
  List<Booking> _filteredList = [];
  bool _dataNotFound = false;
  late SharedPreferences prefs;
  String user_type = "";
  String contactNo = "";
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

      user_type = widget.usertype.toString();
      print("number history ===>>${contactNo}");
      print("##>>>>>>>" + user_type);
      //admin/vendor/user
    });
  }

  loaddata(){
    setState(() {
      listBooking.clear();
    });
    getCustomerBooking(context, widget.cstomer_id, FilterController.text).then((value){

      final responseData = jsonDecode(value);
      final message = responseData['message'];
      final status = responseData['status'];
      print("getCustomerBooking Response >>>>> "+status.toString());
      print("getCustomerBooking value >>>>> "+value.toString());
      if(status == 1)
      {

        TurfBookingModel model= turfBookingModelFromJson(value);
        print("getAllListApi body >>>>> "+model.booking.length.toString());
        //adminAuthFromJson(value).data.
        setState(() {
          listBooking=model.booking;

          //
          _filteredList = List<Booking>.from(listBooking);
          _dataNotFound = _filteredList.isEmpty;
        });
      }
    });
  }
  void filterData(String searchText) {
    setState(() {
      _filteredList = listBooking
          .where((turf) =>
          turf.turfName.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
      _dataNotFound = _filteredList.isEmpty;
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
              showAlertSuccess(message, context,widget.cstomer_id,user_type,contactNo);
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



  showAlertCancellBookingDialog(BuildContext context, String id, String status) {
    TextEditingController reasonController = TextEditingController();
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    Widget cancelButton = Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        child: Text("Cancel"),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );

    Widget continueButton = Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        child: Text("OK"),
        onTap: () {
          if (_formKey.currentState!.validate()) {
            // Validation passed, continue with your logic
            String reason = reasonController.text;
            print("Reason: $reason");
            cancelBookingApi(context,id,reason).then((value)  {
              final responseData = jsonDecode(value);
              final message = responseData['message'];
              final status = responseData['status'];
              if(status==1)
              {
                Fluttertoast.showToast(
                  msg: message,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );//loaddata();

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CustomerHistoryScreen( cstomer_id: widget.cstomer_id, contactno: widget.contactno,)),
                );

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomerHistoryScreen(
                          cstomer_id: widget.cstomer_id,
                          contactno: widget.contactno,
                          reason : reasonController.text,
                          usertype: user_type,
                          id: id
                      )),
                      (route) => route.isFirst,
                  // Condition to remove all routes until the first route
                );

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
                          setState(() {});
                        },
                        colors: Colors.red,
                      ),
                );
              }
            });

            // Place your API call or further logic here
          }
        },
      ),
    );

    AlertDialog alert = AlertDialog(
      title: Text("${status}",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: Colors.red),),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Are you sure you want to $status?"),
            TextFormField(
              controller: reasonController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please provide a reason';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "Enter reason...",
              ),
            ),
          ],
        ),
      ),
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
    );
  }

//capital
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

  // color
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.black;
      case 'cancel':
        return Colors.red;
      case 'approved':
        return Colors.green;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;


    return WillPopScope(onWillPop: () {
      print("contact hh===> ${widget.contactno}");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(cutomerid: widget.cstomer_id,usertype: widget.usertype,contactno: widget.contactno,),
        ),
      );
      return Future.value(true); // Allow the back operation

    },
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.green,
          iconTheme: const IconThemeData(color: Colors.white),
          title:  const Text(
            "History",
            style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        // resizeToAvoidBottomInset: false,
        body: Container(
            height: height,
            child:
            Column(
              children: [
                SizedBox(height: 10,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: FilterController,
                    onChanged: filterData,
                    style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w500),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(fontSize: 16,color: Colors.grey,fontWeight: FontWeight.w600),
                      suffixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                listBooking.length==0?Container(
                  height: height * 0.4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Record Not Found"),
                    ],
                  ),
                ):
                Expanded(
                  child: Container(
                    height: height*0.75,

                    child:_dataNotFound
                        ?  Center(child: Image.asset("assets/no_data.png",scale: 2,))
                        : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredList.length,
                      itemBuilder: (context,index){
                        DateTime dateTime = DateTime.parse(listBooking[index].createddate.toString());
                        String createdDate = DateFormat('d MMM y, h:mm a').format(dateTime);
                        String dateString = listBooking[index].bookingDate.toString();
                        String formattedDateString = dateString.replaceAll("00:00:00.000", "");
                        // DateTime dateTimebook = DateTime.parse(formattedDateString);
                        // String formattedDate = DateFormat('dd-MM-yyyy').format(dateTimebook);
                        String dateOnlyString = dateString.split(" ")[0];
                        DateTime dateTimebook = DateTime.parse(dateOnlyString);

                        String formattedDate = DateFormat('dd-MM-yyyy').format(dateTimebook);

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7,vertical: 8),
                          child: Container(
                            color: Colors.grey[300],
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text("Ordered on:",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500)),
                                    Text(createdDate,style: TextStyle(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side:
                                      const BorderSide(color: Colors.grey, width: 2)),
                                  margin: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                                    width: width,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Image with fixed size
*/
/*
                                            Image.network(_filteredList[index].taruffImg,fit: BoxFit.cover,height: height*0.22,width: width*0.35,),
*//*

                                            // Column with booking details
                                            Image.network(
                                              _filteredList[index].taruffImg,
                                              fit: BoxFit.cover,
                                              height: height * 0.22,
                                              width: width * 0.35,
                                              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                                return Image.asset(
                                                  'assets/image not found.jpg', // Path to your dummy image
                                                  fit: BoxFit.cover,
                                                  height: height * 0.22,
                                                  width: width * 0.35,
                                                );
                                              },
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 8), // Added padding
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [

                                                    FittedBox(
                                                      child: Row(
                                                        children: [
                                                          Text("Turf Owner :  ",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),
                                                      
                                                          Text(
                                                              _capitalizeFirstLetter(
                                                                  listBooking[index].turfHonorName),style: TextStyle(fontWeight: FontWeight.w700,fontSize: 14)),
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text("Turf Contact : ",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),
                                                        Text(listBooking[index].turfHonorPhone,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 14),),
                                                      ],
                                                    ),
                                                    Row(
                                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text("Status : ",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 14)),
                                                                Text(
                                                                  _capitalizeFirstLetter(
                                                                      listBooking[
                                                                      index]
                                                                          .status),
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                      color: _getStatusColor(
                                                                          listBooking[index]
                                                                              .status),
                                                                      fontSize:
                                                                      14),
                                                                ),                                                              ],
                                                            ),
                                                            Text(listBooking[index].turfName!,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 14)),
                                                            SizedBox(height: 3,),
                                                            Text(listBooking[index].slots.join('\n'),style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 14)),
                                                          ],
                                                        ),


                                                      ],
                                                    ),
                                                    SizedBox(height: 3,),
                                                    // Booked date and booking on
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text("Booked Date : ",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 14)),
                                                            Text(formattedDate,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 13)),
                                                          ],
                                                        ),
                                                        */
/* Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text("Booking On : ",style: TextStyle(fontWeight: FontWeight.w400,color: Colors.black)),
                                                            Expanded(child: Text(createdDate,style: TextStyle(color: Colors.black38,fontSize: 13))),
                                                          ],
                                                        )*//*

                                                      ],
                                                    ),
                                                    SizedBox(height: 3,),
                                                    // Advanced percentage and amount
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        */
/* Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text("Advanced Per(%) : ",style: TextStyle(fontWeight: FontWeight.w400,color: Colors.black)),
                                                            Text(listBooking[index].advancedAmontPercentage,style: TextStyle(fontSize: 14),),
                                                          ],
                                                        ),*//*

                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text("Advanced Amount : ",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 14)),
                                                            Text(listBooking[index].advancedAmount!,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize:15 )),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10,),
                                                    // Delete and cancel booking buttons

                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(color: Colors.black38,),
                                        //done
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            // Display Cancel Booking button if status is not "cancel" or "reject" and is_direct_booking is not "1"
                                            Visibility(
                                              visible: listBooking[index].status != "cancel" && listBooking[index].status != "reject" && listBooking[index].isdirectbooking != "1",
                                              child: InkWell(
                                                onTap: () {
                                                  showAlertCancellBookingDialog(context, listBooking[index].id, "Cancel Booking");
                                                },
                                                child: Container(
                                                  width: width * 0.35,
                                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.green, width: 1),
                                                    borderRadius: BorderRadius.all(Radius.circular(05)),
                                                  ),
                                                  child: const Center(
                                                    child: Text(
                                                      "Cancel Booking",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.green,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // Display "Booking Cancelled: Hope you enjoy" if status is "cancel" or "reject"
                                            Visibility(
                                              visible: listBooking[index].status == "cancel" || listBooking[index].status == "reject",
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                                child: FittedBox(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                                        width: width * 0.42,
                                                        child: Text(
                                                          // maxLines: 2,
                                                          listBooking[index].cancelReason,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontStyle: FontStyle.normal,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),

                                            SizedBox(width: 11),

                                            // Display "|" separator if status is not "cancel"
                                            Visibility(
                                              visible: listBooking[index].status != "cancel" && listBooking[index].status != "reject" && listBooking[index].isdirectbooking != "1",
                                              child: Text(
                                                "|",
                                                style: TextStyle(
                                                  fontSize: 30,
                                                  color: Colors.black38,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8),

                                            // Display "Hope you enjoyed !" if status is not "cancel"
                                            Visibility(
                                              visible: listBooking[index].status != "cancel" && listBooking[index].status != "reject" && listBooking[index].isdirectbooking != "1",
                                              child: Text(
                                                "Hope you enjoyed !",
                                                style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    */
/*ListView.builder(
                        shrinkWrap: true,
                        itemCount: listBooking.length,
                        itemBuilder: (context,index){
                          DateTime dateTime = DateTime.parse(listBooking[index].createddate.toString());
                          String createdDate = DateFormat('d MMM y, h:mm a').format(dateTime);
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              width: width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(listBooking[index].taruffImg,fit: BoxFit.cover,height: 100,width: 80,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  // Text("Turf : ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                                                  Text(listBooking[index].turfName!,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green)),
                                                ],
                                              ),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // Text("Slots : ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                                                  Text(listBooking[index].slots.join('\n'),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green)),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text("Status : ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                                              Text(listBooking[index].status,style: TextStyle(color: Colors.black38))
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text("Booked Date : ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                                                  ],
                                                ),
                                                Text(listBooking[index].bookingDate.toString().replaceAll("00:00:00.000", "")),
                                              ],
                                            ),
                                          ),

                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Booking On : ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                                                Text(createdDate,style: TextStyle(color: Colors.black38)),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Text("Advanced Per(%) : ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                                          Text(listBooking[index].advancedAmontPercentage),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Container(height: 1,width: width,color: Colors.black12,),
                                      SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text("Advanced Amount : ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 18)),
                                              Text(listBooking[index].advancedAmount!,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green,fontSize:18 )),

                                            ],
                                          ),
                                          InkWell(
                                            onTap: (){
                                              showAlertDeleteDialog(context,listBooking[index].id);
                                            },
                                            child:   Container(



                                              child: Text('Delete',textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 13,color: Colors.white,
                                                    fontWeight: FontWeight.bold),),

                                              decoration: BoxDecoration(
                                                color:Colors.green,
                                                borderRadius: BorderRadius.circular(10),
                                              ),


                                              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 12),

                                            ),
                                          ),

                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Container(height: 1,width: width,color: Colors.black12,),
                                      SizedBox(height: 10,),


                                                    *//*

                    */
/*
                                      Row(

                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                        children: [

                                          InkWell(
                                            onTap: (){
                                              showAlertCancellBookingDialog(context,listBooking[index].id,"Cancel Booking");
                                            },
                                            child:   Container(
                                              width: (width/1)-80,


                                              child: Text('Cancel Booking',textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 13,color: Colors.white,
                                                    fontWeight: FontWeight.bold),),

                                              decoration: BoxDecoration(
                                                color:Colors.redAccent,
                                                borderRadius: BorderRadius.circular(10),
                                              ),


                                              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 12),

                                            ),
                                          ),







                                        ],
                                      ),
                                                    *//*

                    */
/*

                                      Row(
                                        children: [
                                          Visibility(
                                            visible: listBooking[index].status != "cancel", // Only show if status is not "Cancel"
                                            child: InkWell(
                                              onTap: (){
                                                showAlertCancellBookingDialog(context, listBooking[index].id, "Cancel Booking");
                                              },
                                              child: Container(
                                                width: (width / 1) - 80,
                                                child: Text(
                                                  'Cancel Booking',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.redAccent,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );

                        }),*//*



                  ),
                ),
              ],
            )
        ),
      ), );
  }
}
*/

































import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turfapp/MyConstants/ShPrefConstants.dart';
import 'package:turfapp/MyNetwork/BookingHistoryApi/customerBooking.dart';
import 'package:turfapp/MyNetwork/BookingNetwork/cancelBookingApi.dart';
import 'package:turfapp/Screen/HomeScreen.dart';

import '../../MyConstants/AppCustomDialog.dart';
import '../../MyConstants/ShImageConstants.dart';
import '../../MyConstants/ShWidgetConsts.dart';
import '../../MyModel/BookingModel.dart';
import '../../MyNetwork/BookingNetwork/deleteBookingId.dart';
class CustomerHistoryScreen extends StatefulWidget {

  String cstomer_id;
  String? usertype;
  String contactno;
  String ? reason;
  String ? id;
  CustomerHistoryScreen({required this.cstomer_id, this.usertype, required this.contactno, this.id,this.reason});

  @override
  State<CustomerHistoryScreen> createState() => _CustomerHistoryScreenState();
}

class _CustomerHistoryScreenState extends State<CustomerHistoryScreen> {
  TextEditingController FilterController = TextEditingController();

  List<Booking> listBooking=[];
  List<Booking> _filteredList = [];
  bool _dataNotFound = false;


  late SharedPreferences prefs;
  String user_type = "";
  String contactNo = "";

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

      user_type = widget.usertype.toString();
      print("number history ===>>${contactNo}");
      print("##>>>>>>>" + user_type);
      //admin/vendor/user
    });
  }

  loaddata(){
    setState(() {
      listBooking.clear();
    });
    getCustomerBooking(context, widget.cstomer_id, FilterController.text).then((value){

      final responseData = jsonDecode(value);
      final message = responseData['message'];
      final status = responseData['status'];
      print("getCustomerBooking Response >>>>> "+status.toString());
      print("getCustomerBooking value >>>>> "+value.toString());
      if(status == 1)
      {

        TurfBookingModel model= turfBookingModelFromJson(value);
        print("getAllListApi body >>>>> "+model.booking.length.toString());
        //adminAuthFromJson(value).data.
        setState(() {
          listBooking=model.booking;

          //
          _filteredList = List<Booking>.from(listBooking);
          _dataNotFound = _filteredList.isEmpty;
        });

      }
    });

  }
  void filterData(String searchText) {
    setState(() {
      _filteredList = listBooking
          .where((turf) =>
          turf.turfName.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
      _dataNotFound = _filteredList.isEmpty;
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
              showAlertSuccess(message, context,widget.cstomer_id,user_type,contactNo);
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



  showAlertCancellBookingDialog(BuildContext context, String id, String status) {
    TextEditingController reasonController = TextEditingController();
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    Widget cancelButton = Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        child: Text("Cancel"),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );

    Widget continueButton = Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        child: Text("OK"),
        onTap: () {
          if (_formKey.currentState!.validate()) {
            // Validation passed, continue with your logic
            String reason = reasonController.text;
            print("Reason: $reason");

            cancelBookingApi(context,id,reason).then((value)  {
              final responseData = jsonDecode(value);
              final message = responseData['message'];
              final status = responseData['status'];

              if(status==1)
              {

                Fluttertoast.showToast(
                  msg: message,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );//loaddata();

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CustomerHistoryScreen( cstomer_id: widget.cstomer_id, contactno: widget.contactno,)),
                );

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomerHistoryScreen(
                          cstomer_id: widget.cstomer_id,
                          contactno: widget.contactno,
                          reason : reasonController.text,
                          usertype: user_type,
                          id: id
                      )),
                      (route) => route.isFirst,
                  // Condition to remove all routes until the first route
                );

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
                          setState(() {});
                        },
                        colors: Colors.red,
                      ),
                );
              }
            });

            // Place your API call or further logic here
          }
        },
      ),
    );

    AlertDialog alert = AlertDialog(
      title: Text("${status}",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: Colors.red),),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Are you sure you want to $status?"),
            TextFormField(
              controller: reasonController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please provide a reason';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "Enter reason...",
              ),
            ),
          ],
        ),
      ),
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
    );
  }

//capital
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

  // color
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
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;


    return WillPopScope(onWillPop: () {
      print("contact hh===> ${widget.contactno}");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(cutomerid: widget.cstomer_id,usertype: widget.usertype,contactno: widget.contactno,),
        ),
      );
      return Future.value(true); // Allow the back operation

    },
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.green,
          iconTheme: const IconThemeData(color: Colors.white),
          title:  const Text(
            "History",
            style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        // resizeToAvoidBottomInset: false,
        body: Container(
            height: height,
            child:
            Column(
              children: [
                SizedBox(height: 10,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: FilterController,
                    onChanged: filterData,
                    style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w500),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(fontSize: 16,color: Colors.grey,fontWeight: FontWeight.w600),
                      suffixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                listBooking.length==0?Container(
                  height: height * 0.4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Record Not Found"),
                    ],
                  ),
                ):
                Expanded(
                  child: Container(
                    height: height*0.75,

                    child:_dataNotFound
                        ?  Center(child: Image.asset("assets/no_data.png",scale: 2,))

                        // ? Center(child: Text('Data not found'))
                        : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredList.length,
                      itemBuilder: (context,index){
                        DateTime dateTime = DateTime.parse(listBooking[index].createddate.toString());
                        String createdDate = DateFormat('d MMM y, h:mm a').format(dateTime);
                        String dateString = listBooking[index].bookingDate.toString();
                        String formattedDateString = dateString.replaceAll("00:00:00.000", "");
                        // DateTime dateTimebook = DateTime.parse(formattedDateString);
                        // String formattedDate = DateFormat('dd-MM-yyyy').format(dateTimebook);
                        String dateOnlyString = dateString.split(" ")[0];
                        DateTime dateTimebook = DateTime.parse(dateOnlyString);

                        String formattedDate = DateFormat('dd-MM-yyyy').format(dateTimebook);

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7,vertical: 8),
                          child: Container(
                            color: Colors.grey[300],
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text("Ordered on:",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500)),
                                    Text(createdDate,style: TextStyle(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side:
                                      const BorderSide(color: Colors.grey, width: 2)),
                                  margin: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                                    width: width,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Image with fixed size
                                            // Image.network(_filteredList[index].taruffImg,fit: BoxFit.cover,height: height*0.22,width: width*0.35,),
                                            // Column with booking details
                                            Image.network(
                                              _filteredList[index].taruffImg,
                                              fit: BoxFit.cover,
                                              height: height * 0.22,
                                              width: width * 0.35,
                                              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                                return Image.asset(
                                                  'assets/image not found.jpg', // Path to your dummy image
                                                  fit: BoxFit.cover,
                                                  height: height * 0.22,
                                                  width: width * 0.35,
                                                );
                                              },
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 8), // Added padding
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    // Turf name and slots
                                                    Row(
                                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            // Row(
                                                            //   children: [
                                                            //     Text("Status : ",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 14)),
                                                            //     Text(
                                                            //       _capitalizeFirstLetter(
                                                            //           listBooking[
                                                            //           index]
                                                            //               .status),
                                                            //       style: TextStyle(
                                                            //           fontWeight:
                                                            //           FontWeight
                                                            //               .w700,
                                                            //           color: _getStatusColor(
                                                            //               listBooking[index]
                                                            //                   .status),
                                                            //           fontSize:
                                                            //           14),
                                                            //     ),                                                              ],
                                                            // ),
                                                            // Text(listBooking[index].turfName!,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 14)),

                                                            FittedBox(
                                                              child: Row(
                                                                children: [
                                                                  Text("Turf Owner :  ",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),

                                                                  Text(
                                                                      _capitalizeFirstLetter(
                                                                          listBooking[index].turfHonorName),style: TextStyle(fontWeight: FontWeight.w700,fontSize: 14)),
                                                                ],
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text("Turf Contact : ",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),
                                                                Text(listBooking[index].turfHonorPhone,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 14),),
                                                              ],
                                                            ),
                                                            Row(
                                                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text("Status : ",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 14)),
                                                                        Text(
                                                                          _capitalizeFirstLetter(
                                                                              listBooking[
                                                                              index]
                                                                                  .status),
                                                                          style: TextStyle(
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .w700,
                                                                              color: _getStatusColor(
                                                                                  listBooking[index]
                                                                                      .status),
                                                                              fontSize:
                                                                              14),
                                                                        ),                                                              ],
                                                                    ),
                                                                    Text(listBooking[index].turfName!,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 14)),
                                                                    SizedBox(height: 3,),
                                                                    Text(listBooking[index].slots.join('\n'),style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 14)),
                                                                  ],
                                                                ),


                                                              ],
                                                            ),
                                                            SizedBox(height: 3,),
                                                          ],
                                                        ),


                                                      ],
                                                    ),
                                                    SizedBox(height: 3,),
                                                    // Booked date and booking on
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text("Booked Date : ",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 14)),
                                                            Text(formattedDate,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 13)),
                                                          ],
                                                        ),
                                                        /* Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text("Booking On : ",style: TextStyle(fontWeight: FontWeight.w400,color: Colors.black)),
                                                            Expanded(child: Text(createdDate,style: TextStyle(color: Colors.black38,fontSize: 13))),
                                                          ],
                                                        )*/
                                                      ],
                                                    ),
                                                    SizedBox(height: 3,),
                                                    // Advanced percentage and amount
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        /* Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text("Advanced Per(%) : ",style: TextStyle(fontWeight: FontWeight.w400,color: Colors.black)),
                                                            Text(listBooking[index].advancedAmontPercentage,style: TextStyle(fontSize: 14),),
                                                          ],
                                                        ),*/
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text("Advanced Amount : ",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 14)),
                                                            Text(listBooking[index].advancedAmount!,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize:15 )),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10,),
                                                    // Delete and cancel booking buttons
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        Visibility(
                                            visible: listBooking[index].status != "approved",

                                            child: Divider(color: Colors.black38,)),
                                        //done

                                        /*isibility(
                                          visible: listBooking[index].status == "cancel" && listBooking[index].status == "reject",
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "Booking Cancelled :  ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.red,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                // SizedBox(width: width * 0.15),
                                                Row(
                                                  children: [
                                                    Text(
                                                      listBooking[index].cancelReason,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontStyle: FontStyle.normal,
                                                          fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),*/

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
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [




                                            Visibility(
                                              visible:listBooking[index].status != "reject"&& listBooking[index].status != "cancel" && listBooking[index].isdirectbooking != "1",

                                              child: InkWell(
                                                onTap: (){
                                                  showAlertCancellBookingDialog(context, listBooking[index].id, "Cancel Booking");
                                                },
                                                child: Container(
                                                  width: width * 0.35,
                                                  padding:  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                                  decoration:  BoxDecoration(
                                                      border: Border.all(color: Colors.green,width: 1),
                                                      borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              05))),
                                                  child: const Center(
                                                    child: Text(
                                                      "Cancel Booking",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.green,
                                                          fontWeight:
                                                          FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                            ),
                                            // SizedBox(width: 11),
                                            /*     VerticalDivider(
                                                color: Colors.black38,
                                                thickness: 3,
                                                width: 20, // Adjust width as needed
                                                endIndent: 5, // Adjust endIndent as needed
                                                indent: 5, // Adjust indent as needed
                                              ),*/
                                            SizedBox(width: 11),
                                            Visibility(
                                              visible:listBooking[index].status != "reject"&& listBooking[index].status != "cancel"&&  listBooking[index].isdirectbooking != "1",
                                              child: Text(
                                                "|",
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    color: Colors
                                                        .black38
                                                ),
                                              ),
                                            ),
                                            // Text("|",style: TextStyle(fontSize: 30,color: Colors.black38),),
                                            /*SizedBox(width: 8),
                                            Text("Hope you enjoyed !",style: TextStyle(fontSize: 16,color: Colors.green,fontWeight: FontWeight.w500))*/
                                            SizedBox(width: 8),
                                            Visibility(
                                              visible: listBooking[index].status != "reject"&& listBooking[index].status != "cancel"&& listBooking[index].isdirectbooking != "1",

                                              child:Text("Hope you enjoyed !",style: TextStyle(fontSize: 16,color: Colors.green,fontWeight: FontWeight.w500)),

                                            ),
                                          ],
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    /*ListView.builder(
                        shrinkWrap: true,
                        itemCount: listBooking.length,
                        itemBuilder: (context,index){
                          DateTime dateTime = DateTime.parse(listBooking[index].createddate.toString());
                          String createdDate = DateFormat('d MMM y, h:mm a').format(dateTime);
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              width: width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(listBooking[index].taruffImg,fit: BoxFit.cover,height: 100,width: 80,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  // Text("Turf : ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                                                  Text(listBooking[index].turfName!,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green)),
                                                ],
                                              ),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // Text("Slots : ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                                                  Text(listBooking[index].slots.join('\n'),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green)),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text("Status : ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                                              Text(listBooking[index].status,style: TextStyle(color: Colors.black38))
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text("Booked Date : ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                                                  ],
                                                ),
                                                Text(listBooking[index].bookingDate.toString().replaceAll("00:00:00.000", "")),
                                              ],
                                            ),
                                          ),

                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Booking On : ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                                                Text(createdDate,style: TextStyle(color: Colors.black38)),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Text("Advanced Per(%) : ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                                          Text(listBooking[index].advancedAmontPercentage),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Container(height: 1,width: width,color: Colors.black12,),
                                      SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text("Advanced Amount : ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 18)),
                                              Text(listBooking[index].advancedAmount!,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green,fontSize:18 )),

                                            ],
                                          ),
                                          InkWell(
                                            onTap: (){
                                              showAlertDeleteDialog(context,listBooking[index].id);
                                            },
                                            child:   Container(



                                              child: Text('Delete',textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 13,color: Colors.white,
                                                    fontWeight: FontWeight.bold),),

                                              decoration: BoxDecoration(
                                                color:Colors.green,
                                                borderRadius: BorderRadius.circular(10),
                                              ),


                                              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 12),

                                            ),
                                          ),

                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Container(height: 1,width: width,color: Colors.black12,),
                                      SizedBox(height: 10,),


                                                    *//*
                                      Row(

                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                        children: [

                                          InkWell(
                                            onTap: (){
                                              showAlertCancellBookingDialog(context,listBooking[index].id,"Cancel Booking");
                                            },
                                            child:   Container(
                                              width: (width/1)-80,


                                              child: Text('Cancel Booking',textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 13,color: Colors.white,
                                                    fontWeight: FontWeight.bold),),

                                              decoration: BoxDecoration(
                                                color:Colors.redAccent,
                                                borderRadius: BorderRadius.circular(10),
                                              ),


                                              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 12),

                                            ),
                                          ),







                                        ],
                                      ),
                                                    *//*

                                      Row(
                                        children: [
                                          Visibility(
                                            visible: listBooking[index].status != "cancel", // Only show if status is not "Cancel"
                                            child: InkWell(
                                              onTap: (){
                                                showAlertCancellBookingDialog(context, listBooking[index].id, "Cancel Booking");
                                              },
                                              child: Container(
                                                width: (width / 1) - 80,
                                                child: Text(
                                                  'Cancel Booking',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.redAccent,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );

                        }),*/
                  ),
                ),
              ],
            )
        ),
      ), );
  }
}
