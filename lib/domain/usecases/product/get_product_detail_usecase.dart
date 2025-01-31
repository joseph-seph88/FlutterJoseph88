import 'package:o2/domain/entities/product.dart';
import 'package:o2/domain/repositories/product_repository.dart';

class GetProductDetailUseCase {
  final ProductRepository _repository;

  GetProductDetailUseCase(this._repository);

  Future<Product?> execute(String id) async {
    return _repository.getProduct(id);
  }
}
