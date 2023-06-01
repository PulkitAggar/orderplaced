import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';

class userOrderModel {
  String time;
  String weekday;
  String date;
  String orderStatus;
  String storeUid;
  bool isCancelled;
  String nameR;
  String addressR;
  String phoneR;
  String storeName;

  Map<String, dynamic> map;
  // List<DocumentSnapshotPlatform> lstOfItems;

  userOrderModel(
      {required this.time,
      required this.storeName,
      required this.weekday,
      required this.date,
      required this.orderStatus,
      required this.storeUid,
      required this.isCancelled,
      required this.map,
      required this.addressR,
      required this.nameR,
      required this.phoneR});
}
