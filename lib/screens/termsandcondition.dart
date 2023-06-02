import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  final List<String> termsAndConditions = [
    '1. By accessing or using the App, you agree to be bound by these Terms and any additional terms and conditions incorporated by reference. If you do not agree with these Terms, you should not use the App.\n',
    '2. You agree to use the App in compliance with all applicable laws and regulations. You will not: \n  2.1 Use the App for any illegal, harmful, or unauthorized purposes. \n  2.2 Interfere with the operation or security of the App or any networks or systems connected to the App. \n  2.3 Use any automated means to access the App or collect data from the App. \n  2.4 Upload or transmit any viruses, malware, or other harmful code.\n\n'
    '3. The App provides a platform to connect bike owners with service providers for bike servicing and sell products related to the same. We do not provide bike servicing directly but facilitate the process. We are not responsible for the quality, safety, or any issues arising from the bike servicing or the products provided by the service providers. Any transactions or arrangements made between you and the service providers are solely your responsibility.\n\n'
    '4. Payment for the same is made to the owner of the app and then to the service provider. We may facilitate the payment process through the App but are not responsible for any payment-related issues, such as unauthorized charges or refunds. Any disputes or concerns regarding payments should be resolved directly with the service provider.\n\n'
    '5. The pricing for bike servicing is determined by the service providers. We do not control or guarantee the pricing, and it may vary between different service providers. It is your responsibility to review and agree to the pricing before confirming a bike servicing appointment.\n\n'
    '6. The App and its content are protected by intellectual property laws. You acknowledge that all copyrights, trademarks, and other intellectual property rights related to the App belong to us or our licensors. You agree not to reproduce, modify, distribute, or create derivative works based on the App or its content without our prior written consent.\n\n'
    '7. To the maximum extent permitted by law, we shall not be liable for any indirect, incidental, special, consequential, or punitive damages, or any loss of profits or revenues, whether incurred directly or indirectly, arising out of your use of the App or the services provided through the App.\n\n'
    '8. These Terms shall be governed by and construed in accordance with the laws of [Jurisdiction of Hisar]. Any legal action or proceeding arising out of or relating to these Terms shall be exclusively brought in the courts located in [Jurisdiction of Hisar].\n\n'
    '9. We reserve the right to modify or update these Terms at any time without prior notice. Any changes to the Terms will be effective upon posting the revised version on the App. Your continued use of the App after the posting of the revised Terms constitutes your acceptance of the changes.\n\n'
    '10. If you have any questions or concerns regarding these Terms, please contact us at shashikumarbloda@gmail.com'

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