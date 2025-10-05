import '../models/dish_model.dart';

abstract class DishRepository {
  Future<List<Dish>> getDishes({
    int page = 1,
    int limit = 10,
    String? category,
    String? search,
  });
}
