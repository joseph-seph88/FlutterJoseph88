import 'package:o2/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product?> getProduct(String id);
  Future<List<Product>> searchProducts(String query);
  Future<List<Product>> getProductsByCategory(String category);
  Future<void> incrementViewCount(String id);
  Future<void> toggleLike(String id, bool isLiked);
}
