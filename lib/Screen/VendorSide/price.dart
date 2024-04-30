import 'package:flutter/material.dart';

class PriceDetailScreen extends StatelessWidget {
  final String? hourlyPrice;
  final String? weekendPrice;

  PriceDetailScreen({this.hourlyPrice, this.weekendPrice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Price Details"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hourly Price: \u20B9${hourlyPrice ?? "N/A"} /-',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Weekend Price: \u20B9${weekendPrice ?? "N/A"} /-',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
