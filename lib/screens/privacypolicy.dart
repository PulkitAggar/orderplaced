import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  final List<String> termsAndConditions = [
    'We are committed to protecting the privacy and security of the personal information of our users. This Privacy Policy outlines the types of information we may collect from you or that you may provide when using our app (mobile application) and our practices for collecting, using, maintaining, protecting, and disclosing that information. Please read this Privacy Policy carefully to understand our policies and practices regarding your information. By accessing or using the App, you agree to this Privacy Policy. If you do not agree with our policies and practices, you should not use the App.\n\n\n'
    '1. Information we collect : \n  1.1 Your name, address, email address, and phone number. \n  1.2 Payment information necessary for processing transactions. \n  1.3 Geolocation data when you use location-based services. \n  1.4 Communications and correspondence you send to us.\n\n'
    '2. We may use the information we collect from you to provide and improve our services. This includes: \n  2.1 Managing bike servicing. \n  2.2 Processing payments and providing receipts. \n  2.3 Communicating with you about your appointments and providing customer support. \n  2.4 Analyzing and improving the functionality and performance of the App.\n\n'
    '3. We may disclose your information if required to do so by law or if we believe such action is necessary to (a) comply with a legal obligation, (b) protect and defend our rights or property, (c) prevent or investigate possible wrongdoing in connection with the App, (d) protect the personal safety of users of the App or the public, or (e) enforce our terms of use or other agreements.\n\n'
    '4. We implement reasonable security measures to protect the confidentiality, integrity, and availability of your information. However, please note that no method of transmission over the internet or electronic storage is completely secure, and we cannot guarantee absolute security.\n\n'
    '5. We will retain your personal information for as long as necessary to fulfill the purposes for which it was collected or as required by law. We will securely delete or anonymize your information when it is no longer needed.\n\n'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
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