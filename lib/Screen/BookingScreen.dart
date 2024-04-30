import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:turfapp/MyConstants/ShPrefConstants.dart';
import 'package:turfapp/MyModel/TurfSlotsModel.dart';
import 'package:turfapp/MyModel/turf_recomedation.dart';
import 'package:turfapp/MyNetwork/BookingNetwork/checkSlotsApi.dart';
import 'package:turfapp/MyNetwork/get_priceListApi.dart';
import 'package:turfapp/MyNetwork/turf_recomedationApi.dart';
import 'package:turfapp/Screen/PaymentScreen.dart';
import 'package:turfapp/Screen/VendorSide/view_turf_detials.dart';

class BookingScreen extends StatefulWidget {
  final String turf_id;
  final String customer_id;
  final String current_latitude;
  final String current_longitude;
final  String turfName;
  BookingScreen({
    required this.turf_id,
    required this.customer_id,
    required this.current_latitude,
    required this.current_longitude,  required this.turfName,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  List<String> timelist = ["10:00 AM - 11:00 AM", "11:00 AM - 12:00 AM", "12:00 PM - 01:00 PM", "02:00 PM - 03:00 PM"];
  List<String> selectTimeList = [];
  String selectedDate = "";
  String totalamount = "";
  // String totalamossssunt = "0.0"; // Initialize totalamount with a default value

  late TurfSlotsModel model;
  List<String> listslots = [];
  late SharedPreferences prefs;
  String user_type = "";
  String contactNo = "";
  bool isSlotSelected = false;


  @override
  void initState() {
    selectedDate = DateTime.now().toString().split(" ")[0];
    print("DateTime Now ...." + selectedDate);
    loadLots(selectedDate);
    // fetchData();
    super.initState();
    initialize();
  }






  initialize() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      user_type = prefs.getString(sp_usertype).toString();
      contactNo = prefs.getString(sp_contact).toString();
      print("number history ===>>${contactNo}");
      print("##>>>>>>>" + user_type);
    });
  }

  loadLots(String date) {
    DateTime currentDateTime = DateTime.now();

    checkSlotsType(context, widget.turf_id, selectedDate).then((value) {
      if (value != "") {
        setState(() {
          model = turfSlotsModelFromJson(value);
          listslots = model.slots[0].slots;
          print("Selects >>> lots" + listslots.length.toString());
          // Clear the selected slots when the date changes
          selectTimeList.clear();
        });
      }
    });
  }









  void showPriceButtons(BuildContext context) async {
    print(widget.turf_id);
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(widget.turfName,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.white),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,size: 20,color: Colors.white,), onPressed: () {
          Navigator.pop(context);
        },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                margin: EdgeInsets.all(10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.green,width: 2)
                ),
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Select Date", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                      Container(
                        height: 90,
                        child: DatePicker(
                          DateTime.now(),
                          initialSelectedDate: DateTime.now(),
                          selectionColor: Colors.green,
                          selectedTextColor: Colors.white,
                          onDateChange: (date) {
                            setState(() {
                              selectedDate = date.toString().split(" ")[0];
                              print(">>>>>>>>" + selectedDate);
                              loadLots(selectedDate);
                            });
                          },
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.green,width: 2)
                ),
                child: Container(

                  width: width,
                  margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Select Slots", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),

                      Container(
                        height: height * 0.13,
                        child: GridView.builder(
                          itemCount: listslots.length, // Number of items in the grid
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Number of columns
                            crossAxisSpacing: 1.0, // Spacing between columns
                            mainAxisSpacing: 1.0, // Spacing between rows
                            mainAxisExtent: 50,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            // Builder function for each grid item
                            return Column(
                              children: [
                                InkWell(
                                  child: Container(
                                    child: Text(
                                      listslots[index],
                                      style: TextStyle(
                                        color: selectTimeList.contains(listslots[index]) ? Colors.green : Colors.black,
                                        fontWeight: selectTimeList.contains(listslots[index]) ? FontWeight.bold : FontWeight.w600,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black),
                                    ),
                                    padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
                                  ),
                                  onTap: () {
                                    if (selectTimeList.contains(listslots[index])) {
                                      setState(() {
                                        selectTimeList.remove(listslots[index]);
                                        isSlotSelected = selectTimeList.isNotEmpty;
                                      });
                                    } else {
                                      setState(() {
                                        selectTimeList.add(listslots[index]);
                                        isSlotSelected = true;
                                      });
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              Card(
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.green,width: 2)
                ),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10,vertical: 10),
                  child: InkWell(
                    onTap: () {
                      showPriceButtons(context,);
                    },
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "रु",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 18,
                                  fontWeight:
                                  FontWeight.bold),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "View Price list",
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),

                        Icon(
                          Icons.arrow_drop_down,
                          size: 30,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: isSlotSelected,
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Text("Recommendation", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              ),
              Container(
                height: height * 0.34,
                child: isSlotSelected
                    ? FutureBuilder<RecomedationTurfModel?>(
                  future: fetchTurfRecommendations(widget.current_latitude,
                      widget.current_longitude, widget.turf_id, selectedDate, selectTimeList),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      print('Error: ${snapshot.error}');
                      return Center(child: Text("data not found"));
                    } else if (snapshot.hasData) {
                      final List<Turf> turfs = snapshot.data!.data;
                      return ListView.builder(
                        itemCount: turfs.length,
                        itemBuilder: (context, index) {
                          final Turf turf = turfs[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewTurfDetials(
                                        usertype: user_type,
                                        cutomerid: widget.customer_id,
                                        turf_id: turf.id,
                                        current_latitude: widget.current_latitude,
                                        current_longitude: widget.current_longitude, turfName: turf.turfName,
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(color: Colors.green,width: 2)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        child:ClipRRect(
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                                          child: Image.network(
                                            turf.images.isNotEmpty ? turf.images[0] : '',
                                            height: height * 0.19,
                                            width: MediaQuery.of(context).size.width * 0.35,
                                            fit: BoxFit.fill,
                                            scale: 1,
                                            errorBuilder: (context, error, stackTrace) {
                                              // ErrorBuilder will be called when there is an error loading the image
                                              // Return an empty container to show nothing in place of the image
                                              return Container(
                                                height: height * 0.15,
                                                width: MediaQuery.of(context).size.width * 0.35,
                                              );
                                            },
                                          ),

                                        ),
                                        /* ClipRRect(
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                                          child: Image.network(
                                            turf.images.isNotEmpty ? turf.images[0] : '',
                                            height: height * 0.19,
                                            width: MediaQuery.of(context).size.width * 0.35,
                                            fit: BoxFit.fill,
                                            scale: 1,
                                          ),
                                        ),*/
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(turf.turfName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                            SizedBox(height: 4),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Icon(Icons.location_on_outlined, color: Colors.green, size: 20),
                                                ),
                                                Container(width: width * 0.45, child: Text(turf.address, style: TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.w500))),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(5),
                                                  child: Icon(Icons.my_location_outlined, color: Colors.green, size: 18),
                                                ),
                                                Container(width: width * 0.45, child: Text('${turf.distance} KM', style: TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.w500))),
                                              ],
                                            ),
                                            SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: Icon(Icons.sports, color: Colors.green, size: 20),
                                                ),
                                                Text(turf.sportType.first, style: TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.w500)),
                                                SizedBox(width: 5),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                      // 9655536589


                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(child: Text('No data'));
                    }
                  },
                )
                    : SizedBox(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {

          double amountValue;
          try {
            // Try to parse the totalamount string to a double
            amountValue = double.parse(totalamount);
          } catch (e) {
            // Handle the case where parsing fails (e.g., invalid format)
            // You can provide a default value or show an error message to the user
            amountValue = 0.0; // Default value
            print('Error parsing totalamount: $e');
          }

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentScreen(
                createdDate: selectedDate,
                selectedDates: selectTimeList,
                current_latitude: widget.current_latitude,
                current_longitude: widget.current_longitude,
                turf_id: widget.turf_id,
                cutomer_id: widget.customer_id,
                // amount:100,
              ),
            ),
                  (route) => route.isFirst
          );
        },
        child: Container(
          width: width,
          height: 50,
          margin: EdgeInsets.only(left: 25),
          decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Center(
            child: Text(
              "Next",
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
