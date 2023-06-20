import 'package:flutter/material.dart';
import 'package:mycycleclinic/components/BMRoadAssComponent.dart';
import 'package:nb_utils/nb_utils.dart';
import '../models/BMRoadListModel.dart';
import '../repositories/stores_repository.dart';

class RoadSideAssistance extends StatefulWidget {
  String city;

  RoadSideAssistance({required this.city});

  static const routeName = "/roadsideScreen";

  @override
  State<RoadSideAssistance> createState() => _RoadSideAssistanceState();
}

class _RoadSideAssistanceState extends State<RoadSideAssistance> {
  //final Clinic clinic = Clinic(id: 'dc', name: 'Clinic Name', description: 'description', imageFile: File('path'), products: [], services: [], isOpen: true, number: '8295647903');
  late Future<List<BMRoadAssListModel>> recommendedList;

  @override
  void initState() {
    super.initState();
    recommendedList = StoresRepository.getRoadAssList(widget.city);
  }

//   _makingPhoneCall() async {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Roadside Assistance',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<List<BMRoadAssListModel>>(
                future: recommendedList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                            children: snapshot.data!.map((e) {
                      return GestureDetector(
                        child: BMRoadAssComponent(
                                element: e, fullScreenComponent: true)
                            .paddingSymmetric(vertical: 10),
                      );
                    }).toList())
                        .paddingSymmetric(horizontal: 10);
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              )
            ],
          ),
        ));
  }
}
