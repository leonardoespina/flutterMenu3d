import 'package:flutter/material.dart';
import 'package:proyecto_3d/widgets/model_viewer/model_viewer_component.dart';

import '../models/dish_model.dart';

class DishSwiperComponent extends StatefulWidget {
  final List<Dish> dishes;
  final int currentIndex;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final ValueChanged<int> onPageChanged;

  const DishSwiperComponent({
    Key? key,
    required this.dishes,
    required this.currentIndex,
    required this.onNext,
    required this.onPrevious,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  _DishSwiperComponentState createState() => _DishSwiperComponentState();
}

class _DishSwiperComponentState extends State<DishSwiperComponent> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.99,
      initialPage: widget.currentIndex,
    );
  }

  @override
  void didUpdateWidget(DishSwiperComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      // Animate to the new page if the index changes from the parent
      if (_pageController.hasClients &&
          _pageController.page?.round() != widget.currentIndex) {
        _pageController.animateToPage(
          widget.currentIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dishes.isEmpty) {
      return const Center(child: Text('No hay productos disponibles.'));
    }

    return Stack(
      alignment: Alignment.center,
      children: [_build3DViewer(), _buildNavigationControls()],
    );
  }

  Widget _build3DViewer() {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.dishes.length,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: widget.onPageChanged,
      itemBuilder: (context, index) {
        final dish = widget.dishes[index];
        return AnimatedScale(
          scale: widget.currentIndex == index ? 1.0 : 0.85,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _KeepAliveModelViewer(dish: dish),
        );
      },
    );
  }

  Widget _buildNavigationControls() {
    return Stack(
      children: [
        Positioned(
          left: -10,
          top: 0,
          bottom: 0,
          child: Center(
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              iconSize: 32,
              color: Colors.white.withOpacity(0.8),
              onPressed: widget.onPrevious,
              tooltip: 'Anterior',
            ),
          ),
        ),
        Positioned(
          right: -10,
          top: 0,
          bottom: 0,
          child: Center(
            child: IconButton(
              icon: const Icon(Icons.arrow_forward_ios_rounded),
              iconSize: 32,
              color: Colors.white.withOpacity(0.8),
              onPressed: widget.onNext,
              tooltip: 'Siguiente',
            ),
          ),
        ),
      ],
    );
  }
}

class _KeepAliveModelViewer extends StatefulWidget {
  final Dish dish;

  const _KeepAliveModelViewer({required this.dish});

  @override
  State<_KeepAliveModelViewer> createState() => _KeepAliveModelViewerState();
}

class _KeepAliveModelViewerState extends State<_KeepAliveModelViewer>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (widget.dish.imagen == null || widget.dish.imagen!.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
            Text(
              'Modelo 3D no disponible',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Transform.translate(
      offset: const Offset(0, -40.0),
      child: ModelViewerComponent(
        src: widget.dish.imagen!,
        alt: 'Modelo 3D de ${widget.dish.nombre}',
        ar: false,
        autoRotate: true,
        disableZoom: false,
        cameraControls: true,
        maxCameraOrbit: 'auto 85deg auto',
      ),
    );
  }
}
