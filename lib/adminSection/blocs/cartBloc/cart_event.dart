import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {}

class AddToCart extends CartEvent {
  final String dishId;

  const AddToCart(this.dishId);

  @override
  List<Object> get props => [dishId];
}

class RemoveFromCart extends CartEvent {
  final String dishId;

  const RemoveFromCart(this.dishId);

  @override
  List<Object> get props => [dishId];
}

class ClearCart extends CartEvent {}
