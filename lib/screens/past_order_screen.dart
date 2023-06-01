import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../models/userordermodel.dart';
import '../repositories/stores_repository.dart';
import 'order_detail_screen.dart';

class CurrentOrders extends StatefulWidget {
  const CurrentOrders({super.key});

  @override
  State<CurrentOrders> createState() => _CurrentOrdersState();
}

class _CurrentOrdersState extends State<CurrentOrders> {
  

  Future<List<userOrderModel>> recommendedList =
      StoresRepository.getPastStoreDataList(FirebaseAuth.instance.currentUser!.uid); 

  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Current Orders'),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<userOrderModel>>(
              
              future: recommendedList,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return Column(
                    children: snapshot.data!.map((e){
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>OrderDetailScreen(element: e)));
                        },
                        child: Card(
                          shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: BorderSide.strokeAlignOutside,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white
                            ),
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text('Ordered From: ', style: TextStyle(color: Colors.black,),),
                                      SizedBox(width: 10,),
                                      Expanded(child: Text(e.storeUid))
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Ordered On: ', style: TextStyle(color: Colors.black,),),
                                      SizedBox(width: 10,),
                                      Expanded(child: Text('${e.date} -- ${e.time}'))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ),
                      );
                    }).toList()
                  );
                } else if(snapshot.hasError){
                  return Text('Error: ${snapshot.error}');
                } else{
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