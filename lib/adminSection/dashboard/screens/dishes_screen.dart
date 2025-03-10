import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:untitled/adminSection/blocs/dish/dish_bloc.dart';
import 'package:untitled/adminSection/blocs/dish/dish_state.dart';
import 'package:untitled/adminSection/dashboard/widgets/dish_card.dart';

class DishesScreen extends StatelessWidget {
  const DishesScreen({
    super.key,
    required this.imgUrl,
    required this.catName,
    required this.catId,
  });

  final String imgUrl;
  final String catName;
  final int catId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DishBloc, DishState>(
      builder: (context, state) {
        if (state is DishLoading) {
          return _buildLoadingState();
        }
        if (state is DishLoaded) {
          List<Map<String, dynamic>> categoryDishes =
          state.dishes.where((dish) => dish['catId'] == catId).toList();
          return _buildDishList(categoryDishes);
        }
        return _buildErrorState();
      },
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: 5, // Show 5 loading skeletons
      itemBuilder: (context, index) {
        return _buildShimmerEffect();
      },
    );
  }

  Widget _buildDishList(List<Map<String, dynamic>> categoryDishes) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: categoryDishes.length,
      itemBuilder: (context, index) {
        final dish = categoryDishes[index];
        return DishCard(dish: dish);
      },
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 40),
          const SizedBox(height: 10),
          Text(
            "حدث خطأ، يرجى المحاولة لاحقًا",
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: ListTile(
          contentPadding: const EdgeInsets.all(10),
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[300],
          ),
          title: Container(
            height: 10,
            color: Colors.grey[300],
            margin: const EdgeInsets.only(bottom: 5),
          ),
          subtitle: Container(
            height: 10,
            color: Colors.grey[300],
          ),
        ),
      ),
    );
  }
}
