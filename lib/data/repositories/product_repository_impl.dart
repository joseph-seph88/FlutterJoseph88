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
    return snapshots.map((doc) => Product.fromModel(ProductModel.fromFirebase(doc))).toList();
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
    return snapshots.map((doc) => Product.fromModel(ProductModel.fromFirebase(doc))).toList();
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    final snapshots = await _dataSource.getProductsByCategory(category);
    return snapshots.map((doc) => Product.fromModel(ProductModel.fromFirebase(doc))).toList();
  }

  @override
  Future<void> incrementViewCount(String id) async {
    await _dataSource.incrementViewCount(id);
  }

  @override
  Future<void> toggleLike(String id, bool isLiked) async {
    await _dataSource.toggleLike(id, isLiked);
  }
}
