import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Coming Soon...",style: TextStyle(fontWeight: FontWeight.bold),),
     /* content: Column(
        children: [
          Text("This feature is under development. Stay tuned!"),
          // Add more custom content as needed
        ],
      ),*/
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text("OK"),
        ),
      ],
    );
  }
}

