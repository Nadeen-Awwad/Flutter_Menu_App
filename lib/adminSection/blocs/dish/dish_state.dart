// 🟢 تعريف الحالة
abstract class DishState {}

class DishInitial extends DishState {}

class DishLoading extends DishState {}

class DishLoaded extends DishState {
  final List<Map<String, dynamic>> dishes;

  DishLoaded(this.dishes);
}

class DishError extends DishState {
  final String error;

  DishError(this.error);
}

class DishesSearchResults extends DishState {
  final List<Map<String, dynamic>> dishes;

  DishesSearchResults(this.dishes);
}
