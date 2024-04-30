import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turfapp/MyConstants/ShPrefConstants.dart';
import 'package:turfapp/MyNetwork/get_priceListApi.dart';
import 'package:turfapp/Screen/HomeScreen.dart';
import 'package:turfapp/Screen/VendorSide/HomePage.dart';

class SettingScreen extends StatefulWidget {
  final String turfid;
  const SettingScreen(
      {Key? key,
      required this.cutomerid,
      required this.usertype,
      required this.turfid})
      : super(key: key);

  final String cutomerid;
  final String usertype;

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _1hController = TextEditingController();
  final TextEditingController _2hController = TextEditingController();
  final TextEditingController _3hController = TextEditingController();
  final TextEditingController _4hController = TextEditingController();
  final TextEditingController _5hController = TextEditingController();
  final TextEditingController _6hController = TextEditingController();
  final TextEditingController _12hController = TextEditingController();
  final TextEditingController _1hWeekendController = TextEditingController();
  final TextEditingController _2hWeekendController = TextEditingController();
  final TextEditingController _3hWeekendController = TextEditingController();
  final TextEditingController _4hWeekendController = TextEditingController();
  final TextEditingController _5hWeekendController = TextEditingController();
  final TextEditingController _6hWeekendController = TextEditingController();
  final TextEditingController _12hWeekendController = TextEditingController();

  List<String> _typeOptions = ['normal', 'weekend'];
  String _selectedType = 'weekend';

  late SharedPreferences prefs;
  String current_latitude = "";
  String current_longitude = "";
  String user_type = "";
  String contactNo = "";
  String turf_id = "";

  @override
  void initState() {
    super.initState();
    initialize();
  }



/*
  void initialize() async {
    prefs = await SharedPreferences.getInstance();
    turf_id = prefs.getString(turf_id).toString();
    print("turfid ${widget.turfid}");
    List<Map<String, dynamic>> priceList = await fetchPriceList(widget.turfid);

    // List<Map<String, dynamic>> prices = await fetchPriceList(id);



    if (priceList.isNotEmpty) {
      setState(() {
        var normalPrice =
            priceList.firstWhere((element) => element['type'] == 'normal');
        var weekendPrice =
            priceList.firstWhere((element) => element['type'] == 'weekend');

        //normal
        _1hController.text = normalPrice[0]['hourly_price'].toString();
        // _1hController.text = normalPrice[1]['hourly_price'].toString();
        _2hController.text = normalPrice[1]['hourly_price'].toString();
        _3hController.text = normalPrice[2]['hourly_price'].toString();
        _4hController.text = normalPrice[3]['hourly_price'].toString();
        _5hController.text = normalPrice[4]['hourly_price'].toString();
        _6hController.text = normalPrice[5]['hourly_price'].toString();
        _12hController.text = normalPrice[6]['hourly_price'].toString();
        //Weekend

        _1hWeekendController.text = weekendPrice[0]['hourly_price'].toString();
        _2hWeekendController.text = weekendPrice[1]['hourly_price'].toString();
        _3hWeekendController.text = weekendPrice[2]['hourly_price'].toString();
        _4hWeekendController.text = weekendPrice[3]['hourly_price'].toString();
        _5hWeekendController.text = weekendPrice[3]['hourly_price'].toString();
        _6hWeekendController.text = weekendPrice[4]['hourly_price'].toString();
        _12hWeekendController.text = weekendPrice[5]['hourly_price'].toString();


      });
    }
  }
*/


  void initialize() async {
    prefs = await SharedPreferences.getInstance();
    turf_id = prefs.getString(turf_id).toString();
    print("turfid ${widget.turfid}");
    List<Map<String, dynamic>> priceList = await fetchPriceList(widget.turfid);

    if (priceList.isNotEmpty) {
      setState(() {
        var normalPrice = priceList.firstWhere((element) => element['type'] == 'normal', orElse: () => null!);
        var weekendPrice = priceList.firstWhere((element) => element['type'] == 'weekend', orElse: () => null!);

        // Normal Prices
        _1hController.text = normalPrice != null ? priceList[priceList.indexOf(normalPrice)]['hourly_price'].toString() : '';
        _2hController.text = normalPrice != null ? priceList[priceList.indexOf(normalPrice) + 1]['hourly_price'].toString() : '';
        _3hController.text = normalPrice != null ? priceList[priceList.indexOf(normalPrice) + 2]['hourly_price'].toString() : '';
        _4hController.text = normalPrice != null ? priceList[priceList.indexOf(normalPrice) + 3]['hourly_price'].toString() : '';
        _5hController.text = normalPrice != null ? priceList[priceList.indexOf(normalPrice) + 4]['hourly_price'].toString() : '';
        _6hController.text = normalPrice != null ? priceList[priceList.indexOf(normalPrice) + 5]['hourly_price'].toString() : '';
        _12hController.text = normalPrice != null ? priceList[priceList.indexOf(normalPrice) + 6]['hourly_price'].toString() : '';

        // Weekend Prices
        _1hWeekendController.text = weekendPrice != null ? priceList[priceList.indexOf(weekendPrice)]['hourly_price'].toString() : '';
        _2hWeekendController.text = weekendPrice != null ? priceList[priceList.indexOf(weekendPrice) + 1]['hourly_price'].toString() : '';
        _3hWeekendController.text = weekendPrice != null ? priceList[priceList.indexOf(weekendPrice) + 2]['hourly_price'].toString() : '';
        _4hWeekendController.text = weekendPrice != null ? priceList[priceList.indexOf(weekendPrice) + 3]['hourly_price'].toString() : '';
        _5hWeekendController.text = weekendPrice != null ? priceList[priceList.indexOf(weekendPrice) + 4]['hourly_price'].toString() : '';
        _6hWeekendController.text = weekendPrice != null ? priceList[priceList.indexOf(weekendPrice) + 5]['hourly_price'].toString() : '';
        _12hWeekendController.text = weekendPrice != null ? priceList[priceList.indexOf(weekendPrice) + 6]['hourly_price'].toString() : '';
      });
    }
  }




/*
  void initialize() async {
    prefs = await SharedPreferences.getInstance();
    turf_id = prefs.getString(turf_id).toString();
    print("turfid ${widget.turfid}");
    List<Map<String, dynamic>> priceList = await fetchPriceList(widget.turfid);

    if (priceList.isNotEmpty) {
      setState(() {
        for (var price in priceList) {
          switch (price['type']) {
            case 'normal':
              _1hController.text = price['hourly_price'].toString();
              _2hController.text = price['hourly_price'].toString();
              _3hController.text = price['hourly_price'].toString();
              _4hController.text = price['hourly_price'].toString();
              _5hController.text = price['hourly_price'].toString();
              _6hController.text = price['hourly_price'].toString();
              _12hController.text = price['hourly_price'].toString();
              break;
            case 'weekend':
              _1hWeekendController.text = price['hourly_price'].toString();
              _2hWeekendController.text = price['hourly_price'].toString();
              _3hWeekendController.text = price['hourly_price'].toString();
              _4hWeekendController.text = price['hourly_price'].toString();
              _5hWeekendController.text = price['hourly_price'].toString();
              _6hWeekendController.text = price['hourly_price'].toString();
              _12hWeekendController.text = price['hourly_price'].toString();
              break;
          }
        }
      });
    }
  }
*/



/*
  void _submitForm() async {
    print("turfid" + widget.turfid);
    print("_1hController.text: ${_1hController.text}, "
        "_2hController.text: ${_2hController.text}, "
        "_3hController.text: ${_3hController.text}, "
        "_4hController.text: ${_4hController.text}, "
        "_5hController.text: ${_5hController.text}, "
        "_6hController.text: ${_6hController.text}, "
        "_12hController.text: ${_12hController.text}");
    print("type : ${_selectedType}");

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
     if(_selectedType =="normal") {
       List<String> prices = [
         _1hController.text,
         _2hController.text,
         _3hController.text,
         _4hController.text,
         _5hController.text,
         _6hController.text,
         _12hController.text,
       ];
     }
      List<String> numbers = ['1', '2', '3', '4', '5', '6', '12'];

      var headers = {'Cookie': 'session=s0ntuci4jslkmdm4kt7ogrn5sbnjtbq6'};

      for (int i = 0; i < prices.length; i++) {
        var request = http.MultipartRequest('POST',
            Uri.parse('https://taruff.shortlinker.in/api/turf_price_setting'));
        request.fields.addAll({
          'taruff_id': widget.turfid,
          'hourly_number[]': numbers[i],
          'hourly_price[]': prices[i],
          'type[]': _selectedType,
        });
        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          final jsonResponse = await response.stream.bytesToString();
          final parsedResponse = json.decode(jsonResponse);
          if (parsedResponse['status'] == 1) {
            print("success == ${parsedResponse}");
          } else {
            print("faild");
          }
        } else {
          print('Failed to Insert Price');
          Fluttertoast.showToast(msg: "Price Update successfully");
        }
      }
      Fluttertoast.showToast(msg: "Price Update successfully");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeforAdmin(
            cutomerid: widget.cutomerid,
            usertype: user_type,
            contactno: contactNo,
          ),
        ),
      );
      _formKey.currentState!.reset();
    }
  }
*/



  void _submitForm() async {
    print("turfid" + widget.turfid);
    print("_1hController.text: ${_1hController.text}, "
        "_2hController.text: ${_2hController.text}, "
        "_3hController.text: ${_3hController.text}, "
        "_4hController.text: ${_4hController.text}, "
        "_5hController.text: ${_5hController.text}, "
        "_6hController.text: ${_6hController.text}, "
        "_12hController.text: ${_12hController.text}");
    print("type : ${_selectedType}");

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      List<String> prices = [];
      List<String> numbers = ['1', '2', '3', '4', '5', '6', '12'];
      var headers = {'Cookie': 'session=s0ntuci4jslkmdm4kt7ogrn5sbnjtbq6'};

      if(_selectedType =="normal") {
        prices = [
          _1hController.text,
          _2hController.text,
          _3hController.text,
          _4hController.text,
          _5hController.text,
          _6hController.text,
          _12hController.text,
        ];
      } else if (_selectedType =="weekend") {
        prices = [
          _1hWeekendController.text,
          _2hWeekendController.text,
          _3hWeekendController.text,
          _4hWeekendController.text,
          _5hWeekendController.text,
          _6hWeekendController.text,
          _12hWeekendController.text,
        ];
      }

      for (int i = 0; i < prices.length; i++) {
        var request = http.MultipartRequest('POST',
            Uri.parse('https://taruff.shortlinker.in/api/turf_price_setting'));
        request.fields.addAll({
          'taruff_id': widget.turfid,
          'hourly_number[]': numbers[i],
          'hourly_price[]': prices[i],
          'type[]': _selectedType,
        });
        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          final jsonResponse = await response.stream.bytesToString();
          final parsedResponse = json.decode(jsonResponse);
          if (parsedResponse['status'] == 1) {
            print("success == ${parsedResponse}");
          } else {
            print("faild");
          }
        } else {
          print('Failed to Insert Price');
          Fluttertoast.showToast(msg: "Price Update successfully");
        }
      }
      Fluttertoast.showToast(msg: "Price Update successfully");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeforAdmin(
            cutomerid: widget.cutomerid,
            usertype: user_type,
            contactno: contactNo,
          ),
        ),
      );
      _formKey.currentState!.reset();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Settings",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        // 9624555856
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTypeSelection(),
                      SizedBox(height: 20),
                      if (_selectedType == 'normal') ...[
                        _buildNormalForm(),
                      ] else ...[
                        _buildWeekendForm(),
                      ],
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: InkWell(
                          onTap: _submitForm,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Center(
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNormalForm() {
    return Column(
      children: [
        _buildRow('1 Hour Turf Price', _1hController),
        _buildRow('2 Hours Turf Price', _2hController),
        _buildRow('3 Hours Turf Price', _3hController),
        _buildRow('4 Hours Turf Price', _4hController),
        _buildRow('5 Hours Turf Price', _5hController),
        _buildRow('6 Hours Turf Price', _6hController),
        _buildRow('12 Hours Turf Price', _12hController),
      ],
    );
  }

  Widget _buildWeekendForm() {
    return Column(
      children: [
        _buildRow('1 Hour Turf Price', _1hWeekendController),
        _buildRow('2 Hours Turf Price', _2hWeekendController),
        _buildRow('3 Hours Turf Price', _3hWeekendController),
        _buildRow('4 Hours Turf Price', _4hWeekendController),
        _buildRow('5 Hours Turf Price', _5hWeekendController),
        _buildRow('6 Hours Turf Price', _6hWeekendController),
        _buildRow('12 Hours Turf Price',
            _12hWeekendController), // Add more fields for weekend form if needed
      ],
    );
  }

  Widget _buildRow(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: controller,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Enter price',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 05,
                ),
              ),
              keyboardType: TextInputType.number,
              validator: _validateField,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Select Type:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          children: _typeOptions.map((type) {
            return Row(
              children: [
                Radio<String>(
                  value: type,
                  groupValue: _selectedType,
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                ),
                Text(type),
                SizedBox(width: 20),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid price';
    }
    return null;
  }
}
