import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:untitled/adminSection/blocs/cartBloc/cart_event.dart';
import 'package:untitled/adminSection/widgets/custom_text_widget.dart';
import '../../blocs/cartBloc/cart_bloc.dart';
import '../../utils/colors.dart';
import '../../utils/language_Provideer.dart';
import 'dish_widget.dart';

class DishCard extends StatelessWidget {
  final Map<String, dynamic> dish;

  const DishCard({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final String dishName = dish["name"][languageProvider.locale.languageCode] ?? dish["name"]["en"];
    final String dishPrice = "₪ ${dish["price"] ?? "0.00"}";

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DishWidget(dish: dish)),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        decoration: _buildCardDecoration(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              _buildBlurEffect(),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildImage(),
                    _buildDetails(dishName, dishPrice),
                    _buildCartButton(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: LinearGradient(
        colors: [Colors.black.withOpacity(0.6), Colors.black.withOpacity(0.3)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  Widget _buildBlurEffect() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Hero(
      tag: "${dish["imgUrl"]}",
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CachedNetworkImage(
          imageUrl: dish["imgUrl"],
          placeholder: (context, url) => _buildShimmerEffect(),
          errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[600]!,
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildDetails(String name, String price) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextWidget(
              text: name,
              size: 17,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Palette.lightAppColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => context.read<CartBloc>().add(AddToCart(dish['id'])),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Palette.appColor.withOpacity(0.8),
            boxShadow: [
              BoxShadow(
                color: Palette.appColor.withOpacity(0.3),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const FaIcon(FontAwesomeIcons.cartPlus, size: 18, color: Colors.white),
        ),
      ),
    );
  }
}
