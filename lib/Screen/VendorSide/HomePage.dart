import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_view_indicators/page_view_indicators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turfapp/Drawer/drawer.dart';
import 'package:turfapp/MyConstants/ShPrefConstants.dart';
import 'package:turfapp/MyModel/AllTurfModels.dart';
import 'package:turfapp/MyModel/get_turfByIdModel.dart';
import 'package:turfapp/MyNetwork/get_priceListApi.dart';
import 'package:turfapp/MyNetwork/get_turf_by_cusidApi.dart';
import 'package:turfapp/Screen/Admin/turf_list.dart';
import 'package:turfapp/Screen/Admin/user_list.dart';
import 'package:turfapp/Screen/Admin/vendor_list.dart';
import 'package:turfapp/Screen/Notifications/vendor_notifications_screen.dart';
import 'package:turfapp/Screen/VendorHistory/VendorHistoryScreen.dart';
import 'package:turfapp/Screen/VendorSide/addturf_home.dart';
import 'package:turfapp/Screen/VendorSide/edit_turf.dart';


class HomeforAdmin extends StatefulWidget {
  final String cutomerid;
  final String usertype;
  final String contactno;
  const HomeforAdmin({super.key, required this.usertype, required this.cutomerid, required this.contactno});

  @override
  State<HomeforAdmin> createState() => _HomeforAdminState();
}

class _HomeforAdminState extends State<HomeforAdmin> {
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
  // String turf_id = "";

  @override
  void initState() {
    super.initState();
    initalize();
    _fetchTurfList();
  }

  List<TurfbyId> turfList = [];

  Future<void> _fetchTurfList() async {
    List<TurfbyId> fetchedTurfList = await fetchTurfList(widget.cutomerid);
    setState(() {
      turfList = fetchedTurfList;
    });
  }
  initalize() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      user_type = prefs.getString(sp_usertype).toString();
      contactNo = prefs.getString(sp_contact).toString();
      // user_type = widget.usertype.toString();
      // turf_id = prefs.getString(sp_turfId).toString();

      print("home page##>>>>>>>" + user_type);
      //admin/vendor/user
    });
  }

  void showPriceButtons(BuildContext context, String id) async {
    print(id);
    List<Map<String, dynamic>> prices = await fetchPriceList(id);

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
            child: Icon(
              Icons.dehaze_rounded,
              color: Colors.black,
            ),
          ),
        ),
      ],
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
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      drawer: DrawerComponent(
        cstomer_id: widget.cutomerid,
        usertype: user_type,
        contactno: contactNo,
        turf_id: '',
      ),

      body: Column(
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

                        print("Navigating to VendorNotificationsScreen");

                          print("Navigating to VendorHistoryScreen");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VendorNotificationsScreen(
                                    turf_id: widget.cutomerid,
                                    usertype: user_type,
                                  ),
                            ),
                          );

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
              Container(
                height: height * 0.9 - 25,
                child: turfList.isEmpty
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Center(child: Image.asset("assets/no_data.png",scale: 3,)),
                    InkWell(
                      onTap: () {
                        print("add turf ${user_type}");

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddTurftoHomeScreen(
                              user_id: widget.cutomerid,
                              usertype: user_type,
                            ),
                          ),
                        );
                      },
                      child: Container(
                          height: height * 0.05,
                          width: width * 0.5,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                              child: Text(
                                "Add Turf",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ))),
                    )
                  ],
                )
                    : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: turfList.length,
                  itemBuilder: (context, index) {
                    TurfbyId turf = turfList[index];
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Card(
                            elevation: 0,
                            child: Container(
                              // height: height * 0.38,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey, width: 2),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                      bottomLeft: Radius.circular(8),
                                      bottomRight:
                                      Radius.circular(8))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: <Widget>[
                                        // _buildPageView(images),
                                        _buildPageView(turfList[index]
                                            .images), // Image URL provide kiya gaya hai
                                        _buildCircleIndicator(
                                            turfList[index]
                                                .images
                                                .length),
                                        // _buildCircleIndicator(widget.image.toString().length),
                                      ],
                                    ),
                                    Container(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 10,
                                                vertical: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    turfList[index]
                                                        .turfName,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight
                                                            .w500),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 10,
                                                vertical: 8),
                                            child: Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .location_on_sharp,
                                                      color: Colors
                                                          .green,
                                                      size: 20,
                                                    ),
                                                    Container(
                                                      width: width *
                                                          0.75,
                                                      child: Text(
                                                        turfList[
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
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 10),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons
                                                      .screen_rotation_alt_sharp,
                                                  size: 18,
                                                  color: Colors.green,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  turfList[index]
                                                      .squarefit + " sq. ft.",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors
                                                          .black,
                                                      fontWeight:
                                                      FontWeight
                                                          .w500),
                                                )
                                              ],
                                            ),
                                          ),

/*
                                          Padding(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .start,
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
                                                SizedBox(width: 8,),
                                                Text(
                                                  turf.perHourAmount + "per hour",style: TextStyle(
                                                    fontSize:
                                                    14,
                                                    color: Colors
                                                        .black,
                                                    fontWeight:
                                                    FontWeight
                                                        .w400),
                                                ),
                                              ],
                                            ),
                                          ),
*/
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
                                                        context,
                                                        turfList[index].id)
                                                    ;
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
                                          Padding(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 10),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons
                                                      .watch_later_outlined,
                                                  size: 18,
                                                  color: Colors.green,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "24 hours",
                                                  style: TextStyle(
                                                      fontSize: 14,
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
                                    )
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
                              height: height * 0.18,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey, width: 2),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                      bottomLeft: Radius.circular(8),
                                      bottomRight:
                                      Radius.circular(8))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Sport",
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets
                                            .symmetric(
                                            vertical: 8,
                                            horizontal: 10),
                                        child: Row(
                                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                turfList[index]
                                                    .sportType
                                                    .contains(
                                                    "baseball")
                                                    ? Icon(
                                                  Icons
                                                      .sports_baseball,
                                                  color: Colors
                                                      .green,
                                                  size: 20,
                                                )
                                                    : Icon(
                                                  Icons
                                                      .sports_baseball,
                                                  color: Colors
                                                      .grey,
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
                                                Text(
                                                  "Football",
                                                  style: TextStyle(
                                                      color: Colors
                                                          .black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight
                                                          .w500),
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
                                                    .contains(
                                                    "cricket")
                                                    ? Icon(
                                                  Icons
                                                      .sports_cricket,
                                                  color: Colors
                                                      .green,
                                                  size: 22,
                                                )
                                                    : Icon(
                                                  Icons
                                                      .sports_cricket,
                                                  color: Colors
                                                      .grey,
                                                  size: 22,
                                                ),
                                                /*Icon(
                                              Icons.sports_cricket,
                                              color: Colors.green,
                                              size: 20,
                                            ),*/
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Cricket",
                                                  style: TextStyle(
                                                      color: Colors
                                                          .black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight
                                                          .w500),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "Facilities provided",
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets
                                            .symmetric(
                                            vertical: 8,
                                            horizontal: 10),
                                        child: Row(
                                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                turfList[index]
                                                    .facilities!
                                                    .contains(
                                                    "food")
                                                    ? Icon(
                                                  Icons
                                                      .fastfood,
                                                  color: Colors
                                                      .green,
                                                  size: 20,
                                                )
                                                    : Icon(
                                                  Icons
                                                      .fastfood,
                                                  color: Colors
                                                      .grey,
                                                  size: 20,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Food",
                                                  style: TextStyle(
                                                      color: Colors
                                                          .black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight
                                                          .w500),
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
                                                    .contains(
                                                    "shelter")
                                                    ? Icon(
                                                  Icons
                                                      .night_shelter_rounded,
                                                  color: Colors
                                                      .green,
                                                  size: 20,
                                                )
                                                    : Icon(
                                                  Icons
                                                      .night_shelter_rounded,
                                                  color: Colors
                                                      .grey,
                                                  size: 20,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "shelter",
                                                  style: TextStyle(
                                                      color: Colors
                                                          .black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight
                                                          .w500),
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
                                      color: Colors.grey, width: 2),
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
                                      "- " + turf.aboutUs,
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
                                      color: Colors.grey, width: 2),
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
                                        "- " + turf.cancellationPolicy,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight:
                                            FontWeight.w500),
                                      ),
                                      /* SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "Cancellation before : 0 hours of booking time.",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "Cancellation Charges : 100 %",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                            ],*/
                                    ]),
                              ),
                            ),
                          ),
                        ),

                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                print("User Type ===> ${user_type}");
                                print("id ${turf.id}");
                                print("prachi=======>>>>");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            VendorHistoryScreen(
                                              turf_id: turf.id,
                                              user_type: user_type,

                                              // contactno: widget.contactno
                                            )));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                    top: 10, left: 08),
                                width: width * 0.7,
                                height: height * 0.06,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.green,
                                        width: 2),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(05))),
                                child: const Center(
                                  child: Text(
                                    "Booking Detail",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  print("sport  : ${turf.sportType}");
                                  print("Edit turf");

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditTurfScreen(
                                                lat: turf.latitude,
                                                long:turf.latitude,
                                                user_id:
                                                widget.cutomerid,
                                                id: turf.id,
                                                name: turf.turfName,
                                                contactNo:
                                                turf.contactNo,
                                                address: turf.address,
                                                squareFit:
                                                turf.squarefit,
                                                sportType: turf
                                                    .sportType[index],
                                                facilities:
                                                turf.facilities,
                                                images: turf.images
                                                    .map((imagePath) =>
                                                    XFile(
                                                        imagePath))
                                                    .toList(),
                                              )));
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 10, right: 08),
                                  height: height * 0.06,
                                  width: width * 0.2,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.green,
                                          width: 2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(05))),
                                  child: Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: Colors.green,
                                  ),
                                )),
                          ],
                        )
                      ],
                    );
                    /*ListTile(
                          title: Text(turf.turfName),
                          subtitle: Text(turf.address),
                          leading: Image.network(turf.images.isNotEmpty ? turf.images.first : ''),
                          onTap: () {
                            // Handle onTap event
                          },
                        );*/
                  },
                ),
              ),
          ],
        ),
      
    );
  }
}
