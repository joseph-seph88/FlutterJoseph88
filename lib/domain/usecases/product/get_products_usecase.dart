import 'package:o2/domain/entities/product.dart';
import 'package:o2/domain/repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository _repository;

  GetProductsUseCase(this._repository);

  Future<List<Product>> execute() async {
    return _repository.getProducts();
  }
}
