import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';
import '../components/BMCommonCardComponent.dart';
import '../components/BMHomeFragmentHeadComponent.dart';
import '../components/BMTopServiceHomeComponent.dart';
import '../models/models.dart';
import '../repositories/stores_repository.dart';
import '../utils/BMColors.dart';
import '../utils/BMCommonWidgets.dart';

class BMHomeFragment2 extends StatefulWidget {
  const BMHomeFragment2({Key? key}) : super(key: key);

  @override
  State<BMHomeFragment2> createState() => _BMHomeFragmentState2();
}

class _BMHomeFragmentState2 extends State<BMHomeFragment2> {
  Future<List<BMCommonCardModel>> recommendedList =
      StoresRepository.getStoresList();

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bmLightScaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraint) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeFragmentHeadComponent(),
              20.height,
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
              20.height,
              BMCategoriesHomeComponent(),
              20.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  titleText(title: 'Our Stores (IN YO CITY)'),
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
                                            onTap: () {
                                              // BMSingleComponentScreen(element: e).launch(context);
                                            },
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
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                  },
                                );
                              } else {
                                // Data is still loading
                                return const Center(
                                    child: CircularProgressIndicator());
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
