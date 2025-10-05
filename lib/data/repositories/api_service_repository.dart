import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/app_config.dart';
import '../../domain/category_repository.dart';
import '../../domain/dish_repository.dart';
import '../../models/category_model.dart';
import '../../models/dish_model.dart';

class ApiServiceRepository implements DishRepository, CategoryRepository {
  final _client = http.Client();

  @override
  Future<List<Dish>> getDishes({
    int page = 1,
    int limit = 10,
    String? category,
    String? search,
  }) async {
    final queryParameters = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (category != null && category != "All") {
      queryParameters['category'] = category;
    }

    if (search != null && search.isNotEmpty) {
      queryParameters['search'] = search;
    }

    final uri = Uri.parse(
      '${AppConfig.apiBaseUrl}/api/platos',
    ).replace(queryParameters: queryParameters);

    try {
      final response = await _client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Cache-Control': 'no-cache',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> jsonData = jsonResponse['data'] ?? [];
        return jsonData.map((data) {
          final imageUrl =
              data['imagen'] != null
                  ? '${AppConfig.uploadsBaseUrl}${data['imagen']}'
                  : null;
          return Dish(
            id: data['id'],
            nombre: data['nombre'],
            descripcion: data['descripcion'],
            precio: double.parse(data['precio']),
            imagen: imageUrl,
            categoriaId: data['categoriaId'],
            status: data['status'],
          );
        }).toList();
      } else {
        throw Exception('Failed to load dishes from API');
      }
    } catch (e) {
      throw Exception('Error fetching dishes: $e');
    }
  }

  @override
  Future<List<Category>> getCategories({int page = 1, int limit = 10}) async {
    final queryParameters = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    final uri = Uri.parse(
      '${AppConfig.apiBaseUrl}/api/categorias',
    ).replace(queryParameters: queryParameters);

    try {
      final response = await _client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Cache-Control': 'no-cache',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> jsonData = jsonResponse['data'] ?? [];
        final apiCategories =
            jsonData.map((data) => Category.fromJson(data)).toList();
        return [Category(id: 0, nombre: 'All'), ...apiCategories];
      } else {
        throw Exception('Failed to load categories from API');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }
}
