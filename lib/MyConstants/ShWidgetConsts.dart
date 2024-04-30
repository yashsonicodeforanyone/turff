import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:turfapp/Screen/CustomerHistory/CustomerHistoryScreen.dart';

import 'AppCustomDialog.dart';
import 'ShImageConstants.dart';
const verticalmargin20 =  SizedBox(height: 20.0,);
const verticalmargin10 =  SizedBox(height: 10.0,);



showAlert(String message,BuildContext context, String customer_id)
{
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) =>
        CustomDialog(
          title: "Alert",
          description: message,
          buttonText: "Okay",
          image: ic_alert,
          onTap: () {
            Navigator.pop(context);
          },
          colors: Colors.red,
        ),
  );


}
/*

showAlertSuccess(String message,BuildContext context, String customer_id)
{
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) =>
        CustomDialog(
          title: "Success",
          description: message,
          buttonText: "Okay",
          image: ic_success,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerHistoryScreen(cstomer_id: customer_id, contactno:'',)));
          },
          colors: Colors.green,




        ),
  );
}*/


//new


void showAlertSuccessonlyBooking(String message, BuildContext context, String customerId,String user_type,String contactNo) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.green,
    textColor: Colors.white,
    fontSize: 16.0,
  );
  Future.delayed(Duration(seconds: 5), () {
    Navigator.pop(context);
  });

  // Navigate to CustomerHistoryScreen if needed
  // Navigator.push(
  //   context,
  //   MaterialPageRoute(builder: (context) => CustomerHistoryScreen(cstomer_id: customerId, contactno:contactNo,usertype: user_type,)),

}

void showAlertSuccess(String message, BuildContext context, String customerId,String user_type,String contactNo) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.green,
    textColor: Colors.white,
    fontSize: 16.0,
  );
  Navigator.pop(context);


  // Navigate to CustomerHistoryScreen if needed
  // Navigator.push(
  //   context,
  //   MaterialPageRoute(builder: (context) => CustomerHistoryScreen(cstomer_id: customerId, contactno:contactNo,usertype: user_type,)),

}