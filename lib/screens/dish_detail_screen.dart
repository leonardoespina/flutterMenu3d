import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_3d/models/category_model.dart';
import 'package:proyecto_3d/components/responsive_center_layout.dart';
import 'package:proyecto_3d/models/dish_model.dart';
import 'package:proyecto_3d/presentation/category_providers.dart';
import 'package:proyecto_3d/widgets/empty_dish_info_card.dart';
import 'package:proyecto_3d/widgets/model_viewer/model_viewer_component.dart';
import 'package:badges/badges.dart' as badges;
import 'package:proyecto_3d/providers/cart_provider.dart';
import 'package:proyecto_3d/widgets/cart_bottom_sheet.dart';
import 'package:proyecto_3d/models/cart_item_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DishDetailScreen extends ConsumerStatefulWidget {
  final Dish dish;

  const DishDetailScreen({super.key, required this.dish});

  @override
  ConsumerState<DishDetailScreen> createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends ConsumerState<DishDetailScreen> {
  bool _areCameraControlsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final categoriesAsync = ref.watch(categoryProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ResponsiveCenterLayout(
        child: Stack(
          children: [
            // Contenido principal con fondo semitransparente
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.65),
                borderRadius: BorderRadius.circular(35.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Espacio para los botones de navegación
                      const SizedBox(height: 60),
                      // Visor del modelo 3D
                      SizedBox(
                        height: size.height * 0.5,
                        child:
                            (widget.dish.imagen != null &&
                                    widget.dish.imagen!.isNotEmpty)
                                ? ModelViewerComponent(
                                  src: widget.dish.imagen!,
                                  alt: 'Modelo 3D de ${widget.dish.nombre}',
                                  ar: true,
                                  autoRotate: true,
                                  cameraControls: _areCameraControlsEnabled,
                                )
                                : const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image_not_supported,
                                        size: 60,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                        'Modelo 3D no disponible',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                      ),
                      // Nuevo botón de añadir al carrito con estilo
                      _buildStyledAddToCartButton(),
                      // Información del plato
                      categoriesAsync.when(
                        data: (categoryState) {
                          final category = categoryState.categories.firstWhere(
                            (cat) => cat.id == widget.dish.categoriaId,
                            orElse:
                                () => Category(id: 0, nombre: 'Sin categoría'),
                          );
                          return EmptyDishInfoCard(
                            dish: widget.dish,
                            isDetailView: true,
                            categoryName: category.nombre,
                          );
                        },
                        loading:
                            () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                        error:
                            (err, stack) =>
                                const Text('Error al cargar la categoría'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Botones de navegación dentro del layout centrado
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      final totalItems = ref.watch(cartProvider).totalItems;
                      return badges.Badge(
                        showBadge: totalItems > 0,
                        badgeContent: Text(
                          '$totalItems',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        position: badges.BadgePosition.topEnd(top: 0, end: 0),
                        child: IconButton(
                          icon: const Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            setState(() {
                              _areCameraControlsEnabled = false;
                            });
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              constraints:
                                  kIsWeb
                                      ? const BoxConstraints(maxWidth: 600)
                                      : null,
                              builder: (context) => const CartBottomSheet(),
                            ).whenComplete(() {
                              if (mounted) {
                                setState(() {
                                  _areCameraControlsEnabled = true;
                                });
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledAddToCartButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: GestureDetector(
          onTap: () {
            final cartNotifier = ref.read(cartProvider.notifier);
            final itemToAdd = CartItem(
              productId: widget.dish.id.toString(),
              name: widget.dish.nombre,
              price: widget.dish.precio,
              quantity: 1, // Se añade de uno en uno
              imageUrl: widget.dish.imagen,
            );
            cartNotifier.addItem(itemToAdd);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${widget.dish.nombre} añadido al carrito.'),
                duration: const Duration(seconds: 2),
                backgroundColor: Colors.green[700],
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.blueAccent, Colors.greenAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_shopping_cart, color: Colors.white, size: 16),
                SizedBox(width: 6),
                Text(
                  'Añadir al Pedido',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
