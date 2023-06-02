import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mycycleclinic/screens/order_detail_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/userordermodel.dart';
import '../repositories/stores_repository.dart';

class CurrentOrders extends StatefulWidget {
  const CurrentOrders({super.key});

  @override
  State<CurrentOrders> createState() => _CurrentOrdersState();
}

class _CurrentOrdersState extends State<CurrentOrders> {
  Future<List<userOrderModel>> recommendedList =
      StoresRepository.getStoreDataList(FirebaseAuth.instance.currentUser!.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: Text(
          'Current Orders',
          style: boldTextStyle(color: Colors.black, size: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<userOrderModel>>(
              future: recommendedList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                      mainAxisSize: MainAxisSize.max,
                      children: snapshot.data!.map((e) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    OrderDetailScreen(element: e)));
                          },
                          child: Card(
                            color: Colors.grey.shade200,
                              shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(24)),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                              elevation: BorderSide.strokeAlignOutside,
                              child: Container(
                                // height: 300.0,
                                decoration: BoxDecoration(color: Colors.grey.shade200),
                                width: double.infinity,
                                // padding: EdgeInsets.all(8.0), YOU CAN DO thIS YOU KNOW that RIGHT??????????????????????
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ExpansionTile(
                                        collapsedIconColor: Colors.black,
                                        title: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(e.storeName, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                                            Space(4),
                                            Container(
                                              width: double.infinity,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.watch_later_outlined, color: Colors.orange, size: 16),
                                                  Space(2),
                                                  Text(e.date, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                                  Space(2),
                                                  Text("at", style: TextStyle(color: Colors.orange, fontSize: 12)),
                                                  Space(2),
                                                  Text(e.time, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                                  Expanded(child: SizedBox(width: 1,)),
                                                  Text(
                                                      e.orderStatus,
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                        color: e.orderStatus == "placed" ? Colors.orange : blueColor,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        children: [
                                          ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: e.map.length,
                                            itemBuilder: (context, index) {
                                              String key =
                                                  e.map.keys.elementAt(index);
                                              Map<String, dynamic> item =
                                                  e.map[key];
                                              double cost = item['cost'];
                                              int count = item['count'];
                                              String imageUrl = item['image'];

                                              return ListTile(
                                                leading: Image.network(imageUrl),
                                                title: Text('Item: $key'),
                                                subtitle: Text(
                                                    'Cost: $cost, Count: $count'),
                                              );
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )),
                        );
                      }).toList());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}



class Space extends LeafRenderObjectWidget {
  final double mainAxisExtent;

  Space(this.mainAxisExtent, {Key? key}) : assert(mainAxisExtent >= 0 && mainAxisExtent <= double.infinity), super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSpace(mainAxisExtent: mainAxisExtent);
  }

  @override
  void updateRenderObject(BuildContext context, RenderSpace renderObject) {
    renderObject.mainAxisExtent = mainAxisExtent;
  }
}


class RenderSpace extends RenderBox {
  double _mainAxisExtent;

  RenderSpace({double? mainAxisExtent}) : _mainAxisExtent = mainAxisExtent!;

  double get mainAxisExtent => _mainAxisExtent;

  set mainAxisExtent(double value) {
    if (_mainAxisExtent != value) {
      _mainAxisExtent = value;
      markNeedsLayout();
    }
  }

  @override
  void performLayout() {

    final AbstractNode flex = parent!;

    if (flex is RenderFlex) {
      if (flex.direction == Axis.horizontal) {
        size = constraints.constrain(Size(mainAxisExtent, 0));
      } else {
        size = constraints.constrain(Size(0, mainAxisExtent));
      }
    } else {
      throw 'Space widget is not inside flex parent';
    }
  }
}
