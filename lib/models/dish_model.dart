// lib/models/dish_model.dart

/// Representa la estructura de un plato o producto.
/// Coincide con la estructura de la base de datos para una fácil integración futura.
class Dish {
  final int id;
  final String nombre;
  final String? descripcion;
  final double precio;
  final String? imagen; // URL o ruta local al archivo GLB
  final int categoriaId;
  final bool status;

  Dish({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.precio,
    this.imagen,
    required this.categoriaId,
    this.status = true,
  });
}
