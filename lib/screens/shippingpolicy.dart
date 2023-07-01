import 'package:flutter/material.dart';

class ShippingPolicy extends StatelessWidget {
  ShippingPolicy({super.key});

  final List<String> termsAndConditions = [
    'As an app that connects users with service providers, we want to clarify our shipping policy. Please note that our app does not directly handle any shipping processes or related dealers.\n\n'
        'As our app does not directly handle shipping, any issues or disputes related to shipping should be resolved between the user and the service provider. We encourage open communication to address and resolve any problems that may arise.'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shipping Policy'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: termsAndConditions.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              //leading: Icon(Icons.circle, size: 10,),
              title: Text(
                termsAndConditions[index],
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
