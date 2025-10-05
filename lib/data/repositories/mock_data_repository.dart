import '../../domain/category_repository.dart';
import '../../domain/dish_repository.dart';
import '../../models/category_model.dart';
import '../../models/dish_model.dart';

class MockDataRepository implements DishRepository, CategoryRepository {
  @override
  Future<List<Dish>> getDishes({
    int page = 1,
    int limit = 10,
    String? category,
    String? search,
  }) async {
    // Simula un retraso de red
    await Future.delayed(const Duration(seconds: 1));

    List<Dish> allDishes = [
      // Modificación de la Posición 01 (id: 1)
      Dish(
        id: 1,
        nombre: 'Chicken Meal',
        precio: 7.5, // Precio ajustado
        categoriaId: 6, // Categoría: Vegetariano
        descripcion:
            'Plato indobritánico que consiste en trozos de pollo deshuesados ​​en salsa de curry.',
        imagen: 'assets/model/1.glb',
      ),
      // Modificación de la Posición 02 (id: 2)
      Dish(
        id: 2,
        nombre: 'Cupcake Chocolate',
        precio: 3.5, // Precio ajustado
        categoriaId: 3, // Categoría: Postres
        descripcion:
            'Delicioso pastel individual de chocolate con un cremoso glaseado de cacao.',
        imagen: 'assets/model/2.glb',
      ),
      // Modificación de la Posición 03 (id: 3)
      Dish(
        id: 3,
        nombre: 'Hamburguesa, Enrrollado y papas frita',
        precio: 18.0, // Precio ajustado
        categoriaId: 5, // Categoría: Especiales (por la combinación)
        descripcion:
            'Combo especial que incluye una hamburguesa clásica, un enrrollado de pollo o carne y una porción de papas fritas.',
        imagen: 'assets/model/3.glb',
      ),
      // Modificación de la Posición 04 (id: 4)
      Dish(
        id: 4,
        nombre: 'Sandwich con papas fritas',
        precio: 10.5, // Precio ajustado
        categoriaId: 2, // Categoría: Platos Fuertes
        descripcion:
            'Sandwich a elección (jamón y queso, pollo o pavo) servido con una guarnición de papas fritas crujientes.',
        imagen: 'assets/model/4.glb',
      ),
      // Adición de la Posición 05 (id: 5)
      Dish(
        id: 5,
        nombre: 'Pasta with Meatballs',
        precio: 6.0,
        categoriaId: 7, // Categoría: Vegano
        descripcion:
            'Pasta cremosa con salchicha italiana: un clásico reconfortante con un toque especial.',
        imagen: 'assets/model/5.glb',
      ),
      // Adición de la Posición 06 (id: 6)
      Dish(
        id: 6,
        nombre: 'Pollo y patatas al estilo español',
        precio: 4.0,
        categoriaId: 1, // Categoría: Entradas
        descripcion:
            'Este pollo y patatas al estilo español se cocina a fuego lento con una salsa casera de tomate y aceite de oliva, y se espolvorea con perejil.',
        imagen: 'assets/model/6.glb',
      ),
      // Adición de la Posición 07 (id: 7)
      Dish(
        id: 7,
        nombre: 'Pizza margarita',
        precio: 16.0,
        categoriaId: 2, // Categoría: Platos Fuertes
        descripcion:
            'Clásica pizza con salsa de tomate, mozzarella fresca, y hojas de albahaca sobre una masa artesanal.',
        imagen: 'assets/model/7.glb',
      ),
      // Adición de la Posición 08 (id: 8)
      Dish(
        id: 8,
        nombre: 'Bote sushi',
        precio: 25.0,
        categoriaId: 5, // Categoría: Especiales
        descripcion:
            'Selección de 20 piezas de sushi y rolls variados, presentada en un bote temático.',
        imagen: 'assets/model/8.glb',
      ),
      // Adición de la Posición 09 (id: 9)
      Dish(
        id: 9,
        nombre: 'Croissant',
        precio: 2.5,
        categoriaId: 3, // Categoría: Postres
        descripcion:
            'Hojaldre francés en forma de media luna, crujiente por fuera y suave por dentro.',
        imagen: 'assets/model/9.glb',
      ),
      // Adición de la Posición 10 (id: 10)
      Dish(
        id: 10,
        nombre: 'Carne Roast',
        precio: 9.0,
        categoriaId: 1, // Categoría: Entradas
        descripcion:
            'Proviene de la parte superior de la res, justo detrás del lomo bajo, y se caracteriza por su excelente marmoleo y ternura.',
        imagen: 'assets/model/12.glb',
      ),
      Dish(
        id: 11,
        nombre: 'Sandwich pile',
        precio: 9.0,
        categoriaId: 1, // Categoría: Entradas
        descripcion:
            'Pequeños sándwiches apilados con múltiples capas de ingredientes frescos, perfectos como aperitivo.',
        imagen: 'assets/model/11.glb',
      ),
      Dish(
        id: 12,
        nombre: 'Carne Roast',
        precio: 9.0,
        categoriaId: 1, // Categoría: Entradas
        descripcion:
            'Proviene de la parte superior de la res, justo detrás del lomo bajo, y se caracteriza por su excelente marmoleo y ternura.',
        imagen: 'assets/model/12.glb',
      ),
    ];

    // Filtrar por categoría
    if (category != null && category != "All") {
      final categoryId = int.tryParse(category);
      if (categoryId != null) {
        allDishes =
            allDishes.where((dish) => dish.categoriaId == categoryId).toList();
      }
    }

    // Filtrar por búsqueda
    if (search != null && search.isNotEmpty) {
      allDishes =
          allDishes
              .where(
                (dish) =>
                    dish.nombre.toLowerCase().contains(search.toLowerCase()),
              )
              .toList();
    }

    // Paginar
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;

    if (startIndex >= allDishes.length) {
      return [];
    }

    return allDishes.sublist(
      startIndex,
      endIndex > allDishes.length ? allDishes.length : endIndex,
    );
  }

  @override
  Future<List<Category>> getCategories({int page = 1, int limit = 10}) async {
    // Simula un retraso de red
    await Future.delayed(const Duration(milliseconds: 500));

    final List<Category> allCategories = [
      Category(id: 0, nombre: 'All'),
      Category(id: 1, nombre: 'Entradas'),
      Category(id: 2, nombre: 'Platos Fuertes'),
      Category(id: 3, nombre: 'Postres'),
      Category(id: 4, nombre: 'Bebidas'),
      Category(id: 5, nombre: 'Especiales'),
      Category(id: 6, nombre: 'Vegetariano'),
      Category(id: 7, nombre: 'Vegano'),
    ];

    // Paginar
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;

    if (startIndex >= allCategories.length) {
      return [];
    }

    return allCategories.sublist(
      startIndex,
      endIndex > allCategories.length ? allCategories.length : endIndex,
    );
  }
}
