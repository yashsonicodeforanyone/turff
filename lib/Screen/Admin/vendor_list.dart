/*
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

class VendorListScreen extends StatefulWidget {
 final String? usertype;
  const VendorListScreen({super.key, this.usertype });

  @override
  State<VendorListScreen> createState() => _VendorListScreenState();
}

class _VendorListScreenState extends State<VendorListScreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height =  MediaQuery.of(context).size.height;

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
                InkWell(
                  onTap: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  child: Icon(Icons.arrow_back_outlined, color: Colors.white, size: 30),
                ),
                Container(
                  margin: EdgeInsets.only(left: width * 0.2),
                  child: Text(
                    "Vendor's",
                    style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/

// new

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VendorListScreen extends StatefulWidget {
  final String? usertype;

  const VendorListScreen({Key? key, this.usertype}) : super(key: key);

  @override
  State<VendorListScreen> createState() => _VendorListScreenState();
}

class _VendorListScreenState extends State<VendorListScreen> {
  List<Map<String, dynamic>> vendors = [
    { "number": "1"},
    { "number": "2"},
    { "number": "3"},
    // Add more vendor data as needed
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


  void showRejectConfirmationDialog(BuildContext context) {
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
                Text("Are you sure you want to Reject this Vendor?"),
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
                    msg: "Reject Vendor !",
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

  void showBlockConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Are you sure you want to block this user?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Perform the block action here
                // You can call a function to block the user or execute any other logic
                // After performing the action, close the dialog
                Navigator.of(context).pop();
              },
              child: Text("Block"),
            ),
          ],
        );
      },
    );
  }


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
                InkWell(
                  onTap: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  child: Icon(Icons.arrow_back_outlined,
                      color: Colors.white, size: 30),
                ),
                Container(
                  margin: EdgeInsets.only(left: width * 0.2),
                  child: Text(
                    "Vendor's List",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: vendors.length,
              itemBuilder: (context, index) {
                final vendor = vendors[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(" id : ",style: TextStyle(fontWeight: FontWeight.bold,),),
                                    Text(vendor["number"]?? "" ),

                                  ],
                                ),
                                SizedBox(width: width * 0.44,),
                                Row(

                                  children: [
                                    Text("Type : ",style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                    Text("vendor")
                                  ],
                                ),

                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    Text("Number : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    Text(" 9887765756",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Status : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    Text("pending",
                                        style: TextStyle(color: Colors.black38))
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            // Row(
                            //   children: [],
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    approveVendor(vendor);
                                    showToast("Vendor approved successfully");
                                  },
                                  child: Container(
                                      height: height * 0.05,
                                      width: width * 0.4,
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
                                      cancelVendor(vendor);
                                      showRejectConfirmationDialog(context);
                                    },
                                    child: Container(
                                        height: height * 0.05,
                                        width: width * 0.4,
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
                      ),
                    ),
                  ),
                );

                /*ListTile(
                  title: Text(vendor[""] ?? ""),
                  subtitle: Text(vendor[""] ?? ""),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        children: [
                          Text(vendor["name"]?? ""),

                          Row(
                            children: [
                              Icon(Icons.call,color: Colors.green,size: 20,),

                              SizedBox(width: width * 0.02,),
                              Text(vendor["number"]?? ""),
                            ],
                          ),

                        ],
                      ),
                      SizedBox(width: width * 0.02,),
                      Text(vendor["number"]?? ""),
                      SizedBox(width: width * 0.2,),

                      IconButton(
                        onPressed: () {
                          // Implement approve action
                          approveVendor(vendor);
                        },
                        icon: Icon(Icons.check, color: Colors.green),
                      ),
                      IconButton(
                        onPressed: () {
                          // Implement cancel action
                          cancelVendor(vendor);
                        },
                        icon: Icon(Icons.cancel, color: Colors.red),
                      ),
                    ],
                  ),
                );*/
              },
            ),
          ),
        ],
      ),
    );
  }

  void approveVendor(Map<String, dynamic> vendor) {
    // Implement logic to approve the vendor
    print("Approved: ${vendor["name"]}");
  }

  void cancelVendor(Map<String, dynamic> vendor) {
    // Implement logic to cancel the vendor
    print("Cancelled: ${vendor["name"]}");
  }
}
