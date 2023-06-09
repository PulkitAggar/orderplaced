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
      backgroundColor: bmLightScaffoldBackgroundColor,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        physics: const NeverScrollableScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: bmLightScaffoldBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: bmPrimaryColor),
                onPressed: () {
                  finish(context);
                },
              ).visible(innerBoxIsScrolled),
              title: titleText(title: widget.element.title)
                  .visible(innerBoxIsScrolled),
              actions: [
                IconButton(
                  icon: const Icon(Icons.subdirectory_arrow_right,
                      color: bmPrimaryColor),
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
              elevation: 0.5,
              expandedHeight: 400,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(bottom: 66, left: 30, right: 50),
                collapseMode: CollapseMode.parallax,
                background: Column(
                  children: [
                    Stack(
                      children: [
                        bmCommonCachedNetworkImage(
                          widget.element.image,
                          height: 300,
                          width: context.width(),
                          fit: BoxFit.cover,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: radius(100),
                                color: context.cardColor,
                              ),
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.only(left: 16, top: 30),
                              child:
                                  const Icon(Icons.arrow_back, color: bmPrimaryColor),
                            ).onTap(() {
                              finish(context);
                            }, borderRadius: radius(100)),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: radius(100),
                                    color: context.cardColor,
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.only(right: 16, top: 30),
                                  child:
                                      const Icon(Icons.close, color: bmPrimaryColor),
                                ).onTap(() {
                                  finish(context);
                                }, borderRadius: radius(100)),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: bmLightScaffoldBackgroundColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          titleText(title: widget.element.title, size: 26),
                          12.height,
                          Text(
                            widget.element.subtitle!,
                            style: secondaryTextStyle(
                                color: bmPrimaryColor, size: 12),
                          ),
                          
                        ],
                      ),
                    )
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
                16.height,
                BMOurServiveComponent(storeUid:widget.element.storeUid),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

