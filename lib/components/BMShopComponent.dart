import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../blocs/cart/cart_bloc.dart';
import '../models/BMShoppingModel.dart';
import '../utils/BMColors.dart';
import '../utils/BMCommonWidgets.dart';

class BMShopComponent extends StatefulWidget {
  BMShoppingModel element;
  BMShopComponent({required this.element});

  @override
  State<BMShopComponent> createState() => _BMShopComponentState();
}

class _BMShopComponentState extends State<BMShopComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: radius(32),
        // gradient: LinearGradient(
        //   colors: [
        //     Color(0xFFF1FFB6).withOpacity(0.2), // Starting color at the bottom
        //     Colors.grey.withOpacity(0), // Fading color towards the top
        //   ],
        //   begin: Alignment.centerRight,
        //   end: Alignment.centerLeft,
        // ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 15,
            right: 15,
            child: GestureDetector(
                child: const Icon(
                  Icons.cancel,
                  color: Colors.black,
                  // color: bmPrimaryColor,
                  size: 35,
                ),
                onTap: () {
                  BlocProvider.of<CartBloc>(context).add(DeleteItem(
                    widget.element,
                  ));
                }),
          ),
          Row(
            children: [
              bmCommonCachedNetworkImage(
                widget.element.imageUrl,
                height: 170,
                width: 120,
                fit: BoxFit.cover,
              ).cornerRadiusWithClipRRect(32),
              16.width,
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleText(title: widget.element.name, maxLines: 1, size: 18)
                      .paddingRight(80),
                  8.height,
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      4.width,
                      titleText(title: "5", size: 14),
                    ],
                  ),
                  8.height,
                  titleText(title: "Rs. ${widget.element.cost}", size: 14),
                  8.height,
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          // color: bmPrimaryColor.withAlpha(50),
                          borderRadius: radius(100),
                          // border: Border.all(color: bmPrimaryColor),
                        ),
                        padding: EdgeInsets.all(6),
                        child: Icon(Icons.remove, color: bmPrimaryColor),
                      ).onTap(() {
                        if (widget.element.count > 1) {
                          widget.element.count = widget.element.count - 1;
                          BlocProvider.of<CartBloc>(context).add(DecrementItem(
                            widget.element,
                          ));
                          setState(() {});
                        }
                      }, borderRadius: radius(100)),
                      12.width,
                      titleText(title: widget.element.count.toString()),
                      12.width,
                      Container(
                        decoration: BoxDecoration(
                          // color: bmPrimaryColor.withAlpha(50),
                          borderRadius: radius(100),
                          // border: Border.all(color: bmPrimaryColor),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(Icons.add, color: bmPrimaryColor),
                      ).onTap(() {
                        widget.element.count = widget.element.count + 1;
                        BlocProvider.of<CartBloc>(context).add(IncrementItem(
                          widget.element,
                        ));
                        setState(() {});
                      }, borderRadius: radius(100)),
                    ],
                  )
                ],
              ).expand(),
            ],
          ),
        ],
      ),
    );
  }
}
