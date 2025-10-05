import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_3d/components/category_scroll_view.dart';
import 'package:proyecto_3d/components/glass_app_bar.dart';
import 'package:proyecto_3d/components/responsive_center_layout.dart';
import 'package:proyecto_3d/presentation/dish_providers.dart';
import 'package:proyecto_3d/widgets/dish_swiper_component.dart';
import 'package:proyecto_3d/widgets/empty_dish_info_card.dart';

class MenuScreen extends ConsumerWidget {
  static const String name = 'menu_screen';

  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuAsyncValue = ref.watch(menuProvider);
    final menuNotifier = ref.read(menuProvider.notifier);
    final screenWidth = MediaQuery.of(context).size.width;
    const mobileBreakpoint = 600;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ResponsiveCenterLayout(
        child: Column(
          children: [
            GlassAppBar(
              onSearch: (query) => menuNotifier.setSearchQuery(query),
            ),
            const CategoryScrollView(),
            Expanded(
              child: menuAsyncValue.when(
                data: (menuState) {
                  if (menuState.dishes.isEmpty) {
                    return const Center(
                      child: Text(
                        'No se encontraron platos.',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final mainContent = Column(
                    children: [
                      Expanded(
                        child: DishSwiperComponent(
                          key: ObjectKey(menuState),
                          dishes: menuState.dishes,
                          currentIndex: menuState.currentIndex,
                          onNext: menuNotifier.goToNextItem,
                          onPrevious: menuNotifier.goToPrevItem,
                          onPageChanged: menuNotifier.setCurrentIndex,
                        ),
                      ),
                      if (menuState.currentItem != null)
                        EmptyDishInfoCard(dish: menuState.currentItem!),
                    ],
                  );

                  return screenWidth < mobileBreakpoint
                      ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: mainContent,
                      )
                      : Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 32.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.65),
                          borderRadius: BorderRadius.circular(35.0),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        child: mainContent,
                      );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error:
                    (error, stack) => Center(
                      child: Text(
                        'Error al cargar los platos: $error',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
