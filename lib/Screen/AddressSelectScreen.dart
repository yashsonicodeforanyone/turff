import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

import 'package:turfapp/MyConstants/ShColorConstsnts.dart';
import 'package:turfapp/MyConstants/ShConstants.dart';

class MyAddressScreen extends StatefulWidget {



  MyAddressScreen({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyAddressScreenState createState() => _MyAddressScreenState();
}

class _MyAddressScreenState extends State<MyAddressScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        title:  const Text(
          "Select Address",
          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            placesAutoCompleteTextField(),
          ],
        ),
      ),
    );
  }

  placesAutoCompleteTextField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: controller,
        textStyle:  const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w500),
        googleAPIKey: Google_Map_API,
        inputDecoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 05),
          hintText: "Search your location",
       hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w500),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
        debounceTime: 400,
        countries: ["in", "fr"],
        isLatLngRequired: false,
        getPlaceDetailWithLatLng: (Prediction prediction) {
        },

        itemClick: (Prediction prediction) {

          controller.text = prediction.description ?? "";
          controller.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description?.length ?? 0));

          Navigator.pop(context,prediction);
        },
        seperatedBuilder: Divider(),
        // OPTIONAL// If you want to customize list view item builder
        itemBuilder: (context, index, Prediction prediction) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(
                  width: 7,
                ),
                Expanded(child: Text("${prediction.description??""}"))
              ],
            ),
          );
        },

        isCrossBtnShown: true,

        // default 600 ms ,
      ),
    );
  }
}

