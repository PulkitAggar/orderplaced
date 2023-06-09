part of 'address_bloc.dart';

@override
abstract class AddressEvent {}

class LoadAddressEvent extends AddressEvent {
  LoadAddressEvent();
}

class SaveAddressEvent extends AddressEvent {
  String fullname;
  String pincode;
  String city;
  String state;
  String address;
  String mobileno;

  SaveAddressEvent({required this.address,required this.fullname,required this.pincode,required this.city,required this.mobileno,required this.state,});
}
