import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/adminSection/blocs/dish/dish_bloc.dart';
import 'package:untitled/adminSection/dashboard/widgets/dish_card.dart';
import 'package:untitled/adminSection/utils/colors.dart';
import 'package:untitled/adminSection/widgets/custom_text_widget.dart';

import '../../blocs/dish/dish_state.dart';
import '../../utils/theme_provider.dart';
import 'categories_section.dart';
import 'package:shimmer/shimmer.dart';

class FoodPageBody extends StatefulWidget {
  const FoodPageBody({super.key});

  @override
  State<FoodPageBody> createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    return BlocBuilder<DishBloc, DishState>(
      builder: (context, state) {
        if (state is DishesSearchResults) {
          return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: state.dishes.isNotEmpty
                  ? ListView.builder(
                      itemCount: state.dishes.length,
                      itemBuilder: (context, index) {
                        final dish = state.dishes[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: DishCard(
                            dish: dish,
                          ),
                        );
                      },
                    )
                  : Column(
                      children: [
                        Container(
                            height: 250,
                            width: 250,
                            margin: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Palette.emptyGrey,
                              image: DecorationImage(
                                fit: BoxFit.contain,
                                image: AssetImage(isDarkMode
                                    ? 'assets/images/whitePal.png'
                                    : 'assets/images/blackPal.png'),
                              ),
                            )),
                        CustomTextWidget(
                          text: "لم يتم العثور على نتائج",
                          size: 16,
                        )
                      ],
                    ));
        } else if (state is DishLoaded) {
          return CategoriesSection();
        } else if (state is DishError) {
          return Center(child: Text(state.error));
        } else {
          return CategoriesSection();
        }
      },
    );
  }
}
