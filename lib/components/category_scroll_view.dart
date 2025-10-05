import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../presentation/category_providers.dart';
import '../presentation/dish_providers.dart';

// Habilita el comportamiento de scroll con el ratón en web y escritorio.
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

class CategoryScrollView extends ConsumerStatefulWidget {
  const CategoryScrollView({super.key});

  @override
  ConsumerState<CategoryScrollView> createState() => _CategoryScrollViewState();
}

class _CategoryScrollViewState extends ConsumerState<CategoryScrollView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Si el usuario está cerca del final de la lista, carga la siguiente página.
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(categoryProvider.notifier).fetchNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryProvider);
    final selectedCategoryId =
        ref.watch(menuProvider).value?.selectedCategory ?? 'All';

    return SizedBox(
      height: 55,
      child: categoryState.when(
        data: (data) {
          final categories = data.categories;
          if (categories.isEmpty) {
            return const Center(child: Text('No hay categorías'));
          }
          return ScrollConfiguration(
            behavior: MyCustomScrollBehavior(),
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: categories.length + (data.isLastPage ? 0 : 1),
              itemBuilder: (context, index) {
                if (index == categories.length) {
                  return const Center(child: CircularProgressIndicator());
                }

                final category = categories[index];
                final isSelected =
                    (selectedCategoryId == 'All' && category.id == 0) ||
                    selectedCategoryId == category.id.toString();

                return Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 0, 4.0, 10.0),
                  child: GestureDetector(
                    onTap: () {
                      final valueToSet =
                          category.id == 0 ? 'All' : category.id.toString();
                      ref.read(menuProvider.notifier).setCategory(valueToSet);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? Colors.white.withOpacity(0.2)
                                : Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(25.0),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 0.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          category.nombre,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
