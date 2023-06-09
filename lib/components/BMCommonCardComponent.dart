import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mycycleclinic/screens/single_store_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/BMCommonCardModel.dart';
import '../utils/BMColors.dart';
import '../utils/BMCommonWidgets.dart';
import '../utils/BMConstants.dart';

class BMCommonCardComponent extends StatefulWidget {
  BMCommonCardModel element;
  bool fullScreenComponent;
  bool isFavList;
  double latitude;
  double longitude;

  BMCommonCardComponent(
      {required this.element,
      required this.fullScreenComponent,
      required this.isFavList,
      required this.latitude,
      required this.longitude});

  @override
  State<BMCommonCardComponent> createState() => _BMCommonCardComponentState();
}

class _BMCommonCardComponentState extends State<BMCommonCardComponent> {
  late double distance;
  late int distanceinKM;

  @override
  void initState() {
    distance = Geolocator.distanceBetween(widget.latitude, widget.longitude,
            widget.element.latitude, widget.element.longitude) /
        1000;
    distanceinKM = distance.floor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.fullScreenComponent ? context.width() - 32 : 250,
      decoration:
          BoxDecoration(color: Colors.transparent, borderRadius: radius(32)),
      child: Stack(
        children: [
          bmCommonCachedNetworkImage(
            widget.element.image,
            width: widget.fullScreenComponent ? context.width() - 32 : 250,
            height: 300,
            fit: BoxFit.cover,
          ).cornerRadiusWithClipRRectOnly(
              topLeft: 32, topRight: 32, bottomLeft: 32, bottomRight: 32),
          Container(
            height: 300,
            decoration: BoxDecoration(
              borderRadius: radius(32),
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(1), // Starting color at the bottom
                  Colors.black.withOpacity(0), // Fading color towards the top
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.center,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Offstage(),
              210.height,
              Text(widget.element.title,
                      style: boldTextStyle(
                          size: 22,
                          color: Color(0xFFE2FF6D))) // bmSpecialColorDark
                  .paddingSymmetric(horizontal: 12),
              4.height,
              Text(widget.element.subtitle!,
                      style: secondaryTextStyle(
                          color: Colors.white,
                          size: 12,
                          wordSpacing: 2,
                          height: 1.5)) //bmPrimaryColor
                  .paddingSymmetric(horizontal: 14),
              4.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: Colors.white,
                  ),
                  Text("$distanceinKM km away",
                      style: secondaryTextStyle(color: Colors.white)),
                ],
              ).paddingSymmetric(horizontal: 18),
              12.height,
            ],
          ),
          // Positioned(
          //   top: 15,
          //   right: 15,
          //   child: const Icon(
          //     Icons.favorite,
          //     color: Colors.transparent,
          //     // color: widget.element.liked! ? Colors.amber : bmTextColorDarkMode,
          //     size: 24,
          //   ).onTap(() {
          //     // widget.element.liked = !widget.element.liked.validate();
          //     // if (widget.isFavList) {
          //     //   favList.remove(widget.element);
          //     // }
          //     // setState(() {});
          //   }),
          // ),
        ],
      ),
    ).onTap(() {
      BMSingleComponentScreen(element: widget.element).launch(context);
    });
  }
}
