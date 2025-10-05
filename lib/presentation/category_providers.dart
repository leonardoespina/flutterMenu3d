import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/category_repository.dart';
import '../models/category_model.dart';
import 'dish_providers.dart';

// Provider del repositorio de categorías que ahora depende del provider principal
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return ref.watch(apiServiceRepositoryProvider);
});

// 1. Estado de las categorías
class CategoryState extends Equatable {
  final List<Category> categories;
  final bool isLastPage;
  final int currentPage;

  const CategoryState({
    this.categories = const [],
    this.isLastPage = false,
    this.currentPage = 1,
  });

  CategoryState copyWith({
    List<Category>? categories,
    bool? isLastPage,
    int? currentPage,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      isLastPage: isLastPage ?? this.isLastPage,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [categories, isLastPage, currentPage];
}

// 2. AsyncNotifier para las categorías
class CategoryNotifier extends AsyncNotifier<CategoryState> {
  static const int _pageSize = 10;

  @override
  Future<CategoryState> build() async {
    return _fetchCategories(page: 1);
  }

  Future<CategoryState> _fetchCategories({required int page}) async {
    final repository = ref.read(categoryRepositoryProvider);
    final newCategories = await repository.getCategories(
      page: page,
      limit: _pageSize,
    );

    return CategoryState(
      categories: newCategories,
      currentPage: page,
      isLastPage: newCategories.length < _pageSize,
    );
  }

  Future<void> fetchNextPage() async {
    if (state.isLoading || state.value == null || state.value!.isLastPage) {
      return;
    }

    final repository = ref.read(categoryRepositoryProvider);
    final nextPage = state.value!.currentPage + 1;

    try {
      final newCategories = await repository.getCategories(
        page: nextPage,
        limit: _pageSize,
      );

      state = AsyncData(
        state.value!.copyWith(
          categories: [...state.value!.categories, ...newCategories],
          currentPage: nextPage,
          isLastPage: newCategories.length < _pageSize,
        ),
      );
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }
}

// 3. AsyncNotifierProvider para las categorías
final categoryProvider = AsyncNotifierProvider<CategoryNotifier, CategoryState>(
  CategoryNotifier.new,
);
