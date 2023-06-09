part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class FetchCartEvent extends CartEvent {
  const FetchCartEvent();
}

class IncrementItem extends CartEvent {
  final BMShoppingModel element;
  

  const IncrementItem(this.element, );
}

class DecrementItem extends CartEvent {
  final BMShoppingModel element;

  const DecrementItem(this.element, );
}

class DeleteItem extends CartEvent {
  final BMShoppingModel element;

  const DeleteItem(this.element, );
}
