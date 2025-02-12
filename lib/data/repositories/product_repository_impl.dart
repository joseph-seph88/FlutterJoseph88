import 'package:o2/data/datasources/product_data_source.dart';
import 'package:o2/data/models/product_model.dart';
import 'package:o2/domain/entities/product.dart';
import 'package:o2/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDataSource _dataSource;

  ProductRepositoryImpl(this._dataSource);

  @override
  Future<List<Product>> getProducts() async {
    final snapshots = await _dataSource.getProducts();
    return snapshots
        .map((doc) => Product.fromModel(ProductModel.fromFirebase(doc)))
        .toList();
  }

  @override
  Future<Product?> getProduct(String id) async {
    final snapshot = await _dataSource.getProduct(id);
    if (snapshot == null) return null;
    return Product.fromModel(ProductModel.fromFirebase(snapshot));
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    final snapshots = await _dataSource.searchProducts(query);
    return snapshots
        .map((doc) => Product.fromModel(ProductModel.fromFirebase(doc)))
        .toList();
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    final snapshots = await _dataSource.getProductsByCategory(category);
    return snapshots
        .map((doc) => Product.fromModel(ProductModel.fromFirebase(doc)))
        .toList();
  }

  @override
  Future<void> incrementViewCount(String id) async {
    await _dataSource.incrementViewCount(id);
  }

  @override
  Future<void> addToFavorites(String userId, String productId) async {
    await _dataSource.addToFavorites(userId, productId);
  }

  @override
  Future<void> removeFromFavorites(String userId, String productId) async {
    await _dataSource.removeFromFavorites(userId, productId);
  }

  @override
  Future<List<Product>> getFavoriteProducts(String userId) async {
    final snapshots = await _dataSource.getFavoriteProducts(userId);
    return snapshots
        .map((doc) => Product.fromModel(ProductModel.fromFirebase(doc)))
        .toList();
  }

  @override
  Future<bool> isFavoriteProduct(String userId, String productId) async {
    return await _dataSource.isFavoriteProduct(userId, productId);
  }
}
