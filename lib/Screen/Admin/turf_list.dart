import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_view_indicators/page_view_indicators.dart';

class TurfList extends StatefulWidget {
  const TurfList({super.key});

  @override
  State<TurfList> createState() => _TurfListState();
}

class _TurfListState extends State<TurfList> {
  final _currentPageNotifier = ValueNotifier<int>(0);
  final _boxHeight = 150.0;
  final _pageController = PageController();

  _buildCircleIndicator(int length) {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CirclePageIndicator(
          itemCount: length,
          currentPageNotifier: _currentPageNotifier,
        ),
      ),
    );
  }

  _buildPageView(List<String> images) {
    return Container(
      height: _boxHeight,
      child: PageView.builder(
          itemCount: images.length,
          controller: _pageController,
          itemBuilder: (BuildContext context, int index) {
            return ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              child: Image.asset(
                images[index],
                height: 200,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fill,
              ),
            );
          },
          onPageChanged: (int index) {
            _currentPageNotifier.value = index;
          }),
    );
  }

  final List<String> images = [
    "assets/turf.png",
    "assets/turf.png",
    "assets/turf.png",
    "assets/turf.png",
  ];

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                Container(
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                      child: Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.white,
                        size: 30,
                      )),
                ),
                Container(
                    margin: EdgeInsets.only(left: width * 0.2),
                    child: Text(
                      "Turf List",
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          ),
          Container(
            height: (height * 0.9) - 25,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: 2, // Assuming you have 5 items in your list_turf
              itemBuilder: (context, index) {
                return  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Card(
                    elevation: 2,
                    child: Container(
                      child: Column(
                        children: [
                          Stack(
                            children: <Widget>[
                              // Placeholder for the image
                              _buildPageView(images),
                              _buildCircleIndicator(images.length),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                children: [
                                  Text('Turf Name :',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  Text(" My Turf",
                                      style: TextStyle(color: Colors.black38))
                                ],
                              ),
                                Row(
                                  children: [
                                    Text('Contact No :',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    Text(" 9856767788",
                                        style: TextStyle(color: Colors.black38))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Turf Address :',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    Text("Dewas, Madhya Pradesh, India", style: TextStyle(color: Colors.black38))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Square Fit :',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    Text("Inodre", style: TextStyle(color: Colors.black38))
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('per_hour_amount :',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    Text("1200",style: TextStyle(color: Colors.black38))
                                  ],
                                ),
                                //
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('sport_type :',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    Text("baseball",style: TextStyle(color: Colors.black38))
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('facilities :',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    Text("food",style: TextStyle(color: Colors.black38))
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('createddate :',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    Text("2024-02-06 01:48:08",style: TextStyle(color: Colors.black38))
                                  ],
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showToast("Turf approved successfully");
                                      },
                                      child: Container(
                                          height: height * 0.05,
                                          width: width * 0.38,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.green,
                                          ),
                                          child: Center(
                                              child: Text(
                                                "Approve",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600),
                                              ))),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          // cancelTurf(Turf);
                                          showBlockConfirmationDialog(context);
                                        },
                                        child: Container(
                                            height: height * 0.05,
                                            width: width * 0.38,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                              color: Colors.redAccent,
                                            ),
                                            child: Center(
                                                child: Text("Reject",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                        FontWeight.w600))))),
                                  ],
                                ),

                              ],
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          //   child: Card(
          //     elevation: 2,
          //     child: Container(
          //       child: Column(
          //         children: [
          //           Stack(
          //             children: <Widget>[
          //               // Placeholder for the image
          //               _buildPageView(images),
          //               _buildCircleIndicator(images.length),
          //             ],
          //           ),
          //           Row(
          //             children: [
          //               Text('Turf Name :',
          //                   style: TextStyle(
          //                       fontWeight: FontWeight.bold,
          //                       color: Colors.black)),
          //               Text(" My Turf",
          //                   style: TextStyle(color: Colors.black38))
          //             ],
          //           ),
          //           Row(
          //             children: [
          //               Text('Contact No :',
          //                   style: TextStyle(
          //                       fontWeight: FontWeight.bold,
          //                       color: Colors.black)),
          //               Text(" 9856767788",
          //                   style: TextStyle(color: Colors.black38))
          //             ],
          //           ),
          //           Row(
          //             children: [
          //               Text('Turf Address :',
          //                   style: TextStyle(
          //                       fontWeight: FontWeight.bold,
          //                       color: Colors.black)),
          //               Text("Dewas, Madhya Pradesh, India", style: TextStyle(color: Colors.black38))
          //             ],
          //           ),
          //           Row(
          //             children: [
          //               Text('Square Fit :',
          //                   style: TextStyle(
          //                       fontWeight: FontWeight.bold,
          //                       color: Colors.black)),
          //               Text("Inodre", style: TextStyle(color: Colors.black38))
          //             ],
          //           ),
          //           Row(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text('per_hour_amount :',
          //                   style: TextStyle(
          //                       fontWeight: FontWeight.bold,
          //                       color: Colors.black)),
          //               Text("1200",style: TextStyle(color: Colors.black38))
          //             ],
          //           ),
          //           //
          //           Row(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text('sport_type :',
          //                   style: TextStyle(
          //                       fontWeight: FontWeight.bold,
          //                       color: Colors.black)),
          //               Text("baseball",style: TextStyle(color: Colors.black38))
          //             ],
          //           ),
          //           Row(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text('facilities :',
          //                   style: TextStyle(
          //                       fontWeight: FontWeight.bold,
          //                       color: Colors.black)),
          //               Text("food",style: TextStyle(color: Colors.black38))
          //             ],
          //           ),
          //           Row(
          //             crossAxisAlignment: CrossAxisAlignment.end,
          //             children: [
          //               Text('createddate :',
          //                   style: TextStyle(
          //                       fontWeight: FontWeight.bold,
          //                       color: Colors.black)),
          //               Text("2024-02-06 01:48:08",style: TextStyle(color: Colors.black38))
          //             ],
          //           ),
          //
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceAround,
          //             children: [
          //               InkWell(
          //                 onTap: () {
          //                   showToast("Turf approved successfully");
          //                 },
          //                 child: Container(
          //                     height: height * 0.05,
          //                     width: width * 0.38,
          //                     decoration: BoxDecoration(
          //                       borderRadius: BorderRadius.circular(10),
          //                       color: Colors.green,
          //                     ),
          //                     child: Center(
          //                         child: Text(
          //                           "Approve",
          //                           style: TextStyle(
          //                               color: Colors.white,
          //                               fontWeight: FontWeight.w600),
          //                         ))),
          //               ),
          //               InkWell(
          //                   onTap: () {
          //                     // cancelTurf(Turf);
          //                     showBlockConfirmationDialog(context);
          //                   },
          //                   child: Container(
          //                       height: height * 0.05,
          //                       width: width * 0.38,
          //                       decoration: BoxDecoration(
          //                         borderRadius:
          //                         BorderRadius.circular(10),
          //                         color: Colors.redAccent,
          //                       ),
          //                       child: Center(
          //                           child: Text("Reject",
          //                               style: TextStyle(
          //                                   color: Colors.white,
          //                                   fontWeight:
          //                                   FontWeight.w600))))),
          //             ],
          //           ),
          //
          //         ],
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }


  List<Map<String, dynamic>> Turfs = [
    { "number": "1"},
    { "number": "2"},
    { "number": "3"},
    // Add more Turf data as needed
  ];

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

/*
  void showBlockConfirmationDialog(BuildContext context) {
    TextEditingController reasonController = TextEditingController();
    GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Key for the form

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Are you sure you want to Reject this Turf?"),
              SizedBox(height: 10),
              TextFormField(
                controller: reasonController,
                decoration: InputDecoration(
                  hintText: "Enter reason",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a reason';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // If validation passes, handle the reason
                  String reason = reasonController.text;
                  print("reason ${reason}");// Perform the block action here
                  // You can call a function to block the user or execute any other logic
                  // After performing the action, close the dialog
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                    msg: "Reject Turf !",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
*/

  void showBlockConfirmationDialog(BuildContext context) {
    TextEditingController reasonController = TextEditingController();
    GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Key for the form

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Form(
            key: _formKey, // Assigning the _formKey to the Form widget
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Are you sure you want to Reject this Turf?"),
                SizedBox(height: 10),
                TextFormField(
                  controller: reasonController,
                  decoration: InputDecoration(
                    hintText: "Enter reason",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a reason';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // If validation passes, handle the reason
                  String reason = reasonController.text;
                  print("reason ${reason}");// Perform the block action here
                  // You can call a function to block the user or execute any other logic
                  // After performing the action, close the dialog
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                    msg: "Reject Turf !",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void approveTurf(Map<String, dynamic> Turf) {
    // Implement logic to approve the Turf
    print("Approved: ${Turf["name"]}");
  }

  void cancelTurf(Map<String, dynamic> Turf) {
    // Implement logic to cancel the Turf
    print("Cancelled: ${Turf["name"]}");
  }
}

