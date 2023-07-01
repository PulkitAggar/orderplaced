// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycycleclinic/fragments/BMHomeFragment2.dart';
import 'package:nb_utils/nb_utils.dart';

import '../blocs/address/address_bloc.dart';
import '../blocs/cart/cart_bloc.dart';
import '../components/BMShopComponent.dart';
import '../models/BMShoppingModel.dart';
import '../models/order.model.dart';
import '../utils/BMColors.dart';
import '../utils/BMCommonWidgets.dart';
import 'FoodAddAddress.dart';
import 'screens.dart';

// ignore: must_be_immutable
class BMShoppingScreen extends StatefulWidget {
  bool isOrders = true;

  BMShoppingScreen({isOrders});

  @override
  State<BMShoppingScreen> createState() => _BMShoppingScreenState();
}

class _BMShoppingScreenState extends State<BMShoppingScreen> {
  final BaseUrl = 'https://assets.iqonic.design/old-themeforest-images/prokit';
  late String ADDRESSCHECK;

  @override
  void initState() {
    setStatusBarColor(bmLightScaffoldBackgroundColor);
    super.initState();
    BlocProvider.of<AddressBloc>(context).add(LoadAddressEvent());
    BlocProvider.of<CartBloc>(context).add(FetchCartEvent());
  }

  @override
  void dispose() {
    setStatusBarColor(Colors.transparent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
      if (state is CartLoadedState) {
        if (state.list.isEmpty) {
          return Scaffold(
            body: Center(
              child: titleText(title: 'Your cart is empty', size: 30),
            ),
          );
        }
        String getWeekdayName(int weekday) {
          switch (weekday) {
            case DateTime.monday:
              return 'Monday';
            case DateTime.tuesday:
              return 'Tuesday';
            case DateTime.wednesday:
              return 'Wednesday';
            case DateTime.thursday:
              return 'Thursday';
            case DateTime.friday:
              return 'Friday';
            case DateTime.saturday:
              return 'Saturday';
            case DateTime.sunday:
              return 'Sunday';
            default:
              return 'Unknown';
          }
        }

        double calculateTotalCost(List<BMShoppingModel> shoppingList) {
          double totalCost = 0.0;
          for (var item in shoppingList) {
            totalCost += item.cost * item.count;
          }
          return totalCost;
        }

        // will get a boolean on whether to calculate or not which we will send from bloc
        double calculateDiscount(
            List<BMShoppingModel> shoppingList, bool calculateDiscount) {
          double discount = 0.0;
          double ngdiscount = 0.0;

          if (!calculateDiscount) {
            return 0.0;
          }

          for (var item in shoppingList) {
            if (item.subName == 'Geared') {
              discount = state.discount;
            }
            if (item.subName == 'Single-speed') {
              ngdiscount = state.ngdiscount;
            }
          }

          if (ngdiscount != 0.0) {
            return ngdiscount;
          }

          return discount;
        }

        double discount =
            calculateDiscount(state.list, state.calculateDiscount);
        double subTotal = calculateTotalCost(state.list);
        double fee = state.deliveryFee.toDouble();
        if (subTotal > 800.00) {
          fee = 0.00;
        }
        double total = (subTotal - discount) + fee;
        return Scaffold(
          backgroundColor: bmLightScaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: bmLightScaffoldBackgroundColor,
            elevation: 0,
            iconTheme: IconThemeData(color: bmPrimaryColor),
            leadingWidth: 30,
            title: titleText(title: 'Cart', size: 32),
          ),
          bottomSheet: BottomSheet(
            constraints: BoxConstraints(maxHeight: 150),
            elevation: 10,
            enableDrag: false,
            builder: (context) {
              return Column(
                children: [
                  BlocBuilder<AddressBloc, AddressState>(
                    builder: (context, state) {
                      if (state is AddressErrorState) {
                        return Container(
                          height: 20,
                          child: Text(state.error),
                        );
                      }
                      if (state is AddressLoadedState) {
                        ADDRESSCHECK = state.address;
                        return Container(
                          // color: food_app_background,
                          padding: EdgeInsets.all(14),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Icon(Icons.location_on, size: 30),
                              SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                            state.address == ''
                                                ? 'Your Address'
                                                : 'Sweet Home',
                                            style: primaryTextStyle()),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FoodAddAddress()),
                                            );
                                          },
                                          child: Text(
                                              state.address == ''
                                                  ? 'Enter'
                                                  : 'Change',
                                              style: primaryTextStyle(
                                                  color: Color(0xFF3B8BEA))),
                                        ),
                                      ],
                                    ),
                                    Text(
                                        state.address == ''
                                            ? 'Please Enter your address'
                                            : state.address,
                                        style: primaryTextStyle()),
                                    Text(
                                        state.address == ''
                                            ? 'before proceeding...'
                                            : state.city,
                                        style: primaryTextStyle(
                                            size: 14,
                                            color: Color(0xFF949292))),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      } else {
                        return 40.height;
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                            "\Rs. ${total.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              if (ADDRESSCHECK == '') {
                                var snackBar = const SnackBar(
                                  backgroundColor: Colors.redAccent,
                                  dismissDirection: DismissDirection.down,
                                  content: Text(
                                    'Please Fill Address First',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                              if (total != 0 && !(ADDRESSCHECK == '')) {
                                DateTime currentDate = DateTime.now();
                                DateTime currentTime = DateTime.now();
                                OrderModel modelOfOrder = OrderModel(
                                    trackOrder: "pending",
                                    time:
                                        "${currentTime.hour}:${currentTime.minute}:${currentTime.second}",
                                    weekday:
                                        getWeekdayName(currentDate.weekday),
                                    date:
                                        "${currentDate.day}-${currentDate.month}-${currentDate.year}",
                                    cost: (total),
                                    storeUid: state.storUid,
                                    lstOfItems: state.list);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentScreen(
                                      totsamount: total.toDouble(),
                                      orderModel: modelOfOrder,
                                      // code: coupon,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: const Text(
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
                  ),
                ],
              );
            },
            onClosing: () {},
          ),
          body: Container(
            margin: EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
                color: bmSecondBackgroundColorLight,
                borderRadius: radiusOnly(topLeft: 32, topRight: 32)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  30.height,
                  Offstage(),
                  Column(
                    children: state.list.map((e) {
                      return BMShopComponent(element: e);
                    }).toList(),
                  ),
                  4.height,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ExpansionTile(
                          collapsedIconColor: Colors.black54,
                          title: const Text(
                            "Detailed Bill",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 18),
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
                              trailing: Text("\₹${subTotal.toStringAsFixed(2)}",
                                  // "111",
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(fontSize: 14)),
                            ),
                            ListTile(
                              title: const Text(
                                //TODO: On every third order logic?
                                "Coupon Discount",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                              trailing: Text("-₹${discount.toStringAsFixed(2)}",
                                  // "222",
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(fontSize: 14)),
                            ),
                            ListTile(
                              title: const Text(
                                "Pick and Drop fee",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                              trailing: Text("\₹${fee.toStringAsFixed(2)}",
                                  // '333',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(fontSize: 14)),
                            ),
                            const Text(
                              "*Get Free Pick and Drop on Order Above ₹800",
                              style: TextStyle(fontSize: 10),
                            )
                          ],
                        ),
                        ListTile(
                          title: const Text("Total",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 18)),
                          trailing: Text(
                            "\₹${total.toStringAsFixed(2)}",
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  ),
                  148.height
                ],
              ),
            ),
          ),
        );
      }
      if (state is CartLoadingState || state is CartNonInteractiveState) {
        return Scaffold(body: shimmerWidget());
      }
      if (state is CartErrorState) {
        return Scaffold(body: Center(child: Text(state.error)));
      } else {
        return Scaffold(
            body: Center(
                child: Text(
                    'Not again!, there was an unexpected error. Please contact team Mycycleclinic')));
      }
    });
  }
}

Widget makeCartNonInteractive() {
  return Container(
    color: Colors.black.withOpacity(0.5),
    constraints: BoxConstraints.expand(),
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
}
