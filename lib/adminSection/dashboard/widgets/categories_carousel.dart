import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/category/category_bloc.dart';
import '../../blocs/category/category_state.dart';
import '../../utils/language_Provideer.dart';
import '../../utils/theme_provider.dart';
import '../screens/dishes_screen.dart';
import 'package:untitled/adminSection/widgets/custom_text_widget.dart';
import 'package:untitled/adminSection/utils/colors.dart';

class CategoriesCarousel extends StatefulWidget {
  const CategoriesCarousel({super.key});

  @override
  _CategoriesCarouselState createState() => _CategoriesCarouselState();
}

class _CategoriesCarouselState extends State<CategoriesCarousel> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final languageProvider = context.watch<LanguageProvider>();

    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Expanded(child: Center(child: CircularProgressIndicator()));
        }

        if (state is CategoryLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoryList(state.categories, languageProvider),
              const SizedBox(height: 10),
              _buildDishContent(state.categories),
            ],
          );
        }

        return const Center(child: Text("حدث خطأ"));
      },
    );
  }

  Widget _buildCategoryList(List<dynamic> categories, LanguageProvider languageProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = index == selectedIndex;
          final categoryName = category["name"][languageProvider.locale.languageCode] ?? category["name"]["en"];

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: _buildCategoryItem(categoryName, isSelected),
          );
        },
      ),
    );
  }

  Widget _buildCategoryItem(String categoryName, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 2,
            color: isSelected ? Palette.appColor.withOpacity(0.9) : Colors.transparent,
          ),
        ),
      ),
      child: Center(
        child: CustomTextWidget.smallText(
          size: 14,
          text: categoryName,
          color: isSelected ? Palette.appColor : Colors.black,
        ),
      ),
    );
  }

  Widget _buildDishContent(List<dynamic> categories) {
    return Expanded(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: DishesScreen(
          key: ValueKey(selectedIndex),
          catId: selectedIndex + 1,
          catName: categories[selectedIndex]["name"]['en'],
          imgUrl: categories[selectedIndex]["imageUrl"],
        ),
      ),
    );
  }
}
