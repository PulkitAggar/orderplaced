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
  String namer;
  String numberr;
  String address;
  String city;
  String state;
  String pincode;
  bool paymentdone;

  LastBookingScreen(
      {Key? key,
      required this.orderModel,
      required this.namer,
      required this.address,
      required this.city,
      required this.state,
      required this.pincode,
      required this.numberr,
      required this.paymentdone
      })
      : super(key: key);

  @override
  State<LastBookingScreen> createState() => _LastBookingScreenState();
}

class _LastBookingScreenState extends State<LastBookingScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  _updatingOrderINtoFirebase(
      String date,
      String weekday,
      String time,
      bool paymentType,
      String storeId,
      String orderStatus,
      String nameR,
      String numberR,
      String addressR,
      String city,
      String state,
      String pincode,
      ) async {
        
    String uuid = _auth.currentUser!.uid;

    final doc = await _store.collection('stores').doc(storeId).get();
    final String name = doc.data()!["storeName"];
    final int numberStore = doc.data()!["phone"];
    final doc2 = await _store.collection('users').doc(uuid).get();
    final String numberUser = doc2.data()!["mobile"];
    final docStore =
        _store.collection("stores").doc(storeId).collection("orders").doc();
    final docUser =
        _store.collection("users").doc(uuid).collection("orders").doc();

    await docStore.set({
      "time": time,
      "date": date,
      "weekday": weekday,
      "user": uuid,
      "orderStatus": orderStatus,
      "nameR": nameR,
      "addressR": addressR,
      "city": city,
      "state": state,
      "pincode": pincode,
      "numberR": numberR,
      "paymentdone":paymentType,
      "numberUser":numberUser
    }, SetOptions(merge: true));

    await docUser.set({
      "time": time,
      "date": date,
      "weekday": weekday,
      "orderStatus": orderStatus,
      "nameR": nameR,
      "addressR": addressR,
      "numberR": numberR,
      "city": city,
      "state": state,
      "pincode": pincode,
      "storeuid": storeId,
      "name": name,
      "paymentdone":paymentType,
      "numberStore":numberStore
    }, SetOptions(merge: true));

    for (var items in widget.orderModel.lstOfItems) {
      
      await docUser.set({
        "order": {
          items.name: {
            "cost": items.cost,
            "count": items.count,
            "image": items.imageUrl,
          },
        }
      }, SetOptions(merge: true));

      await docStore.set({
        "order": {
          items.name: {
            "cost": items.cost,
            "count": items.count,
            "image": items.imageUrl
          },
        }
      }, SetOptions(merge: true));
    }
  }

  @override
  void initState() {
    _updatingOrderINtoFirebase(
      widget.orderModel.date,
      widget.orderModel.weekday,
      widget.orderModel.time,
      widget.paymentdone,
      widget.orderModel.storeUid,
      "placed",
      widget.namer,
      widget.numberr,
      widget.address,
      widget.city,
      widget.state,
      widget.pincode,
      //TODO: add address ,name,number from payment screen
    );
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
              Text("Confirmed",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
              Space(32),
              Text(
                     "Your booking has been confirmed for ${widget.orderModel.date}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Visibility(
                visible:  true,
                child: Column(
                  children: [
                    Space(8),
                    Text(
                      "The designated personal from the store will contact you",
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
