/*
import 'package:flutter/material.dart';

class BlockUserScreen extends StatefulWidget {
  @override
  _BlockUserScreenState createState() => _BlockUserScreenState();
}

class _BlockUserScreenState extends State<BlockUserScreen> {
  bool _blockUser = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Block User'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Block User at Login Time',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text('Block User:'),
              Checkbox(
                value: _blockUser,
                onChanged: (value) {
                  setState(() {
                    _blockUser = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Perform action to block user here
                  if (_blockUser) {
                    // Implement logic to block user
                    print('User blocked at login time');
                  } else {
                    print('User not blocked');
                  }
                },
                child: Text('Block User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

*/




import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class User {
  final String userName;
  final String contactNumber;
  final bool isBooking;
  final String address;

  User({
    required this.userName,
    required this.contactNumber,
    required this.isBooking,
    required this.address,
  });
}

class BlockUserScreen extends StatefulWidget {
  @override
  _BlockUserScreenState createState() => _BlockUserScreenState();
}

class _BlockUserScreenState extends State<BlockUserScreen> {
  List<User> _users = [
    User(
      userName: 'User 1',
      contactNumber: '1234567890',
      isBooking: true,
      address: 'Address 1',
    ),
    User(
      userName: 'User 2',
      contactNumber: '0987654321',
      isBooking: false,
      address: 'Address 2',
    ),
    // Add more users as needed
  ];

 /* void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User's"),

      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return UserItem(
            user: user,
            onBlock: () {
              // Implement block logic here
              print('Blocked ${user.userName}');


            },
          );
        },
      ),
    );
  }
}

class UserItem extends StatelessWidget {
  final User user;
  final VoidCallback onBlock;

  const UserItem({
    Key? key,
    required this.user,
    required this.onBlock,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 1,
        child: ListTile(
          title: Text(user.userName),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Contact Number: ${user.contactNumber}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
              Text('Booking: ${user.isBooking ? 'Yes' : 'No'}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
              Text('Address: ${user.address}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
             /* Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: (){
                      showBlockConfirmationDialog(context);
                      onBlock();
                    },
                    child: Center(
                      child: Container(
                          height: height * 0.05,
                          width: width * 0.6,
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(10),
                            color: Colors.redAccent,
                          ),
                          child: Center(
                            child: Text('Block',style: TextStyle(
                                color: Colors.white,
                                fontWeight:
                                FontWeight.w600,fontSize: 16)),
                          )
                      ),
                    )
                ),
              )*/
            ],
          ),
        ),
      ),
    );

  }
  void showBlockConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Are you sure you want to block this user?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Fluttertoast.showToast(
                  msg: "Blocked ${user.userName}",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                Navigator.of(context).pop();
              },
              child: Text("Block"),
            ),
          ],
        );
      },
    );
  }

}

