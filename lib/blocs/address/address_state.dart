part of 'address_bloc.dart';

abstract class AddressState extends Equatable {
  @override
  List<Object> get props => [];
}

class AddressInitialState extends AddressState {}

class AddressLoadingState extends AddressState {}

class AddressLoadedState extends AddressState {
  String fullname;
  String pincode;
  String city;
  String state;
  String address;
  String mobileno;

  AddressLoadedState({
    required this.address,
    required this.fullname,
    required this.pincode,
    required this.city,
    required this.mobileno,
    required this.state,
  });
}

class AddressErrorState extends AddressState {
  String error;

  AddressErrorState(this.error);
}
