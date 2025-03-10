import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'category_event.dart';
import 'category_state.dart';

// 🟢 الكتلة الرئيسية
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CategoryBloc() : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
  }

  Future<void> _onLoadCategories(LoadCategories event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      var snapshot = await _firestore.collection('categories').get();
      List<Map<String, dynamic>> categories = snapshot.docs.map((doc) => doc.data()).toList();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError("حدث خطأ أثناء تحميل التصنيفات"));
    }
  }

}