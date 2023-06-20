import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../components/BMCommonCardComponent.dart';
import '../components/BMHomeFragmentHeadComponent.dart';
import '../components/BMTopServiceHomeComponent.dart';
import '../models/models.dart';
import '../repositories/stores_repository.dart';
import '../utils/BMColors.dart';
import '../utils/BMCommonWidgets.dart';
import '../utils/BMDataGenerator.dart';

class OffersModel {
  String imageUrl;

  OffersModel({required this.imageUrl});
}

List<OffersModel> getOffers() {
  List<OffersModel> list = [];

  list.add(OffersModel(imageUrl: "assets/Offer1.png"));
  list.add(OffersModel(imageUrl: "assets/Offer2.png"));

  return list;
}

class BMHomeFragment2 extends StatefulWidget {
  final Function(int) onTabChanged;
  String city;

  BMHomeFragment2({required this.onTabChanged, required this.city});

  @override
  State<BMHomeFragment2> createState() => _BMHomeFragmentState2();
}

class _BMHomeFragmentState2 extends State<BMHomeFragment2> {
  final List<BMMasterModel> topServiceList = ServiceList();
  final List<OffersModel> offers = getOffers();
  // late String city1;
  late double latitude;
  late double longitude;
  // late Future<List<BMServiceListModel>> bikepartsList;
  // late Future<List<BMServiceListModel>> bikesList;
  // late Future<List> accessoriesname;

  Future<double> getposition() async {
    bool servicesEnabled = await Geolocator.isLocationServiceEnabled();
    if (!servicesEnabled) {
      return Future.error("Locations services not enabled");
    }
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Locations services denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Locations services denied forever");
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    longitude = position.longitude;

    return latitude = position.latitude;
  }

  @override
  void initState() {
    setStatusBarColor(Colors.black);
    // city1 = widget.city;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<List<BMCommonCardModel>> recommendedList =
        StoresRepository.getStoresList(widget.city);

    Future<List<OfferCardModel>> offersList = StoresRepository.getOffers();

    return Scaffold(
      backgroundColor: bmLightScaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraint) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeFragmentHeadComponent(
                onButtonPressed: widget.onTabChanged,
              ),

              11.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  titleText(title: 'Categories'),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          // BMTopOffersScreen().launch(context);
                        },
                        child: Text('See All',
                            style: boldTextStyle(color: Colors.transparent)),
                      ),
                      const Icon(Icons.arrow_forward_ios,
                          color: Colors.transparent, size: 16),
                    ],
                  )
                ],
              ).paddingSymmetric(horizontal: 16),
              2.height,
              HorizontalList(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  spacing: 16,
                  itemCount: topServiceList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 110,
                      width: 100,
                      child: Stack(
                        children: [
                          Image.asset(
                            topServiceList[index].image,
                            fit: BoxFit.cover,
                          ).cornerRadiusWithClipRRect(16),
                          Container(
                            height: 110,
                            decoration: BoxDecoration(
                              borderRadius: radius(16),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(
                                      1), // Starting color at the bottom
                                  Colors.black.withOpacity(
                                      0), // Fading color towards the top
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.center,
                              ),
                            ),
                          ),
                          // Container(
                          //   // width: 40,
                          //   // height: 36,
                          //   // padding: const EdgeInsets.all(20),
                          //   decoration: BoxDecoration(
                          //       color: Colors.grey.withOpacity(0.3),
                          //       borderRadius: radius(32)),
                          //   child:
                          // ),
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                85.height,
                                Text(topServiceList[index].name,
                                        style: boldTextStyle(
                                            size: 14, color: Colors.white))
                                    .paddingSymmetric(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              16.height,

              FutureBuilder<List<OfferCardModel>>(
                future: offersList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return CarouselSlider(
                      options: CarouselOptions(height: 217.32, autoPlay: true),
                      items: snapshot.data!.map((e) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: bmCommonCachedNetworkImage(e.img,
                                  fit: BoxFit.cover)
                              .cornerRadiusWithClipRRect(20),
                        );
                      }).toList(),
                    );
                  } else if (snapshot.hasError) {
                    print(errorMessage);
                    return Text(errorMessage);
                  } else {
                    return shimmerWidget();
                  }
                },
              ),
              // CarouselSlider(
              //   options: CarouselOptions(height: 257.0),
              //   items: offers.map((e) {
              //     return Builder(
              //       builder: (BuildContext context) {
              //         return Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Container(
              //               width: MediaQuery.of(context).size.width,
              //               decoration: BoxDecoration(color: Color(0xFF181E00)),
              //               child: Image.asset(
              //                 e.imageUrl,
              //                 fit: BoxFit.cover,
              //               )).cornerRadiusWithClipRRect(20),
              //         );
              //       },
              //     );
              //   }).toList(),
              // ),
              16.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  titleText(
                      title: 'Our Stores in ${widget.city.toUpperCase()}',
                      size: 26),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          // BMTopOffersScreen().launch(context);
                        },
                        child: Text('See All',
                            style: boldTextStyle(color: Colors.transparent)),
                      ),
                      const Icon(Icons.arrow_forward_ios,
                          color: Colors.transparent, size: 16),
                    ],
                  )
                ],
              ).paddingSymmetric(horizontal: 16),
              //20.height,
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: Container(
                  width: context.width(),
                  decoration: BoxDecoration(
                    color: bmSecondBackgroundColorLight,
                    borderRadius: radiusOnly(topLeft: 32, topRight: 32),
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        5.height,
                        FutureBuilder<double>(
                            future: getposition(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                      'Error: ${snapshot.error}. Please allow location service in settings'),
                                );
                              }
                              if (snapshot.hasData) {
                                return FutureBuilder<List<BMCommonCardModel>>(
                                  future:
                                      recommendedList, // Assuming recommendedList is of type Future<List<BMCommonCardModel>>
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      // Data is available, map and display the list
                                      return Column(
                                        children: snapshot.data!.map((e) {
                                          return GestureDetector(
                                            onTap: () {},
                                            child: BMCommonCardComponent(
                                              latitude: latitude,
                                              longitude: longitude,
                                              fullScreenComponent: true,
                                              element: e,
                                              isFavList: false,
                                            ).paddingSymmetric(vertical: 10),
                                          );
                                        }).toList(),
                                      ).paddingSymmetric(horizontal: 16);
                                    } else if (snapshot.hasError) {
                                      // Error occurred while fetching data
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      // Data is still loading
                                      return shimmerWidget();
                                    }
                                  },
                                );
                              } else {
                                // Data is still loading
                                return shimmerWidget();
                              }
                            }),
                        2.height,
                      ],
                    ).cornerRadiusWithClipRRectOnly(topRight: 32, topLeft: 32),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget shimmerWidget() {
  return Center(
    child: Container(
      width: double.maxFinite,
      height: 400,
      child: SpinKitFoldingCube(
        color: Colors.redAccent,
        size: 50.0,
      ),
    ),
  );
}
