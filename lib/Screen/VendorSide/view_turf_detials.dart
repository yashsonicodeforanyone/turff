import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/page_view_indicators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turfapp/MyConstants/ShPrefConstants.dart';
import 'package:turfapp/MyModel/AllTurfModels.dart';
import 'package:turfapp/MyModel/Turf_detials/turf_detials.dart';
import 'package:turfapp/MyNetwork/get_priceListApi.dart';
import 'package:turfapp/MyNetwork/turf_detialsApi.dart';
import 'package:turfapp/MyNetwork/turflistapi.dart';
import 'package:turfapp/Screen/BookingScreen.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turfapp/Screen/GoogleMapScreen.dart';

class ViewTurfDetials extends StatefulWidget {
  final String? cutomerid;
  final String? usertype;
  final String turf_id;
  final String? current_latitude;
  final String? current_longitude;
  final String turfName;
  final String? image;
  final String? squarefit;
  final String? address;
  final String? food;
  final String? sport;
  const ViewTurfDetials({
    super.key,
    this.cutomerid,
    this.usertype,
    required this.turf_id,
    this.current_latitude,
    this.current_longitude,
    required this.turfName,
    this.image,
    this.squarefit,
    this.address,
    this.food,
    this.sport,
  });

  @override
  State<ViewTurfDetials> createState() => _ViewTurfDetialsState();
}

class _ViewTurfDetialsState extends State<ViewTurfDetials> {
  final _boxHeight = 150.0;
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  List<TurfModel> list_turf = [];

  late SharedPreferences prefs;
  String current_latitude = "";
  String current_longitude = "";
  String user_type = "";
  String contactNo = "";

  List<TurfDetials> turfList = [];

  void fetchData() async {
    try {
      ApiService apiService = ApiService(); // Create an instance of ApiService
      List<TurfDetials> fetchedData = await apiService
          .getTaruffList(widget.turf_id); // Call the method on the instance
      setState(() {
        turfList = fetchedData;
      });
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error, show error message to user, etc.
    }
  }

  @override
  void initState() {
    super.initState();
    initalize();
    fetchData(); // Fetch data when the screen loads
  }

  initalize() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      user_type = prefs.getString(sp_usertype).toString();
      contactNo = prefs.getString(sp_contact).toString();
      user_type = widget.usertype.toString();
      print("number history ===>>${contactNo}");
      print("##>>>>>>>" + user_type);
      print(widget.turf_id);
      //admin/vendor/user
    });
  }


  void showPriceButtons(BuildContext context) async {
    List<Map<String, dynamic>> prices = await fetchPriceList(widget.turf_id);

    List<Map<String, dynamic>> weekdayPrices =
    prices.where((price) => price['type'] == 'normal').toList();
    List<Map<String, dynamic>> weekendPrices =
    prices.where((price) => price['type'] == 'weekend').toList();

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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Price List",
                        style: TextStyle(
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
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "Weekdays",
                    style: TextStyle(
                      color: Colors.green[900],
                      fontWeight: FontWeight.w700,
                      decorationThickness: 2,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Time",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "Price per hour",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
                Container(
                  // height: 200,
                  child: _buildPriceList(weekdayPrices),
                ),
                Container(
                  color: Colors.green[200],
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "Weekend",
                    style: TextStyle(
                      color: Colors.green[900],
                      fontWeight: FontWeight.w700,
                      decorationThickness: 2,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Time",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "Price per hour",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
                Container(
                  // height: 200,
                  child: _buildPriceList(weekendPrices),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPriceList(List<Map<String, dynamic>> prices) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: prices.length,
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (BuildContext context, int index) => Divider(height: 0),
      itemBuilder: (BuildContext context, int index) {
        Map<String, dynamic> price = prices[index];
        return InkWell(
          onTap: () {
            // Handle button tap
            print(
                'Selected Price: ${price['hourly_number']} Hours - \u20B9${price['hourly_price']}');
            // Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                    fontWeight: FontWeight.w400,
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
          ),
        );
      },
    );
  }

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
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        title:  const Text(
          "Turf Details",
          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          height: height,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: turfList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side:
                                    const BorderSide(color: Colors.green, width: 2)),
                            child: Container(
                              // height: height * 0.38,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Stack(
                                      children: <Widget>[
                                        // _buildPageView(images),
                                        _buildPageView(turfList[index]
                                            .images), // Image URL provide kiya gaya hai
                                        _buildCircleIndicator(
                                            turfList[index].images.length),
                                        // _buildCircleIndicator(widget.image.toString().length),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                turfList[index].turfName,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black),
                                              ),
                                          /*    InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                MyMapScreen(
                                                                  list_turf:
                                                                      list_turf,
                                                                  cutomer_id: widget
                                                                      .cutomerid
                                                                      .toString(),
                                                                  current_latitude:
                                                                      list_turf[0]
                                                                          .latitude
                                                                          .toString(),
                                                                  current_longitude:
                                                                      list_turf[0]
                                                                          .longitude
                                                                          .toString(),
                                                                )));
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(03),
                                                    height: height * 0.04,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.green),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                05)),
                                                    child: const Text(
                                                      "Map View",
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14),
                                                    ),
                                                  ))*/
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 8),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Icon(
                                                    Icons.location_on_sharp,
                                                    color: Colors.green,
                                                    size: 20,
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.6,
                                                    child: Text(
                                                      turfList[index].address,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.screen_rotation_alt_sharp,
                                                size: 18,
                                                color: Colors.green,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                turfList[index].squarefit +" sq. ft.",
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                      FontWeight.w500,
                                              )
                                              )],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets
                                              .symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "रु",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .green,
                                                        fontSize:
                                                        18,
                                                        fontWeight:
                                                        FontWeight
                                                            .w500),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "  View Price list",
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
                                              InkWell(
                                                onTap: () {
                                                  showPriceButtons(
                                                      context,);
                                                },
                                                child: Icon(
                                                  Icons
                                                      .arrow_drop_down,
                                                  size: 30,
                                                  color:
                                                  Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.watch_later_outlined,
                                                size: 20,
                                                color: Colors.green,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "24 hours ",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                  )
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10,)
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side:
                                const BorderSide(color: Colors.green, width: 2)),
                            child: Container(
                              height: height * 0.18,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Sport",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 10),
                                      child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              turfList[index]
                                                      .sportType
                                                      .contains("baseball")
                                                  ? const Icon(
                                                      Icons.sports_baseball,
                                                      color: Colors.green,
                                                      size: 20,
                                                    )
                                                  : const Icon(
                                                      Icons.sports_baseball,
                                                      color: Colors.grey,
                                                      size: 20,
                                                    ),
                                              /* Icon(
                                                Icons.sports_baseball,
                                                color: Colors.green,
                                                size: 20,
                                              ),*/
                                              SizedBox(
                                                width: 3,
                                              ),
                                              const Text(
                                                "Football",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,fontWeight: FontWeight.w500),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            width: width * 0.25,
                                          ),
                                          Row(
                                            children: [
                                              turfList[index]
                                                      .sportType
                                                      .contains("cricket")
                                                  ? const Icon(
                                                      Icons.sports_cricket,
                                                      color: Colors.green,
                                                      size: 22,
                                                    )
                                                  : const Icon(
                                                      Icons.sports_cricket,
                                                      color: Colors.grey,
                                                      size: 22,
                                                    ),
                                              /*Icon(
                                                Icons.sports_cricket,
                                                color: Colors.green,
                                                size: 20,
                                              ),*/
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              const Text(
                                                "Cricket",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,fontWeight: FontWeight.w500),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "Facilities provided",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 10),
                                      child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              turfList[index]
                                                      .facilities!
                                                      .contains("food")
                                                  ? Icon(
                                                      Icons.fastfood,
                                                      color: Colors.green,
                                                      size: 20,
                                                    )
                                                  : Icon(
                                                      Icons.fastfood,
                                                      color: Colors.grey,
                                                      size: 20,
                                                    ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Food",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,fontWeight: FontWeight.w500),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            width: width * 0.3,
                                          ),
                                          Row(
                                            children: [
                                              turfList[index]
                                                      .facilities!
                                                      .contains("shelter")
                                                  ? Icon(
                                                      Icons.night_shelter_rounded,
                                                      color: Colors.green,
                                                      size: 20,
                                                    )
                                                  : Icon(
                                                      Icons.night_shelter_rounded,
                                                      color: Colors.grey,
                                                      size: 20,
                                                    ),
                                              /*   Icon(
                                                Icons.night_shelter_rounded,
                                                color: Colors.green,
                                                size: 20,
                                              )*/
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "shelter",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,fontWeight: FontWeight.w500),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8),
                          child: Card(
                            elevation: 0,
                            child: Container(
                              // height: height * 0.2,
                              width: width,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.green, width: 2),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                      bottomLeft: Radius.circular(8),
                                      bottomRight:
                                      Radius.circular(8))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10,vertical: 10),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "About ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                          FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),

                                    Text(
                                      "- " + turfList[index].aboutUs,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight:
                                          FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8),
                          child: Card(
                            elevation: 0,
                            child: Container(
                              // height: height * 0.14,
                              width: width,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.green, width: 2),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                      bottomLeft: Radius.circular(8),
                                      bottomRight:
                                      Radius.circular(8))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Cancellation policy",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight:
                                            FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "- " + turfList[index].cancellationPolicy,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight:
                                            FontWeight.w500),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: height*0.20,)
            ],
          ),
        ),

      ),
    /*  floatingActionButton: user_type == "vendor"
          ? FloatingActionButton.extended(
              onPressed: () {
                // Vendor ke liye kriya
                print("Delete turf");
              },
              label: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 100.0), // Horizontal padding dena
                child: Text(
                  'Delete turf',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              // icon: Icon(Icons.delete),
              backgroundColor: Colors.green,
            )
          : user_type == "user"
              ? FloatingActionButton.extended(
                  onPressed: () {
                    // User ke liye kriya
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingScreen(
                          turf_id: widget.turf_id.toString(),
                          turfName: widget.turfName.toString(),
                          customer_id: widget.cutomerid.toString(),
                          current_latitude: widget.current_latitude.toString(),
                          current_longitude:
                              widget.current_longitude.toString(),
                        ),
                      ),
                    );
                  },
                  // label: Text('Book now'),

                  label: Text(
                    'Book now',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  // icon: Icon(Icons.book),
                  backgroundColor: Colors.green,
                )
              : user_type == "admin"
                  ? FloatingActionButton.extended(
                      onPressed: () {
                        // Admin ke liye kriya
                        print("Approve Turfr");
                      },
                      label: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 100.0), // Horizontal padding dena
                        child: Text(
                          'Approve Turfr',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      // icon: Icon(Icons.check),
                      backgroundColor: Colors.green,
                    )
                  : null,*/



      floatingActionButton: SizedBox(
        width: width * 0.9,
        height: height * 0.065,// Set the desired width here
        child: FloatingActionButton.extended(
          onPressed: () {
            // User ke liye kriya
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingScreen(
                  turf_id: widget.turf_id.toString(),
                  turfName: widget.turfName,
                  customer_id: widget.cutomerid.toString(),
                  current_latitude: widget.current_latitude.toString(),
                  current_longitude: widget.current_longitude.toString(),
                ),
              ),
            );
          },
          label: Text(
            'Book now',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              decorationThickness: 2
            ),
          ),
          backgroundColor: Colors.green,
        ),
      ),

    );
  }
}
