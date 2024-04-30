import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turfapp/Drawer/drawer.dart';
import 'package:turfapp/MyModel/Profile/cus_getProfile_model.dart';
import 'package:turfapp/MyNetwork/Profile/cus_profile.dart';
import 'package:turfapp/Screen/HomeScreen.dart';
import 'package:turfapp/Screen/VendorSide/HomePage.dart';

import '../MyConstants/ShPrefConstants.dart';

class ProfileForm extends StatefulWidget {
  final String? contactno;
  final String usertype;
  final String user_id;

  const ProfileForm(
      {Key? key, this.contactno, required this.usertype, required this.user_id})
      : super(key: key);

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  TextEditingController nameCtr = TextEditingController();
  TextEditingController mobileCtr = TextEditingController();

  late UserProfile _userProfile =
      UserProfile(name: '', image: '', phone: '', otp: '');

  bool isImagePicked = false;
  late SharedPreferences prefs;
  String user_type = "";
  String contactNo = "";
  File? imageFile;
  String turf_id = '';

  @override
  void initState() {
    super.initState();
    initalize();
    _fetchProfileData();
  }

  void _fetchProfileData() async {
    try {
      UserProfile userProfile = await fetchUserProfile(widget.user_id);
      setState(() {
        _userProfile = userProfile;
        nameCtr.text = _userProfile.name;
        mobileCtr.text = _userProfile.phone;
      });
    } catch (error) {
      print('Error fetching profile data: $error');
    }
  }


  initalize() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      user_type = prefs.getString(sp_usertype).toString();
      contactNo = prefs.getString(sp_contact).toString();
      mobileCtr.text = contactNo;
      turf_id = prefs.getString(sp_turfId).toString();

    });
  }

  showToast(msg) {
    Fluttertoast.showToast(
      msg: "$msg",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP_RIGHT,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 12.0,
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    setState(() {
      if (pickedImage != null) {
        imageFile = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> updateProfile() async {
    var headers = {
      'Cookie': 'ci_session=gvd7qn254clivb53fcfq8bd8rvqljrui',
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://taruff.shortlinker.in/api/update_profile'));
    request.fields.addAll({
      'user_id': widget.user_id,
      'name': nameCtr.text,
    });
    if (imageFile != null) {
      request.files
          .add(await http.MultipartFile.fromPath('img', imageFile!.path));
    }
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var jsonData = json.decode(responseBody);
      if (jsonData['status'] == 1) {
        showToast(jsonData['message']);
        if(user_type == "user") {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(cutomerid: widget.user_id, usertype: user_type,)));
        }
        if(user_type =="vendor"){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeforAdmin(
                  cutomerid: widget.user_id,
                  usertype: user_type, contactno:contactNo
              ),
            ),
          );

        }
      } else {
        showToast('Failed to update profile');
      }
    } else {
      showToast(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Profile",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(80),
                              child: imageFile != null
                                  ? Image.file(
                                      imageFile!.absolute,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                _userProfile.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return CircleAvatar(
                                    backgroundImage:
                                    const AssetImage("assets/profilegrey.jpg",),
                                    radius: width * 0.08,
                                  );
                                },
                              )

                              /*Image.network(
                                          _userProfile.image,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/avtar.png', // Path to your dummy asset image
                                          fit: BoxFit.cover,
                                        ),*/
                              /*Image.network(
                                        _userProfile.image,
                                        fit: BoxFit.cover,
                                      )*/
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(60),
                              onTap: () {
                                showImagePicker(context);
                              },
                              child: Icon(
                                Icons.camera_alt,
                                size: 25,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.05),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      child: TextFormField(
                        controller: nameCtr,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          hintText: 'Enter name',
                          prefixIcon: const Icon(Icons.person_2_outlined),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      child: TextFormField(
                        controller: mobileCtr,
                        readOnly: true, // Make the text field uneditable
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          hintText: 'Mobile',
                          prefixIcon: Icon(Icons.local_phone_outlined),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: height * 0.05),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        height: height * 0.06,
                        width: width * 0.9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.green,
                        ),
                        child: InkWell(
                          onTap: () {
                            if (formkey.currentState!.validate()) {
                              updateProfile();
                            }
                          },
                          child: Center(
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
