// 🟢 تعريف الأحداث
abstract class CategoryEvent {}
class LoadCategories extends CategoryEvent {}
class AddCategory extends CategoryEvent {
  final String name;
  AddCategory(this.name);
}
