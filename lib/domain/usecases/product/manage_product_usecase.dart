import 'package:o2/data/models/product_model.dart';
import 'package:o2/domain/repositories/product_repository.dart';

class ManageProductUseCase {
  final ProductRepository _repository;

  ManageProductUseCase(this._repository);

  Future<void> createProduct(ProductModel product) async {
    await _repository.createProduct(product);
  }

  Future<void> incrementViewCount(String id) async {
    await _repository.incrementViewCount(id);
  }

  Future<void> addToFavorites(String userId, String productId) async {
    await _repository.addToFavorites(userId, productId);
  }

  Future<void> removeFromFavorites(String userId, String productId) async {
    await _repository.removeFromFavorites(userId, productId);
  }

  Future<bool> isFavoriteProduct(String userId, String productId) async {
    return await _repository.isFavoriteProduct(userId, productId);
  }
}
