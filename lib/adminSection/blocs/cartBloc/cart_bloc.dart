import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState(cartItems: [])) {
    // تحميل السلة عند بدء التطبيق
    on<LoadCart>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final cartItemIds = await getCartFromFirestore(user.uid);
        print("Cart loaded: $cartItemIds");  // طباعة للتأكد من تحميل السلة بشكل صحيح
        emit(CartState(cartItems: cartItemIds));
      } else {
        emit(CartState(cartItems: []));
      }
    });


    // إضافة عنصر للسلة (تخزين ID فقط)
    on<AddToCart>((event, emit) async {
      final updatedCart = List<String>.from(state.cartItems);
      if (!updatedCart.contains(event.dishId)) {
        updatedCart.add(event.dishId);
      }
      emit(CartState(cartItems: updatedCart));
      await saveCartToFirestore(updatedCart);
    });

    // إزالة عنصر من السلة
    on<RemoveFromCart>((event, emit) async {
      final updatedCart = List<String>.from(state.cartItems);
      updatedCart.remove(event.dishId);
      emit(CartState(cartItems: updatedCart));
      await saveCartToFirestore(updatedCart);
    });

    // مسح السلة بالكامل
    on<ClearCart>((event, emit) async {
      emit(CartState(cartItems: []));
      await saveCartToFirestore([]);
    });
  }

  // جلب السلة من Firestore
  Future<List<String>> getCartFromFirestore(String userId) async {
    final docSnapshot =
        await FirebaseFirestore.instance.collection('carts').doc(userId).get();
    if (docSnapshot.exists) {
      return List<String>.from(docSnapshot.data()?['cartItems'] ?? []);
    }
    return [];
  }

  // حفظ السلة في Firestore
  Future<void> saveCartToFirestore(List<String> cartItemIds) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('carts').doc(user.uid).set({
        'cartItems':cartItemIds,
      },SetOptions(merge: true));
    }
  }
}
