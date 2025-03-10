// 🟢 تعريف الحالة
abstract class CategoryState {}
class CategoryInitial extends CategoryState {}
class CategoryLoading extends CategoryState {}
class CategoryLoaded extends CategoryState {
  final List<Map<String, dynamic>> categories;
  CategoryLoaded(this.categories);
}
class CategoryError extends CategoryState {
  final String error;
  CategoryError(this.error);
}
