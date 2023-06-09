
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';


import '../widgets/widgets.dart';
import 'screens.dart';

import 'package:http/http.dart' as http;
import 'package:mycycleclinic/repositories/razor_credentials.dart' as razorCredentials;

class PaymentScreen extends StatefulWidget {

  

  final String weekday;
  final double amount;

  PaymentScreen({Key? key, required this.weekday, required this.amount}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();

  // void setDate() {
  //   list[0].date = "13 January,2023";
  // }
}

class _PaymentScreenState extends State<PaymentScreen> {

  @override

  int selectedValue=0;
  // void initState() {
  //   if (widget.list[0].date == "") {
  //     widget.setDate();
  //   }
  //   super.initState();
  // }

  final _razorpay = Razorpay();
  
  get amount => amount;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    });
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LastBookingScreen(
                            cancel: false,
                            weekday: widget.weekday,
                            // date: widget.list[0].date,
                            // time: widget.list[0].time,
                          ),
                        ),
                      );
    print(response);
    verifySignature(
      signature: response.signature,
      paymentId: response.paymentId,
      orderId: response.orderId,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(response);
    // Do something when payment fails
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message ?? ''),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print(response);
    // Do something when an external wallet is selected
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.walletName ?? ''),
      ),
    );
  }

  void createOrder() async {
    String username = razorCredentials.keyId;
    String password = razorCredentials.keySecret;
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    Map<String, dynamic> body = {
      "amount": amount * 100,
      "currency": "INR",
      "receipt": "rcptid_11"
    };
    var res = await http.post(
      Uri.https(
          "api.razorpay.com", "v1/orders"), //https://api.razorpay.com/v1/orders
      headers: <String, String>{
        "Content-Type": "application/json",
        'authorization': basicAuth,
      },
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      openGateway(jsonDecode(res.body)['id']);
    }
    print(res.body);
  }

  openGateway(String orderId) {
    var options = {
      'key': razorCredentials.keyId,
      'amount': 100, //in the smallest currency sub-unit.
      'name': 'Acme Corp.',
      'order_id': orderId, // Generate order_id using Orders API
      'description': 'Fine T-Shirt',
      'timeout': 60 * 5, // in seconds // 5 minutes
      'prefill': {
        'contact': '9123456789',
        'email': 'ary@example.com',
      }
    };
    _razorpay.open(options);
  }

  verifySignature({
    String? signature,
    String? paymentId,
    String? orderId,
  }) async {
    Map<String, dynamic> body = {
      'razorpay_signature': signature,
      'razorpay_payment_id': paymentId,
      'razorpay_order_id': orderId,
    };

    var parts = [];
    body.forEach((key, value) {
      parts.add('${Uri.encodeQueryComponent(key)}='
          '${Uri.encodeQueryComponent(value)}');
    });
    var formData = parts.join('&');
    var res = await http.post(
      Uri.https(
        "10.0.2.2", // my ip address , localhost
        "razorpay_signature_verify.php",
      ),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded", // urlencoded
      },
      body: formData,
    );

    print(res.body);
    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res.body),
        ),
      );
    }
  }

  @override
  void dispose() {
    _razorpay.clear(); // Removes all listeners

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Payment",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Colors.black),
        ),
      ),
      bottomSheet: BottomSheet(
        elevation: 0,
        enableDrag: false,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Expanded(
                  //   child: Text(
                  //     "Rs.$amount",
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  TextButton(
                    onPressed: () {
                      if(selectedValue==1){
                        createOrder();
                      }
                      else if(selectedValue==2){
                        Navigator.of(context).pushAndRemoveUntil( MaterialPageRoute(builder: (context) => LastBookingScreen()), (Route<dynamic> route) => false,);
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Choose one of the options"))
                        );
                      }
                    },
                    child: Text(
                      "Pay",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        onClosing: () {},
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Space(75),
            //PaymentContainer(title: "Net Banking", icon: Icons.food_bank),
           
            ListTile(
              title: const Text('Net Banking'),
              leading: Radio<int>(
                fillColor: MaterialStateColor.resolveWith((states) => Colors.black),
                focusColor: MaterialStateColor.resolveWith((states) => Colors.black),
                value: 1,
                groupValue: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Cash Delivery'),
              leading: Radio<int>(
                fillColor: MaterialStateColor.resolveWith((states) => Colors.black),
                value: 2,
                groupValue: selectedValue,
                onChanged: ( value) {
                  setState(() {
                    selectedValue = value!;
                  });
                },
              ),
            ),
      
    
            Space(75),
          ],
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}