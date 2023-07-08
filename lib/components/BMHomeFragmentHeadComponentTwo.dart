import 'package:flutter/material.dart';
import 'package:mycycleclinic/screens/screens.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/BMColors.dart';
import '../utils/BMCommonWidgets.dart';

class HomeFragmentHeadComponentTwo extends StatelessWidget {
  HomeFragmentHeadComponentTwo();

  @override
  Widget build(BuildContext context) {
    return upperContainer(
      screenContext: context,
      child: Column(
        children: [
          40.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.wb_sunny, color: Colors.amber, size: 50),
                  8.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hey There',
                          style: boldTextStyle(color: Colors.white, size: 24)),

                      // Wrap(
                      //   children: [
                      //     Text('32',
                      //         style:
                      //             boldTextStyle(size: 24, color: Colors.white)),
                      //     Text(
                      //       '°C',
                      //       style: TextStyle(
                      //           fontFeatures: [FontFeature.superscripts()],
                      //           color: Colors.white),
                      //     )
                      //   ],
                      // )
                    ],
                  )
                ],
              ),
              GestureDetector(
                onTap: () {
                  // handleButtonPress();
                  showAlertDialog(context);
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black, borderRadius: radius(100)),
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Sign-In/\nCreate an\nAccount',
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
          16.height,
          // Container(
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: radius(32),
          //   ),
          //   padding: EdgeInsets.symmetric(horizontal: 8),
          //   child: AppTextField(
          //     decoration: InputDecoration(
          //         border: InputBorder.none,
          //         prefixIcon: Icon(Icons.search_sharp, color: bmPrimaryColor),
          //         hintText: 'Search your services..',
          //         hintStyle: boldTextStyle(color: bmPrimaryColor)),
          //     textFieldType: TextFieldType.NAME,
          //     cursorColor: bmPrimaryColor,
          //   ),
          // ),
          // 16.height,
        ],
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("No"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: Text("Yeah, Sure"),
    onPressed: () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (((context) => LandingScreen()))),
          (route) => false);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Hey, Why not join us!!!"),
    content: Text(
        "Sign-In or Create an Account to book a service or order from the stores."),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
