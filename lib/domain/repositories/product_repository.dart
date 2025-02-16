import 'package:o2/domain/entities/product.dart';
import 'package:o2/data/models/product_model.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product?> getProduct(String id);
  Future<List<Product>> searchProducts(String query);
  Future<List<Product>> getProductsByCategory(String category);
  Future<void> incrementViewCount(String id);
  Future<void> createProduct(ProductModel product);
  Future<void> updateStatus(String id, ProductStatus status);
  Future<void> deleteProduct(String id);

  // 관심 상품 관련 메서드
  Future<void> addToFavorites(String userId, String productId);
  Future<void> removeFromFavorites(String userId, String productId);
  Future<List<Product>> getFavoriteProducts(String userId);
  Future<bool> isFavoriteProduct(String userId, String productId);
}
