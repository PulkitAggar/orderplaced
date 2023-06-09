// import 'dart:async';
// import 'dart:ui';
// import 'package:collection/collection.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../blocs/blocs.dart';
// import '../datamodels/models.dart';
// import '../widgets/widgets.dart';
// import 'screens.dart';
// import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
// import '../models/order.model.dart';
// import 'home_screen.dart';

// final _firebase = FirebaseFirestorePlatform.instance;
// User? loggineduser;

// class ShoppingCart extends StatefulWidget {
//   @override
//   ShoppingCartState createState() => ShoppingCartState();
// }

// class ShoppingCartState extends State<ShoppingCart> {
//   bool _isRunning = false;
//   String storeuid = "";
//   String weekday = '';
//   int empty = 0;
//   int fee = 0;
//   String coupon = "";
//   double total = 0.00;
//   int discount = 0;
//   int dis = 0;
//   int c = 0;
//   List<DocumentSnapshotPlatform> messagewidget2 = [];
//   TextEditingController textEditingController = TextEditingController();
//   final _auth = FirebaseAuth.instance;
//   bool exist = false;

//   void getCurrentWeekday() {
//     DateTime now = DateTime.now();
//     int currentWeekday = now.weekday;

//     switch (currentWeekday) {
//       case 1:
//         setState(() {
//           weekday = 'Monday';
//         });
//         break;
//       case 2:
//         setState(() {
//           weekday = 'Tuesday';
//         });
//         break;
//       case 3:
//         setState(() {
//           weekday = 'Wednesday';
//         });
//         break;
//       case 4:
//         setState(() {
//           weekday = 'Thursday';
//         });
//         break;
//       case 5:
//         setState(() {
//           weekday = 'Friday';
//         });
//         break;
//       case 6:
//         setState(() {
//           weekday = 'Saturday';
//         });
//         break;
//       case 7:
//         setState(() {
//           weekday = 'Sunday';
//         });
//         break;
//       default:
//         setState(() {
//           weekday = 'Unknown';
//         });
//         break;
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     // BlocProvider.of<CartBloc>(context).add(FetchCartEvent());
//     xyz();
//     feeFetch();
//     getuser();
//     getCurrentWeekday();
//   }

//   void getuser() async {
//     try {
//       final user = await _auth.currentUser;
//       if (user != null) {
//         loggineduser = user;
//         print(loggineduser?.email);
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

  

//   void emptyCart() async {

//     var d = await FirebaseFirestore.instance
//         .collection("cart")
//         .doc("${loggineduser?.email}")
//         .collection("cart")
//         .get();

//     if (d.docs.isNotEmpty) {
//       setState(() {
//         empty = 1;
//       });
//     } else {
//       setState(() {
//         empty = 0;
//       });
//     }
//   }

  

//   void xyz() {
//     FirebaseFirestore.instance
//         .collection("users")
//         .doc("${loggineduser?.uid}")
//         .collection("userAddress")
//         .get()
//         .then((value) {

//       QueryDocumentSnapshot<Map<String, dynamic>>? foundDoc = value.docs
//           .firstWhereOrNull((element) => element.get("fullAddress") == "");
//       QueryDocumentSnapshot<Map<String, dynamic>>? foundDoc1 =
//           value.docs.firstWhereOrNull((element) => element.get("name") == "");
//       QueryDocumentSnapshot<Map<String, dynamic>>? foundDoc2 =
//           value.docs.firstWhereOrNull((element) => element.get("number") == "");

//       if (value.docs.length != 0 &&
      
//           foundDoc?.get("fullAddress") != "" &&
//           foundDoc1?.get("name") != "" &&
//           foundDoc2?.get("number") != ""
//           ) {
//         // if(value.docs.){}
//         setState(() {
//           exist = true;
//         });
//         print("added");
//       } else {
//         setState(() {
//           exist = false;
//         });

//         print("add");
//       }
//       print(foundDoc?.get("name"));
//     });
//   }

//   @override
//   void dispose() {
//     textEditingController.dispose();
//     super.dispose();
//   }

//   void delete() async {
//     FirebaseFirestore.instance
//         .collection("cart")
//         .doc("${loggineduser?.email}")
//         .collection("cart")
//         .get()
//         .then((snapshot) {
//       for (DocumentSnapshot ds in snapshot.docs) {
//         ds.reference.delete();
//       }
//     });
//   }

//   Widget CCard(
//     double cost,
//     int count,
//     String imageurl,
//     String name,
//     List list,
//     String subname,
//     String catname,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 5),
//       child: Container(
//         width: double.infinity,
//         decoration: BoxDecoration(
//           color: Colors.grey.shade200,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Image.network(imageurl, height: 64, width: 64),
//                   const SizedBox(
//                     width: 15,
//                   ),
//                   Expanded(
//                     child: Text(
//                       name,
//                       style: const TextStyle(
//                           fontWeight: FontWeight.bold, fontSize: 15),
//                     ),
//                   ),
//                   //Spacer(),
//                   const SizedBox(
//                     width: 15,
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.cancel),
//                     onPressed: () async {
//                       if (list.length == 1) {
//                         setState(() {
//                           total = 0.00;
//                           discount = 0;
//                           fee = 0;
//                         });

//                         await _firebase
//                             .collection("cart")
//                             .doc("${loggineduser?.email}")
//                             .collection("cart")
//                             .doc(name)
//                             .delete()
//                             .then((value) {
//                           FirebaseFirestore.instance
//                               .collection("cart")
//                               .doc("${loggineduser?.email}")
//                               .delete()
//                               .then((value) {
//                             emptyCart();
//                             FirebaseFirestore.instance
//                                 .collection("cart")
//                                 .doc("${loggineduser?.email}")
//                                 .set({
//                               "storeid": "",
//                             });
//                           });
//                         });
//                       }
//                       await _firebase
//                           .collection("cart")
//                           .doc("${loggineduser?.email}")
//                           .collection("cart")
//                           .doc(name)
//                           .delete()
//                           .then((value) {
//                         feeFetch();
//                       });
//                     },
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   //Spacer(),
//                   IconButton(
//                     icon: const Icon(Icons.remove),
//                     onPressed: () {
//                       if (count > 1) {
//                         int countnew = count - 1;
//                         _firebase
//                             .collection("cart")
//                             .doc("${loggineduser?.email}")
//                             .collection("cart")
//                             .doc("$name")
//                             .set({
//                           'cost': cost,
//                           'count': countnew,
//                           'imageurl': imageurl,
//                           'name': name,
//                           'subname': subname,
//                           'catname': catname,
//                         }).then((value) {
//                           setState(() {
//                             feeFetch();
//                           });
//                           // feeFetch();
//                         });
//                       }
//                     },
//                   ),
//                   SizedBox(
//                     height: 20,
//                     width: 30,
//                     child: Container(
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                           border: Border.all(color: Colors.black, width: 0.5)),
//                       child: Text(
//                         count.toString(),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.add),
//                     onPressed: () {
//                       int countnew = count + 1;
//                       _firebase
//                           .collection("cart")
//                           .doc("${loggineduser?.email}")
//                           .collection("cart")
//                           .doc("$name")
//                           .set({
//                         'cost': cost,
//                         'count': countnew,
//                         'imageurl': imageurl,
//                         'name': name,
//                         'subname': subname,
//                         'catname': catname,
//                       }).then((value) {
//                         feeFetch();
//                       });
//                     },
//                   ),
//                   const Spacer(),
//                   Text(
//                     "₹${cost * count}",
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 20),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // print(discount);
//     return Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           centerTitle: true,
//           title: const Text(
//             'Shopping Cart',
//             style: TextStyle(color: Colors.black),
//           ),
//           elevation: 0,
//           leading: IconButton(
//             icon: const Icon(
//               Icons.arrow_back,
//               color: Colors.black,
//             ),
//             onPressed: () {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => DashboardScreen()));
//             },
//           ),
//         ),
//         bottomSheet: BottomSheet(
//           elevation: 10,
//           enableDrag: false,
//           builder: (context) {
//             return Padding(
//               padding: const EdgeInsets.all(10),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 height: MediaQuery.of(context).size.height * 0.06,
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                   color: Colors.black,
//                   borderRadius: BorderRadius.circular(40),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "\Rs. ${((total + fee) - discount).toStringAsFixed(2)}",
//                       // "\Rs. ${totalAmount.toStringAsFixed(2)}",
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         if (exist == false) {
//                           var snackBar = const SnackBar(
//                             dismissDirection: DismissDirection.down,
//                             content: Text(
//                               'Please Fill Recivers Details',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           );
//                           ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                         }
//                         if (total != 0 && exist) {
//                           print(messagewidget2.length);
//                           DateTime currentDate = DateTime.now();
//                           DateTime currentTime = DateTime.now();
//                           OrderModel modelOfOrder = OrderModel(
//                               trackOrder: "pending",
//                               time:
//                                   "${currentTime.hour}:${currentTime.minute}:${currentTime.second}",
//                               weekday: weekday,
//                               date:
//                                   "${currentDate.day}-${currentDate.month}-${currentDate.year}",
//                               cost: ((total + fee) - discount),
//                               storeUid: storeuid,
//                               lstOfItems: messagewidget2);
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => PaymentScreen(
//                                 totsamount:
//                                     ((total + fee) - discount).toDouble(),
//                                 orderModel: modelOfOrder,
//                                 code: coupon,
//                               ),
//                             ),
//                           );
//                         }
//                       },
//                       child: const Text(
//                         "Proceed to Pay",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//           onClosing: () {},
//         ),
//         body: StreamBuilder<QuerySnapshotPlatform>(
//             stream: _firebase
//                 .collection("cart")
//                 .doc("${loggineduser?.email}")
//                 .collection("cart")
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Container(color: Colors.white);
//                 // return const Center(
//                 //   child: CircularProgressIndicator(
//                 //     backgroundColor: Colors.lightBlueAccent,
//                 //   ),
//                 // );
//               }

//               final messages = snapshot.data?.docs;

//               List<Widget> messagewidget = [];
//               for (var message in messages!) {
//                 final double cost = message.get("cost");
//                 final count = message.get("count");
//                 final imageUrl = message.get("imageurl");
//                 final name = message.get("name");
//                 final subName = message.data()?["subname"] ?? "";
//                 final catName = message.data()?["catname"] ?? "";
//                 var mess = CCard(cost, count, imageUrl, name, messagewidget,
//                     subName, catName);
//                 messagewidget.add(mess);
//               }
//               messagewidget2 = messages;
//               return empty == 0
//                   ? SizedBox(
//                       height: 300,
//                       child: Center(
//                         child: Text("Your Cart is empty"),
//                       ),
//                     )
//                   : _isRunning
//                       ? BackdropFilter(
//                           filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
//                           child: Container(
//                             color: Colors.black.withOpacity(0.0),
//                             child: Center(
//                               child: CircularProgressIndicator(),
//                             ),
//                           ),
//                         )
//                       : SingleChildScrollView(
//                           child: Column(
//                             children: [
//                               Container(
//                                 height: 300,
//                                 child: ListView(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 10.0, vertical: 20.0),
//                                   children: messagewidget,
//                                 ),
//                               ),
//                               Space(8),
//                               StreamBuilder<QuerySnapshotPlatform>(
//                                   stream: _firebase
//                                       .collection("users")
//                                       .doc("${loggineduser?.uid}")
//                                       .collection("userAddress")
//                                       .snapshots(),
//                                   builder: (context, innershot) {
//                                     String name = "";
//                                     String number = "";
//                                     String addre = "";
//                                     if (!innershot.hasData) {
//                                       return const Center(
//                                         child: CircularProgressIndicator(
//                                           backgroundColor:
//                                               Colors.lightBlueAccent,
//                                         ),
//                                       );
//                                     } else {
//                                       var address = innershot.data?.docs;
//                                       List<String> addres = [];
//                                       for (var add in address!) {
//                                         addres.add(add.get("fullAddress"));
//                                         addres.add(add.get("name"));
//                                         addres.add(add.get("number"));
//                                       }
//                                       return Padding(
//                                         padding: const EdgeInsets.only(
//                                             left: 15, right: 15),
//                                         child: Card(
//                                           color: Colors.grey.shade200,
//                                           shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(10)),
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(16),
//                                             child: Row(
//                                               children: [
//                                                 const Icon(Icons.location_on,
//                                                     size: 20),
//                                                 Space(8),
//                                                 Expanded(
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       const Text(
//                                                         "Name",
//                                                         textAlign:
//                                                             TextAlign.start,
//                                                         style: TextStyle(
//                                                             fontWeight:
//                                                                 FontWeight.w900,
//                                                             fontSize: 21),
//                                                       ),
//                                                       Space(4),
//                                                       Text(
//                                                         addres.length != 0
//                                                             ? "${addres[1]}"
//                                                                 .toUpperCase()
//                                                             : "Please enter your name",
//                                                         textAlign:
//                                                             TextAlign.start,
//                                                         style: const TextStyle(
//                                                           color: Colors.grey,
//                                                           fontSize: 16,
//                                                         ),
//                                                       ),
//                                                       Space(4),
//                                                       const Text(
//                                                         "Number",
//                                                         textAlign:
//                                                             TextAlign.start,
//                                                         style: TextStyle(
//                                                             fontWeight:
//                                                                 FontWeight.w900,
//                                                             fontSize: 21),
//                                                       ),
//                                                       Space(4),
//                                                       Text(
//                                                         addres.length != 0
//                                                             ? "${addres[2]}"
//                                                             : "Enter your number",
//                                                         textAlign:
//                                                             TextAlign.start,
//                                                         style: const TextStyle(
//                                                           color: Colors.grey,
//                                                           fontSize: 16,
//                                                         ),
//                                                       ),
//                                                       Space(4),
//                                                       const Text(
//                                                         "Address",
//                                                         textAlign:
//                                                             TextAlign.start,
//                                                         style: TextStyle(
//                                                             fontWeight:
//                                                                 FontWeight.w900,
//                                                             fontSize: 21),
//                                                       ),
//                                                       Space(4),
//                                                       Text(
//                                                         addres.length != 0
//                                                             ? "${addres[0]}"
//                                                                 .toUpperCase()
//                                                             : "Enter your pick up address",
//                                                         textAlign:
//                                                             TextAlign.start,
//                                                         style: const TextStyle(
//                                                           color: Colors.grey,
//                                                           fontSize: 16,
//                                                         ),
//                                                       ),
//                                                       Space(4),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 Space(8),
//                                                 IconButton(
//                                                     onPressed: () {
//                                                       showDialog(
//                                                           context: context,
//                                                           builder: (BuildContext
//                                                               context) {
//                                                             return Dialog(
//                                                               child: Container(
//                                                                 height: 300,
//                                                                 width: 500,
//                                                                 padding:
//                                                                     const EdgeInsets
//                                                                         .all(20),
//                                                                 child:
//                                                                     SingleChildScrollView(
//                                                                   child: Column(
//                                                                     children: [
//                                                                       CustomTextField(
//                                                                           controller:
//                                                                               textEditingController,
//                                                                           maxLines:
//                                                                               2,
//                                                                           title:
//                                                                               'Address',
//                                                                           hasTitle:
//                                                                               true,
//                                                                           initialValue:
//                                                                               '',
//                                                                           onChanged:
//                                                                               (value) {
//                                                                             addre =
//                                                                                 value.toString();
//                                                                           }),
//                                                                       CustomTextField(
//                                                                           controller:
//                                                                               textEditingController,
//                                                                           maxLines:
//                                                                               1,
//                                                                           title:
//                                                                               'Name',
//                                                                           hasTitle:
//                                                                               true,
//                                                                           initialValue:
//                                                                               '',
//                                                                           onChanged:
//                                                                               (value) {
//                                                                             name =
//                                                                                 value.toString();
//                                                                           }),
//                                                                       CustomTextField(
//                                                                           controller:
//                                                                               textEditingController,
//                                                                           maxLines:
//                                                                               1,
//                                                                           title:
//                                                                               'Number',
//                                                                           hasTitle:
//                                                                               true,
//                                                                           initialValue:
//                                                                               '',
//                                                                           onChanged:
//                                                                               (value) {
//                                                                             number =
//                                                                                 value.toString();
//                                                                           }),
//                                                                       ElevatedButton(
//                                                                         style: ElevatedButton.styleFrom(
//                                                                             backgroundColor:
//                                                                                 Colors.white),
//                                                                         onPressed:
//                                                                             () {
//                                                                           _firebase.collection("users").doc("${loggineduser?.uid}").collection("userAddress").doc("${loggineduser?.email}").set({
//                                                                             "fullAddress":
//                                                                                 addre,
//                                                                             "number":
//                                                                                 number,
//                                                                             "name":
//                                                                                 name
//                                                                           }).then(
//                                                                               (value) {
//                                                                             xyz();
//                                                                           });

//                                                                           Navigator.pop(
//                                                                               context);
//                                                                         },
//                                                                         child:
//                                                                             Text(
//                                                                           'Save',
//                                                                           style: Theme.of(context)
//                                                                               .textTheme
//                                                                               .headline5!
//                                                                               .copyWith(color: Colors.black),
//                                                                         ),
//                                                                       )
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             );
//                                                           });
//                                                     },
//                                                     icon:
//                                                         const Icon(Icons.edit)),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       );
//                                     }
//                                   }),
//                               Space(8),
//                               Column(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.only(
//                                         left: 15, right: 15),
//                                     child: Card(
//                                       color: Colors.grey.shade200,
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(10)),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(15),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 const Icon(
//                                                     Icons
//                                                         .offline_share_outlined,
//                                                     size: 20),
//                                                 Space(8),
//                                                 Expanded(
//                                                   child: Text(
//                                                     "This is your Order Number : $c",
//                                                     textAlign: TextAlign.start,
//                                                     style: const TextStyle(
//                                                         fontWeight:
//                                                             FontWeight.w900,
//                                                         fontSize: 18),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Space(8),
//                                             Text(
//                                               "*Get a safety service free in Your Every 3rd Order",
//                                               textAlign: TextAlign.start,
//                                               style: const TextStyle(
//                                                   fontWeight: FontWeight.w900,
//                                                   fontSize: 10),
//                                             ),
//                                             Space(3),
//                                             Text(
//                                               "P.S. The discount will be provided by itself.",
//                                               textAlign: TextAlign.start,
//                                               style: const TextStyle(
//                                                   fontWeight: FontWeight.w900,
//                                                   fontSize: 10),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Space(8),
//                                   Padding(
//                                     padding: const EdgeInsets.only(
//                                         left: 15, right: 15),
//                                     child: Card(
//                                       color: Colors.grey.shade200,
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(10)),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(16),
//                                         child: Column(
//                                           children: [
//                                             ExpansionTile(
//                                               title: const Text(
//                                                 "Detailed Bill",
//                                                 textAlign: TextAlign.start,
//                                                 style: TextStyle(
//                                                     fontWeight: FontWeight.w900,
//                                                     fontSize: 18),
//                                               ),
//                                               children: [
//                                                 ListTile(
//                                                   title: const Text(
//                                                     "Subtotal",
//                                                     textAlign: TextAlign.start,
//                                                     style: TextStyle(
//                                                         color: Colors.grey,
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                         fontSize: 14),
//                                                   ),
//                                                   trailing: Text(
//                                                       "\₹${total.toStringAsFixed(2)}",
//                                                       textAlign:
//                                                           TextAlign.start,
//                                                       style: const TextStyle(
//                                                           fontSize: 14)),
//                                                 ),
//                                                 ListTile(
//                                                   title: const Text(
//                                                     "Coupon Discount",
//                                                     textAlign: TextAlign.start,
//                                                     style: TextStyle(
//                                                         color: Colors.grey,
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                         fontSize: 14),
//                                                   ),
//                                                   trailing: Text("-₹$discount",
//                                                       textAlign:
//                                                           TextAlign.start,
//                                                       style: const TextStyle(
//                                                           fontSize: 14)),
//                                                 ),
//                                                 ListTile(
//                                                   title: const Text(
//                                                     "Pick and Drop fee",
//                                                     textAlign: TextAlign.start,
//                                                     style: TextStyle(
//                                                         color: Colors.grey,
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                         fontSize: 14),
//                                                   ),
//                                                   trailing: Text(
//                                                       "\₹${fee.toStringAsFixed(2)}",
//                                                       textAlign:
//                                                           TextAlign.start,
//                                                       style: const TextStyle(
//                                                           fontSize: 14)),
//                                                 ),
//                                                 const Text(
//                                                   "*Get Free Pick and Drop on Order Above ₹800",
//                                                   style:
//                                                       TextStyle(fontSize: 10),
//                                                 )
//                                               ],
//                                             ),
//                                             ListTile(
//                                               title: const Text("Total",
//                                                   textAlign: TextAlign.start,
//                                                   style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.w900,
//                                                       fontSize: 18)),
//                                               trailing: Text(
//                                                 "\₹${((total + fee) - discount.toDouble()).toStringAsFixed(2)}",
//                                                 textAlign: TextAlign.start,
//                                                 style: const TextStyle(
//                                                     fontWeight: FontWeight.w900,
//                                                     fontSize: 18),
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(
//                                 height:
//                                     MediaQuery.of(context).size.height * 0.09,
//                               )
//                             ],
//                           ),
//                         );
//             }));
//   }
// }
