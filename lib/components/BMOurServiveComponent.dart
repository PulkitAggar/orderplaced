import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mycycleclinic/blocs/cart/cart_bloc.dart';
import 'package:mycycleclinic/datamodels/service_model.dart';
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
  late Future<List<ServiceCardModel>> serviceCardList;

  @override
  void initState() {
    super.initState();
    storeid = widget.storeUid;
    serviceCardList = StoresRepository.getServiceCardList(widget.storeUid);
    servicesList = StoresRepository.getServicesList(storeid);
    accessoriesList =
        StoresRepository.getAccessoriesList(storeid, "Accessories");
  }

  bool collapse = true;

  getbuilder(String n, String id) {
    return ExpansionTile(
        // expandedCrossAxisAlignment: CrossAxisAlignment.start,
        shape: const Border(),
        initiallyExpanded: n == 'Services',
        // collapsedBackgroundColor: Colors.black12,
        // backgroundColor: Colors.black12,
        collapsedIconColor: bmSpecialColorDark,
        iconColor: bmSpecialColorDark,
        title: titleText(title: n, size: 24),
        children: [
          n == 'Services'
              ? FutureBuilder<List<ServiceCardModel>>(
                  future: serviceCardList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return CarouselSlider(
                          options: CarouselOptions(
                            height: 500,
                            autoPlay: true,
                            enlargeCenterPage: true,
                          ),
                          items: snapshot.data!.map((e) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24.0),
                                color: const Color(0xFFE2FF6D),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0,
                                        3), // changes the position of the shadow
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 1,
                                    ),
                                    Row(
                                      children: [
                                        const Expanded(
                                          child: SizedBox(
                                            width: 1,
                                          ),
                                        ),
                                        Text(
                                          e.name,
                                          style: const TextStyle(
                                              fontSize: 22,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Expanded(
                                          child: SizedBox(
                                            width: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // SizedBox(
                                    //   height: 10,
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          const Expanded(
                                            child: SizedBox(
                                              width: 1,
                                            ),
                                          ),
                                          Card(
                                            elevation: 10,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(24.0),
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(24.0),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Text(
                                                  'Rs.${e.price}',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 26),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Expanded(
                                            child: SizedBox(
                                              width: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // SizedBox(
                                    //   height: 10,
                                    // ),
                                    // Row(
                                    //   children: [
                                    //     // Expanded(
                                    //     //   child: SizedBox(
                                    //     //     width: 1,
                                    //     //   ),
                                    //     // ),
                                    //     Text(
                                    //       'Services Not Included',
                                    //       style: TextStyle(
                                    //           fontSize: 22,
                                    //           color: Colors.black,
                                    //           fontWeight: FontWeight.bold),
                                    //     ),
                                    //     // Expanded(
                                    //     //   child: SizedBox(
                                    //     //     width: 1,
                                    //     //   ),
                                    //     // ),
                                    //   ],
                                    // ),
                                    // ListView.builder(
                                    //     shrinkWrap: true,
                                    //     physics: NeverScrollableScrollPhysics(),
                                    //     itemCount: e.invalid.length,
                                    //     itemBuilder: (context, index) {
                                    //       return Row(
                                    //         children: [
                                    //           Icon(
                                    //             Icons.cancel,
                                    //             color: Colors.red,
                                    //             size: 18,
                                    //           ),
                                    //           SizedBox(
                                    //             width: 5,
                                    //           ),
                                    //           Expanded(
                                    //             child: Text(
                                    //               e.invalid[index],
                                    //               maxLines: 1,
                                    //               overflow:
                                    //                   TextOverflow.ellipsis,
                                    //             ),
                                    //             flex: 7,
                                    //           ),
                                    //           Expanded(
                                    //             child: SizedBox(
                                    //               width: 1,
                                    //             ),
                                    //             flex: 1,
                                    //           ),
                                    //         ],
                                    //       );
                                    //     }),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: e.valid.length,
                                        itemBuilder: (context, index) {
                                          return Row(
                                            children: [
                                              const Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                                size: 18,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  e.valid[index],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                flex: 7,
                                              ),
                                              const Expanded(
                                                child: SizedBox(
                                                  width: 1,
                                                ),
                                                flex: 1,
                                              ),
                                            ],
                                          );
                                        }),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: e.invalid.length,
                                        itemBuilder: (context, index) {
                                          return Row(
                                            children: [
                                              const Icon(
                                                Icons.cancel,
                                                color: Colors.red,
                                                size: 18,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  e.invalid[index],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                flex: 7,
                                              ),
                                              const Expanded(
                                                child: SizedBox(
                                                  width: 1,
                                                ),
                                                flex: 1,
                                              ),
                                            ],
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            );
                          }).toList());
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                )
              // ? CarouselSlider(
              //     options: CarouselOptions(
              //       height: 665.0,
              //       enableInfiniteScroll: true,
              //       autoPlay: true,
              //     ),
              //     items: carouselItems.map((item) {
              //       return Builder(
              //         builder: (BuildContext context) {
              //           return Container(
              //             width: MediaQuery.of(context).size.width,
              //             margin: EdgeInsets.symmetric(horizontal: 15.0),
              //             child: item,
              //           );
              //         },
              //       );
              //     }).toList() )
              : const SizedBox(height: 0),
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
                            shape: const Border(),
                            initiallyExpanded: n == 'Services',
                            //n=='Services'?
                            collapsedIconColor: bmSpecialColorDark,
                            iconColor: bmSpecialColorDark,
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            title: Text(
                              '${doc[i]}',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 22),
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
