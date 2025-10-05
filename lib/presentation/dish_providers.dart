import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/api_service_repository.dart';
import '../domain/dish_repository.dart';
import '../models/dish_model.dart';

// Provider principal que crea la instancia del repositorio de API
final apiServiceRepositoryProvider = Provider<ApiServiceRepository>((ref) {
  return ApiServiceRepository();
});

// Provider del repositorio de platos que ahora depende del provider principal
final dishRepositoryProvider = Provider<DishRepository>((ref) {
  return ref.watch(apiServiceRepositoryProvider);
});

// 1. Estado del menú (contiene los filtros para que la UI pueda reaccionar)
class MenuState extends Equatable {
  final List<Dish> dishes;
  final bool isLastPage;
  final int currentPage;
  final int currentIndex;
  final String selectedCategory;

  const MenuState({
    this.dishes = const [],
    this.isLastPage = false,
    this.currentPage = 1,
    this.currentIndex = 0,
    this.selectedCategory = 'All',
  });

  Dish? get currentItem =>
      (dishes.isNotEmpty && currentIndex < dishes.length)
          ? dishes[currentIndex]
          : null;

  MenuState copyWith({
    List<Dish>? dishes,
    bool? isLastPage,
    int? currentPage,
    int? currentIndex,
    String? selectedCategory,
  }) {
    return MenuState(
      dishes: dishes ?? this.dishes,
      isLastPage: isLastPage ?? this.isLastPage,
      currentPage: currentPage ?? this.currentPage,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [
    dishes,
    isLastPage,
    currentPage,
    currentIndex,
    selectedCategory,
  ];
}

// 2. Crear el AsyncNotifier con la lógica de filtro correcta
class MenuNotifier extends AsyncNotifier<MenuState> {
  static const int _pageSize = 10;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  Future<MenuState> build() async {
    final repository = ref.read(dishRepositoryProvider);
    final newDishes = await repository.getDishes(
      page: 1,
      limit: _pageSize,
      category: _selectedCategory,
      search: _searchQuery,
    );
    return MenuState(
      dishes: newDishes,
      currentPage: 1,
      isLastPage: newDishes.length < _pageSize,
      selectedCategory: _selectedCategory,
    );
  }

  Future<void> fetchNextPage() async {
    if (state.isLoading || state.value == null || state.value!.isLastPage) {
      return;
    }
    final currentState = state.value!;
    final repository = ref.read(dishRepositoryProvider);
    final nextPage = currentState.currentPage + 1;

    try {
      final newDishes = await repository.getDishes(
        page: nextPage,
        limit: _pageSize,
        category: _selectedCategory,
        search: _searchQuery,
      );

      state = AsyncData(
        currentState.copyWith(
          dishes: [...currentState.dishes, ...newDishes],
          currentPage: nextPage,
          isLastPage: newDishes.length < _pageSize,
        ),
      );
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }

  void setCategory(String categoryId) {
    if (_selectedCategory == categoryId) return;

    _selectedCategory = categoryId;
    _searchQuery = '';
    ref.invalidateSelf();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _selectedCategory = 'All';
    ref.invalidateSelf();
  }

  void setCurrentIndex(int index) {
    if (state.value == null) return;
    final currentState = state.value!;
    if (index >= 0 && index < currentState.dishes.length) {
      state = AsyncData(currentState.copyWith(currentIndex: index));
    }
  }

  void goToNextItem() {
    if (state.value == null) return;

    final currentState = state.value!;
    if (currentState.currentIndex < currentState.dishes.length - 1) {
      state = AsyncData(
        currentState.copyWith(currentIndex: currentState.currentIndex + 1),
      );
    } else if (!currentState.isLastPage) {
      fetchNextPage();
    } else if (currentState.dishes.isNotEmpty) {
      state = AsyncData(currentState.copyWith(currentIndex: 0));
    }
  }

  void goToPrevItem() {
    if (state.value == null) return;

    final currentState = state.value!;
    if (currentState.currentIndex > 0) {
      state = AsyncData(
        currentState.copyWith(currentIndex: currentState.currentIndex - 1),
      );
    } else if (currentState.dishes.isNotEmpty) {
      state = AsyncData(
        currentState.copyWith(currentIndex: currentState.dishes.length - 1),
      );
    }
  }
}

// 3. Crear el AsyncNotifierProvider
final menuProvider = AsyncNotifierProvider<MenuNotifier, MenuState>(
  MenuNotifier.new,
);
