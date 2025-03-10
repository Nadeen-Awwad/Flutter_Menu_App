import 'dart:io';

abstract class DishEvent {}

class LoadDishes extends DishEvent {}

class AddDish extends DishEvent {
  final String name;
  final String description;
  final double price;
  final File image;
  final String category;
  final String? subcategory;

  AddDish({required this.name, required this.description, required this.price, required this.image, required this.category,
      this.subcategory});
}

class SearchDishes extends DishEvent {
  final String query;
  SearchDishes(this.query);
}
