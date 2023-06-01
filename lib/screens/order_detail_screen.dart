import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mycycleclinic/models/userordermodel.dart';

class OrderDetailScreen extends StatefulWidget {
  userOrderModel element;
  
  OrderDetailScreen({required this.element});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: 
          Card(
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30,),
                  Row(
                    children: [
                      Text('Ordered From: ', style: TextStyle(color: Colors.black,),),
                      SizedBox(width: 10,),
                      Expanded(child: Text(widget.element.storeUid))
                    ],
                  ),
                  Row(
                    children: [
                      Text('Ordered On: ', style: TextStyle(color: Colors.black,),),
                      SizedBox(width: 10,),
                      Expanded(child: Text('${widget.element.date} -- ${widget.element.time}'))
                    ],
                  ),
                  Row(
                    children: [
                      Text('Receivers Name: ', style: TextStyle(color: Colors.black,),),
                      SizedBox(width: 10,),
                      Expanded(child: Text(widget.element.nameR))
                    ],
                  ),
                  Row(
                    children: [
                      Text('Receivers Number: ', style: TextStyle(color: Colors.black,),),
                      SizedBox(width: 10,),
                      Expanded(child: Text(widget.element.phoneR))
                    ],
                  ),
                  Row(
                    children: [
                      Text('Receivers Address: ', style: TextStyle(color: Colors.black,),),
                      SizedBox(width: 10,),
                      Expanded(child: Text(widget.element.addressR))
                    ],
                  ),
                ],
              ),
            ),
          )
        ),
      ),
    );
  }
}