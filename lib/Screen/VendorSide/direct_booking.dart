/*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:turfapp/MyModel/TurfSlotsModel.dart';
import 'package:turfapp/MyNetwork/BookingNetwork/checkSlotsApi.dart';
import 'package:turfapp/MyNetwork/Vendor/pre_bookingApi.dart';
import 'package:turfapp/Screen/HomeScreen.dart';

class BookingForm extends StatefulWidget {
  final String? usertype;
  final String ? cutomerid;
  final String turf_id;
  const BookingForm({super.key,this.usertype, this.cutomerid, required this.turf_id });

  @override
  State<BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _paymentController = TextEditingController();
  TextEditingController advanceAmount = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController perslotpriceCtr = TextEditingController();
  TextEditingController advancedamountCtr = TextEditingController();
  // String? _selectedTime;

  List<String> selectTimeList = [];

  late TurfSlotsModel model;
  List<String> listslots = [];
  // late SharedPreferences prefs
  String user_type = "";
  String contactNo = "";
  bool isSlotSelected = false;

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }


*/
/*  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        // Format the picked date
        String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        _dateController.text = formattedDate;
        loadLots(_dateController.text);
      });
    }
  }

  loadLots(String date) {
    checkSlotsType(context, widget.turf_id, _dateController.text).then((value) {
      if (value != "") {
        setState(() {
          model = turfSlotsModelFromJson(value);
          listslots = model.slots[0].slots;
          print("Selects >>> lots" + listslots.length.toString());
        });
      }
    });
  }*//*


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        // Format the picked date
        String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        _dateController.text = formattedDate;
        // Clear the selected slot when date changes
        selectedSlot = null;
        loadLots(_dateController.text);
      });
    }
  }

  loadLots(String date) {
    checkSlotsType(context, widget.turf_id, _dateController.text).then((value) {
      if (value != "") {
        setState(() {
          model = turfSlotsModelFromJson(value);
          listslots = model.slots[0].slots;
          print("Selects >>> lots" + listslots.length.toString());
        });
      }
    });
  }


  String? selectedSlot; // Add this variable to track selected slot


  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title:  Text("Direct Booking",style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.bold),),

        backgroundColor: Colors.green,
      ),


      body: SingleChildScrollView(
        child: Column(

          children: [

            SizedBox(
              height: height * 0.02,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'User Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),

                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: InputDecoration(
                          hintText: 'Mobile Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your mobile number';
                          }
                          // Check if the value contains exactly 10 digits
                          if (value.length != 10 || int.tryParse(value) == null) {
                            return 'Mobile number must be 10 digits';
                          }
                          // Additional validation rules can be added here
                          return null;
                        },
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          labelText: 'Select Date',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () {
                              // selectedDate = date.toString().split(" ")[0];

                              _selectDate(context);

                            },

                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),

                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your mobile number';
                          }
                          // Add additional validation rules if needed
                          return null;
                        },

                        readOnly: true,
                      ),
                    ),

                    */
/*   Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                        value: _selectedTime,
                        items: timelist.map((String time) {
                          return DropdownMenuItem<String>(
                            value: time,
                            child: Text(time),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedTime = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Select Time Slot',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),

                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a time slot';
                          }
                          return null;
                        },
                      ),
                    ),*//*


                    //new


                    Text("Select Slot",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
                 */
/*   Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: height * 0.13,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black)
                          // color: Colors.black45
                        ),
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
                                        fontWeight: selectTimeList.contains(listslots[index]) ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all( color:Colors.black),
                                    ),
                                    padding: EdgeInsets.only(left: 10,top: 10,bottom: 10,right: 10),
                                    // margin: EdgeInsets.all(5.0),
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
                    ),*//*


                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: height * 0.13,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black)
                          // color: Colors.black45
                        ),
                        child: listslots.isEmpty ? FittedBox(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all( color:Colors.white),
                            ),
                            padding: EdgeInsets.only(left: 8,top: 10,bottom: 10,right: 250),
                          
                            child: Text(
                              'Select Slot',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ) : GridView.builder(
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
                                        fontWeight: selectTimeList.contains(listslots[index]) ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all( color:Colors.black),
                                    ),
                                    padding: EdgeInsets.only(left: 10,top: 10,bottom: 10,right: 10),
                                    // margin: EdgeInsets.all(5.0),
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
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _paymentController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Full Payment Amount',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),

                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter full payment amount';
                          }
                          // Add additional validation rules if needed
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: advanceAmount,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Advance Amount",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),

                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter turf name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: perslotpriceCtr,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "per_slot_price",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),

                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter turf name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: advancedamountCtr,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "advanced amount",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),

                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter turf name';
                          }
                          return null;
                        },
                      ),
                    ),
                    */
/*
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, submit the booking
                            _submitBooking();
                          }
                        },
                        child: Text('Submit'),
                      ),
                    ),
            *//*

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 8),
                      child: InkWell(
                        onTap: (){
                          print("time == ${selectTimeList}");
                          print(" widget id ${widget.turf_id}");
                          if (_formKey.currentState!.validate()) {
                            submitBooking(
                              context,
                              user_type,
                              widget.turf_id,
                              _nameController.text,
                              _dateController.text,
                              selectTimeList,
                              advanceAmount.text,
                              perslotpriceCtr.text,
                              advancedamountCtr.text,
                              _paymentController.text,
                              _mobileController.text,
                              // _turfNameController.text,
                              //String turf_id ,String name ,String number,  String date ,String advanceAmountPre,String turfName,
                              //     List<String> selectTimeList,

                              // _turfNameController.text,
                            );
                          }
                        },
                        child: Container(
                          width: width,

                          padding: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.green,

                              borderRadius: BorderRadius.all(Radius.circular(10))),

                          child: Center(
                            child: Text("Submit", style: TextStyle(

                                fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
























import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:turfapp/MyModel/TurfSlotsModel.dart';
import 'package:turfapp/MyNetwork/BookingNetwork/checkSlotsApi.dart';
import 'package:turfapp/MyNetwork/Vendor/pre_bookingApi.dart';
import 'package:turfapp/Screen/HomeScreen.dart';

class BookingForm extends StatefulWidget {
  final String? usertype;
  final String? cutomerid;
  final String turf_id;

  const BookingForm({Key? key, this.usertype, this.cutomerid, required this.turf_id})
      : super(key: key);

  @override
  State<BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _paymentController = TextEditingController();
  TextEditingController advanceAmount = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController perslotpriceCtr = TextEditingController();
  TextEditingController advancedamountCtr = TextEditingController();

  List<String> selectTimeList = [];
  late TurfSlotsModel model;
  List<String> listslots = [];
  String user_type = "";
  String contactNo = "";
  bool isSlotSelected = false;
  Set<String> selectedSlots = {}; // Use a Set to track selected slots

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _paymentController.dispose();
    advanceAmount.dispose();
    _dateController.dispose();
    perslotpriceCtr.dispose();
    advancedamountCtr.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        // Format the picked date
        String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        _dateController.text = formattedDate;
        // Clear the selected slots when date changes
        selectedSlots.clear();
        loadLots(_dateController.text);
      });
    }
  }

  loadLots(String date) {
    checkSlotsType(context, widget.turf_id, _dateController.text).then((value) {
      if (value != "") {
        setState(() {
          model = turfSlotsModelFromJson(value);
          listslots = model.slots[0].slots;
          print("Selects >>> lots" + listslots.length.toString());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Direct Booking",
          style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
      ),
      body: Container(
        height: height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height * 0.02,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'User Name',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: InputDecoration(
                            hintText: 'Mobile Number',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your mobile number';
                            }
                            if (value.length != 10 || int.tryParse(value) == null) {
                              return 'Mobile number must be 10 digits';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _dateController,
                          decoration: InputDecoration(
                            labelText: 'Select Date',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () {
                                _selectDate(context);
                              },
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a date';
                            }
                            return null;
                          },
                          readOnly: true,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: height * 0.13,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black),
                          ),
                          child: listslots.isEmpty
                              ? FittedBox(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white),
                              ),
                              padding: EdgeInsets.only(left: 8, top: 10, bottom: 10, right: 250),
                              child: Text(
                                'Select Slot',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                              : GridView.builder(
                            itemCount: listslots.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 1.0,
                              mainAxisSpacing: 1.0,
                              mainAxisExtent: 50,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  InkWell(
                                    child: Container(
                                      child: Text(
                                        listslots[index],
                                        style: TextStyle(
                                          color: selectedSlots.contains(listslots[index])
                                              ? Colors.green
                                              : Colors.black,
                                          fontWeight: selectedSlots.contains(listslots[index])
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.black),
                                      ),
                                      padding: EdgeInsets.all(10),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        if (selectedSlots.contains(listslots[index])) {
                                          selectedSlots.remove(listslots[index]);
                                        } else {
                                          selectedSlots.add(listslots[index]);
                                        }
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _paymentController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Full Payment Amount',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter full payment amount';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: advanceAmount,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Advance Amount",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the advance amount';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: perslotpriceCtr,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Per Slot Price",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the per slot price';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: advancedamountCtr,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Advanced Amount",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the advanced amount';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                        child: InkWell(
                          onTap: () {
                            print("Selected Slots: $selectedSlots");
                            print("Widget ID: ${widget.turf_id}");
                            if (_formKey.currentState!.validate()) {
                              submitBooking(
                                context,
                                user_type,
                                widget.turf_id,
                                _nameController.text,
                                _dateController.text,
                                selectedSlots.toList(), // Pass the selected slots as a list
                                advanceAmount.text,
                                perslotpriceCtr.text,
                                advancedamountCtr.text,
                                _paymentController.text,
                                _mobileController.text,
                              );
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
                      ),
                    ],
                  ),
                ),
              ),
              Container(height: height*0.1,)
            ],
          ),
        ),
      ),
    );
  }
}
