import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turfapp/Drawer/drawer.dart';
import 'package:turfapp/MyConstants/ShImageConstants.dart';
import 'package:turfapp/MyModel/get_turfByIdModel.dart';
import 'package:turfapp/MyNetwork/add_to_pin.dart';
import 'package:turfapp/MyNetwork/get_priceListApi.dart';
import 'package:turfapp/MyNetwork/get_turf_by_cusidApi.dart';
import 'package:turfapp/Screen/AddTurfScreen.dart';
import 'package:turfapp/Screen/Admin/turf_list.dart';
import 'package:turfapp/Screen/Admin/user_list.dart';
import 'package:turfapp/Screen/Admin/vendor_list.dart';
import 'package:turfapp/Screen/BookingScreen.dart';
import 'package:turfapp/Screen/CustomerHistory/CustomerHistoryScreen.dart';
import 'package:turfapp/Screen/GoogleMapScreen.dart';
import 'package:turfapp/Screen/Notifications/admin_notification_screen.dart';
import 'package:turfapp/Screen/Notifications/notifications_screen.dart';
import 'package:turfapp/Screen/Notifications/vendor_notifications_screen.dart';
import 'package:turfapp/Screen/VendorHistory/VendorHistoryScreen.dart';
import 'package:turfapp/Screen/VendorSide/addturf_home.dart';
import 'package:turfapp/Screen/VendorSide/edit_turf.dart';
import 'package:turfapp/Screen/VendorSide/price.dart';
import 'package:turfapp/Screen/VendorSide/view_turf_detials.dart';
import '../MyConstants/ShPrefConstants.dart';
import '../MyModel/AllTurfModels.dart';
import '../MyNetwork/turflistapi.dart';
import 'LoginScreen.dart';

class HomeScreen extends StatefulWidget {
  String cutomerid;
  final String? usertype;

  final String? contactno;
  HomeScreen({
    super.key,
    required this.cutomerid,
    this.usertype,
    this.contactno,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  final _boxHeight = 150.0;
  List<TurfModel> list_turf = [];
  List<TurfModel> _filteredList = [];
  bool _dataNotFound = false;

  late SharedPreferences prefs;
  String current_latitude = "";
  String current_longitude = "";
  String user_type = "";
  String contactNo = "";
  String turf_id = "";

/*
    void showPriceButtons(BuildContext context) async {
      List<Map<String, dynamic>> prices = await fetchPriceList(widget.cutomerid);

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 5),
            decoration: BoxDecoration(
              color: Colors.grey[200], // Background color for the modal
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 1.0),
                  decoration: BoxDecoration(
                    // color: Colors.green, // Background color for heading row
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Price List",
                        style: TextStyle(
                          // color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close,color: Colors.green,),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.green[200],
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Center(child: Text("Weekdays",style: TextStyle(color: Colors.green[900],fontWeight: FontWeight.w700,decorationThickness: 2,fontSize: 18),)),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: prices.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                    itemBuilder: (BuildContext context, int index) {
                      Map<String, String> price = prices[index];
                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${price['hourly_number']} Hours',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              '\u20B9${price['hourly_price']} /-',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          // Handle button tap
                          print(
                              'Selected Price: ${price['hourly_number']} Hours - \u20B9${price['hourly_price']}');
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
                Container(
                  color: Colors.green[200],
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Center(child: Text("weekend",style: TextStyle(color: Colors.green[900],fontWeight: FontWeight.w700,decorationThickness: 2,fontSize: 18),)),
                ),

              ],
            ),
          );
        },
      );
    }
*/

/*
  void showPriceButtons(BuildContext context) async {
    List<Map<String, dynamic>> prices = await fetchPriceList(widget.cutomerid);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200], // Background color for the modal
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        "Price List",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              _buildPriceSection(context, "Weekdays", prices.where((price) => price['type'] == 'normal').toList() as List<Map<String, dynamic>>),
              SizedBox(height: 10),
              _buildPriceSection(context, "Weekend", prices.where((price) => price['type'] == 'weekend').toList() as List<Map<String, dynamic>>),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPriceSection(BuildContext context, String title, List<Map<String, dynamic>> prices) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: Colors.green[200],
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.green[900],
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: prices.length,
          separatorBuilder: (BuildContext context, int index) => Divider(height: 0),
          itemBuilder: (BuildContext context, int index) {
            Map<String, dynamic> price = prices[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PriceDetailScreen(
                      hourlyPrice: price['hourly_price'].toString(),
                      weekendPrice: price['hourly_price'].toString(),
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${price['hourly_number']} Hours',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.arrow_forward_ios, color: Colors.black87),
                        SizedBox(width: 8),
                        Text(
                          '\u20B9${price['hourly_price']} /-',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

*/

/*
  void showPriceButtons(BuildContext context) async {
    List<Map<String, dynamic>> prices = await fetchPriceList(widget.cutomerid);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 5),
          decoration: BoxDecoration(
            color: Colors.grey[200], // Background color for the modal
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  // padding: EdgeInsets.symmetric(vertical: 1.0),
                  decoration: BoxDecoration(
                    // color: Colors.green, // Background color for heading row
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Price List",
                        style: TextStyle(
                          // color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.green),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.green[200],
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Center(child: Text("Weekdays",style: TextStyle(color: Colors.green[900],fontWeight: FontWeight.w700,decorationThickness: 2,fontSize: 18),)),
                ),
                Container(
                  height: 100,
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Time",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),
                      Text("Price per hour",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),)
                    ],
                  )
                  */
/* Expanded(
                    child: ListView.separated(
                      itemCount: prices.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(height: 0,),
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> price = prices[index];
                        return ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${price['hourly_number']} Hours',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                '\u20B9${price['hourly_price']} /-',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            // Handle button tap
                            print(
                                'Selected Price: ${price['hourly_number']} Hours - \u20B9${price['hourly_price']}');
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),*/
  /*

                ),

                Container(
                  color: Colors.green[200],
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Center(child: Text("Weekend",style: TextStyle(color: Colors.green[900],fontWeight: FontWeight.w700,decorationThickness: 2,fontSize: 18),)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Time",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),
                      Text("Price per hour",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),)
                    ],
                  ),
                ),
                Container(
                  height: 150,
                  child: Expanded(
                    child: ListView.separated(
                      itemCount: prices.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(height: 0,),
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> price = prices[index];
                        return ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${price['hourly_number']} Hours',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                '\u20B9${price['hourly_price']} /-',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            // Handle button tap
                            print(
                                'Selected Price: ${price['hourly_number']} Hours - \u20B9${price['hourly_price']}');
                            // Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
*/



  @override
  void initState() {
    super.initState();
    initalize();
    getCurrentLocation();
  }

  initalize() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      user_type = prefs.getString(sp_usertype).toString();
      contactNo = prefs.getString(sp_contact).toString();
      user_type = widget.usertype.toString();
      turf_id = prefs.getString(sp_turfId).toString();

      print("home page##>>>>>>>" + user_type);
      //admin/vendor/user
    });
  }

  Future<void> getCurrentLocation() async {
    EasyLoading.show();
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    setState(() {
      current_latitude = _locationData.latitude!.toString();
      current_longitude = _locationData.longitude!.toString();
    });

    // getturflistapi(context,"23.179930092307693","75.78404365384615").
    getturflistapi(context, current_latitude, current_longitude,
            FilterController.text, widget.cutomerid)
        .then((value) {
      final responseData = jsonDecode(value);
      final message = responseData['message'];
      final status = responseData['status'];
      print("getAllListApi Response >>>>> " + status.toString());
      print("getAllListApi value >>>>> " + value.toString());
      if (status == 1) {
        AllTurfModel allhotels = allTurfModelFromJson(value);
        print("getAllListApi body >>>>hm> " + allhotels.data.length.toString());
        //adminAuthFromJson(value).data.
        setState(() {
          list_turf = allhotels.data;
          //
          _filteredList = List<TurfModel>.from(list_turf);
          _dataNotFound = _filteredList.isEmpty;

          // Initialize filtered list with original list
        });
        return Center(child: CircularProgressIndicator());
      }
    });
  }

  void filterData(String searchText) {
    setState(() {
      _filteredList = list_turf
          .where((turf) =>
              turf.turfName.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
      _dataNotFound = _filteredList.isEmpty;
    });
  }

  Widget topWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            scaffoldKey.currentState!.openDrawer();
          },
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2), spreadRadius: 1),
                ],
                borderRadius: BorderRadius.circular(9)),
            child: const Icon(
              Icons.dehaze_rounded,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  TextEditingController FilterController = TextEditingController();
  bool _isLoading = true;

  List<TurfbyId> turfList = [];


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    _buildPageView(List<String> images) {
      return Container(
        height: _boxHeight,
        child: PageView.builder(
            itemCount: images.length,
            controller: _pageController,
            itemBuilder: (BuildContext context, int index) {
              return CachedNetworkImage(
                width: width * 0.22,
                height: height * 0.4,
                imageUrl: images[index],
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5)),
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => Container(
                  padding: EdgeInsets.all(80),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5)),
                  ),
                  child: const CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5)),
                    image: DecorationImage(
                        image: AssetImage("assets/albumPlace.jpg"),
                        fit: BoxFit.cover),
                  ),
                ),
              );
            },
            onPageChanged: (int index) {
              _currentPageNotifier.value = index;
            }),
      );
    }

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

    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: scaffoldKey,
        drawer: DrawerComponent(
          cstomer_id: widget.cutomerid,
          usertype: widget.usertype,
          contactno: widget.contactno,
          turf_id: "",
        ),
        // resizeToAvoidBottomInlset:false,
        body: Container(
          width: width,
          height: height,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 38, left: 8),
                  height: 100,
                  color: Colors.green,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              scaffoldKey.currentState!.openDrawer();
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  // boxShadow: [
                                  //   BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: 1),
                                  // ],
                                  borderRadius: BorderRadius.circular(9)),
                              child: Icon(
                                Icons.dehaze_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          if (user_type == "user")
                            Container(
                              width: width * 0.7,
                              height: height * .045,
                              margin: EdgeInsets.only(left: width * 0.020),
                              child: TextFormField(
                                controller: FilterController,
                                onChanged: filterData,
                                keyboardType: TextInputType.text,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: "Filter Turf's",
                                  hintStyle: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.grey),
                                  suffixIcon: Icon(
                                    Icons.filter_alt,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: width * 0.040,
                                      vertical: height * 0.0010),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(05.0),
                                      borderSide: BorderSide
                                          .none // Set the border color here
                                      ),
                                ),
                              ),
                            ),
                          if (user_type == "vendor")
                            Center(
                                child: Padding(
                              padding: const EdgeInsets.only(left: 120),
                              child: Text(
                                "Home",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            )),
                          if (user_type == "admin")
                            Center(
                                child: Padding(
                              padding: const EdgeInsets.only(left: 120),
                              child: Text(
                                "Home",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ))
                        ],
                      ),
                      // notifications
                      Padding(
                        padding: const EdgeInsets.only(right: 18),
                        child: InkWell(
                          onTap: () {
                            print("User type home: $user_type");
                            print("Customer ID: ${widget.cutomerid}");

                            if (user_type == "user") {
                              print("Navigating to CustomerHistoryScreen");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CustomerNotificationsScreen(
                                          cstomer_id: widget.cutomerid,
                                          usertype: widget.usertype.toString()),
                                ),
                              );
                            } else if (user_type == "vendor") {
                              print("Navigating to VendorNotificationsScreen");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      VendorNotificationsScreen(
                                    turf_id: widget.cutomerid,
                                    usertype: widget.usertype.toString(),
                                  ),
                                ),
                              );
                            } else if (user_type == "admin") {
                              print(
                                  "Navigating to admin notification ${user_type}");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AdminNotificationsScreen(
                                    userid: widget.cutomerid,
                                    usertype: widget.usertype.toString(),
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),

                      /*
                    Row(
                      children: [

                        // _childPopup()
                      ],
                    )*/
                    ],
                  ),
                ),
                if (user_type == "user")
                  Container(
                    height: height * 0.9 - 25,
                    child: _dataNotFound
                        ? const Center(child: Text('Data not found'))
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: _filteredList.length,
                            itemBuilder: (Context, index) {
                              // if (list_turf[index].isTurfPin == 1) {
                              return InkWell(
                                onTap: () {
                                  print("Navigating to VendorHistoryScreen");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewTurfDetials(
                                          usertype: widget.usertype,
                                          food: _filteredList[index]
                                              .facilities!
                                              .contains("food")
                                              .toString(),
                                          image: _filteredList[index]
                                              .images
                                              .toString(),
                                          squarefit:
                                              _filteredList[index].squarefit,
                                          address: _filteredList[index]
                                              .address
                                              .toString(),
                                          turfName: list_turf[index].turfName,
                                          cutomerid: widget.cutomerid,
                                          turf_id: list_turf[index].id,
                                          current_latitude: current_latitude,
                                          current_longitude: current_longitude,
                                          sport: _filteredList[index]
                                              .sportType
                                              .contains("cricket")
                                              .toString()),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Card(
                                    elevation: 0,
                                    margin: EdgeInsets.all(05),
                                    child: Container(
                                      // height: height * 0.42,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey, width: 2),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              topRight: Radius.circular(8),
                                              bottomLeft: Radius.circular(8),
                                              bottomRight: Radius.circular(8))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {},
                                            child: Stack(
                                              children: <Widget>[
                                                _buildPageView(
                                                    _filteredList[index]
                                                        .images),
                                                _buildCircleIndicator(
                                                    _filteredList[index]
                                                        .images
                                                        .length),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: width * 0.85,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10,
                                                                right: 0,
                                                                top: 5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Flexible(
                                                              child: Text(
                                                                "" +
                                                                    _filteredList[
                                                                            index]
                                                                        .turfName,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              top: 5,
                                                              bottom: 2),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 2,
                                                                    right: 5),
                                                            child: Icon(
                                                              Icons.location_on,
                                                              color:
                                                                  Colors.green,
                                                              size:
                                                                  20, // You can adjust the size according to your needs
                                                            ),
                                                          ),
                                                          Container(
                                                              width:
                                                                  width * 0.75,
                                                              // height: height * 0.08,
                                                              child: Text(
                                                                "" +
                                                                    _filteredList[
                                                                            index]
                                                                        .address,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 05,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10),
                                                          child: Row(
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .directions_outlined,
                                                                color: Colors
                                                                    .green,
                                                                size: 18,
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              // Image.asset("assets/1003828-200.png",height: 30,width: 20,color: Colors.green,),
                                                              Text(
                                                                _filteredList[
                                                                            index]
                                                                        .distance
                                                                        .toStringAsFixed(
                                                                            2) +
                                                                    " K.M ",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: width * 0.3,
                                                        ),
                                                        Container(
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .screen_rotation_alt_sharp,
                                                                size: 18,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              Text(
                                                                _filteredList[
                                                                            index]
                                                                        .squarefit +
                                                                    " sq. ft.",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      width: width * 0.85,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              left: 10,
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                _filteredList[
                                                                            index]
                                                                        .sportType
                                                                        .contains(
                                                                            "baseball")
                                                                    ? Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                0,
                                                                            vertical:
                                                                                4),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .sports_baseball,
                                                                          color:
                                                                              Colors.green,
                                                                          size:
                                                                              20,
                                                                        ),
                                                                      )
                                                                    : const Icon(
                                                                        Icons
                                                                            .sports_baseball,
                                                                        color: Colors
                                                                            .green,
                                                                        size:
                                                                            22,
                                                                      ),
                                                                // _filteredList[
                                                                //             index].
                                                                //         .sportType
                                                                _filteredList[
                                                                            index]
                                                                        .sportType!
                                                                        .contains(
                                                                            "cricket")
                                                                    // .contains(
                                                                    //         "cricket")
                                                                    ? const Icon(
                                                                        Icons
                                                                            .sports_cricket,
                                                                        color: Colors
                                                                            .green,
                                                                        size:
                                                                            20,
                                                                      )
                                                                    : const Icon(
                                                                        Icons
                                                                            .sports_cricket,
                                                                        color: Colors
                                                                            .green,
                                                                        size:
                                                                            20,
                                                                      ),
                                                              ],
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              _filteredList[
                                                                          index]
                                                                      .facilities!
                                                                      .contains(
                                                                          "shelter")
                                                                  ? const Icon(
                                                                      Icons
                                                                          .night_shelter_rounded,
                                                                      color: Colors
                                                                          .green,
                                                                    )
                                                                  : Container(),
                                                              _filteredList[
                                                                          index]
                                                                      .facilities!
                                                                      .contains(
                                                                          "food")
                                                                  ? const Icon(
                                                                      Icons
                                                                          .fastfood,
                                                                      color: Colors
                                                                          .green,
                                                                      size: 18,
                                                                    )
                                                                  : Container(),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  BookingScreen(
                                                                    turf_id:
                                                                        list_turf[index]
                                                                            .id,
                                                                    turfName: list_turf[
                                                                            index]
                                                                        .turfName,
                                                                    customer_id:
                                                                        widget
                                                                            .cutomerid,
                                                                    current_latitude:
                                                                        current_latitude,
                                                                    current_longitude:
                                                                        current_longitude,
                                                                    // contactno: widget.contactno
                                                                  )));
                                                },
                                                child: Container(
                                                  width: width * 0.7,
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.green,
                                                          width: 2),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  05))),
                                                  child: const Center(
                                                    child: Text(
                                                      "Book Now",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  addToPin(
                                                    list_turf[index].id,
                                                    widget.cutomerid,
                                                  );
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomeScreen(
                                                        cutomerid:
                                                            widget.cutomerid,
                                                        usertype:
                                                            widget.usertype,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: list_turf[index].isPinned
                                                    ? Container(
                                                        height: height * 0.05,
                                                        width: width * 0.15,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .green,
                                                                width: 2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            05))),
                                                        child: Image.asset(
                                                          "assets/pin.png",
                                                        ),
                                                      )
                                                    : Container(
                                                        height: height * 0.05,
                                                        width: width * 0.15,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .green,
                                                                width: 2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            05))),
                                                        child: Image.asset(
                                                          "assets/icons8-unpin-96.png",
                                                          height: 30,
                                                          width: 40,
                                                          // color: Colors.black45
                                                        ),
                                                      ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                              // }
                            }),
                  ),
             
              ],
            ),
          ),
        ),
        floatingActionButton: user_type == "user"
            ? FloatingActionButton(
                elevation: 0.0,
                child: Icon(Icons.location_on, color: Colors.white),
                backgroundColor: Colors.green,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyMapScreen(
                                list_turf: list_turf,
                                cutomer_id: widget.cutomerid,
                                current_latitude: current_latitude,
                                current_longitude: current_longitude,
                              )));
                })
            : Container());
  }

  void showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Added to pin!'),
          content: Text('Your booking request has been pin successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
