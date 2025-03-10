import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dish_event.dart';
import 'dish_state.dart';

// 🟢 Main Bloc class
class DishBloc extends Bloc<DishEvent, DishState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _allDishes = []; // القائمة الأصلية

  DishBloc() : super(DishInitial()) {
    on<LoadDishes>(_onLoadDishes);
    on<SearchDishes>(_onSearchDishes);
  }

  Future<void> _onLoadDishes(LoadDishes event, Emitter<DishState> emit) async {
    emit(DishLoading());
    try {
      var snapshot = await _firestore.collection('dishes').get();
      List<Map<String, dynamic>> dishes =
          snapshot.docs.map((doc) => doc.data()).toList();
      _allDishes = dishes;
      emit(DishLoaded(dishes));
    } catch (e) {
      emit(DishError("حدث خطأ أثناء تحميل الأطباق"));
    }
  }

  Future<void> _onSearchDishes(
      SearchDishes event, Emitter<DishState> emit) async {
    String query = event.query.toLowerCase();

    // إذا كان نص البحث فارغ، نعود للحالة الأصلية مع القائمة الكاملة
    if (query.isEmpty) {
      emit(DishLoaded(_allDishes));
      return;
    }

    // البحث دائمًا على القائمة الأصلية
    List<Map<String, dynamic>> matchedDishes = _allDishes.where((dish) {
      return dish['name'].toString().toLowerCase().contains(query);
    }).toList();

    emit(DishesSearchResults(matchedDishes));
  }
}
