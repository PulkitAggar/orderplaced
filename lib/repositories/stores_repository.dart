import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/BMRoadListModel.dart';
import '../models/models.dart';
import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';

import '../models/order.model.dart';
import '../models/userordermodel.dart';

class StoresRepository {
  static Future<List<BMCommonCardModel>> getStoresList() async {
    List<BMCommonCardModel> storesList = [];

    // Fetch data from Firestore
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('stores').get();

    // Process each document in the query snapshot
    querySnapshot.docs.forEach((doc) {
      String title = doc.data()['storeName'] ?? '';

      String subtitle = doc.data()['address'] ?? '';

      String storeUid = doc.data()['storeUid'] ?? '';

      String image = doc.data()['storeAvatarUrl'] ?? '';

      double latitude = double.parse(doc.data()['lat'] ?? 0);

      double longitude = double.parse(doc.data()['lng'] ?? 0);

      int number = doc.data()['phone'] ?? 0;

      // double distance = doc['distance'].toDouble();
      String distance = "0.00";

      bool saveTag = false;

      BMCommonCardModel cardModel = BMCommonCardModel(
        storeUid: storeUid,
        title: title,
        subtitle: subtitle,
        image: image,
        distance: distance,
        saveTag: saveTag,
        latitude: latitude,
        longitude: longitude,
        number: number,
      );

      storesList.add(cardModel);
    });

    return storesList;
  }

  static Future<List<BMRoadAssListModel>> getRoadAssList() async {
    List<BMRoadAssListModel> storesList = [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('stores')
        .where("roadsideassistance", isEqualTo: true)
        .get();

    querySnapshot.docs.forEach((doc) {
      String title = doc.data()['storeName'] ?? '';
      String storeUid = doc.data()['storeUid'] ?? '';
      String image = doc.data()['storeAvatarUrl'] ?? '';
      int number = doc.data()['phone'] ?? '';

      BMRoadAssListModel cardModel = BMRoadAssListModel(
          storeuid: storeUid, image: image, name: title, number: number);

      storesList.add(cardModel);
    });
    return storesList;
  }

  // StreamBuilder<QuerySnapshot>(
  //           stream: FirebaseFirestore.instance
  //               .collection("sellers")
  //               .doc(widget.model!.sellerUID)
  //               .collection("menus")
  //               .doc(widget.model!.menuID)
  //               .collection("items")
  //               .orderBy("publishedDate", descending: true)
  //               .snapshots(),

  static Future<List<BMServiceListModel>> getServicesList(
      String storeUid) async {
    List<BMServiceListModel> storesList = [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('stores')
        .doc(storeUid)
        .collection("menus")
        .where("itemCategory", isEqualTo: "services")
        .get();

    querySnapshot.docs.forEach((doc) {
      String name = doc.data()['itemName'] ?? '';

      int cost = doc.data()['itemPrice'] ?? '';

      String description = doc.data()['itemDescription'] ?? '';

      String image = doc.data()['itemImage'] ?? '';

      BMServiceListModel cardModel = BMServiceListModel(
        name: name,
        cost: cost,
        description: description,
        image: image,
        subname: '',
      );

      storesList.add(cardModel);
    });

    return storesList;
  }

  static Future<List<dynamic>> getAccessoriesList(
      String storeUid, String name) async {
    List<BMServiceListModel> storesList = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('stores')
        .doc(storeUid)
        .collection("menus")
        .where("itemCategory", isEqualTo: "accessories")
        .where("subname", isEqualTo: name)
        .get();

    querySnapshot.docs.forEach((doc) {
      String name = doc.data()['itemName'] ?? '';

      int cost = doc.data()['itemPrice'] ?? '';

      String description = doc.data()['itemDescription'] ?? '';

      String image = doc.data()['itemImage'] ?? '';
      String subname = doc.data()["subname"] ?? "";

      BMServiceListModel cardModel = BMServiceListModel(
        name: name,
        cost: cost,
        description: description,
        image: image,
        subname: subname,
      );

      storesList.add(cardModel);
    });

    return storesList;
  }

  static Future<List<BMServiceListModel>> getBikepartsList(
      String storeUid, String name) async {
    List<BMServiceListModel> storesList = [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('stores')
        .doc(storeUid)
        .collection("menus")
        .where("itemCategory", isEqualTo: "bikeparts")
        .where("subname", isEqualTo: name)
        .get();

    querySnapshot.docs.forEach((doc) {
      String name = doc.data()['itemName'] ?? '';

      int cost = doc.data()['itemPrice'] ?? '';

      String description = doc.data()['itemDescription'] ?? '';

      String image = doc.data()['itemImage'] ?? '';
      String subname = doc.data()["subname"] ?? "";
      BMServiceListModel cardModel = BMServiceListModel(
        name: name,
        cost: cost,
        description: description,
        image: image,
        subname: subname,
      );

      storesList.add(cardModel);
    });

    return storesList;
  }

  static Future<List<BMServiceListModel>> getBikesList(
      String storeUid, String name) async {
    List<BMServiceListModel> storesList = [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('stores')
        .doc(storeUid)
        .collection("menus")
        .where("itemCategory", isEqualTo: "bikes")
        .where("subname", isEqualTo: name)
        .get();

    querySnapshot.docs.forEach((doc) {
      String name = doc.data()['itemName'] ?? '';

      int cost = doc.data()['itemPrice'] ?? '';

      String description = doc.data()['itemDescription'] ?? '';

      String image = doc.data()['itemImage'] ?? '';
      String subname = doc.data()["subname"] ?? "";

      BMServiceListModel cardModel = BMServiceListModel(
        name: name,
        cost: cost,
        description: description,
        image: image,
        subname: subname,
      );

      storesList.add(cardModel);
    });

    return storesList;
  }

  static Future<List<userOrderModel>> getStoreDataList(String uid) async {
    List<userOrderModel> orders = [];

    // Fetch data from Firestore
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(uid)
        .collection('orders')
        .where("orderStatus", isNotEqualTo: "Delivered")
        .get();

    // Process each document in the query snapshot
    for (var doc in querySnapshot.docs) {
      String date = doc.data()['date'] ?? '';

      String time = doc.data()['time'] ?? '';

      String storeid = doc.data()['storeuid'] ?? '';

      bool paymentType = doc.data()['isCancelled'] ?? false;

      String weekday = doc.data()['weekday'] ?? '';
      String orderStatus = doc.data()['orderStatus'] ?? '';
      String nameR = doc.data()['nameR'] ?? '';
      String phoneR = doc.data()['numberR'] ?? '';
      String addressR = doc.data()['addressR'] ?? '';
      // List<DocumentSnapshotPlatform> list = doc.data()['order'] ?? [];
      Map<String, dynamic> map = doc.data()['order'] ?? [];
      String storeName = doc.data()['name'] ?? '';

      userOrderModel orderModel = userOrderModel(
        date: date,
        weekday: weekday,
        time: time,
        storeUid: storeid,
        isCancelled: paymentType,
        orderStatus: orderStatus,
        addressR: addressR,
        nameR: nameR,
        phoneR: phoneR,
        map: map,
        storeName: storeName,
      );

      orders.add(orderModel);
    }

    return orders;
  }

  static Future<List<userOrderModel>> getPastStoreDataList(String uid) async {
    List<userOrderModel> orders = [];

    // Fetch data from Firestore
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(uid)
        .collection('orders')
        .where("orderStatus", isEqualTo: "Delivered")
        .get();

    // Process each document in the query snapshot
    for (var doc in querySnapshot.docs) {
      String date = doc.data()['date'] ?? '';

      String time = doc.data()['time'] ?? '';

      String storeid = doc.data()['storeuid'] ?? '';

      bool paymentType = doc.data()['isCancelled'] ?? false;

      String weekday = doc.data()['weekday'] ?? '';
      String orderStatus = doc.data()['orderStatus'] ?? '';
      String nameR = doc.data()['nameR'] ?? '';
      String phoneR = doc.data()['numberR'] ?? '';
      String addressR = doc.data()['addressR'] ?? '';
      // List<DocumentSnapshotPlatform> list = doc.data()['order'] ?? [];
      Map<String, dynamic> map = doc.data()['order'] ?? [];
      String storeName = doc.data()['name'] ?? '';

      userOrderModel orderModel = userOrderModel(
        date: date,
        weekday: weekday,
        time: time,
        storeUid: storeid,
        isCancelled: paymentType,
        orderStatus: orderStatus,
        addressR: addressR,
        nameR: nameR,
        phoneR: phoneR,
        map: map,
        storeName: storeName,
      );

      orders.add(orderModel);
    }

    return orders;
  }
}

List<Container> carouselItems = [
  Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24.0),
      color: Color(0xFFE2FF6D),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3), // changes the position of the shadow
        ),
      ],
    ),
    padding: EdgeInsets.all(8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                width: 1,
              ),
            ),
            Text(
              'Safety Service',
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: SizedBox(
                width: 1,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  width: 1,
                ),
              ),
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Rs.500',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: 1,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text('\u2022Frame alignment check and visual damage inspection'),
        Text('\u2022Botton bracket check and adjustment'),
        Text('\u2022Check and adjust wedge nut'),
        Text('\u2022Wheel truing and spoke tensioned'),
        Text('\u2022Tyre condition and pressure check'),
        Text('\u2022Axle and quick release check'),
        Text('\u2022Hub bearing check and adjustment'),
        Text('\u2022Chain set removal and clean'),
        Text('\u2022Bike cleaning'),
        Text('\u2022Lubrication of drive trains and pivot points'),
        Text('\u2022Bolt torque check'),
        Text('\u2022Road test ride'),
        Text('\u2022Suspension advisory'),
        Text('\u2022Full workshop report including future advices'),
        Stack(
          children: [
            Text(
              '\u2022Headset stripped, cleaned and greased',
              style: TextStyle(color: Colors.grey),
            ),
            Positioned(
              child: Divider(
                color: Colors.grey,
                height: 1.0,
                thickness: 1.0,
              ),
              left: 0,
              right: 0,
              top: 8,
            )
          ],
        ),
        Stack(
          children: [
            Text(
              '\u2022BB removed, cleaned, re-greased and torqued',
              style: TextStyle(color: Colors.grey),
            ),
            Positioned(
              child: Divider(
                color: Colors.grey,
                height: 1.0,
                thickness: 1.0,
              ),
              left: 0,
              right: 0,
              top: 8,
            )
          ],
        ),
        Stack(
          children: [
            Text(
              '\u2022Hub striped, cleaned and greased',
              style: TextStyle(color: Colors.grey),
            ),
            Positioned(
              child: Divider(
                color: Colors.grey,
                height: 1.0,
                thickness: 1.0,
              ),
              left: 0,
              right: 0,
              top: 8,
            )
          ],
        ),
        Stack(
          children: [
            Text(
              '\u2022Removal and re-grease of seat-post',
              style: TextStyle(color: Colors.grey),
            ),
            Positioned(
              child: Divider(
                color: Colors.grey,
                height: 1.0,
                thickness: 1.0,
              ),
              left: 0,
              right: 0,
              top: 8,
            )
          ],
        ),
        Stack(
          children: [
            Text(
              '\u2022Pedal removed, thread cleaned, re-greased and torqued',
              style: TextStyle(color: Colors.grey),
            ),
            Positioned(
              child: Divider(
                color: Colors.grey,
                height: 1.0,
                thickness: 1.0,
              ),
              left: 0,
              right: 0,
              top: 8,
            )
          ],
        ),
        Stack(
          children: [
            Text(
              '\u2022Brakes and Gear - Inner Cable(free replacement)',
              style: TextStyle(color: Colors.grey),
            ),
            Positioned(
              child: Divider(
                color: Colors.grey,
                height: 1.0,
                thickness: 1.0,
              ),
              left: 0,
              right: 0,
              top: 8,
            )
          ],
        ),
        Stack(
          children: [
            Text(
              '\u2022All cables lubricated',
              style: TextStyle(color: Colors.grey),
            ),
            Positioned(
              child: Divider(
                color: Colors.grey,
                height: 1.0,
                thickness: 1.0,
              ),
              left: 0,
              right: 0,
              top: 8,
            )
          ],
        ),
        Stack(
          children: [
            Text(
              '\u2022Adjustment for better cycling comfort',
              style: TextStyle(color: Colors.grey),
            ),
            Positioned(
              child: Divider(
                color: Colors.grey,
                height: 1.0,
                thickness: 1.0,
              ),
              left: 0,
              right: 0,
              top: 8,
            )
          ],
        ),
        Stack(
          children: [
            Text(
              '\u2022Frame and fork polish',
              style: TextStyle(color: Colors.grey),
            ),
            Positioned(
              child: Divider(
                color: Colors.grey,
                height: 1.0,
                thickness: 1.0,
              ),
              left: 0,
              right: 0,
              top: 8,
            )
          ],
        ),
        Stack(
          children: [
            Text(
              '\u2022Hydraulic brake fluid changed',
              style: TextStyle(color: Colors.grey),
            ),
            Positioned(
              child: Divider(
                color: Colors.grey,
                height: 1.0,
                thickness: 1.0,
              ),
              left: 0,
              right: 0,
              top: 8,
            )
          ],
        ),
        Stack(
          children: [
            Text(
              '\u2022All bolts cleaned, greased and torqued',
              style: TextStyle(color: Colors.grey),
            ),
            Positioned(
              child: Divider(
                color: Colors.grey,
                height: 1.0,
                thickness: 1.0,
              ),
              left: 0,
              right: 0,
              top: 8,
            )
          ],
        ),
        Stack(
          children: [
            Text(
              '\u2022Any frame facing required',
              style: TextStyle(color: Colors.grey),
            ),
            Positioned(
              child: Divider(
                color: Colors.grey,
                height: 1.0,
                thickness: 1.0,
              ),
              left: 0,
              right: 0,
              top: 8,
            )
          ],
        ),
        Stack(
          children: [
            Text(
              '\u2022Bicycle care advised',
              style: TextStyle(color: Colors.grey),
            ),
            Positioned(
              child: Divider(
                color: Colors.grey,
                height: 1.0,
                thickness: 1.0,
              ),
              left: 0,
              right: 0,
              top: 8,
            )
          ],
        ),
      ],
    ),
  ),
  Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24.0),
      color: Colors.greenAccent,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3), // changes the position of the shadow
        ),
      ],
    ),
    padding: EdgeInsets.all(8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                width: 1,
              ),
            ),
            Text(
              'General Service',
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: SizedBox(
                width: 1,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  width: 1,
                ),
              ),
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Rs.1000',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: 1,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text('\u2022Frame alignment check and visual damage inspection'),
        Text('\u2022Botton bracket check and adjustment'),
        Text('\u2022Check and adjust wedge nut'),
        Text('\u2022Wheel truing and spoke tensioned'),
        Text('\u2022Tyre condition and pressure check'),
        Text('\u2022Axle and quick release check'),
        Text('\u2022Hub bearing check and adjustment'),
        Text('\u2022Chain set removal and clean'),
        Text('\u2022Bike cleaning'),
        Text('\u2022Lubrication of drive trains and pivot points'),
        Text('\u2022Bolt torque check'),
        Text('\u2022Road test ride'),
        Text('\u2022Suspension advisory'),
        Text('\u2022Full workshop report including future advices'),
        Text('\u2022Headset stripped, cleaned and greased'),
        Text('\u2022BB removed, cleaned, re-greased and torqued'),
        Text('\u2022Hub striped, cleaned and greased'),
        Text('\u2022Removal and re-grease of seat-post'),
        Text('\u2022Pedal removed, thread cleaned, re-greased and torqued'),
        Text('\u2022Brakes and Gear - Inner Cable(free replacement)'),
        Text('\u2022All cables lubricated'),
        Text('\u2022Adjustment for better cycling comfort'),
        Stack(
          children: [
            Text(
              '\u2022Frame and fork polish',
              style: TextStyle(color: Colors.grey),
            ),
            Positioned(
              child: Divider(
                color: Colors.grey,
                height: 1.0,
                thickness: 1.0,
              ),
              left: 0,
              right: 0,
              top: 8,
            )
          ],
        ),
        Stack(
          children: [
            Text(
              '\u2022Hydraulic brake fluid changed',
              style: TextStyle(color: Colors.grey),
            ),
            Positioned(
              child: Divider(
                color: Colors.grey,
                height: 1.0,
                thickness: 1.0,
              ),
              left: 0,
              right: 0,
              top: 8,
            )
          ],
        ),
        Stack(
          children: [
            Text(
              '\u2022All bolts cleaned, greased and torqued',
              style: TextStyle(color: Colors.grey),
            ),
            Positioned(
              child: Divider(
                color: Colors.grey,
                height: 1.0,
                thickness: 1.0,
              ),
              left: 0,
              right: 0,
              top: 8,
            )
          ],
        ),
        Stack(
          children: [
            Text(
              '\u2022Any frame facing required',
              style: TextStyle(color: Colors.grey),
            ),
            Positioned(
              child: Divider(
                color: Colors.grey,
                height: 1.0,
                thickness: 1.0,
              ),
              left: 0,
              right: 0,
              top: 8,
            )
          ],
        ),
        Stack(
          children: [
            Text(
              '\u2022Bicycle care advised',
              style: TextStyle(color: Colors.grey),
            ),
            Positioned(
              child: Divider(
                color: Colors.grey,
                height: 1.0,
                thickness: 1.0,
              ),
              left: 0,
              right: 0,
              top: 8,
            )
          ],
        ),
      ],
    ),
  ),
  Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24.0),
      color: Colors.red,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3), // changes the position of the shadow
        ),
      ],
    ),
    padding: EdgeInsets.all(8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                width: 1,
              ),
            ),
            Text(
              'Overhaul Service',
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: SizedBox(
                width: 1,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  width: 1,
                ),
              ),
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Rs.1500',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: 1,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text('\u2022Frame alignment check and visual damage inspection'),
        Text('\u2022Botton bracket check and adjustment'),
        Text('\u2022Check and adjust wedge nut'),
        Text('\u2022Wheel truing and spoke tensioned'),
        Text('\u2022Tyre condition and pressure check'),
        Text('\u2022Axle and quick release check'),
        Text('\u2022Hub bearing check and adjustment'),
        Text('\u2022Chain set removal and clean'),
        Text('\u2022Bike cleaning'),
        Text('\u2022Lubrication of drive trains and pivot points'),
        Text('\u2022Bolt torque check'),
        Text('\u2022Road test ride'),
        Text('\u2022Suspension advisory'),
        Text('\u2022Full workshop report including future advices'),
        Text('\u2022Headset stripped, cleaned and greased'),
        Text('\u2022BB removed, cleaned, re-greased and torqued'),
        Text('\u2022Hub striped, cleaned and greased'),
        Text('\u2022Removal and re-grease of seat-post'),
        Text('\u2022Pedal removed, thread cleaned, re-greased and torqued'),
        Text('\u2022Brakes and Gear - Inner Cable(free replacement)'),
        Text('\u2022All cables lubricated'),
        Text('\u2022Adjustment for better cycling comfort'),
        Text('\u2022Frame and fork polish'),
        Text('\u2022Hydraulic brake fluid changed'),
        Text('\u2022All bolts cleaned, greased and torqued'),
        Text('\u2022Any frame facing required'),
        Text('\u2022Bicycle care advised'),
      ],
    ),
  ),
];

//