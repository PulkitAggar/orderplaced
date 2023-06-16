import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../models/BMServiceListModel.dart';
import '../repositories/stores_repository.dart';
import '../utils/BMColors.dart';
import '../utils/BMCommonWidgets.dart';
import 'BMServiceComponent.dart';
import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import '../models/models.dart';

final _firebase = FirebaseFirestorePlatform.instance;

class BMOurServiveComponent extends StatefulWidget {
  String storeUid;

  BMOurServiveComponent({required this.storeUid});

  @override
  State<BMOurServiveComponent> createState() => _BMOurServiveComponentState();
}

class _BMOurServiveComponentState extends State<BMOurServiveComponent> {
  late String storeid;
  late Future<List<BMServiceListModel>> servicesList;
  late Future<List<dynamic>> accessoriesList;

  @override
  void initState() {
    super.initState();
    storeid = widget.storeUid;
    servicesList = StoresRepository.getServicesList(storeid);
    accessoriesList =
        StoresRepository.getAccessoriesList(storeid, "Accessories");
  }

  bool collapse = true;

  getbuilder(String n, String id) {
    return ExpansionTile(
        // expandedCrossAxisAlignment: CrossAxisAlignment.start,
        shape: Border(),
        initiallyExpanded: n == 'Services',
        // collapsedBackgroundColor: Colors.black12,
        // backgroundColor: Colors.black12,
        collapsedIconColor: bmSpecialColorDark,
        iconColor: bmSpecialColorDark,
        title: titleText(title: n, size: 24),
        children: [
          n == 'Services'
              ? CarouselSlider(
                  options: CarouselOptions(
                    height: 665.0,
                    enableInfiniteScroll: true,
                    autoPlay: true,
                  ),
                  items: carouselItems.map((item) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 15.0),
                          child: item,
                        );
                      },
                    );
                  }).toList() ):  SizedBox(height: 0),
          StreamBuilder(
              stream: _firebase.collection("subnames").doc(n).snapshots(),
              builder: (context, snapshot) {
                var doc = snapshot.data?.get(id);
                //print(doc as List);
                if (snapshot.hasData) {
                  return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: doc.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ExpansionTile(
                            shape: Border(),
                            initiallyExpanded: n == 'Services',
                            //n=='Services'?
                            collapsedIconColor: bmSpecialColorDark,
                            iconColor: bmSpecialColorDark,
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            title: Text(
                              '${doc[i]}',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 22),
                            ),

                            children: [
                              //SizedBox(height: 10),

                              8.height,

                              StreamBuilder<QuerySnapshotPlatform>(
                                  stream: _firebase
                                      .collection("stores")
                                      .doc(id)
                                      .collection("menus")
                                      .snapshots(),
                                  builder: (context, innershot) {
                                    if (innershot.hasData) {
                                      final messages = innershot.data?.docs;
                                      List<BMServiceComponent> messagewidget =
                                          [];
                                      if (messages != null) {
                                        for (var message in messages) {
                                          final name =
                                              message.data()?["itemName"] ?? "";
                                          final cost = message.get("itemPrice");
                                          final imageurl =
                                              message.get("itemImage");
                                          final subname =
                                              message.get("subname");
                                          final disc = message
                                                  .data()?["itemDescription"] ??
                                              "";

                                          print(name);
                                          if (subname == doc[i]) {
                                            messagewidget
                                                .add(BMServiceComponent(
                                              name: name,
                                              cost: cost,
                                              imageurl: imageurl,
                                              disc: disc,
                                              storeid: id,
                                              subname: doc[i],
                                              catname: n,
                                            ));
                                          }
                                        }
                                      }

                                      //print(messagewidget);
                                      if (innershot.hasData) {
                                        return Column(
                                          children: messagewidget,
                                        );
                                      } else if (innershot.hasError) {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            backgroundColor:
                                                Colors.lightBlueAccent,
                                          ),
                                        );
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            backgroundColor:
                                                Colors.lightBlueAccent,
                                          ),
                                        );
                                      }
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          backgroundColor:
                                              Colors.lightBlueAccent,
                                        ),
                                      );
                                    }
                                  }),
                            ],
                          ),
                        );
                      });
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }
              }),
        ]).cornerRadiusWithClipRRect(32);
  }

  // getbuilder2(list, String name) {
  //   return FutureBuilder<List<BMServiceListModel>>(
  //     future:
  //         list, // Assuming recommendedList is of type Future<List<BMCommonCardModel>>
  //     builder: (context, snapshot) {
  //       if (snapshot.hasData) {
  //         // Data is available, map and display the list
  //         return Column(
  //           mainAxisSize: MainAxisSize.min,
  //           //title: titleText(title: name, size: 24),
  //           children: snapshot.data!.map((e) {
  //             return BMServiceComponent2(
  //               element: e,
  //               storeid: widget.storeUid,
  //             );
  //           }).toList(),
  //         );
  //       } else if (snapshot.hasError) {
  //         // Error occurred while fetching data
  //         return Text('Error: ${snapshot.error}');
  //       } else {
  //         // Data is still loading
  //         return const Center(child: CircularProgressIndicator());
  //       }
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    print(storeid);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 8.height,
        getbuilder("Services", storeid.toString()),
        10.height,
        getbuilder("Accessories", storeid.toString()),
        10.height,
        getbuilder("Bikeparts", storeid.toString()),
        10.height,
        getbuilder("Bikes", storeid.toString())
      ],
    );
  }
}
