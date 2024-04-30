import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turfapp/MyConstants/ShPrefConstants.dart';
import 'package:turfapp/MyModel/Profile/cus_getProfile_model.dart';
import 'package:turfapp/MyNetwork/Suport/user_suportApi.dart';
import 'package:turfapp/Screen/HomeScreen.dart';
import 'package:turfapp/Screen/cus/get_suportdata.dart';

import '../../MyNetwork/Profile/cus_profile.dart';

class VendoreSuportForm extends StatefulWidget {
  final String? usertype;
  final String cutomerid;

  const VendoreSuportForm({Key? key, this.usertype, required this.cutomerid})
      : super(key: key);

  @override
  State<VendoreSuportForm> createState() => _VendoreSuportFormState();
}

class _VendoreSuportFormState extends State<VendoreSuportForm> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _issueDescriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late SharedPreferences prefs;
  String user_type = "";
  String contactNo = "";
  String name = "";
  String number = "";
  String msg = "";
  @override
  void initState() {
    super.initState();
    initalize();
    _fetchProfileData();

  }

  initalize() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      user_type = prefs.getString(sp_usertype).toString();
      contactNo = prefs.getString(sp_contact).toString();
      name = prefs.getString(sp_supName).toString();
      // number = prefs.getString(sp_supNumber).toString();
      // msg = prefs.getString(sp_supMsg).toString();

      user_type = widget.usertype.toString();
      print("number history ===>>${contactNo}");
      print("##>>>>>>>" + user_type);



      // _nameController.text = name;
      _numberController.text = contactNo;
      // _issueDescriptionController.text = msg;
      //admin/vendor/user
    });
  }
  late UserProfile _userProfile = UserProfile(name: '', image: '', phone: '', otp: '');


  void _fetchProfileData() async {
    try {
      UserProfile userProfile = await fetchUserProfile(widget.cutomerid);
      setState(() {
        _userProfile = userProfile;
        _nameController.text = _userProfile.name;
        // mobileCtr.text = _userProfile.phone;
      });
    } catch (error) {
      print('Error fetching profile data: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
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
                        readOnly: true,
                        controller: _nameController,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Name',
                          hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),


                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _numberController,
                        readOnly: true,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
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
                          hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _issueDescriptionController,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please describe the issue';
                          }
                          // You can add more validation logic for the description if needed
                          return null;
                        },
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Application Issue & Other',
                          hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),

                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          vendorsubmitForm();
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
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
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


  //
  void vendorsubmitForm() async {
    String name = _nameController.text;
    String number = _numberController.text;
    String issue = _issueDescriptionController.text;
    String issueType = "other"; // Handling nullability
    print("name : $name");
    print("number : $number");
    print("note : $issue");
    // print('Selected Issue Type: $selectedIssueType');
    print('Issue Type: $issueType');

    var response = await APIService.createSupportRequest(
      userVendorId: widget.cutomerid,
      name: name,
      number: number,
      email:  " ",
      type: issueType,
      turfId: '',
      message: issue,
    );

    if (response['status'] == 1) {
      // Success
      Fluttertoast.showToast(msg: response['message']);
      // Navigate to HomeScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GetSuportMsg(
            cutomerid: widget.cutomerid,
            usertype: user_type,
          ),
        ),
      );
    } else {
      // String name = "";
      // {
      //   prefs.setString(sp_supName, _nameController.text);
      //   prefs.setString(sp_supNumber, _numberController.text);
      //   prefs.setString(sp_supMsg,_issueDescriptionController.text );
      // }
      // Failure
      Fluttertoast.showToast(msg: response['message']);
    }
  }


}
