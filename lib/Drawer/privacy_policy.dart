import 'package:flutter/material.dart';
import 'package:turfapp/MyModel/cancellation_policy.dart';

import '../MyNetwork/cancellation_policy.dart';

class PrivacyPolicyPage extends StatefulWidget {
  final String cutomerid;
  final String usertype;

  PrivacyPolicyPage({Key? key, required this.cutomerid, required this.usertype}) : super(key: key);

  @override
  _PrivacyPolicyPageState createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  late Future<CancellationPolicyModel> _cancellationPolicyData;

  @override
  void initState() {
    super.initState();
    _cancellationPolicyData = ApiService.getCancellationPolicyData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Privacy Policy",
          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<CancellationPolicyModel>(
        future: _cancellationPolicyData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                _buildPolicyContent(snapshot.data!),
                Image.asset("assets/no_data.png", scale: 3,),

              ],
            );
          } else if (snapshot.hasError) {
            return  Center(child: Image.asset("assets/no_data.png",scale: 3,));
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildPolicyContent(CancellationPolicyModel model) {
    return ListView.builder(
      itemCount: model.data.length,
      itemBuilder: (context, index) {
        var item = model.data[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                item.content,
                style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );
      },
    );
  }
}
