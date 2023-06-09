import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../components/BMOurServiveComponent.dart';
import '../models/BMCommonCardModel.dart';
import '../utils/BMColors.dart';
import '../utils/BMCommonWidgets.dart';

class BMSingleComponentScreen extends StatefulWidget {
  BMCommonCardModel element;

  BMSingleComponentScreen({required this.element});

  @override
  _BMSingleComponentScreenState createState() =>
      _BMSingleComponentScreenState();
}

class _BMSingleComponentScreenState extends State<BMSingleComponentScreen> {
  @override
  void initState() {
    setStatusBarColor(Colors.transparent);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        physics: const NeverScrollableScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: bmPrimaryColor),
                onPressed: () {
                  finish(context);
                },
              ).visible(innerBoxIsScrolled),
              title: Text(
                widget.element.title,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ).visible(innerBoxIsScrolled),
              actions: [
                IconButton(
                  icon: const Icon(Icons.subdirectory_arrow_right,
                      color: Colors.transparent),
                  onPressed: () {
                    // BMSingleImageScreen(element: widget.element).launch(context);
                  },
                ).visible(innerBoxIsScrolled),
                // IconButton(
                //   icon: widget.element.liked!
                //       ? Icon(Icons.favorite, color: bmPrimaryColor)
                //       : Icon(Icons.favorite_outline, color: bmPrimaryColor),
                //   onPressed: () {
                //     widget.element.liked = !widget.element.liked!;
                //     setState(() {});
                //   },
                // ).visible(innerBoxIsScrolled),
              ],
              leadingWidth: 30,
              pinned: true,
              elevation: 0.8,
              expandedHeight: 360,
              flexibleSpace: FlexibleSpaceBar(
                // titlePadding:
                //     const EdgeInsets.only(bottom: 66, left: 30, right: 50),
                collapseMode: CollapseMode.parallax,
                background: Column(
                  children: [
                    Stack(
                      children: [
                        bmCommonCachedNetworkImage(
                          widget.element.image,
                          height: 390,
                          width: context.width(),
                          fit: BoxFit.cover,
                        ),
                        Container(
                          height: 390,
                          decoration: BoxDecoration(
                            // borderRadius: radius(32),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: radius(100),
                                // color: context.cardColor,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.only(left: 16, top: 30),
                              child: const Icon(
                                Icons.arrow_back,
                                // color: bmPrimaryColor,
                                color: Colors.white,
                              ),
                            ).onTap(() {
                              finish(context);
                            }, borderRadius: radius(100)),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: radius(100),
                                      // color: context.cardColor,
                                      color: Colors.transparent),
                                  padding: const EdgeInsets.all(8),
                                  margin:
                                      const EdgeInsets.only(right: 16, top: 30),
                                  child: const Icon(
                                    Icons.close,
                                    // color: bmPrimaryColor,
                                    color: Colors.transparent,
                                  ),
                                ).onTap(() {
                                  // finish(context);
                                }, borderRadius: radius(100)),
                              ],
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 5,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            color: Colors.transparent,
                            width: 300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.element.title,
                                  style: TextStyle(
                                      fontSize: 28, color: Color(0xFFE2FF6D)),
                                ),
                                // titleText(
                                //     title: widget.element.title, size: 28),
                                8.height,
                                Text(
                                  widget.element.subtitle!,
                                  style: secondaryTextStyle(
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                4.height,
                                Text(
                                  'Give a call on:- ${widget.element.number.toString()}',
                                  style: secondaryTextStyle(
                                      color: Colors.white,
                                      size: 16,
                                      weight: FontWeight.w600),
                                )
                              ],
                            ),
                          ).cornerRadiusWithClipRRectOnly(
                              topLeft: 32, topRight: 32),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Container(
          decoration: BoxDecoration(
            color: bmSecondBackgroundColorLight,
            borderRadius: radiusOnly(topLeft: 32, topRight: 32),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                BMOurServiveComponent(storeUid: widget.element.storeUid),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
