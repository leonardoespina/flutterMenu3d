import '../models/category_model.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories({int page = 1, int limit = 10});
}
