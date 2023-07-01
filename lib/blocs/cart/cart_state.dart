part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitialState extends CartState {}

class CartLoadingState extends CartState {}

class CartLoadedState extends CartState {
  final List<BMShoppingModel> list;
  final int deliveryFee;
  final String storUid;
  final bool calculateDiscount;
  final double discount;
  final double ngdiscount;

  CartLoadedState(this.list, this.deliveryFee, this.storUid,
      this.calculateDiscount, this.discount, this.ngdiscount);
}

class CartErrorState extends CartState {
  String error;

  CartErrorState(this.error);
}

class CartNonInteractiveState extends CartState {}
