import 'package:equatable/equatable.dart';

class CartState extends Equatable {
  final List<String> cartItems; // تخزين قائمة المعرفات فقط

  CartState({this.cartItems = const []});

  @override
  List<Object> get props => [cartItems];
}
