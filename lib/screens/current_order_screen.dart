import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
                              shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(24)),
                              elevation: BorderSide.strokeAlignOutside,
                              child: Container(
                                // height: 300.0,
                                decoration: BoxDecoration(color: Colors.white),
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
                                      Row(
                                        children: [
                                          Text(
                                            'Ordered From: ',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(child: Text(e.storeName))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Ordered On: ',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                              child: Text(
                                                  '${e.date} -- ${e.time}'))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Ordered Status: ',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(child: Text(e.orderStatus))
                                        ],
                                      ),
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
