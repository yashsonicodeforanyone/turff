import 'package:flutter/material.dart';
import 'package:turfapp/MyModel/about_us.dart';
import 'package:turfapp/MyNetwork/aboutAPis.dart';


class AboutUsPage extends StatefulWidget {
  final String cutomerid;
  final String usertype;

  const AboutUsPage({Key? key, required this.cutomerid, required this.usertype}) : super(key: key);

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  late Future<AboutUsModel> _aboutUsData;

  @override
  void initState() {
    super.initState();
    _aboutUsData = ApiService.getAboutUsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "About Us",
          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<AboutUsModel>(
        future: _aboutUsData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: snapshot.hasError
                  ? Image.asset("assets/no_data.png", scale: 3,)
                  : Image.asset("assets/no_data.png", scale: 3,),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.data.length,
              itemBuilder: (context, index) {
                var item = snapshot.data!.data[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    item.content,
                    style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                );
              },
            );
          } else {
            // Handle the case when snapshot doesn't have data
            return Center(
              child: Image.asset("assets/no_data.png", scale: 3,),
            );
          }
        },
      ),

    );
  }
}
