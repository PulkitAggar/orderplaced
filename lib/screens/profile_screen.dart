import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycycleclinic/screens/cancellationpolicy.dart';
import 'package:mycycleclinic/screens/current_order_screen.dart';
import 'package:mycycleclinic/screens/past_order_screen.dart';
import 'package:mycycleclinic/screens/privacypolicy.dart';
import 'package:mycycleclinic/screens/shippingpolicy.dart';
import 'package:mycycleclinic/screens/termsandcondition.dart';
import 'package:nb_utils/nb_utils.dart';
import '../screens/screens.dart';
import '../blocs/blocs.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

//The following is for the app router file routing config
// We first declare a string of routename for LocationScreen class
  static const String routeName = '/profile';
// A route method which returns a abstract class Route
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => const ProfileScreen(),
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(SignOutRequested());
            },
            icon: const Icon(
              Icons.exit_to_app_outlined,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            // Navigate to the sign in screen when the user Signs Out
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LandingScreen()),
              (route) => false,
            );
          }
        },
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 15),
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Image.asset(
                  "assets/images/profileimage.png",
                  scale: 1.5,
                ),
                Text(
                  "${FirebaseAuth.instance.currentUser!.displayName}",
                  style: const TextStyle(
                    fontSize: 26,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Text(
                    "${FirebaseAuth.instance.currentUser!.email}",
                    style: TextStyle(
                        color: Color(0xFF797979),
                        fontWeight: FontWeight.w500,
                        fontSize: 12),
                  ),
                ),
                Container(
                  height: 90,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Your Cart',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 16),
                          ),
                          Text(
                            'Wish to Checkout?',
                            style: TextStyle(
                                color: Color(0xFF797979),
                                fontWeight: FontWeight.w500,
                                fontSize: 12),
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  height: 100,
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Current Order Status',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 18),
                      ),
                      Expanded(
                          child: SizedBox(
                        width: 1,
                      )),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CurrentOrders()));
                        },
                        icon: Icon(Icons.arrow_forward_ios_rounded),
                        color: Colors.white,
                        iconSize: SizeConfig.screenHeight,
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  height: 100,
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order History',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 18),
                      ),
                      Expanded(
                          child: SizedBox(
                        width: 1,
                      )),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PastOrders()));
                        },
                        icon: Icon(Icons.arrow_forward_ios_rounded),
                        color: Colors.white,
                        iconSize: SizeConfig.screenHeight,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    height: 200,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12, left: 20),
                      child: Column(
                        children: [
                          8.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 110.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Report a problem",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 0, top: 4),
                                      child: Text(
                                        "Contact Us",
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF515050)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 16.0),
                                child: Icon(
                                  Icons.warning_amber_outlined,
                                  color: Color(0xFFFF6565),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.voicemail_outlined,
                                  color: Color(0xFF9ABF00),
                                ),
                                Text(
                                  "  Phone : ",
                                  style: TextStyle(
                                    color: Color(0xFF9ABF00),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  "  +91 8395941016",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.mail_outline,
                                  color: Color(0xFF9ABF00),
                                ),
                                Text(
                                  "  E-Mail : ",
                                  style: TextStyle(
                                    color: Color(0xFF9ABF00),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  "shashikumarbloda@gmail.com",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.location_city,
                                  color: Color(0xFF9ABF00),
                                ),
                                Text(
                                  "  Address : ",
                                  style: TextStyle(
                                    color: Color(0xFF9ABF00),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "55232, Santro Enclave Industrial Area Road, Delhi Rd, opp Bharath Petrol Pump Vidyut Nagar, Hisar, Haryana 125006",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TermsAndConditionsScreen()));
                    },
                    child: Text(
                      "Terms and Conditions apply*",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('In adherence to our '),
                          GestureDetector(
                            child: Text(
                              "Privacy Policy ",
                              style: TextStyle(color: Colors.blue),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PrivacyPolicyScreen()));
                            },
                          ),
                          Text(','),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: Text(
                              "Cancellation Policy ",
                              style: TextStyle(color: Colors.blue),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CancellationPolicyScreen()));
                            },
                          ),
                          Text('and '),
                          GestureDetector(
                            child: Text(
                              "Shipping Policy ",
                              style: TextStyle(color: Colors.blue),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ShippingPolicy()));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
