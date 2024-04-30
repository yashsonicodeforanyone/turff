import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turfapp/MyConstants/ShPrefConstants.dart';
import 'package:turfapp/MyConstants/ShWidgetConsts.dart';
import 'package:turfapp/MyNetwork/AddressPlaceApi/AddressGeoCoderModel.dart';
import 'package:turfapp/MyNetwork/AddressPlaceApi/getAddressGeocoderApi.dart';
import 'package:turfapp/MyNetwork/AddturfAppi.dart';
import 'package:turfapp/Screen/AddressSelectScreen.dart';
import 'package:turfapp/Screen/HomeScreen.dart';
import 'package:turfapp/Screen/VendorSide/HomePage.dart';
import 'dart:io';


class AddTurftoHomeScreen extends StatefulWidget {
  String user_id;
  String usertype;
  String? contactno;
  AddTurftoHomeScreen(
      {super.key, required this.user_id, required this.usertype, this.contactno});

  @override
  State<AddTurftoHomeScreen> createState() => _AddTurftoHomeScreenState();
}

class _AddTurftoHomeScreenState extends State<AddTurftoHomeScreen> {
  int selectedIndex = 0;
  //new
  // Set<int> selectedIndexes = {};
  Set<String> selectSportTypes = {};

/*
  void handleTap(String sportType) {
    setState(() {
      if (selectSportTypes.contains(sportType)) {
        selectSportTypes.remove(sportType); // If already selected, unselect it
      } else {
        selectSportTypes.add(sportType); // If not selected, select it
      }
    });
  }
*/
  //food
  // Set<String> selectFacilities = {};


  //get  prefs

  late SharedPreferences prefs;
  String user_type = "";
  String contactNo = "";

  @override
  void initState() {
    super.initState();
    initalize();
    // loaddata();

  }

  initalize() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      user_type = prefs.getString(sp_usertype).toString();
      contactNo = prefs.getString(sp_contact).toString();

      // user_type = widget.usertype.toString();
      print("number history add turf page===>>${contactNo}");
      print("##>>>>>>>" + user_type);

      contactnameController .text = contactNo;
      //admin/vendor/user
    });
  }

  //facilities
  void handleTapFacilities(String facility) {
    setState(() {
      if (selectFacilities.contains(facility)) {
        selectFacilities.remove(facility); // If already selected, unselect it
      } else {
        selectFacilities.add(facility); // If not selected, select it
      }
    });
  }


  void handleTap(String sportType) {
    /* setState(() {
      selectedIndex = sportType == "baseball" ? 1 : 2;
      *//*   selectedIndex = 2;
                                          selectSportType = "cricket";*//*
    });*/

    setState(() {
      if (selectSportType.contains(sportType)) {
        selectSportType.remove(sportType); // If already selected, unselect it
      } else {
        selectSportType.add(sportType); // If not selected, select it
      }
    });
  }


/*
  void handleTap(String sportType) {
    setState(() {
      selectedIndex = sportType == "baseball" ? 1 : 2;
      */
/*   selectedIndex = 2;
                                          selectSportType = "cricket";*//*

    });
  }
*/

/*
  void handleTapFacilities(String facility) {
    setState(() {
      if (selectFacilities.contains(facility)) {
        selectFacilities.remove(facility);
      } else {
        selectFacilities.add(facility);
      }
    });
  }
*/

  void _validateAndProceed() {
    if (slectedStep == 2) {
      if (selectSportType.isEmpty) {
        _showErrorDialog("Please select a sport type.");
        return;
      }
    } else if (slectedStep == 3) {
      if (selectFacilities.isEmpty) {
        _showErrorDialog("Please select at least one facility.");
        return;
      }
    }

    // Proceed to next step or do something else
    setState(() {
      slectedStep++;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }



  int slectedStep = 1;
  List<String> selectSportType = [];
  List<String> selectFacilities = [];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  TextEditingController turfnameController = TextEditingController();
  TextEditingController contactnameController = TextEditingController();
  TextEditingController addressControlller = TextEditingController();
  TextEditingController squareFiltController = TextEditingController();
  TextEditingController AboutUsController = TextEditingController();
  TextEditingController PrivacyController = TextEditingController();
  TextEditingController PerHoursPriceController = TextEditingController();

  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  String lat = "";
  String long = "";

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    print("Image List Length:" + imageFileList!.length.toString());
    setState(() {});
  }




  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.green,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: width,
                padding: EdgeInsets.only(top: 30, left: 15, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.arrow_back_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                    verticalmargin20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Fill Details Of Turf",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),

                      ],
                    )
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.all(15.0),
                height: height * 0.8,
                width: width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.0)),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Step " + slectedStep.toString(),
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),

                        verticalmargin10,
                        slectedStep == 1
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 5,
                              width: width * 0.2,
                              color: Colors.green,
                            ),
                            Container(
                              height: 5,
                              width: width * 0.7,
                              color: Colors.black12,
                            )
                          ],
                        )
                            : Container(),
                        slectedStep == 2

                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 5,
                              width: width * 0.4,
                              color: Colors.green,
                            ),
                            Container(
                              height: 5,
                              width: width * 0.5,
                              color: Colors.black12,
                            )
                          ],
                        )
                            : Container(),
                        slectedStep == 3
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 5,
                              width: width * 0.7,
                              color: Colors.green,
                            ),
                            Container(
                              height: 5,
                              width: width * 0.2,
                              color: Colors.black12,
                            )
                          ],
                        )
                            : Container(),
                        slectedStep == 4
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 5,
                              width: width * 0.7,
                              color: Colors.green,
                            ),
                            Container(
                              height: 5,
                              width: width * 0.2,
                              color: Colors.green,
                            )
                          ],
                        )
                            : Container(),
                        verticalmargin20,
                        Visibility(
                          visible: slectedStep == 1 ? true : false,
                          child: Container(
                            height: height*0.55,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    // height : 200,
                                      margin: EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        "Turf Name",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      )),
                                  TextFormField(
                                    controller: turfnameController,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                    decoration: InputDecoration(
                                      hintText: 'Turf Name',
                                      prefixIcon: Container(
                                        padding: EdgeInsets.all(12),
                                        height:
                                        10.0, // Adjust the height as needed
                                        width: 10.0, // Adjust the width as needed
                                        child: Icon(Icons.grass),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      hintStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 05),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter Turf Name ';
                                      }
                                      return null;
                                    },
                                  ),
                                  verticalmargin10,
                                  Container(
                                      margin: EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        "Contact No.",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      )),
                                  TextFormField(
                                    controller: contactnameController,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                    readOnly: true,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter Contact number';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Turf Contact No',
                                      prefixIcon: Icon(Icons.phone),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      hintStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 05),
                                    ),
                                  ),
                                  verticalmargin10,
                                  Container(
                                      margin: EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        "Address",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      )),
                                  TextFormField(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyAddressScreen()))
                                          .then((value) {
                                        Prediction prediction =
                                        value as Prediction;
                                        addressControlller.text =
                                        prediction.description!;
                                        // String latitude = prediction.lat.toString();
                                        // String longitude = prediction.lng.toString();

                                        getAddressGeoCorder(
                                            context, prediction.placeId!)
                                            .then((value) => {
                                          if (value != "")
                                            {
                                              lat =
                                                  addressGeoCoderFromJson(
                                                      value)
                                                      .result
                                                      .geometry
                                                      .location
                                                      .lat
                                                      .toString(),
                                              long =
                                                  addressGeoCoderFromJson(
                                                      value)
                                                      .result
                                                      .geometry
                                                      .location
                                                      .lng
                                                      .toString(),
                                              print(
                                                  "Latitude >>>>>>>>. " +
                                                      lat),
                                              print(
                                                  "Latitude >>>>>>>>. " +
                                                      long),
                                            }
                                        });
                                      });
                                    },
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                    readOnly: true,
                                    controller: addressControlller,
                                    decoration: InputDecoration(
                                      hintText: 'Turf Address',
                                      prefixIcon:
                                      Icon(Icons.location_on_outlined),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      hintStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 05),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter location';
                                      }
                                      return null;
                                    },
                                  ),
                                  verticalmargin10,
                                  Container(
                                      margin: EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        "Square Fit",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      )),
                                  TextFormField(
                                    controller: squareFiltController,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter Square Fit';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Square Fit',
                                      prefixIcon:
                                      Icon(Icons.location_on_outlined),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      hintStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 05),
                                    ),
                                  ),


                                  //about
                                  Container(
                                      margin: EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        "About Us",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      )),
                                  TextFormField(
                                    controller: AboutUsController,
                                    maxLines: 6,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                    decoration: InputDecoration(
                                      hintText: 'About Us',
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(1.0), // Adjust padding as needed
                                        child: Icon(Icons.grass),
                                      ),
                                      prefixIconConstraints: BoxConstraints(
                                        minWidth: 40, // Adjust the icon width as needed
                                        minHeight: 40, // Adjust the icon height as needed
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      hintStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 05),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter about us ';
                                      }
                                      return null;
                                    },
                                  ),
                                  verticalmargin10,

                                  Container(
                                      margin: EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        "Cancellation Policy",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      )),
                                  TextFormField(
                                    controller: PrivacyController,
                                    maxLines: 6,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                    decoration: InputDecoration(
                                      hintText: 'Cancellation Policy',
                                      prefixIcon: Container(
                                        padding: EdgeInsets.all(12),
                                        height:
                                        10.0, // Adjust the height as needed
                                        width: 10.0, // Adjust the width as needed
                                        child: Icon(Icons.privacy_tip_outlined),
                                      ),
                                      prefixIconConstraints: BoxConstraints(
                                        minWidth: 40, // Adjust the icon width as needed
                                        minHeight: 40, // Adjust the icon height as needed
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      hintStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 05),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter cancellation_policy ';
                                      }
                                      return null;
                                    },
                                  ),
                                  // verticalmargin20,
                                  verticalmargin10,

                                 /* Container(
                                      margin: EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        "Per Hour_Amount",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      )),
                                  TextFormField(
                                    controller: PerHoursPriceController,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                    decoration: InputDecoration(
                                      hintText: 'Per Hour Amount',
                                      prefixIcon: Container(
                                        padding: EdgeInsets.all(12),
                                        height:
                                        10.0, // Adjust the height as needed
                                        width: 10.0, // Adjust the width as needed
                                        child: Icon(Icons.price_change_outlined),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      hintStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 05),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter per hour amount';
                                      }
                                      return null;
                                    },
                                  ),*/
                                ],
                              ),
                            ),
                          ),
                        ),

                        //new
                        Visibility(
                          visible: slectedStep == 2 ? true : false,
                          child: Container(
                            height: height * 0.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    "Select Sport Type",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 20),
                                  ),
                                ),
                                verticalmargin20,

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        handleTap("baseball"); // Toggle selection for "Base Ball"
                                      },
                                      child: Container(
                                        width: width * 0.4,
                                        height: width * 0.4,
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(),
                                                Icon(
                                                  selectSportType.contains("baseball")
                                                      ? Icons.check_circle
                                                      : Icons.circle_outlined,
                                                  color: selectSportType.contains("baseball")
                                                      ? Colors.green
                                                      : Colors.black12,
                                                )
                                              ],
                                            ),
                                            Icon(
                                              Icons.sports_baseball,
                                              size: 50,
                                              color: selectSportType.contains("baseball")
                                                  ? Colors.green
                                                  : Colors.black12,
                                            ),
                                            Text(
                                              "Base Ball",
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: selectSportType.contains("baseball")
                                                    ? Colors.green
                                                    : Colors.black12,
                                              ),
                                            )
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          border: Border.all(
                                            color: Colors.black12,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        handleTap("cricket"); // Toggle selection for "Cricket"
                                      },
                                      child: Container(
                                        width: width * 0.4,
                                        height: width * 0.4,
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(),
                                                Icon(
                                                  selectSportType.contains("cricket")
                                                      ? Icons.check_circle
                                                      : Icons.circle_outlined,
                                                  color: selectSportType.contains("cricket")
                                                      ? Colors.green
                                                      : Colors.black12,
                                                )
                                              ],
                                            ),
                                            Icon(
                                              Icons.sports_cricket,
                                              size: 50,
                                              color: selectSportType.contains("cricket")
                                                  ? Colors.green
                                                  : Colors.black12,
                                            ),
                                            Text(
                                              "Cricket",
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: selectSportType.contains("cricket")
                                                    ? Colors.green
                                                    : Colors.black12,
                                              ),
                                            )
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          border: Border.all(
                                            color: Colors.black12,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: slectedStep == 3 ? true : false,
                          child: Container(
                            height: height * 0.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    "Select Facilities",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 20),
                                  ),
                                ),
                                verticalmargin20,
                                /*Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedIndex = 1;
                                          selectFacilities.add("shelter");
                                        });
                                      },
                                      child: Container(
                                        width: width * 0.4,
                                        height: width * 0.4,
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(),
                                                Icon(
                                                  selectedIndex == 1
                                                      ? Icons.check_circle
                                                      : Icons.circle_outlined,
                                                  color: selectedIndex == 1
                                                      ? Colors.green
                                                      : Colors.black12,
                                                )
                                              ],
                                            ),
                                            Icon(Icons.night_shelter_rounded,
                                                size: 50,
                                                color: selectedIndex == 1
                                                    ? Colors.green
                                                    : Colors.black12),
                                            Text(
                                              "Shelter",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: selectedIndex == 1
                                                      ? Colors.green
                                                      : Colors.black12),
                                            )
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            border: Border.all(
                                                color: Colors.black12, width: 1)),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedIndex = 2;
                                          selectFacilities.add("food");
                                        });
                                      },
                                      child: Container(
                                        width: width * 0.4,
                                        height: width * 0.4,
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(),
                                                Icon(
                                                  selectedIndex == 2
                                                      ? Icons.check_circle
                                                      : Icons.circle_outlined,
                                                  color: selectedIndex == 2
                                                      ? Colors.green
                                                      : Colors.black12,
                                                )
                                              ],
                                            ),
                                            Icon(Icons.fastfood,
                                                size: 50,
                                                color: selectedIndex == 2
                                                    ? Colors.green
                                                    : Colors.black12),
                                            Text(
                                              "Food",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: selectedIndex == 2
                                                      ? Colors.green
                                                      : Colors.black12),
                                            )
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            border: Border.all(
                                                color: Colors.black12, width: 1)),
                                      ),
                                    ),
                                  ],
                                ),*/

                                //new

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        handleTapFacilities("shelter");
                                        // selectFacilities.add("shelter");

                                      },
                                      child: Container(
                                        width: width * 0.4,
                                        height: width * 0.4,
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(),
                                                Icon(
                                                  selectFacilities.contains("shelter")
                                                      ? Icons.check_circle
                                                      : Icons.circle_outlined,
                                                  color: selectFacilities.contains("shelter")
                                                      ? Colors.green
                                                      : Colors.black12,
                                                )
                                              ],
                                            ),
                                            Icon(
                                              Icons.night_shelter_rounded,
                                              size: 50,
                                              color: selectFacilities.contains("shelter")
                                                  ? Colors.green
                                                  : Colors.black12,
                                            ),
                                            Text(
                                              "Shelter",
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: selectFacilities.contains("shelter")
                                                    ? Colors.green
                                                    : Colors.black12,
                                              ),
                                            )
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          border: Border.all(color: Colors.black12, width: 1),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        handleTapFacilities("food");
                                        // selectFacilities.add("food");
                                      },
                                      child: Container(
                                        width: width * 0.4,
                                        height: width * 0.4,
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(),
                                                Icon(
                                                  selectFacilities.contains("food")
                                                      ? Icons.check_circle
                                                      : Icons.circle_outlined,
                                                  color: selectFacilities.contains("food")
                                                      ? Colors.green
                                                      : Colors.black12,
                                                )
                                              ],
                                            ),
                                            Icon(
                                              Icons.fastfood,
                                              size: 50,
                                              color: selectFacilities.contains("food")
                                                  ? Colors.green
                                                  : Colors.black12,
                                            ),
                                            Text(
                                              "Food",
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: selectFacilities.contains("food")
                                                    ? Colors.green
                                                    : Colors.black12,
                                              ),
                                            )
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          border: Border.all(color: Colors.black12, width: 1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: slectedStep == 4 ? true : false,
                          child: Container(
                            height: height * 0.5,
                            child: GridView.builder(
                                itemCount: (imageFileList!.length +
                                    1), //listsearchProducts2.length,
                                //prodcutsColorList
                                shrinkWrap: true,
                                padding: EdgeInsets.all(0.0),
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  childAspectRatio:
                                  (MediaQuery.of(context).size.width) / (350),
                                  mainAxisSpacing: 10,
                                ),
                                itemBuilder: (_, index) {
                                  return index == 0
                                      ? Container(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedIndex = 1;
                                                  selectImages();
                                                });
                                              },
                                              child: Container(
                                                width: width * 0.4,
                                                height: width * 0.4,
                                                padding: EdgeInsets.all(10.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Container(),
                                                        //  Icon(selectedIndex==1?Icons.check_circle:Icons.circle_outlined,color:selectedIndex==1?Colors.green: Colors.black12,)
                                                      ],
                                                    ),
                                                    Icon(Icons.add,
                                                        size: 50,
                                                        color:
                                                        selectedIndex == 1
                                                            ? Colors.green
                                                            : Colors
                                                            .black12),
                                                    Text(
                                                      "Add Image",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: selectedIndex ==
                                                              1
                                                              ? Colors.green
                                                              : Colors
                                                              .black12),
                                                    )
                                                  ],
                                                ),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10.0),
                                                    border: Border.all(
                                                        color: Colors.black12,
                                                        width: 1)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                      : ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Image.file(
                                      File(imageFileList![index - 1].path),
                                      width: 200.0,
                                      height: 120,
                                      fit: BoxFit.fill,
                                    ),
                                  );
                                }),
                          ),
                        ),
                        verticalmargin20,
                        verticalmargin20,
                        /*  slectedStep == 1
                            ? InkWell(
                                onTap: () {
                                  setState(() {
                                    slectedStep++;
                                  });
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
                                      "Next",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )
                            : slectedStep == 4
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            slectedStep--;
                                          });
                                        },
                                        child: Container(
                                          width: width * 0.4,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Center(
                                            child: Text(
                                              "Previos",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            if (selectedIndex == 4) {
                              addTurfApi(
                                  imageFileList!,
                                  turfnameController.text,
                                  widget.user_id,
                                  contactnameController.text,
                                  addressControlller.text,
                                  squareFiltController.text,
                                  selectSportType,
                                  lat,
                                  long,
                                  selectFacilities,
                                  widget.usertype.toString(),
                                  context);
                            }
                          }
                                        },
                                        child: Container(
                                          width: width * 0.4,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Center(
                                            child: Text(
                                              "Continue",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            slectedStep--;
                                          });
                                        },
                                        child: Container(
                                          width: width * 0.4,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Center(
                                            child: Text(
                                              "Previos",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            slectedStep++;
                                          });
                                        },
                                        child: Container(
                                          width: width * 0.4,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Center(
                                            child: Text(
                                              "Next",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),*/

                        slectedStep == 1
                            ? InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                slectedStep++;
                              });
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
                                "Next",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                            : slectedStep == 4
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  slectedStep--;
                                });
                              },
                              child: Container(
                                width: width * 0.4,
                                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Center(
                                  child: Text(
                                    "Previous",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  if (imageFileList == null || imageFileList!.isEmpty) {
                                    _showErrorDialog("Please add at least one image.");
                                    return;
                                  }
                                  addTurfApi(
                                    imageFileList!,
                                    turfnameController.text,
                                    widget.user_id,
                                    contactnameController.text,
                                    addressControlller.text,
                                    squareFiltController.text,
                                    AboutUsController.text,
                                    PrivacyController.text,
                                    PerHoursPriceController.text,
                                    selectSportType,
                                    // selectSportType,
                                    lat,
                                    long,
                                    selectFacilities,
                                    widget.usertype.toString(),
                                    context,
                                  );
                                }
                              },
                              child: Container(
                                width: width * 0.4,
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
                            )
                          ],
                        )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {

                                setState(() {
                                  slectedStep--;
                                });
                              },
                              child: Container(
                                width: width * 0.4,
                                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Center(
                                  child: Text(
                                    "Previous",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: _validateAndProceed,
                              child: Container(
                                width: width * 0.4,
                                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Center(
                                  child: Text(
                                    "Next",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


}
//7555223333 user
