import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turfapp/MyModel/getuser_suportModel.dart';
import 'package:turfapp/MyNetwork/Vendor/get_userIssueApi.dart';
import 'package:turfapp/MyNetwork/Vendor/replyApi.dart';


class UserSuportFormData extends StatefulWidget {
  final String usertype;
  final String cutomerid;
  final String turf_id;
  const UserSuportFormData({super.key, required this.usertype, required this.cutomerid, required this.turf_id});

  @override
  State<UserSuportFormData> createState() => _UserSuportFormDataState();
}

class _UserSuportFormDataState extends State<UserSuportFormData> {
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.black;
      case 'cancel':
        return Colors.red;
      case 'approved':
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height =  MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "User Messages",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [

        //new
          Expanded(
            child: FutureBuilder<List<UserSuport>>(
              future: fetchUserSupportList(widget.turf_id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<UserSuport> userSupportList = snapshot.data!;
                  if (userSupportList.isEmpty) {
                    return Center(child: Image.asset("assets/no_data.png",scale: 3,));
                  }
                  return ListView.builder(
                    itemCount: userSupportList.length,
                    itemBuilder: (context, index) {
                      UserSuport userSupport = userSupportList[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Name: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '${userSupport.name}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'Email: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '${userSupport.email}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Message: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${userSupport.message}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'Date: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '${userSupport.createdDate.toString()}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              InkWell(
                                onTap: () {
                                  _showMessageDialog(context, widget.cutomerid);
                                },
                                child: Container(
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Reply',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "${snapshot.error}",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
                // By default, show a loading spinner.
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),



          /*  Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 2,
              child: Container(
                color: CupertinoColors.white,
                // height: height * 0.35,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  *//*    Row(
                        children: [
                          Icon(Icons.person),
                          SizedBox(
                            width: 10,
                          ),
                          Text("john "),
                        ],
                      ),
                      SizedBox(height: height * 0.01,),*//*
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                        Text("status :"),
                          Text("Pending",style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: _getStatusColor("pending.status"),
                              fontSize: 16
                          ),)
                      ],),
                      SizedBox(height: height * 0.01,),

                  *//*    Row(
                        children: [
                          Icon(Icons.alternate_email),
                          SizedBox(
                            width: 10,
                          ),
                          Text("john@gmail.com"),
                        ],
                      ),
                      SizedBox(height: height * 0.01,),*//*

                      Row(
                        children: [
                          Icon(Icons.drive_file_rename_outline,color: Colors.green,),
                          SizedBox(
                            width: 10,
                          ),
                          Text("cricket"),
                        ],
                      ),
                      SizedBox(height: height * 0.01,),
                      Row(
                        children: [
                          Icon(Icons.message, color: Colors.green,),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(child: Text(" loss of wildlife habitat when green space is replaced with synthetic turf")),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Icon(Icons.reply, color: Colors.green),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(child: Text(" wait for reply ")),
                        ],
                      ),
                      Container(height: 1,width: width,color: Colors.black12,),
                      SizedBox(height: 10,),

                      InkWell(
                        onTap: (){
                          // showBlockConfirmationDialog(contextt);

                          // showAlertDeleteDialog(context,listBooking[index].id);
                          _showMessageDialog(context, widget.cutomerid);

                        },
                        child:   Container(
                          child: Text('Reply',textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13,color: Colors.white,
                                fontWeight: FontWeight.bold),),

                          decoration: BoxDecoration(
                            color:Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),


                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 100),

                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          )*/
        ],
      ),
    );
  }
  void _showMessageDialog(BuildContext context, String cutomerid) {
    TextEditingController messageController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter Your Message"),
          content: TextField(
            controller: messageController,
            decoration: InputDecoration(hintText: "Enter message here..."),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Okay"),
              onPressed: () {
                String message = messageController.text;
                // Call sendMessage function with id and message
                replyApi(cutomerid, message);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

  }

 /* void sendMessage(String id, String message) {
    // Do something with the id and message here
    print("Sending Message: ID: $id, Message: $message");
  }*/

}
