/*
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:turfapp/Screen/HomeScreen.dart';
import 'package:turfapp/Screen/VendorSide/get_user_suport_form.dart';
import 'package:http/http.dart'as http;


class SupportForm extends StatefulWidget {
  final String? usertype;
  final String? cutomerid;

  const SupportForm({Key? key, this.usertype, this.cutomerid}) : super(key: key);

  @override
  State<SupportForm> createState() => _SupportFormState();
}

class _SupportFormState extends State<SupportForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  String? selectedIssueType;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

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
                    "Support and Help",
                    style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Name',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        ),

                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: numberController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a mobile number';
                          }
                          if (value.length != 10) {
                            return 'Mobile number must be 10 digits';
                          }
                          return null; // Return null if the validation is successful
                        },
                        decoration: InputDecoration(
                          hintText: 'Number',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),

                        ),

                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                        value: selectedIssueType,
                        items: ['Select turf issue', 'Application issue', 'Other']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            selectedIssueType = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty || value == 'Select turf issue') {
                            return 'Please select an issue type';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Issue Type',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: noteController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Note',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          submitForm();
                        }
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
                            "Submit",
                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void submitForm() async {
    String name = nameController.text;
    String number = numberController.text;
    String email = emailController.text;
    String issueType = selectedIssueType ?? '';
    String note = noteController.text;
    print("name = ${nameController.text}");
    print("number = ${nameController.text}");

    print("email = ${emailController.text}");
    print("issue = ${selectedIssueType ?? ''}");

    print("note = ${noteController.text}");



    var headers = {
      'Cookie': 'ci_session=57nmmrmv7102l0gfqal2134fgktni489'
    };
    var request = http.MultipartRequest('POST', Uri.parse('https://taruff.shortlinker.in/api/create_support'));
    request.fields.addAll({
      'user_vendor_id': '5591',
      // 'user_vendor_id': widget.cutomerid.toString(), // This might need to be changed if you get this value dynamically
      'name': name,
      'number': number,
      'email': email,
      'type': issueType,
      'turf_id': '', // You might need to populate this value if applicable
      'message': note
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            cutomerid: widget.cutomerid.toString(),
            usertype: widget.usertype,
          ),
        ),
      );
      // showConfirmationDialog(); // Show confirmation dialog on success
    } else {
      print(response.reasonPhrase);
      // Handle error here, such as showing an error toast
      Fluttertoast.showToast(msg: 'Failed to submit support request');
    }
  }


  void sendFormDataToBackend(String name, String number, String email, String issueType, String note) {
    // Implement backend communication here
    // You may use a package like http or dio to send data to your server
  }

  void showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Form Submitted'),
          content: Text('Your support request has been submitted successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserSuportFormData(*//*

*/
/*cutomerid: widget.cutomerid ?? '', usertype: widget.usertype*//*
*/
/*
)),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
//8885556663 vendor
//5591 user  9893204765*//*




import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:turfapp/Screen/HomeScreen.dart';
import 'package:http/http.dart' as http;

class SupportForm extends StatefulWidget {
  final String? usertype;
  final String? cutomerid;

  const SupportForm({Key? key, this.usertype, this.cutomerid}) : super(key: key);

  @override
  State<SupportForm> createState() => _SupportFormState();
}

class _SupportFormState extends State<SupportForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  String? selectedIssueType;

  List<String> issueTypes = ['Select turf issue', 'Application issue', 'Other'];

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

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
                    "Support and Help",
                    style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Name',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: numberController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a mobile number';
                          }
                          if (value.length != 10) {
                            return 'Mobile number must be 10 digits';
                          }
                          return null; // Return null if the validation is successful
                        },
                        decoration: InputDecoration(
                          hintText: 'Number',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                        value: selectedIssueType,
                        items: issueTypes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            selectedIssueType = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty || value == 'Select turf issue') {
                            return 'Please select an issue type';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Issue Type',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: noteController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Note',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          submitForm();
                        }
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
                            "Submit",
                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void submitForm() async {
    String name = nameController.text;
    String number = numberController.text;
    String email = emailController.text;
    String? issueType = selectedIssueType;
    String note = noteController.text;

    if (issueType == null || issueType.isEmpty || issueType == 'Select turf issue') {
      Fluttertoast.showToast(msg: 'Please select a valid issue type');
      return;
    }

    var headers = {
      'Cookie': 'ci_session=57nmmrmv7102l0gfqal2134fgktni489'
    };
    var request = http.MultipartRequest('POST', Uri.parse('https://taruff.shortlinker.in/api/create_support'));
    request.fields.addAll({
      'user_vendor_id': '5591',
      'name': name,
      'number': number,
      'email': email,
      'type': issueType,
      'turf_id': '',
      'message': note
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("====>>>sucess");
      print(await response.stream.bytesToString());
      print("====>>>praachi");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            cutomerid: widget.cutomerid.toString(),
            usertype: widget.usertype,
          ),
        ),
      );
    } else {
      print(response.reasonPhrase);
      Fluttertoast.showToast(msg: 'Failed to submit support request');
    }
  }
}
*/







import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turfapp/MyModel/BookingModel.dart';
import 'package:turfapp/MyModel/Profile/cus_getProfile_model.dart';
import 'package:turfapp/MyModel/user_suportModel.dart';
import 'package:turfapp/MyNetwork/BookingHistoryApi/customerBooking.dart';
import 'package:turfapp/MyNetwork/Profile/cus_profile.dart';
import 'package:turfapp/MyNetwork/Suport/user_suportApi.dart';
import 'package:turfapp/Screen/HomeScreen.dart';
import 'package:http/http.dart' as http;
import 'package:turfapp/Screen/cus/get_suportdata.dart';

import '../../MyConstants/ShPrefConstants.dart';

class SupportForm extends StatefulWidget {
  final String usertype;
  final String cutomerid;

  const SupportForm({Key? key, required this.usertype, required this.cutomerid}) : super(key: key);

  @override
  State<SupportForm> createState() => _SupportFormState();
}

class _SupportFormState extends State<SupportForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  String? selectedIssueType;

  // String? selectedTurfId;
  bool showOtherField = false;
  String? otherValue;
  List<String> issueTypes = ['Select turf issue', 'Application issue', 'Other'];
  String? selectedTurfId;

  /* List<Map<String, dynamic>> turfList = [];
  @override
  void initState() {
    super.initState();
    fetchTurfList(); // Fetch list of turfs from API
  }

  Future<void> fetchTurfList() async {
    var headers = {
      'Cookie': 'ci_session=1444hm725l9r5jiumps0u2movc5hooem'
    };
    var request = http.MultipartRequest('POST', Uri.parse('https://taruff.shortlinker.in/api/booking_list_by_customer_id'));
    request.fields.addAll({'customer_id': '5700'});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseData = jsonDecode(responseBody);
      if (responseData['status'] == 1) {
        List<dynamic> bookingList = responseData['booking'];
        setState(() {
          turfList = bookingList.map<Map<String, dynamic>>((booking) {
            return {
              // 'id': booking['turf_id'],
              'name': booking['turf_name']
            };
          }).toList();
        });
      }
    } else {
      print(response.reasonPhrase);
    }
  }
*/

  List<Booking> listBooking = [];
  late SharedPreferences prefs;
  String user_type = "";
  String contactNo = "";

  @override
  void initState() {
    super.initState();
    initalize();
    loaddata();
    _fetchProfileData();

  }

  initalize() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      user_type = prefs.getString(sp_usertype).toString();
      contactNo = prefs.getString(sp_contact).toString();

      user_type = widget.usertype.toString();
      print("number history ===>>${contactNo}");
      print("##>>>>>>sup>" + user_type);
      numberController.text = contactNo;


      //admin/vendor/user

    });

  }

  void _fetchProfileData() async {
    try {
      UserProfile userProfile = await fetchUserProfile(widget.cutomerid);
      setState(() {
        _userProfile = userProfile;
        nameController.text = _userProfile.name;
        // mobileCtr.text = _userProfile.phone;
      });
    } catch (error) {
      print('Error fetching profile data: $error');
    }
  }

  loaddata() {
    setState(() {
      listBooking.clear();
    });
    getCustomerBooking(context, widget.cutomerid.toString(),"").then((value) {
      final responseData = jsonDecode(value);
      final message = responseData['message'];
      final status = responseData['status'];

      print("getCustomerBooking Response >>>>> " + status.toString());
      print("getCustomerBooking value >>>>> " + value.toString());

      if (status == 1) {
        TurfBookingModel model = turfBookingModelFromJson(value);
        print("getAllListApi body >>>>> " + model.booking.length.toString());
        print("listBooking${listBooking}");

        // Use removeDuplicates function to remove duplicate items
        setState(() {
          listBooking = removeDuplicates(model.booking);
          print("listBooking${listBooking}");

        });
      }
    });


  }


  List<Booking> removeDuplicates(List<Booking> list) {
    List<Booking> uniqueList = [];
    Set<String> ids = Set(); // Unique ids set
    for (Booking turf in list) {
      if (!ids.contains(turf.turfName)) { // Check if id is already present in the set
        uniqueList.add(turf);
        ids.add(turf.turfName); // Add id to set
      }
    }
    return uniqueList;
  }

  late UserProfile _userProfile = UserProfile(name: '', image: '', phone: '', otp: '');



  @override
  Widget build(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        title:  const Text(
          "Support and Help",
          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: nameController,
                        readOnly: true,
                        style: const TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Name',
                          hintStyle: TextStyle(color: Colors.grey,fontSize: 16,fontWeight: FontWeight.w500),
                          border: OutlineInputBorder(borderRadius: BorderRadius
                              .circular(5)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10,
                              vertical: 5),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: numberController,
                        readOnly: true,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a mobile number';
                          }
                          if (value.length != 10) {
                            return 'Mobile number must be 10 digits';
                          }
                          return null; // Return null if the validation is successful
                        },
                        decoration: InputDecoration(
                          hintText: 'Number',
                          hintStyle: TextStyle(color: Colors.grey,fontSize: 16,fontWeight: FontWeight.w500),
                          border: OutlineInputBorder(borderRadius: BorderRadius
                              .circular(5)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10,
                              vertical: 5),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.grey,fontSize: 16,fontWeight: FontWeight.w500),
                          border: OutlineInputBorder(borderRadius: BorderRadius
                              .circular(5)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10,
                              vertical: 5),
                        ),
                      ),
                    ),


                    //new


                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                        value: selectedTurfId,
                        items: [
                          ...listBooking.map<DropdownMenuItem<String>>((turf) {
                            return DropdownMenuItem<String>(
                            /*  value: turf.turfName, // Turf  name set
                              child: Text(turf.turfName),*/
                              value: turf.id.toString(),
                              child: Text(turf.turfName),
                            );
                          }).toList(),
                          DropdownMenuItem<String>(
                            value: 'other',
                            child: Text('Other',style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),),
                          ),
                        ],
                         onChanged: (String? value) {
                          print('Selected value from dropdown: $value'); // Debug statement
                          setState(() {
                            if (value == 'other') {
                              // If 'other' is selected, clear selectedTurfId and showOtherField
                              selectedTurfId = null;
                              showOtherField = true;
                            } else {
                              // Otherwise, update selectedTurfId and hide showOtherField
                              selectedTurfId = value;
                              showOtherField = false;
                            }
                          });
                        },

/*
                        onChanged: (String? value) {
                          print('Selected value from dropdown: $value'); // Debug statement
                          setState(() {
                            if (value == 'other') {
                              selectedTurfId = null;
                              showOtherField = true;
                            } else {
                              // Turf name se uska corresponding ID fetch karein
                              selectedTurfId = listBooking.firstWhere((turf) => turf.turfName == value).id.toString();
                              showOtherField = false;
                            }
                          });
                        },
*/


                        decoration: InputDecoration(
                          hintText: 'Select turf',
                          hintStyle: TextStyle(color: Colors.grey,fontSize: 16,fontWeight: FontWeight.w500),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: noteController,
                        style: const TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Note',
                          hintStyle: TextStyle(color: Colors.grey,fontSize: 16,fontWeight: FontWeight.w500),
                          border: OutlineInputBorder(borderRadius: BorderRadius
                              .circular(5)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10,
                              vertical: 5),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          submitForm();
                        }
                      },
                      child: Container(
                        width: width,
                        padding: EdgeInsets.symmetric(
                            horizontal: 25, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Center(
                          child: Text(
                            "Submit",
                            style: TextStyle(fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }






  void submitForm() async {
    String name = nameController.text;
    String number = numberController.text;
    String email = emailController.text;
    String issueType =  selectedIssueType ?? ''; // Handling nullability
    String note = noteController.text;
    print("name : $name");
    print("number : $number");
    print("note : $note");
    print('Selected Issue Type: $selectedIssueType');
    print('Issue Type: $issueType');
    var response = await APIService.createSupportRequest(
      userVendorId: widget.cutomerid.toString(),
      name: name,
      number: number,
      email: email,
      type: "other",
      turfId: '',
      message: note,
    );
    if (response['status'] == 1) {
      // Success
      Fluttertoast.showToast(msg: response['message']);
      print("mssgasge : ${response['status'] }");
      // Navigate to HomeScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GetSuportMsg(
            cutomerid: widget.cutomerid.toString(),
            usertype: widget.usertype,
          ),
        ),
      );
    } else {
      // Failure
      Fluttertoast.showToast(msg: response['message']);
      print("Failure");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GetSuportMsg(
            cutomerid: widget.cutomerid.toString(),
            usertype: widget.usertype,
          ),
        ),
      );

    }
  }


}




