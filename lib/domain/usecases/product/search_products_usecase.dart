import 'package:o2/domain/entities/product.dart';
import 'package:o2/domain/repositories/product_repository.dart';

class SearchProductsUseCase {
  final ProductRepository _repository;

  SearchProductsUseCase(this._repository);

  Future<List<Product>> execute(String query) async {
    return _repository.searchProducts(query);
  }
}
