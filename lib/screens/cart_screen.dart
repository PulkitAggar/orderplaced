import 'dart:async';
import 'package:collection/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nb_utils/nb_utils.dart';
import '../blocs/blocs.dart';
import '../datamodels/models.dart';
import '../widgets/widgets.dart';
import 'screens.dart';
import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import '../models/order.model.dart';

final _firebase = FirebaseFirestorePlatform.instance;
User? loggineduser;

class ShoppingCart extends StatefulWidget {
  @override
  ShoppingCartState createState() => ShoppingCartState();
}

class ShoppingCartState extends State<ShoppingCart> {

String weekday = '';

  void getCurrentWeekday() {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday;

    switch (currentWeekday) {
      case 1:
        setState(() {
          weekday = 'Monday';
        });
        break;
      case 2:
        setState(() {
          weekday = 'Tuesday';
        });
        break;
      case 3:
        setState(() {
          weekday = 'Wednesday';
        });
        break;
      case 4:
        setState(() {
          weekday = 'Thursday';
        });
        break;
      case 5:
        setState(() {
          weekday = 'Friday';
        });
        break;
      case 6:
        setState(() {
          weekday = 'Saturday';
        });
        break;
      case 7:
        setState(() {
          weekday = 'Sunday';
        });
        break;
      default:
        setState(() {
          weekday = 'Unknown';
        });
        break;
    }
  }

  double total = 0.00;
  String coupon = '';
  int discount = 0;
  int fee = 0;
  TextEditingController textEditingController = TextEditingController();
  final AddressBloc addressBloc = AddressBloc();
  final _auth = FirebaseAuth.instance;

  final StreamController<QuerySnapshotPlatform> localStreamController =
      StreamController.broadcast();
  List<dynamic> cop = [];
  bool exist = false;

  late String nameR = '';
  late String numberR = '';
  late String addressR = '';

  @override
  void initState() {
    feeFetch();
    xyz();
    fetch();
    super.initState();
    getuser();
    getCurrentWeekday();

    _firebase
        .collection("cart")
        .doc("${loggineduser?.email}")
        .collection("cart")
        .snapshots()
        .listen((QuerySnapshotPlatform querySnapshot) =>
            localStreamController.add(querySnapshot));

    localStreamController.stream.listen((event) {
      var t = 0.0;
      for (var doc in event.docs) {
        t += doc.get("cost") * doc.get("count");
      }
      if (mounted) {
        setState(() {
          // Your state update code goes here
          total = t;
        });
      }
      // setState(() {
      //   total = t;
      // });
    });
  }

  void getuser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggineduser = user;
        print(loggineduser?.email);
      }
    } catch (e) {
      print(e);
    }
  }

  Future fetch() async {
    await _firebase.collection("coupon").doc("coupon").get().then((value) {
      _firebase
          .collection("users")
          .doc("${loggineduser?.uid}")
          .get()
          .then((value2) {
        List<dynamic> cop1 = [];
        for (int i = 0; i < value.get("code").length; i++) {
          if (total > value.get("code")[i]["amount"]) {
            setState(() {
              cop1.add(value.get("code")[i]["codename"]);
            });
          }
        }
        for (int j = 0; j < value2.get("code").length; j++) {
          cop1.remove(value2.get("code")[j]);
        }
        setState(() {
          cop = cop1;
        });
      });
    });
    // DocumentSnapshotPlatform? foundDoc =
    //     doc.docs.firstWhereOrNull((element) => element.get("code") == coupon);
  }

  void codeDiscount(String name) async {
    await _firebase.collection("coupon").doc("coupon").get().then((value) {
      for (int i = 0; i < value.get("code").length; i++) {
        if (value.get("code")[i]["codename"] == name) {
          print(value.get("code")[i]["amount"]);
          setState(() {
            discount = value.get("code")[i]["amount"];
          });
        }
        // else {
        //   setState(() {
        //     discount = 0;
        //   });
        // }
      }
    });
  }

  void feeFetch() {
    FirebaseFirestore.instance
        .collection("cart")
        .doc("${loggineduser?.email}")
        .get()
        .then((value) {
      try {
        FirebaseFirestore.instance
            .collection("stores")
            .doc(value.get("storeid"))
            .get()
            .then((value) {
          setState(() {
            fee = value.get("Fee");
          });
        });
      } catch (e) {
        print("hello");
      }
    });
  }

  void xyz() {
    FirebaseFirestore.instance
        .collection("users")
        .doc("${loggineduser?.uid}")
        .collection("userAddress")
        .get()
        .then((value) {
      QueryDocumentSnapshot<Map<String, dynamic>>? foundDoc = value.docs
          .firstWhereOrNull((element) => element.get("fullAddress") == "");
      QueryDocumentSnapshot<Map<String, dynamic>>? foundDoc1 =
          value.docs.firstWhereOrNull((element) => element.get("name") == "");
      QueryDocumentSnapshot<Map<String, dynamic>>? foundDoc2 =
          value.docs.firstWhereOrNull((element) => element.get("number") == "");
      if (value.docs.length != 0 &&
          foundDoc?.get("fullAddress") != "" &&
          foundDoc1?.get("name") != "" &&
          foundDoc2?.get("number") != "") {
        // if(value.docs.){}
        setState(() {
          exist = true;
        });
        print("added");
      } else {
        setState(() {
          exist = false;
        });

        print("add");
      }
      print(foundDoc?.get("name"));
    });
  }

  @override
  void dispose() {
    // localStreamController.close();
    textEditingController.dispose();
    super.dispose();
  }

  late List<ShopItem> cartItems;
  double totalAmount = 0.00;
  void calculateTotalAmount(List<ShopItem> list) {
    double res = 0.00;

    list.forEach((element) {
      res = res + element.price * element.quantity;
    });
    totalAmount = res;
  }

  void delete() async {
    FirebaseFirestore.instance
        .collection("cart")
        .doc("${loggineduser?.email}")
        .collection("cart")
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshotPlatform>(
        stream: localStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final messages = snapshot.data?.docs;
          List<CustomCard> messagewidget = [];

          for (var message in messages!) {
            final double cost = message.get("cost");
            final count = message.get("count");
            final imageurl = message.get("imageurl");
            final name = message.get("name");
            var mess = CustomCard(cost, count, imageurl, name, messagewidget);
            messagewidget.add(mess);
          }
          print(loggineduser?.uid);
          

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(
                'Shopping Cart',
                style: TextStyle(color: Colors.black),
              ),
              elevation: 0,
              // leading: IconButton(
              //   icon: Icon(
              //     Icons.arrow_back,
              //     color: Colors.black,
              //   ),
              //   onPressed: () {
              //     Navigator.pop(context);
              //   },
              // ),
            ),
            bottomSheet: BottomSheet(
              elevation: 10,
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
                        Text(
                          "\Rs. ${(total - discount).toStringAsFixed(2)}",
                          // "\Rs. ${totalAmount.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (exist == false) {
                              var snackBar = const SnackBar(
                                dismissDirection: DismissDirection.down,
                                content: Text(
                                  'Please Fill Recivers Details',
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                            if (total != 0 && exist) {
                              DateTime currentDate = DateTime.now();
                              DateTime currentTime = DateTime.now();
                              OrderModel modelOfOrder = OrderModel(
                                  trackOrder: "pending",
                                  time:
                                      "${currentTime.hour}:${currentTime.minute}:${currentTime.second}",
                                  weekday: weekday,
                                  date:
                                      "${currentDate.day}-${currentDate.month}-${currentDate.year}",
                                  cost: total - discount,
                                  storeUid: "Jw05mBpXnk9ydGaJh0p0",
                                  isCancelled: false,
                                  nameR: nameR,
                                  numberR: numberR,
                                  addressR: addressR,
                                  lstOfItems: messages);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentScreen(
                                    totsamount: total - discount.toDouble(),
                                    orderModel: modelOfOrder,
                                    code: coupon,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text(
                            "Proceed to Pay",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
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
            body: messagewidget.length == 0
                ? Center(child: Text('Your Cart is Empty'))
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: 300,
                          child: ListView(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 20.0),
                            children: messagewidget,
                          ),
                        ),
                        Space(8),
                        StreamBuilder<QuerySnapshotPlatform>(
                            stream: _firebase
                                .collection("users")
                                .doc("${loggineduser?.uid}")
                                .collection("userAddress")
                                .snapshots(),
                            builder: (context, innershot) {
                              String name = "";
                              String number = "";
                              String addre = "";
                              if (!innershot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.lightBlueAccent,
                                  ),
                                );
                              }
                              var address = innershot.data?.docs;
                              List<String> addres = [];
                              for (var add in address!) {
                                addres.add(add.get("fullAddress"));
                                addres.add(add.get("name"));
                                addres.add(add.get("number"));
                              }
                              final nameR= name;
                              final numberR = number;
                              final addressR= addre;
                              //OrderModel modelOfOrder = OrderModel
                              return Padding(
                                padding: EdgeInsets.only(left: 15, right: 15),
                                child: Card(
                                  color: Colors.grey.shade200,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Icon(Icons.location_on, size: 20),
                                        Space(24),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Address",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 21),
                                              ),
                                              Space(4),
                                              Text(
                                                addres.length != 0
                                                    ? "${addres[0]}"
                                                    : "enter your Address",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Space(4),
                                              Text(
                                                "Name",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 21),
                                              ),
                                              Space(4),
                                              Text(
                                                addres.length != 0
                                                    ? "${addres[1]}"
                                                    : "enter your name",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Space(4),
                                              Text(
                                                "Number",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 21),
                                              ),
                                              Space(4),
                                              Text(
                                                addres.length != 0
                                                    ? "${addres[2]}"
                                                    : "enter your number",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Space(8),
                                        IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Dialog(
                                                      child: Container(
                                                        height: 250,
                                                        width: 500,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(20),
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Column(
                                                            children: [
                                                              CustomTextField(
                                                                  controller:
                                                                      textEditingController,
                                                                  maxLines: 3,
                                                                  title:
                                                                      'Address',
                                                                  hasTitle:
                                                                      true,
                                                                  initialValue:
                                                                      '',
                                                                  onChanged:
                                                                      (value) {
                                                                    addre = value
                                                                        .toString();
                                                                  }),
                                                              CustomTextField(
                                                                  controller:
                                                                      textEditingController,
                                                                  maxLines: 1,
                                                                  title: 'Name',
                                                                  hasTitle:
                                                                      true,
                                                                  initialValue:
                                                                      '',
                                                                  onChanged:
                                                                      (value) {
                                                                    name = value
                                                                        .toString();
                                                                  }),
                                                              CustomTextField(
                                                                  controller:
                                                                      textEditingController,
                                                                  maxLines: 1,
                                                                  title:
                                                                      'Number',
                                                                  hasTitle:
                                                                      true,
                                                                  initialValue:
                                                                      '',
                                                                  onChanged:
                                                                      (value) {
                                                                    number = value
                                                                        .toString();
                                                                  }),
                                                              ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                        backgroundColor:
                                                                            Colors.white),
                                                                onPressed: () {
                                                                  _firebase
                                                                      .collection(
                                                                          "users")
                                                                      .doc(
                                                                          "${loggineduser?.uid}")
                                                                      .collection(
                                                                          "userAddress")
                                                                      .doc(
                                                                          "${loggineduser?.email}")
                                                                      .set({
                                                                    "fullAddress":
                                                                        addre,
                                                                    "number":
                                                                        number,
                                                                    "name": name
                                                                  }).then((value) {
                                                                    xyz();
                                                                  });

                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                  'Save',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline5!
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.black),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                            icon: Icon(Icons.edit)),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                        Space(8),
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Card(
                                color: Colors.grey.shade200,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Row(
                                    children: [
                                      Icon(Icons.offline_share_outlined,
                                          size: 20),
                                      Space(8),
                                      Expanded(
                                        child: Text(
                                          "Apply Coupon",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 18),
                                        ),
                                      ),
                                      if (total != 0)
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            // ignore: use_build_context_synchronously
                                            // if (total == 0)
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return ListView.builder(
                                                      itemCount: cop.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Card(
                                                            child: Column(
                                                          children: [
                                                            Text(cop[index]),
                                                            TextButton(
                                                                onPressed: () {
                                                                  codeDiscount(
                                                                      cop[index]);
                                                                  coupon = cop[
                                                                      index];
                                                                  print(coupon);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                    'Apply'))
                                                          ],
                                                        ));
                                                      });
                                                });
                                            print(cop);
                                          },
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Space(8),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Card(
                                color: Colors.grey.shade200,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      ExpansionTile(
                                        title: Text(
                                          "Detailed Bill",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 18),
                                        ),
                                        children: [
                                          ListTile(
                                            title: Text(
                                              "Subtotal",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                            trailing: Text(
                                                "\₹${(total - discount).toStringAsFixed(2)}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(fontSize: 14)),
                                          ),
                                          ListTile(
                                            title: Text(
                                              "Coupon Discount",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                            trailing: Text("$discount",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(fontSize: 14)),
                                          ),
                                        ],
                                      ),

                                      ///Divider(indent: 10, endIndent: 12, color: Colors.grey),
                                      ListTile(
                                        title: Text("Total",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 18)),
                                        trailing: Text(
                                          "\₹${(total - discount.toDouble()).toStringAsFixed(2)}",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 18),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.09,
                        )
                      ],
                    ),
                  ),
          );
        });
  }
}

class CustomCard extends StatelessWidget {
  CustomCard(this.cost, this.count, this.imageurl, this.name, this.list);
  final double cost;
  final int count;
  final String imageurl;
  final String name;
  final List<CustomCard> list;
  @override
  Widget build(BuildContext context) {
    final url = 'https://picsum.photos/200/300';
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 5),
      child: Container(
        //height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Image.network(imageurl, height: 64, width: 64),
                  //Expanded(child: SizedBox(width: 1)),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text(
                      name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  //Spacer(),
                  SizedBox(
                    width: 15,
                  ),
                  IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      if (list.length == 1) {
                        _firebase
                            .collection("cart")
                            .doc("${loggineduser?.email}")
                            .collection("cart")
                            .doc(name)
                            .delete()
                            .then((value) {
                          FirebaseFirestore.instance
                              .collection("cart")
                              .doc("${loggineduser?.email}")
                              .delete()
                              .then((value) {
                            FirebaseFirestore.instance
                                .collection("cart")
                                .doc("${loggineduser?.email}")
                                .set({
                              "storeid": "",
                            });
                          });
                        });
                      }
                      _firebase
                          .collection("cart")
                          .doc("${loggineduser?.email}")
                          .collection("cart")
                          .doc(name)
                          .delete();
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //Spacer(),
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      if (count > 0) {
                        int countnew = count - 1;
                        _firebase
                            .collection("cart")
                            .doc("${loggineduser?.email}")
                            .collection("cart")
                            .doc("$name")
                            .set({
                          'cost': cost,
                          'count': countnew,
                          'imageurl': imageurl,
                          'name': name
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                    width: 30,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 0.5)),
                      child: Text(
                        count.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      int countnew = count + 1;
                      _firebase
                          .collection("cart")
                          .doc("${loggineduser?.email}")
                          .collection("cart")
                          .doc("$name")
                          .set({
                        'cost': cost,
                        'count': countnew,
                        'imageurl': imageurl,
                        'name': name
                      });
                    },
                  ),
                  Spacer(),
                  Text(
                    "₹${cost * count}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
