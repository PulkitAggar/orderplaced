import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mycycleclinic/fragments/BMHomeFragment2.dart';
import 'package:mycycleclinic/screens/home_screen.dart';
import 'package:mycycleclinic/utils/BMColors.dart';
import 'package:mycycleclinic/utils/BMCommonWidgets.dart';
import 'package:nb_utils/nb_utils.dart';

class SelectCityScreen extends StatefulWidget {
  SelectCityScreen({super.key});

  @override
  State<SelectCityScreen> createState() => _SelectCityScreenState();
}

class _SelectCityScreenState extends State<SelectCityScreen> {
  Future<List<RoomFinderModel>> locationListData = locationList();

  @override
  void initState() {
    setStatusBarColor(Colors.black);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              16.height,
              Text('Popular cities',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: bmPrimaryColor)),
              16.height,
              FutureBuilder<List<RoomFinderModel>>(
                  future: locationListData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: snapshot.data!.map((e) {
                            return RFLocationComponent(locationData: e);
                          }).toList());
                    } else {
                      return shimmerWidget();
                    }
                  }),
            ],
          ),
        ),
      ),
    ));
  }
}

class RFLocationComponent extends StatelessWidget {
  final RoomFinderModel locationData;
  final bool? locationWidth;

  RFLocationComponent({required this.locationData, this.locationWidth});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (locationData.price == 'Coming soon...') {
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => DashboardScreen(locationData.location)));
        }
      },
      child: Stack(
        children: [
          bmCommonCachedNetworkImage(
            locationData.img.validate(),
            fit: BoxFit.cover,
            height: 170,
            width: context.width() * 0.47 - 16,
          ).cornerRadiusWithClipRRect(10),
          Container(
            height: 170,
            width: context.width() * 0.47 - 16,
            decoration: boxDecorationWithRoundedCorners(
                backgroundColor: black.withOpacity(0.2)),
          ).cornerRadiusWithClipRRect(10),
          Container(
            height: 170,
            width: context.width() * 0.47 - 16,
            decoration: BoxDecoration(
              borderRadius: radius(10),
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.7), // Starting color at the bottom
                  Colors.black.withOpacity(0), // Fading color towards the top
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.center,
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: white, size: 18),
                    8.width,
                    Text(locationData.location.validate(),
                        style: boldTextStyle(color: white)),
                  ],
                ),
                4.height,
                Text(locationData.price.validate(),
                        style: secondaryTextStyle(color: white))
                    .paddingOnly(left: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<List<RoomFinderModel>> locationList() async {
  List<RoomFinderModel> locationListData = [];

  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('cities').get();

  querySnapshot.docs.forEach((doc) {
    String img = doc.data()['img'] ?? '';

    String location = doc.data()['name'] ?? '';

    String price = doc.data()['stores'] ?? '';

    RoomFinderModel model = RoomFinderModel(
      img: img,
      location: location,
      price: price,
    );

    locationListData.add(model);
  });

  return locationListData;
}

class RoomFinderModel {
  String? img;
  String? price;
  String location;

  RoomFinderModel({
    this.img,
    this.price,
    required this.location,
  });
}

const rf_location1 = "assets/images/rf_location1.jpg";
const rf_location2 = "assets/images/rf_location2.jpg";
const rf_location3 = "assets/images/rf_location3.jpg";
const rf_location4 = "assets/images/rf_location4.jpg";
const rf_location5 = "assets/images/rf_location5.jpg";
const rf_location6 = "assets/images/rf_location6.jpg";

Decoration boxDecorationWithRoundedCorners({
  Color backgroundColor = whiteColor,
  BorderRadius? borderRadius,
  LinearGradient? gradient,
  BoxBorder? border,
  List<BoxShadow>? boxShadow,
  DecorationImage? decorationImage,
  BoxShape boxShape = BoxShape.rectangle,
}) {
  return BoxDecoration(
    color: backgroundColor,
    borderRadius:
        boxShape == BoxShape.circle ? null : (borderRadius ?? radius()),
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    image: decorationImage,
    shape: boxShape,
  );
}
