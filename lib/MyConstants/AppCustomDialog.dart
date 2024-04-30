
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title, description, buttonText, image;
  void Function() onTap;
  Color colors;
  // final Image image;

  CustomDialog({
    required this.title,
    required this.description,
    required this.buttonText,
    required this.image,
    required this.onTap,
    required this.colors,
    // required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: Consts.avatarRadius + Consts.padding,
            // bottom: Consts.padding,
            // left: Consts.padding,
            // right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            // borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                    color: colors,
                  //  fontFamily: fc_Bold
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13.0,
                    //  fontFamily: fc_Regular
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  color: Colors.grey,
                  child: Text(
                    buttonText,
                    textAlign: TextAlign.center,
                   // style: TextStyle(fontFamily: fc_SemiBold),
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned(
          left: Consts.padding,
          right: Consts.padding,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Color(0xFF000000)
                    .withOpacity(0.1), // Set the color of the border
                width: 5.0, // Set the width of the border
              ),
            ),
            child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: Consts.avatarRadius,
                child: Image.asset(
                  image,
                  width: 50,
                )),
          ),
        ),
      ],
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 45.0;
}