import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:untitled/adminSection/blocs/cartBloc/cart_bloc.dart';
import 'package:untitled/adminSection/blocs/cartBloc/cart_event.dart';
import 'package:untitled/adminSection/blocs/cartBloc/cart_state.dart';
import 'package:untitled/adminSection/utils/colors.dart';
import 'package:untitled/adminSection/widgets/custom_text_widget.dart';

import '../../../blocs/dish/dish_bloc.dart';
import '../../../blocs/dish/dish_state.dart';
import '../../../utils/language_Provideer.dart';

class CheckoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTextWidget(
            text: "Cart (${context.read<CartBloc>().state.cartItems.length})"),
        backgroundColor: Palette.appColor,
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.black38,
      ),
      body: Stack(
        children: [
          _buildBackground(),
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state.cartItems.isEmpty) {
                return _buildEmptyCart();
              }
              return _buildCartItemsList(state);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: Stack(
        children: [
          Image.asset(
            'assets/images/food.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Text(
        "السلة فارغة 🛒",
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCartItemsList(CartState state) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: state.cartItems.length,
            itemBuilder: (context, index) {
              final dishId = state.cartItems[index];
              return CartDishCard(dishId: dishId);
            },
          ),
        ),
        Divider(color: Colors.white70, thickness: 1),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                print("تم الطلب");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.appColor,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: CustomTextWidget(text: "Request here"),
            ),
          ),
        ),
      ],
    );
  }
}

class CartDishCard extends StatelessWidget {
  final String dishId;

  const CartDishCard({super.key, required this.dishId});

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();

    return BlocBuilder<DishBloc, DishState>(
      builder: (context, state) {
        if (state is DishLoading) {
          return _buildShimmerCard();
        }

        if (state is DishLoaded) {
          final dish = state.dishes.firstWhere(
            (dish) => dish['id'] == dishId,
            orElse: () => {
              'id': '',
              'name': {'en': 'Unknown Dish', 'ar': 'طبق غير معروف'},
              'price': '0.0',
              'imgUrl': ''
            },
          );

          return _buildDishCard(dish, langProvider);
        }

        return _buildErrorState();
      },
    );
  }

  Widget _buildShimmerCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child:
            Container(height: 100, width: double.infinity, color: Colors.white),
      ),
    );
  }

  Widget _buildDishCard(
      Map<String, dynamic> dish, LanguageProvider langProvider) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _buildDishImage(dish),
            const SizedBox(width: 12),
            _buildDishInfo(dish, langProvider),
            _buildCartControls(dish),
          ],
        ),
      ),
    );
  }

  Widget _buildDishImage(Map<String, dynamic> dish) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        imageUrl: dish['imgUrl'] ?? '',
        width: 90,
        height: 90,
        fit: BoxFit.cover,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(width: 90, height: 90, color: Colors.white),
        ),
        errorWidget: (context, url, error) =>
            Icon(Icons.error, size: 40, color: Colors.redAccent),
      ),
    );
  }

  Widget _buildDishInfo(
      Map<String, dynamic> dish, LanguageProvider langProvider) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dish['name'][langProvider.locale.languageCode] ?? 'اسم الطبق',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            "₪ ${dish['price'] ?? '0.0'}",
            style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildCartControls(Map<String, dynamic> dish) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        return Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove_circle_outline, color: Colors.redAccent),
              onPressed: () =>
                  context.read<CartBloc>().add(RemoveFromCart(dish['id'])),
            ),
            Text("1",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(
              icon: Icon(Icons.add_circle_outline, color: Colors.green),
              onPressed: () =>
                  context.read<CartBloc>().add(AddToCart(dish['id'])),
            ),
          ],
        );
      },
    );
  }

  Widget _buildErrorState() {
    return Center(child: Text('Error loading dishes'));
  }
}
