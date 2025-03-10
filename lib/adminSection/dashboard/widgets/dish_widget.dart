import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:untitled/adminSection/widgets/custom_text_widget.dart';
import 'package:untitled/adminSection/widgets/white_empty_card.dart';
import '../../blocs/cartBloc/cart_bloc.dart';
import '../../blocs/cartBloc/cart_event.dart';
import '../../utils/colors.dart';
import '../../utils/language_Provideer.dart';

class DishWidget extends StatelessWidget {
  const DishWidget({super.key, required this.dish});

  final Map<String, dynamic> dish;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final languageProvider = context.watch<LanguageProvider>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackgroundImage(isDarkMode),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: kToolbarHeight + 20),
                _buildDishImage(),
                _buildDishDetails(context, languageProvider, isDarkMode),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage(bool isDarkMode) {
    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: CachedNetworkImage(
              imageUrl: dish['imgUrl'] ?? '',
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Image.asset(
                'assets/images/food.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (isDarkMode) Container(color: Colors.black.withOpacity(0.5)),
        ],
      ),
    );
  }

  Widget _buildDishImage() {
    return Hero(
      tag: dish["imgUrl"],
      child: Container(
        height: 300,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, 5)),
          ],
          image: DecorationImage(
            fit: BoxFit.cover,
            image: dish['imgUrl'] != null && dish['imgUrl'].isNotEmpty
                ? CachedNetworkImageProvider(dish['imgUrl'])
                : const AssetImage('assets/images/food.jpg') as ImageProvider,
          ),
        ),
      ),
    );
  }

  Widget _buildDishDetails(BuildContext context,
      LanguageProvider languageProvider, bool isDarkMode) {
    return WhiteEmptyCard(
      border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          width: 1.5),
      color: isDarkMode
          ? Colors.black.withOpacity(0.7)
          : Colors.white.withOpacity(0.9),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDishTitleAndPrice(context, languageProvider),
          const Divider(thickness: 0.5, color: Colors.grey),
          const SizedBox(height: 10),
          _buildDishDescription(context, languageProvider),
          const SizedBox(height: 20),
          _buildAdditionalDetails(context, isDarkMode),
          _buildAddToCartButton(context),
        ],
      ),
    );
  }

  Widget _buildDishTitleAndPrice(
      BuildContext context, LanguageProvider languageProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomTextWidget(
          text:
              dish['name'][languageProvider.locale.languageCode] ?? "Dish Name",
          size: 26,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        CustomTextWidget(
          text: '₪ ${dish['price'] ?? ""}',
          size: 20,
          color: Palette.appColor,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }

  Widget _buildDishDescription(
      BuildContext context, LanguageProvider languageProvider) {
    return CustomTextWidget(
      text: dish['desc'][languageProvider.locale.languageCode] ??
          "No description available",
      size: 18,
      height: 1.2,
      fontWeight: FontWeight.w100,
      color: Theme.of(context).colorScheme.onBackground,
      overflow: TextOverflow.visible,
    );
  }

  Widget _buildAdditionalDetails(BuildContext context, bool isDarkMode) {
    return Row(
      children: [
        Icon(Icons.access_time,
            color: isDarkMode ? Colors.white70 : Colors.grey, size: 20),
        const SizedBox(width: 5),
        CustomTextWidget(
          text: '${dish['prepTime'] ?? "25"} mins',
          size: 16,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ],
    );
  }

  Widget _buildAddToCartButton(BuildContext context) {
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
                  offset: const Offset(0, 3)),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextWidget.smallText(
                  text: "Add to Cart",
                  size: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
              const SizedBox(width: 5),
              const FaIcon(FontAwesomeIcons.cartPlus,
                  size: 18, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
