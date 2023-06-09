import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import '../blocs/cart/cart_bloc.dart';
import '../models/BMServiceListModel.dart';
import '../utils/BMBottomSheet.dart';
import '../utils/BMColors.dart';
import '../utils/BMCommonWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:collection/collection.dart';

import 'BMServiceComponent2.dart';

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
                      // Text(
                      //   element.time,
                      //   style: secondaryTextStyle(
                      //     color:bmPrimaryColor,
                      //     size: 12,
                      //   ),
                      // ),
                    ],
                  )
                ],
              ).expand(),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      // color: bmPrimaryColor.withAlpha(50),
                      color: Colors.white,
                      borderRadius: radius(100),
                      border: Border.all(color: bmPrimaryColor),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: GestureDetector(
                      onTap: () {
                        showBookBottomSheet(context, widget.imageurl,
                            widget.disc, widget.name, widget.cost);
                      },
                      child: const Icon(
                        Icons.info,
                        // color: bmPrimaryColor,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  8.width,
                  if (isAdded == false)
                    AppButton(
                      width: 60,
                      padding: const EdgeInsets.all(0),
                      shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      // color: bmPrimaryColor,
                      color: Colors.white,

                      onTap: () {
                        if (currentid == widget.storeid || currentid == "") {
                          var snackBar = const SnackBar(
                            dismissDirection: DismissDirection.down,
                            content: Text(
                              'Your Item is added to the Cart',
                              style: TextStyle(color: Colors.white),
                            ),
                          );

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
                            'count': 1,
                            'subname': widget.subname,
                            'catname': widget.catname,
                            'imageurl': widget.imageurl,
                            'name': widget.name,
                          }).then((value) {
                            setState(() {
                              isAdded = true;
                            });
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
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
                          style: boldTextStyle(color: Colors.black, size: 12)),
                    ),
                  if (isAdded == true)
                    AppButton(
                      width: 60,
                      padding: const EdgeInsets.all(0),
                      shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      // color: bmPrimaryColor,
                      color: Colors.black12,
                      onTap: () {
                        var snackBar = const SnackBar(
                          dismissDirection: DismissDirection.down,
                          content: Text(
                            'Already Added',
                            style: TextStyle(color: Colors.grey),
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
                titleText(title: name, size: 24),
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
