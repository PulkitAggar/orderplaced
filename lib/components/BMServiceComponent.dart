import 'dart:async';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:numberpicker/numberpicker.dart';
import '../blocs/cart/cart_bloc.dart';
import '../screens/landing_screen.dart';
import '../utils/BMColors.dart';
import '../utils/BMCommonWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:collection/collection.dart';

class BMServiceComponent extends StatefulWidget {
  BMServiceComponent(
      {required this.name,
      required this.cost,
      required this.imageurl,
      required this.disc,
      required this.storeid,
      required this.subname,
      required this.catname});
  String name;
  String imageurl;
  int cost;
  String disc;
  String storeid;
  String subname;
  String catname;

  @override
  State<BMServiceComponent> createState() => BMServiceComponentState();
}

class BMServiceComponentState extends State<BMServiceComponent> {
  final _auth = FirebaseAuth.instance;
  bool isAdded = false;
  String currentid = "";
  int val = 1;
  int fetched = 0;
  @override
  void initState() {
    addcart();
    super.initState();
    // fetch(widget.name);
  }

  Future<void> fetch(String name) async {
    var doc = await FirebaseFirestore.instance
        .collection("cart")
        .doc("${_auth.currentUser?.email}")
        .collection("cart")
        .get();

    QueryDocumentSnapshot? foundDoc =
        doc.docs.firstWhereOrNull((element) => element.get("name") == name);

    if (doc.docs.isEmpty) {
      if (mounted) {
        setState(() {
          // Your state update code goes here
          isAdded = false;
        });
      }
    }
    if (foundDoc != null) {
      if (mounted) {
        setState(() {
          // Your state update code goes here
          isAdded = true;
        });
      }
    } else if (foundDoc == null) {
      if (mounted) {
        setState(() {
          // Your state update code goes here
          isAdded = false;
        });
      }
    }
  }

  void addcart() async {
    var doc = await FirebaseFirestore.instance
        .collection("cart")
        .doc("${_auth.currentUser?.email}")
        .collection("cart")
        .get();

    FirebaseFirestore.instance
        .collection("cart")
        .doc("${_auth.currentUser?.email}")
        .get()
        .then((value) {
      setState(() {
        currentid = value.get("storeid");
      });

      if (widget.storeid == value.get("storeid")) {
        QueryDocumentSnapshot? foundDoc = doc.docs
            .firstWhereOrNull((element) => element.get("name") == widget.name);
        if (foundDoc == null) {
          setState(() {
            isAdded = false;
          });
        }
        if (foundDoc != null) {
          itemCount();
          setState(() {
            isAdded = true;
          });
        }
      }

      if (widget.storeid != value.get("storeid")) {
        setState(() {
          isAdded = false;
        });
      }
    });
  }

  void itemCount() async {
    var doc = await FirebaseFirestore.instance
        .collection("cart")
        .doc("${_auth.currentUser?.email}")
        .collection("cart")
        .doc("${widget.name}")
        .get()
        .then((value) {
      setState(() {
        fetched = value.get("count");
        val = value.get("count");
      });
    });
  }

  void itemSet() async {
    var doc = await FirebaseFirestore.instance
        .collection("cart")
        .doc("${_auth.currentUser?.email}")
        .collection("cart")
        .doc("${widget.name}")
        .update({
      "count": val,
    });
    setState(() {
      fetched = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(32)),
          margin: const EdgeInsets.only(bottom: 10),
          padding:
              const EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(fontSize: 14, color: Color(0xFFE2FF6D)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // titleText(title: widget.name, size: 14, maxLines: 2),
                  12.height,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'RS.${widget.cost}',
                        style: secondaryTextStyle(
                          // color: bmPrimaryColor,
                          color: Colors.white,
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
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Quantity", style: TextStyle(color: Colors.white)),
                        Row(
                          children: [
                            Text(
                              "$val",
                              style: TextStyle(color: Colors.white),
                            ),
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) {
                                        return WillPopScope(
                                          onWillPop: () async {
                                            return true;
                                          },
                                          child: Center(
                                            child: AlertDialog(
                                                title: const Center(
                                                  child:
                                                      Text("Pick the Quantity"),
                                                ),
                                                content: StatefulBuilder(
                                                    builder:
                                                        (context, SBsetState) {
                                                  return NumberPicker(
                                                    minValue: 1,
                                                    maxValue: 100,
                                                    value: val,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        val = value;
                                                      });
                                                      SBsetState(() {
                                                        val = value;
                                                      });
                                                    },
                                                  );
                                                })),
                                          ),
                                        );
                                      });
                                },
                                icon: const Icon(
                                  Icons.arrow_drop_down_circle_outlined,
                                  color: Colors.white,
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 5),
                  Column(
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            minimumSize: Size(60, 40),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            side: BorderSide(color: Colors.white)),
                        onPressed: () {
                          showBookBottomSheet(context, widget.imageurl,
                              widget.disc, widget.name, widget.cost);
                        },
                        child: Text('SHOW INFO',
                            style:
                                boldTextStyle(color: Colors.white, size: 12)),
                      ),
                      // SizedBox(height: 4),
                      if (isAdded == false)
                        if (FirebaseAuth.instance.currentUser != null)
                          AppButton(
                            width: 60,
                            padding: const EdgeInsets.all(5),
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32)),
                            // color: bmPrimaryColor,
                            color: Colors.white,

                            onTap: () {
                              if (currentid == widget.storeid ||
                                  currentid == "") {
                                FirebaseFirestore.instance
                                    .collection("cart")
                                    .doc("${_auth.currentUser?.email}")
                                    .set({"storeid": widget.storeid});

                                FirebaseFirestore.instance
                                    .collection("cart")
                                    .doc("${_auth.currentUser?.email}")
                                    .collection("cart")
                                    .doc("${widget.name}")
                                    .set({
                                  'cost': widget.cost.toDouble(),
                                  'count': val,
                                  'subname': widget.subname,
                                  'catname': widget.catname,
                                  'imageurl': widget.imageurl,
                                  'name': widget.name,
                                }).then((value) {
                                  setState(() {
                                    isAdded = true;
                                    fetched = val;
                                  });
                                  AnimatedSnackBar.rectangle(
                                    'Success',
                                    'Your Item is added to the Cart',
                                    type: AnimatedSnackBarType.success,
                                    brightness: Brightness.light,
                                  ).show(context);
                                });
                              } else {
                                AnimatedSnackBar.rectangle(
                                  'Failed',
                                  'Items from multiple stores cannot be added at a time. To add items from this store remove items present in the cart from other store.',
                                  type: AnimatedSnackBarType.success,
                                  brightness: Brightness.light,
                                ).show(context);
                              }
                            },
                            child: Text('ADD TO CART',
                                style: boldTextStyle(
                                    color: Colors.black, size: 12)),
                          ),
                      if (FirebaseAuth.instance.currentUser == null)
                        AppButton(
                          width: 60,
                          padding: const EdgeInsets.all(5),
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32)),
                          // color: bmPrimaryColor,
                          color: Colors.white,

                          onTap: () {
                            showAlertDialog(context);
                          },
                          child: Text('ADD TO CART',
                              style:
                                  boldTextStyle(color: Colors.black, size: 12)),
                        ),
                      if (isAdded == true)
                        AppButton(
                          width: 60,
                          padding: const EdgeInsets.all(5),
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          // color: bmPrimaryColor,
                          color: Colors.white,
                          onTap: () {
                            if (fetched != val) {
                              itemSet();
                              AnimatedSnackBar.rectangle(
                                'Success',
                                'Cart Updated Successfully',
                                type: AnimatedSnackBarType.info,
                                brightness: Brightness.light,
                              ).show(context);
                            } else {
                              AnimatedSnackBar.rectangle(
                                'Info',
                                'Already Added',
                                type: AnimatedSnackBarType.info,
                                brightness: Brightness.light,
                              ).show(context);
                            }

                            // showBookBottomSheet(context, element);
                          },
                          child: fetched != val
                              ? Text('UPDATE CART',
                                  style: boldTextStyle(
                                      color: Colors.black, size: 12))
                              : Text('ADDED TO CART',
                                  style: boldTextStyle(
                                      color: Colors.black, size: 12)),
                        ),
                    ],
                  ),
                ],
              )
            ],
          ).paddingSymmetric(vertical: 8),
        ).paddingSymmetric(horizontal: 16);
      },
    );
  }
}

void showBookBottomSheet(
    BuildContext context, String image, String disc, String name, int cost) {
  disc = '\u2022 ' + disc.replaceAll('. ', '.\n\u2022 ');
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
          return SingleChildScrollView(
            child: Column(
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
                titleText(title: name, size: 24, maxLines: 2),
                16.height,
                bmCommonCachedNetworkImage(image, fit: BoxFit.cover),
                // Image.network(
                //   image,
                //   fit: BoxFit.cover,
                // ),
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
            ).paddingAll(16),
          );
        });
      });
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
