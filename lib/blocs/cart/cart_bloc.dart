import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/BMShoppingModel.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitialState()) {
    on<FetchCartEvent>((event, emit) async {
      emit(CartLoadingState());
      try {
        List<BMShoppingModel> list = [];
        int deliveryFee = 0;
        list = await getCartList();
        await toCalculateDiscount();
        deliveryFee = await getDeliveryFee();
        emit(CartLoadedState(list, deliveryFee, storeId, calculateDiscount));
      } catch (e) {
        emit(CartErrorState(e.toString()));
      }
    });

    on<IncrementItem>((event, emit) async {
      emit(CartNonInteractiveState());

      try {
        var newCount = event.element.count;
        int deliveryFee = 0;
        List<BMShoppingModel> list = [];
        await FirebaseFirestore.instance
            .collection('cart')
            .doc(FirebaseAuth.instance.currentUser?.email)
            .collection('cart')
            .doc(event.element.name)
            .update({'count': newCount});
        list = await getCartList();
        deliveryFee = await getDeliveryFee();
        emit(CartLoadedState(list, deliveryFee, storeId, calculateDiscount));
      } catch (e) {
        emit(CartErrorState(e.toString()));
      }
    });
    on<DecrementItem>((event, emit) async {
      emit(CartNonInteractiveState());
      try {
        var newCount = event.element.count;
        int deliveryFee = 0;
        List<BMShoppingModel> list = [];
        await FirebaseFirestore.instance
            .collection('cart')
            .doc(FirebaseAuth.instance.currentUser?.email)
            .collection('cart')
            .doc(event.element.name)
            .update({'count': newCount});
        list = await getCartList();
        deliveryFee = await getDeliveryFee();
        emit(CartLoadedState(list, deliveryFee, storeId, calculateDiscount));
      } catch (e) {
        emit(CartErrorState(e.toString()));
      }
    });
    on<DeleteItem>((event, emit) async {
      emit(CartNonInteractiveState());

      try {
        int deliveryFee = 0;
        List<BMShoppingModel> list = [];
        await FirebaseFirestore.instance
            .collection('cart')
            .doc(FirebaseAuth.instance.currentUser?.email)
            .collection('cart')
            .doc(event.element.name)
            .delete();

        list = await getCartList();

        if (list.isEmpty) {
          await FirebaseFirestore.instance
              .collection('cart')
              .doc(FirebaseAuth.instance.currentUser?.email)
              .set({'storeid': ''}, SetOptions(merge: true));
        }
        deliveryFee = await getDeliveryFee();
        emit(CartLoadedState(list, deliveryFee, storeId, calculateDiscount));
      } catch (e) {
        emit(CartErrorState(e.toString()));
      }
    });
  }
}

Future<List<BMShoppingModel>> getCartList() async {
  List<BMShoppingModel> list = [];

  QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
      .instance
      .collection('cart')
      .doc(FirebaseAuth.instance.currentUser?.email)
      .collection('cart')
      .get();

  for (var doc in querySnapshot.docs) {
    String name = doc.data()['name'] ?? '';

    String subName = doc.data()['subname'] ?? '';

    String catName = doc.data()['catname'] ?? '';

    String imageUrl = doc.data()['imageurl'] ?? '';

    double cost = doc.data()['cost'] ?? 0;

    int count = doc.data()['count'] ?? 0;

    BMShoppingModel modelData = BMShoppingModel(
        name: name,
        cost: cost,
        imageUrl: imageUrl,
        subName: subName,
        count: count,
        catName: catName);

    list.add(modelData);
  }

  return list;
}

String storeId = '';

bool calculateDiscount = false;

Future<void> toCalculateDiscount() async {
  var doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .get();

  int count = doc.data()!['count'];

  if (count.remainder(3) == 0) {
    calculateDiscount = true;
  }
}

Future<int> getDeliveryFee() async {
  var doc = await FirebaseFirestore.instance
      .collection('cart')
      .doc(FirebaseAuth.instance.currentUser?.email)
      .get();

  storeId = doc.data()!['storeid'];

  if (storeId == '') {
    return 0;
  } else {
    var storeDoc = await FirebaseFirestore.instance
        .collection('stores')
        .doc(storeId)
        .get();

    int fee = storeDoc.data()!['Fee'];
    return fee;
  }
}

// feeFetch() async {

//     await FirebaseFirestore.instance
//         .collection("cart")
//         .doc("${FirebaseAuth.instance.currentUser?.email}")
//         .collection("cart")
//         .get()
//         .then((value) {
//       if (value.docs.isNotEmpty) {
//         _firebase
//             .collection("cart")
//             .doc("${FirebaseAuth.instance.currentUser?.email}")
//             .get()
//             .then((value) {
//           setState(() {
//             storeuid = value.get("storeid");
//           });
//           couponDiscount2(value.get("storeid"));
//         });
//       } else {
//         setState(() {
//           empty = 0;
//         });
//       }
//     });
//   }

//   void couponDiscount2(String id) async {
//     if (id != "") {
//       var d = await FirebaseFirestore.instance
//           .collection("cart")
//           .doc("${loggineduser?.email}")
//           .collection("cart")
//           .get();
//       List tot = [];
//       for (int i = 0; i < d.docs.length; i++) {
//         setState(() {
//           tot.add(d.docs[i].get("cost") * d.docs[i].get("count"));
//         });
//       }
//       double sum = tot.reduce((value, element) => value + element);

//       setState(() {
//         total = sum;
//       });
//       if (sum < 800.00) {
//         FirebaseFirestore.instance
//             .collection("cart")
//             .doc("${loggineduser?.email}")
//             .get()
//             .then((value) {
//           FirebaseFirestore.instance
//               .collection("stores")
//               .doc(id)
//               .get()
//               .then((value) {
//             setState(() {
//               fee = value.get("Fee");
//             });
//           });
//         });
//       } else {
//         setState(() {
//           fee = 0;
//         });
//       }
//       List amount = [];
//       List nonamount = [];
//       List gearamount = [];

//       var doc = await FirebaseFirestore.instance
//           .collection("stores")
//           .doc(id)
//           .collection("menus")
//           .get();

//       var doc1 = await FirebaseFirestore.instance
//           .collection("cart")
//           .doc("${loggineduser?.email}")
//           .collection("cart")
//           .get();

//       var founddoc = doc1.docs
//           .firstWhereOrNull((element) => element.get("subname") == "Geared");
//       var founddoc2 = doc1.docs.firstWhereOrNull(
//           (element) => element.get("subname") == "Single-speed");
//       var founddoc3 = doc1.docs
  //         .firstWhereOrNull((element) => element.get("catname") == "Services");

  //     await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc("${loggineduser?.uid}")
  //         .get()
  //         .then((value) {
  //       setState(() {
  //         c = value.get("count");
  //       });
  //     });
  //     await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc("${loggineduser?.uid}")
  //         .get()
  //         .then((value) {
  //       if (value.get("count") % 3 == 0) {
  //         if (founddoc != null) {
  //           for (int i = 0; i < doc.docs.length; i++) {
  //             if (doc.docs[i].get("subname") == "Geared") {
  //               setState(() {
  //                 gearamount.add(doc.docs[i].get("itemPrice"));
  //               });
  //             }
  //           }
  //           setState(() {
  //             int val = gearamount.reduce(
  //                 (value, element) => value < element ? value : element);
  //             amount.add(val);
  //           });
  //         }

  //         if (founddoc2 != null) {
  //           for (int i = 0; i < doc.docs.length; i++) {
  //             if (doc.docs[i].get("subname") == "Single-speed") {
  //               setState(() {
  //                 nonamount.add(doc.docs[i].get("itemPrice"));
  //               });
  //             }
  //           }
  //           setState(() {
  //             int val2 = nonamount.reduce(
  //                 (value, element) => value < element ? value : element);

  //             amount.add(val2);
  //           });
  //         }

  //         setState(() {
  //           if (amount.isEmpty) {
  //             setState(() {
  //               discount = 0;
  //             });
  //           } else {
  //             int val3 = amount.reduce(
  //                 (value, element) => value < element ? value : element);

  //             discount = val3.toInt();
  //           }
  //         });
  //       }
  //     }).then((value) {
  //       setState(() {
  //         _isRunning = false;
  //       });
  //     });
  //   } else {
  //     setState(() {
  //       _isRunning = false;
  //     });
  //   }
  // }