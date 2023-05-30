import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import 'package:http/http.dart';
import 'package:mycycleclinic/models/order.model.dart';
import 'package:mycycleclinic/screens/landing_screen.dart';
import 'package:mycycleclinic/screens/screens.dart';

import '../widgets/widgets.dart';

class LastBookingScreen extends StatefulWidget {
  OrderModel orderModel;

  LastBookingScreen({Key? key, required this.orderModel}) : super(key: key);

  @override
  State<LastBookingScreen> createState() => _LastBookingScreenState();
}

class _LastBookingScreenState extends State<LastBookingScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  _updatingOrderINtoFirebase(String date, String weekday, String time,
      bool isCancelled, String storeId) async {
    String uuid = _auth.currentUser!.uid;

    final doc_store =
        _store.collection("stores").doc(storeId).collection("orders").doc();
    final doc_user =
        _store.collection("users").doc(uuid).collection("orders").doc();

    await doc_store.set(
        {"time": time, "date": date, "weekday": weekday, "user": uuid},
        SetOptions(merge: true));

    await doc_user.set({
      "time": time,
      "date": date,
      "weekday": weekday,
      "isCancelled": isCancelled
    }, SetOptions(merge: true));

    for (var items in widget.orderModel.lstOfItems) {
      await doc_user.set({
        "order": {
          items.get("name"): {
            "cost": items.get("cost"),
            "count": items.get("count"),
            "image": items.get("imageurl")
          },
        }
      }, SetOptions(merge: true));

      await doc_store.set({
        "order": {
          items.get("name"): {
            "cost": items.get("cost"),
            "count": items.get("count"),
            "image": items.get("imageurl")
          },
        }
      }, SetOptions(merge: true));

      widget.orderModel.trackOrder = "placed";
      print(widget.orderModel.trackOrder);
    }
  }

  @override
  void initState() {
    _updatingOrderINtoFirebase(
        widget.orderModel.date,
        widget.orderModel.weekday,
        widget.orderModel.time,
        widget.orderModel.isCancelled,
        widget.orderModel.storeUid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: BottomSheet(
        elevation: 10,
        enableDrag: false,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.height * 0.06),
                  shape: StadiumBorder(),
                  backgroundColor: Colors.white),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("Go Back Home",
                    style: TextStyle(fontSize: 16, color: Colors.black)),
              ),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                    (Route<dynamic> route) => false);
              },
            ),
          );
        },
        onClosing: () {},
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 0.6,
                        spreadRadius: 1),
                  ],
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.done, size: 80, color: Colors.black),
              ),
              Space(16),
              Text(widget.orderModel.isCancelled ? "Cancelled!!" : "Confirmed",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
              Space(32),
              Text(
                widget.orderModel.isCancelled
                    ? "Your booking has been cancelled successfully"
                    : "Your booking has been confirmed for ${widget.orderModel.date}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Visibility(
                visible: widget.orderModel.isCancelled ? false : true,
                child: Column(
                  children: [
                    Space(8),
                    Text(
                      "The designated personal from the store",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Space(32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.timer_outlined, color: Colors.grey),
                        Space(4),
                        Text(widget.orderModel.time,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17)),
                        Space(4),
                        Text("on",
                            style: TextStyle(color: Colors.grey, fontSize: 13)),
                        Space(4),
                        Text(widget.orderModel.weekday,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17)),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}