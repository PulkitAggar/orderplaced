import 'package:cloud_firestore/cloud_firestore.dart';
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
          storeName: storeName,)
          ;

      orders.add(orderModel);
    }

    return orders;
  }
}
