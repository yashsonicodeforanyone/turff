import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turfapp/MyConstants/ShImageConstants.dart';
import 'package:turfapp/MyConstants/ShPrefConstants.dart';
import 'package:turfapp/MyModel/turf_recomedation.dart';
import 'package:turfapp/MyNetwork/BookingNetwork/addBookingApi.dart';
import 'package:turfapp/MyNetwork/BookingNetwork/turf_Slot_price.dart';
import 'package:turfapp/MyNetwork/turf_recomedationApi.dart';

class PaymentScreen extends StatefulWidget {

  String createdDate;
  List<String> selectedDates=[];
  String current_latitude;
  String current_longitude;
  String turf_id;
  String cutomer_id;
  // final double amount;
// String contactno;
   PaymentScreen({
   required this.createdDate,
   required this.selectedDates,
   required this.current_latitude,
   required this.current_longitude,

   required this.turf_id,
   required this.cutomer_id,
   // required this.amount,
     // required this.contactno
   });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {


  double totalamount=0;
  double advancedamount=0;
  int adancedper=25;
  int finalAmount=0;

  int selected=1;


  var active_decoration= BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(10)),
  border: Border.all(width: 1,color: Colors.green)
  );

  var inactive_decoration= BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border.all(width: 1,color: Colors.black12)

  );

  late SharedPreferences prefs;
  String user_type = "";
  String contactNo = "";


  initalize() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      user_type = prefs.getString(sp_usertype).toString();
      contactNo = prefs.getString(sp_contact).toString();

      // user_type = widget.usertype.toString();
      print("number history py ===>>${contactNo}");
      print("##>>>>>>>" + user_type);
      //admin/vendor/user
    });
  }

  int _price = 0;



  @override
  void initState() {
    // calculateAmount(25);
    super.initState();
    _getTurfPrice();
    initalize();
  }


/*

  void _getTurfPrice() async {
    final priceModel = await TurfPriceService.fetchTurfPrice();
    setState(() {
      // _price = priceModel.price.toDouble();


      // _price = priceModel.price;
    });
  }
*/




/*
  void _getTurfPrice() async {
    try {
      final price = await TurfPriceService.fetchTurfPrice(widget.turf_id,
        widget.selectedDates
      );
      setState(() {
        _price = price;
        calculateAmount(25); // Calculate amounts after fetching price
      });
    } catch (e) {
      print('Error fetching turf price: $e');
      // Handle error, show error message to the user, etc.
    }
  }
*/
  int perSlotPrice = 0;

  void _getTurfPrice() async {
    try {
      final response = await TurfPriceService.fetchTurfPrice(widget.turf_id, widget.selectedDates);
      if (response['status'] == 1) {
        setState(() {
          _price = response['price'];
          perSlotPrice = response['per_slot_price'];
          // String user = response['user'];
          // Do whatever you need with perSlotPrice and user
          calculateAmount(25);
        });
      } else {
        print('Error: ${response['message']}');
      }
    } catch (e) {
      print('Error fetching turf price: $e');
    }
  }



  // double amount = 100;
/*
  calculateAmount(int per){
    setState(() {

      finalAmount=(widget.selectedDates.length*_price);//100*3=300

      advancedamount=(finalAmount*per)/100;

      totalamount=finalAmount-advancedamount;
    });

  }*/


/*
  calculateAmount(int per) {
    setState(() {
      finalAmount = (widget.selectedDates.length * _price); // Calculate final amount
      advancedamount = (finalAmount * per) / 100; // Calculate advanced amount
      totalamount = finalAmount - advancedamount; // Calculate total amount

      // Ensure totalamount is a valid double before setting it
      if (totalamount.isNaN || totalamount.isInfinite) {
        print('Error calculating total amount: Invalid double');
        // Handle error, set a default value, or show an error message
      } else {
        // Set the totalamount only if it's a valid double
        totalamount = double.parse(totalamount.toStringAsFixed(2));
      }
    });
  }
*/


  calculateAmount(int per) {
    setState(() {
      print("price ===> $_price");
      // finalAmount = _price as double;
     /* print('Final Amount: $finalAmount');
      advancedamount = (finalAmount * perSlotPrice) / 100; // Calculate advanced amount
      print('Advanced Amount: $advancedamount');
      totalamount = finalAmount - advancedamount; // Calculate total amount
      print('Total Amount: $totalamount');
      // Ensure totalamount is a valid double before setting it
      if (totalamount.isNaN || totalamount.isInfinite) {
        print('Error calculating total amount: Invalid double');
      } else {
        totalamount = totalamount.toStringAsFixed(2);

      }*/


      finalAmount=(widget.selectedDates.length*_price);//100*3=300

      advancedamount=((finalAmount*per)/100);

      totalamount=finalAmount-advancedamount;
    });
  }


  @override
  Widget build(BuildContext context) {

    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        title:  const Text(
          "Payment",
          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(


          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Card(
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side:
                    const BorderSide(color: Colors.grey, width: 2)),
                child: Container(
                  width: width,
                  margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Advanced Amount",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),),
                      SizedBox(height: 10,),

                      // Container(
                      //   margin: EdgeInsets.all(5),
                      //   width: width,
                      //   padding: EdgeInsets.all(10),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.all(Radius.circular(10)),
                      //     border: Border.all(width: 1,color: Colors.black12)
                      //
                      //   ),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text("Pay @25% ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black38),),
                      //       Icon(Icons.circle_outlined,color: Colors.black38,)
                      //     ],
                      //   )
                      // ),
                      InkWell(
                        onTap: (){
                          setState(() {
                            selected=1;
                            calculateAmount(25);
                          });
                        },
                        child: Container(
                            margin: EdgeInsets.all(5),
                            width: width,
                            padding: EdgeInsets.all(10),

                            decoration: selected==1?active_decoration:inactive_decoration,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Pay @25% ",
                                  style:selected==1? TextStyle(fontWeight: FontWeight.bold,color: Colors.green):
                                  TextStyle(fontWeight: FontWeight.bold,color: Colors.black38),
                                ),
                                selected==1?  Icon(Icons.check_circle,color: Colors.green,):
                                Icon(Icons.circle_outlined,color: Colors.black38,)
                              ],
                            )
                        ),
                      ),
                      InkWell(

                        onTap: (){
                          setState(() {
                            selected=2;
                            calculateAmount(100);
                          });
                        },
                        child: Container(
                            margin: EdgeInsets.all(5),
                            width: width,
                            padding: EdgeInsets.all(10),
                            decoration: selected==2?active_decoration:inactive_decoration,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Pay @100% ",style: selected==1? TextStyle(fontWeight: FontWeight.bold,color: Colors.green):
                                TextStyle(fontWeight: FontWeight.bold,color: Colors.black38)),
                               selected==2?  Icon(Icons.check_circle,color: Colors.green,):
                               Icon(Icons.circle_outlined,color: Colors.black38,)
                              ],
                            )
                        ),
                      ),

                    ],
                  ),

                ),
              ),

              Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side:
                      const BorderSide(color: Colors.grey, width: 2)),
                  margin: EdgeInsets.all(10),
                  child:Container(
                    margin: EdgeInsets.all(10),
                    width: width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Payment",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),),
                        SizedBox(height: 10,),
                        Row(

                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Per Slot Price : ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black),),
                            Text("${perSlotPrice}",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(

                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Selected Slots  : ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black),),
                            Text("${widget.selectedDates.length}",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(

                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Final Amount : ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black),),
                            Text(""+"${_price}",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(

                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Advanced Amount : ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black),),
                            Text(""+advancedamount.toStringAsFixed(2),style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),),
                          ],
                        ),
                        SizedBox(height: 8,),
                        Container(color: Colors.black38,height: 2,),
                        SizedBox(height: 5,),
                        Row(

                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Remaining Amount :",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.black),),
                            Text(""+totalamount.toStringAsFixed(2),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.green),),
                          ],
                        ),
                        SizedBox(height: 8,),
                        SwipeButton.expand(
                          thumb: Icon(
                            Icons.double_arrow_rounded,
                            color: Colors.white,
                          ),
                          child: Text(
                            "Swipe to Pay",
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          activeThumbColor: Colors.green,
                          activeTrackColor: Colors.grey.shade300,
                          onSwipe: () {

                            addBooking(context,
                                widget.turf_id,
                                widget.cutomer_id,
                                widget.createdDate,
                                widget.selectedDates,
                                widget.current_latitude,
                                widget.current_longitude,
                                selected==1?"25":"100",
                                _price.toStringAsFixed(2),
                                advancedamount.toStringAsFixed(2),
                                totalamount.toStringAsFixed(2),
                              contactNo,
                              user_type,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Payment Processing"),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 8,),

                      ],
                    ),
                  )
              )



            ],
          ),
        ),
      ),

    );
  }
}
