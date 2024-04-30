import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RejectedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Sorry, you are rejected. Please try again.",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
