import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/BMRoadListModel.dart';
import '../models/models.dart';

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
      );

      storesList.add(cardModel);
    });

    return storesList;
  }

    static Future<List<BMRoadAssListModel>> getRoadAssList()async{
    List<BMRoadAssListModel> storesList = [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('stores').where("roadsideassistance", isEqualTo: true).get();

    querySnapshot.docs.forEach((doc) { 
      String title = doc.data()['storeName'] ?? '';
      String storeUid = doc.data()['storeUid'] ?? '';
      String image = doc.data()['storeAvatarUrl'] ?? '';
      int number = doc.data()['phone'] ?? '';
    

    BMRoadAssListModel cardModel = BMRoadAssListModel(
        storeuid: storeUid,
        image: image,
        name: title,
        number: number
      );

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
      );

      storesList.add(cardModel);
    });

    return storesList;
  }

  static Future<List<BMServiceListModel>> getAccessoriesList(
      String storeUid) async {
    List<BMServiceListModel> storesList = [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('stores')
        .doc(storeUid)
        .collection("menus")
        .where("itemCategory", isEqualTo: "accessories")
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
      );

      storesList.add(cardModel);
    });

    return storesList;
  }

  static Future<List<BMServiceListModel>> getBikepartsList(
      String storeUid) async {
    List<BMServiceListModel> storesList = [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('stores')
        .doc(storeUid)
        .collection("menus")
        .where("itemCategory", isEqualTo: "bikeparts")
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
      );

      storesList.add(cardModel);
    });

    return storesList;
  }

  static Future<List<BMServiceListModel>> getBikesList(String storeUid) async {
    List<BMServiceListModel> storesList = [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('stores')
        .doc(storeUid)
        .collection("menus")
        .where("itemCategory", isEqualTo: "bikes")
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
      );

      storesList.add(cardModel);
    });

    return storesList;
  }
}
