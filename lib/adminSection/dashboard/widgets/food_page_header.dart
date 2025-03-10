import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:untitled/adminSection/blocs/cartBloc/cart_bloc.dart';
import 'package:untitled/adminSection/blocs/cartBloc/cart_state.dart';
import '../../blocs/dish/dish_bloc.dart';
import '../../blocs/dish/dish_event.dart';
import '../../utils/colors.dart';
import '../../utils/language_Provideer.dart';
import '../../widgets/custom_text_widget.dart';
import '../../utils/theme_provider.dart';
import '../cart/screens/cart_screen.dart';
import 'map/screens/map-screen.dart';

class FoodPageHeader extends StatefulWidget {
  const FoodPageHeader({super.key});

  @override
  State<FoodPageHeader> createState() => _FoodPageHeaderState();
}

class _FoodPageHeaderState extends State<FoodPageHeader> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    text: languageProvider.locale.languageCode == 'en'
                        ? "Palestine"
                        : "فلسطين",
                    color: themeProvider.primaryColor,
                  ),
                  Row(
                    children: [
                      CustomTextWidget.smallText(
                          text: languageProvider.locale.languageCode == 'en'
                              ? "Bethlehem"
                              : "بيت لحم"),
                      IconButton(
                        icon: Icon(Icons.location_on, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
              // Language Toggle
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      languageProvider.toggleLanguage(); // Toggle the language
                    },
                    child: Row(
                      children: [
                        Icon(
                          languageProvider.locale.languageCode == 'en'
                              ? Icons.language
                              : Icons.language_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          languageProvider.locale.languageCode == 'en'
                              ? "English"
                              : "العربية",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutScreen(),
                        ),
                      );
                    },
                    child: Stack(clipBehavior: Clip.none, children: [
                      FaIcon(
                        FontAwesomeIcons.cartShopping,
                        color: Colors.white,
                        size: 30,
                      ),
                      BlocBuilder<CartBloc, CartState>(
                        builder: (context, state) {
                          if (state.cartItems.isEmpty) return SizedBox();
                          return TweenAnimationBuilder(
                            tween: Tween<double>(begin: 10, end: -5),
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeOut,
                            builder: (context, value, child) {
                              return Positioned(
                                right: value,
                                top: value,
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                  ),
                                  child: Text(
                                    state.cartItems.length.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )
                    ]),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 300,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Palette.appColor, // لون الإطار
                width: 2,
              ),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                context.read<DishBloc>().add(SearchDishes(value));
              },
              onSubmitted: (value) {
                context.read<DishBloc>().add(SearchDishes(value));
              },
              decoration: InputDecoration(
                hintText: languageProvider.locale.languageCode == 'en'
                    ? 'Search here...'
                    : 'ابحث هنا...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Palette.appColor,
                  ),
                  onPressed: () {
                    context
                        .read<DishBloc>()
                        .add(SearchDishes(_searchController.text));
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
