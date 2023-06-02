import 'package:flutter/material.dart';

class CancellationPolicyScreen extends StatelessWidget {
  final List<String> termsAndConditions = [
    'Thank you for choosing our bike servicing app. We strive to provide you with reliable and convenient bike servicing services. Please review our cancellation policy carefully.\n\n\n'
    '1. This cancellation policy applies to all bookings made through our app.\n\n'
    '2. Once you have booked a bike service through the App, cancellation or refunds are not permitted. We have a no-cancellation policy in place due to the nature of our services and the need to allocate resources and schedule service providers accordingly.\n\n'
    '3. If you need to make any modifications to your appointment, please contact the service provider.\n\n'
    '4. If you have any questions or need further assistance regarding our cancellation policy, please contact our customer support team through the contact information provided in the App.\n\n\n'
    'Please note that by using our App and booking any service or product, you acknowledge and agree to abide by this cancellation policy.'

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
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