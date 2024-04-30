import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turfapp/MyConstants/ShPrefConstants.dart';
import 'package:turfapp/MyConstants/ShWidgetConsts.dart';
import 'package:turfapp/MyModel/Turf_detials/turf_detials.dart';
import 'package:turfapp/MyNetwork/AddressPlaceApi/AddressGeoCoderModel.dart';
import 'package:turfapp/MyNetwork/AddressPlaceApi/getAddressGeocoderApi.dart';
import 'package:turfapp/MyNetwork/Vendor/delete_turfimageApi.dart';
import 'package:turfapp/MyNetwork/Vendor/editturfApi.dart';
import 'package:turfapp/MyNetwork/turf_detialsApi.dart';
import 'package:turfapp/Screen/AddressSelectScreen.dart';
import 'package:turfapp/Screen/HomeScreen.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class EditTurfScreen extends StatefulWidget {
  final String lat;
  final String long;
  final String id;
  final String name;
  final String contactNo;
  final String address;
  final String squareFit;
  final String sportType;
  final String user_id;
  // final String facilities ;
  // final String images;
  final List<String> facilities; // Updated to List<String>
  final List<XFile> images;
  const EditTurfScreen(
      {super.key,
      required this.id,
      required this.name,
      required this.contactNo,
      required this.address,
      required this.squareFit,
      required this.sportType,
      required this.facilities,
      required this.images,
      required this.user_id, required this.lat, required this.long});

  @override
  State<EditTurfScreen> createState() => _EditTurfScreenState();
}

class _EditTurfScreenState extends State<EditTurfScreen> {
  int selectedIndex = 0;
  //new
  // Set<int> selectedIndexes = {};
  Set<String> selectSportTypes = {};

  late SharedPreferences prefs;
  String user_type = "";
  String contactNo = "";

  @override
  void initState() {
    super.initState();
    // selectSportType = widget.sportType; // Initialize with initial value
    // selectedIndex = widget.sportType == "baseball" ? 1 : 2; // Initialize index
    // imageFileList = List.from(widget.images);
    initalize();
    // loaddata();
    fetchData(); // Fetch data when the screen loads
  }

  List<TurfDetials> turfList = [];

  // Function to fetch data including images
  void fetchData() async {
    try {
      ApiService apiService = ApiService();

      List<TurfDetials> fetchedData = await apiService.getTaruffList(widget.id);
      setState(() async {
        turfList = fetchedData;
        TurfDetials turf = turfList.first;
        turfnameController.text = turf.turfName;
        contactnameController.text = contactNo;
        addressControlller.text = turf.address;
        squareFiltController.text = turf.squarefit;
        selectSportType = turf.sportType;
        selectFacilities = turf.facilities;
        AboutUsController.text = turf.aboutUs;
        PrivacyController.text = turf.cancellationPolicy;
        PerHoursPriceController.text = turf.perHourAmount;

        // Convert URLs to XFile and update imageFileList
        List<XFile> xFileList = [];
        for (var imageUrl in turf.images) {
          XFile xFile = await urlToXFile(imageUrl);
          xFileList.add(xFile);
        }
        imageFileList = xFileList;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

// Function to convert URL to XFile
  Future<XFile> urlToXFile(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      final documentDirectory = await getApplicationDocumentsDirectory();
      final file = File(
          '${documentDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(response.bodyBytes);
      return XFile(file.path);
    } catch (e) {
      print("Error converting URL to XFile: $e");
      throw Exception("Error converting URL to XFile");
    }
  }

  initalize() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      user_type = prefs.getString(sp_usertype).toString();
      contactNo = prefs.getString(sp_contact).toString();

      // user_type = widget.usertype.toString();
      print("number history add turf page===>>${contactNo}");
      print("##>>>>>>>" + user_type);

      // imageFileList! = widget.images;

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

  // This function is called when a sport type is selected
  void handleTap(String sportType) {

    setState(() {
      if (selectSportType.contains(sportType)) {
        selectSportType.remove(sportType); // If already selected, unselect it
      } else {
        selectSportType.add(sportType); // If not selected, select it
      }
    });
  }



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
  // List<String> selectedIndex = [];
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

  // image delete
  void deleteImageFromList(int index) {
    setState(() {
      imageFileList!.removeAt(index);
    });
  }

  void handleDeleteImage(String imageUrl) {
    deleteImage(imageUrl).then((_) {
      setState(() {
        imageFileList!.removeWhere((element) => element.path == imageUrl);
      });
    });
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
                  padding: EdgeInsets.only(top: 80, left: 15, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Edit Turf Details",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  )),
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
                              fontSize: 22,
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
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
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
                                    hintStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                    prefixIcon: Container(
                                      padding: EdgeInsets.all(12),
                                      height:
                                          10.0, // Adjust the height as needed
                                      width: 10.0, // Adjust the width as needed
                                      child: Icon(Icons.grass),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 05),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
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
                                    hintStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 05),
                                    prefixIcon: Icon(Icons.phone),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
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
                                                  }
                                              });
                                    });
                                  },
                                  readOnly: true,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                  controller: addressControlller,
                                  decoration: InputDecoration(
                                    hintText: 'Turf Address',
                                    prefixIcon:
                                        const Icon(Icons.location_on_outlined),
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
                                    child: const Text(
                                      "Square Fit",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    )),
                                TextFormField(
                                  controller: squareFiltController,
                                  keyboardType: TextInputType.number,
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
                                        const Icon(Icons.location_on_outlined),
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

                              /*  Container(
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

                        // new  one

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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
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
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                                verticalmargin20,


                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(),
                                                Icon(
                                                  selectFacilities
                                                          .contains("shelter")
                                                      ? Icons.check_circle
                                                      : Icons.circle_outlined,
                                                  color: selectFacilities
                                                          .contains("shelter")
                                                      ? Colors.green
                                                      : Colors.black12,
                                                )
                                              ],
                                            ),
                                            Icon(
                                              Icons.night_shelter_rounded,
                                              size: 50,
                                              color: selectFacilities
                                                      .contains("shelter")
                                                  ? Colors.green
                                                  : Colors.black12,
                                            ),
                                            Text(
                                              "Shelter",
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: selectFacilities
                                                        .contains("shelter")
                                                    ? Colors.green
                                                    : Colors.black12,
                                              ),
                                            )
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border: Border.all(
                                              color: Colors.black12, width: 1),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(),
                                                Icon(
                                                  selectFacilities
                                                          .contains("food")
                                                      ? Icons.check_circle
                                                      : Icons.circle_outlined,
                                                  color: selectFacilities
                                                          .contains("food")
                                                      ? Colors.green
                                                      : Colors.black12,
                                                )
                                              ],
                                            ),
                                            Icon(
                                              Icons.fastfood,
                                              size: 50,
                                              color: selectFacilities
                                                      .contains("food")
                                                  ? Colors.green
                                                  : Colors.black12,
                                            ),
                                            Text(
                                              "Food",
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: selectFacilities
                                                        .contains("food")
                                                    ? Colors.green
                                                    : Colors.black12,
                                              ),
                                            )
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border: Border.all(
                                              color: Colors.black12, width: 1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Widget to display images with delete functionality
                        Visibility(
                          visible: slectedStep == 4 ? true : false,
                          child: Container(
                            height: height * 0.5,
                            child: GridView.builder(
                              itemCount: imageFileList!.length + 1,
                              shrinkWrap: true,
                              padding: EdgeInsets.all(10.0),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return index == 0
                                    ? GestureDetector(
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
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            border: Border.all(
                                              color: Colors.black12,
                                              width: 1,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add,
                                                size: 50,
                                                color: selectedIndex == 1
                                                    ? Colors.green
                                                    : Colors.black12,
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                "Add Image",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: selectedIndex == 1
                                                      ? Colors.green
                                                      : Colors.black12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            child: Image.file(
                                              File(imageFileList![index - 1]
                                                  .path),
                                              width: 200.0,
                                              height: 120,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                         /* Positioned(
                                            top: 5,
                                            right: 5,
                                            child: GestureDetector(
                                              onTap: () {
                                                //
                                                // String imageUrl = filePathToUrlString(imageFileList![index].path);
                                                // handleDeleteImage(imageUrl, index);

                                                // String imageUrl = imageFileList![index - 1].path;
                                                print("imahghgh");
                                                //                               itemCount: imageFileList!.length + 1,
                                                // File(imageFileList![index - 1].path),

                                                // if (index >= 0 && index < imageFileList!.length + 1) {
                                                //   String imageUrl = filePathToUrlString(imageFileList![index-1].path);
                                                //   deleteImage(imageUrl).then((_) {
                                                //     setState(() {
                                                //       imageFileList!.removeAt(index);
                                                //     });
                                                //   });
                                                // }

                                                // handleDeleteImage(imageUrl);

                                                // Call delete function on tap
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                ),
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),*/
                                        ],
                                      );
                              },
                            ),
                          ),
                        ),

                        verticalmargin20,
                        verticalmargin20,

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
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
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
                                                Radius.circular(10)),
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
                                          if (_formKey.currentState!
                                              .validate()) {
                                            if (imageFileList == null ||
                                                imageFileList!.isEmpty) {
                                              _showErrorDialog(
                                                  "Please add at least one image.");
                                              return;
                                            }

                                            editTurfApi(
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
                                                widget.lat,
                                                widget.long,
                                                selectFacilities,
                                                user_type,
                                                widget.id,
                                                context);
                                          }
                                        },
                                        child: Container(
                                          width: width * 0.4,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
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
                                                Radius.circular(10)),
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
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
