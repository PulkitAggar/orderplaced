import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';

class OrderModel {
  String time;
  String weekday;
  String date;
  double cost;
  String trackOrder;
  String storeUid;

  List<DocumentSnapshotPlatform> lstOfItems;

  OrderModel({
    required this.time,
    required this.weekday,
    required this.date,
    required this.trackOrder,
    required this.cost,
    required this.storeUid,
    required this.lstOfItems,
  });
}
