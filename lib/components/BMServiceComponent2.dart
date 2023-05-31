import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import 'package:collection/collection.dart';

import '../models/BMServiceListModel.dart';
import '../utils/BMColors.dart';
import '../utils/BMCommonWidgets.dart';

final _firebase = FirebaseFirestorePlatform.instance;

User? loggineduser;

class BMServiceComponent2 extends StatefulWidget {
  BMServiceListModel element;

  BMServiceComponent2({required this.element, required this.storeid});
  String storeid;
  @override
  State<BMServiceComponent2> createState() => _BMServiceComponent2State();
}

class _BMServiceComponent2State extends State<BMServiceComponent2> {
  final _auth = FirebaseAuth.instance;
  int add = 0;
  String currentid = "";
  @override
  void initState() {
    addcart();
    super.initState();
    getuser();
  }

  // Future<void> fetch(String name) async {
  //   var doc = await _firebase
  //       .collection("cart")
  //       .doc("${loggineduser?.email}")
  //       .collection("cart")
  //       .get();
  //   DocumentSnapshotPlatform? foundDoc =
  //       doc.docs.firstWhereOrNull((element) => element.get("name") == name);
  //   if (doc.docs.isEmpty) {
  //     if (mounted) {
  //       setState(() {
  //         // Your state update code goes here
  //         add = 0;
  //       });
  //     }
  //   }
  //   if (foundDoc != null) {
  //     if (mounted) {
  //       setState(() {
  //         // Your state update code goes here
  //         add = 1;
  //       });
  //     }
  //   } else if (foundDoc == null) {
  //     if (mounted) {
  //       setState(() {
  //         // Your state update code goes here
  //         add = 0;
  //       });
  //     }
  //   }
  // }

  void getuser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggineduser = user;
        print(loggineduser?.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void addcart() async {
    var doc = await _firebase
        .collection("cart")
        .doc("${loggineduser?.email}")
        .collection("cart")
        .get();
    FirebaseFirestore.instance
        .collection("cart")
        .doc("${loggineduser?.email}")
        .get()
        .then((value) {
      setState(() {
        currentid = value.get("storeid");
      });
      if (widget.storeid == value.get("storeid")) {
        DocumentSnapshotPlatform? foundDoc = doc.docs.firstWhereOrNull(
            (element) => element.get("name") == widget.element.name);
        if (foundDoc == null) {
          setState(() {
            add = 0;
          });
        }
        if (foundDoc != null) {
          setState(() {
            add = 1;
          });
        }
      }
      if (widget.storeid != value.get("storeid")) {
        setState(() {
          add = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(45)),
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleText(title: widget.element.name, size: 14, maxLines: 2),
              12.height,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'RS.${widget.element.cost}',
                    style: secondaryTextStyle(
                      color: bmPrimaryColor,
                      size: 12,
                    ),
                  ),
                  16.width,
                ],
              )
            ],
          ).expand(),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: bmPrimaryColor.withAlpha(50),
                  borderRadius: radius(100),
                  border: Border.all(color: bmPrimaryColor),
                ),
                padding: EdgeInsets.all(6),
                child: GestureDetector(
                    onTap: () {
                      showBookBottomSheet(
                          context,
                          widget.element.image,
                          widget.element.description,
                          widget.element.name,
                          widget.element.cost);
                    },
                    child: Icon(Icons.info, color: bmPrimaryColor)),
              ),
              8.width,
              if (add == 0)
                AppButton(
                  width: 60,
                  padding: EdgeInsets.all(0),
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  color: bmPrimaryColor,
                  onTap: () {
                    if (currentid == widget.storeid) {
                      var snackBar = const SnackBar(
                        dismissDirection: DismissDirection.down,
                        content: Text(
                          'Your Item is added to the Cart',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                      // showBookBottomSheet(context, element);
                      // fetch(widget.element.name);

                      print(widget.element.image);
                      _firebase
                          .collection("cart")
                          .doc("${loggineduser?.email}")
                          .set({"storeid": widget.storeid});
                      _firebase
                          .collection("cart")
                          .doc("${loggineduser?.email}")
                          .collection("cart")
                          .doc("${widget.element.name}")
                          .set({
                        'cost': widget.element.cost.toDouble(),
                        'count': 1,
                        'imageurl': widget.element.image,
                        'name': widget.element.name
                      }).then((value) {
                        setState(() {
                          add = 1;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      });
                    } else if (currentid == "") {
                      var snackBar = const SnackBar(
                        dismissDirection: DismissDirection.down,
                        content: Text(
                          'Your Item is added to the Cart',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                      _firebase
                          .collection("cart")
                          .doc("${loggineduser?.email}")
                          .set({"storeid": widget.storeid});
                      _firebase
                          .collection("cart")
                          .doc("${loggineduser?.email}")
                          .collection("cart")
                          .doc(widget.element.name)
                          .set({
                        'cost': widget.element.cost.toDouble(),
                        'count': 1,
                        'imageurl': widget.element.image,
                        'name': widget.element.name
                      }).then((value) {
                        setState(() {
                          add = 1;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      });
                    } else {
                      var snackBar = const SnackBar(
                        dismissDirection: DismissDirection.down,
                        content: Text(
                          'Cannot Add multiple store items remove your other store items to add this item',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Text('ADD',
                      style: boldTextStyle(color: Colors.white, size: 12)),
                ),
              if (add != 0)
                AppButton(
                  width: 60,
                  padding: EdgeInsets.all(0),
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  color: bmPrimaryColor,
                  onTap: () {
                    var snackBar = const SnackBar(
                      dismissDirection: DismissDirection.down,
                      content: Text(
                        'Already Added',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    // showBookBottomSheet(context, element);
                  },
                  child: Text('ADDED',
                      style: boldTextStyle(color: Colors.white, size: 12)),
                ),
            ],
          )
        ],
      ).paddingSymmetric(vertical: 8),
    );
  }
}

void showBookBottomSheet(
    BuildContext context, String image, String disc, String name, int cost) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
          borderRadius: radiusOnly(topLeft: 30, topRight: 30)),
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    finish(context);
                  },
                  icon: const Icon(Icons.cancel_rounded,
                      color: bmTextColorDarkMode),
                ),
              ),
              titleText(title: name, size: 24),
              16.height,
              Image.network(
                image,
                fit: BoxFit.cover,
              ),
              // Text(
              //   "NULL available",
              //   style: primaryTextStyle(color:  bmSpecialColorDark),
              // ),
              20.height,

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  titleText(
                      title: "Rs. ${cost.toString()}", size: 16, maxLines: 2),
                  14.height,
                  Text(
                    disc,
                    style: secondaryTextStyle(color: bmPrimaryColor),
                  )
                ],
              ),
              // AppButton(
              //   //padding: EdgeInsets.all(0),
              //   shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
              //   child: Text('Book Now', style: boldTextStyle(color: Colors.white, size: 12)),
              //   color: bmPrimaryColor,
              //   onTap: () {
              //     // BMCalenderScreen(element: element, isStaffBooking: false).launch(context);
              //   },
              // ),
            ],
          ).paddingAll(16);
        });
      });
}
