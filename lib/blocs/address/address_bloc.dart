import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc() : super(AddressInitialState()) {

    on<SaveAddressEvent>((event, emit) async {
      emit(AddressLoadingState());

      try {
        var doc = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('userAddress')
            .doc(FirebaseAuth.instance.currentUser?.email);

        await doc.set({
          'fullname': event.fullname,
          'address': event.address,
          'pincode': event.pincode,
          'city': event.city,
          'mobileno': event.mobileno,
          'state': event.state,
        }, SetOptions(merge: true));

        await getAddress();

        emit(AddressLoadedState(
            address: address,
            fullname: fullname,
            pincode: pincode,
            city: city,
            mobileno: mobileno,
            state: state));
      } on Exception catch (e) {
        emit(AddressErrorState(e.toString()));
      }
    });

    on<LoadAddressEvent>((event, emit) async {
      emit(AddressLoadingState());

      try {
        await getAddress();

        emit(AddressLoadedState(
            address: address,
            fullname: fullname,
            pincode: pincode,
            city: city,
            mobileno: mobileno,
            state: state));

      } on Exception catch (e) {
        emit(AddressErrorState(e.toString()));
      }
    });
  
  }
}

String pincode = '';
String city = '';
String state = '';
String address = '';
String mobileno = '';
String fullname = '';

Future<void> getAddress() async {
  var doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('userAddress')
      .doc(FirebaseAuth.instance.currentUser?.email)
      .get();

  pincode = doc.data()!['pincode'];
  city = doc.data()!['city'];
  state = doc.data()!['state'];
  address = doc.data()!['address'];
  mobileno = doc.data()!['mobileno'];
  fullname = doc.data()!['fullname'];
}
