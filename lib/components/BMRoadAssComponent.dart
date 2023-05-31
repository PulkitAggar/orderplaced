import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:nb_utils/nb_utils.dart';
import '../models/BMRoadListModel.dart';
import '../utils/BMColors.dart';
import '../utils/BMCommonWidgets.dart';

class BMRoadAssComponent extends StatefulWidget {
  BMRoadAssListModel element;
  bool fullScreenComponent;

  BMRoadAssComponent(
      {required this.element, required this.fullScreenComponent});

  @override
  State<BMRoadAssComponent> createState() => _BMRoadAssComponentState();
}

class _BMRoadAssComponentState extends State<BMRoadAssComponent> {
  _callNumber(String number) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: widget.fullScreenComponent ? context.width() - 32 : 250,
      decoration:
          BoxDecoration(color: context.cardColor, borderRadius: radius(32)),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              bmCommonCachedNetworkImage(
                widget.element.image,
                width: widget.fullScreenComponent ? context.width() - 32 : 250,
                height: 150,
                fit: BoxFit.cover,
              ).cornerRadiusWithClipRRectOnly(topLeft: 32, topRight: 32),
              8.height,
              Row(
                children: [
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.element.name,
                      style: TextStyle(fontSize: 22, color: bmSpecialColorDark),
                    ),
                  ),
                  Expanded(
                      child: SizedBox(
                    width: 1,
                  )),
                  IconButton(
                      onPressed: () {
                        _callNumber(widget.element.number.toString());
                      },
                      icon: Icon(
                        Icons.call,
                        color: bmSpecialColorDark,
                      ))
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
