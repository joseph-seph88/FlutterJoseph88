import 'package:o2/data/datasources/product_data_source.dart';
import 'package:o2/data/models/product_model.dart';
import 'package:o2/domain/entities/product.dart';
import 'package:o2/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDataSource _dataSource;

  ProductRepositoryImpl(this._dataSource);

  Product _modelToEntity(ProductModel model) {
    return Product(
      id: model.id,
      title: model.title,
      description: model.description,
      price: model.price,
      location: model.location,
      category: model.category,
      images: model.images,
      viewCount: model.viewCount,
      likeCount: model.likeCount,
      createdAt: model.createdAt.toDate(),
      sellerId: model.sellerId,
      isOfferEnabled: model.isOfferEnabled,
      status: model.status,
      chatCount: model.chatCount,
    );
  }

  @override
  Future<List<Product>> getProducts() async {
    final docs = await _dataSource.getProducts();
    final models = docs.map((doc) => ProductModel.fromFirebase(doc)).toList();
    return models.map(_modelToEntity).toList();
  }

  @override
  Future<Product?> getProduct(String id) async {
    final doc = await _dataSource.getProduct(id);
    if (doc == null || !doc.exists) return null;
    final model = ProductModel.fromFirebase(doc);
    return _modelToEntity(model);
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    final docs = await _dataSource.searchProducts(query);
    final models = docs.map((doc) => ProductModel.fromFirebase(doc)).toList();
    return models.map(_modelToEntity).toList();
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    final docs = await _dataSource.getProductsByCategory(category);
    final models = docs.map((doc) => ProductModel.fromFirebase(doc)).toList();
    return models.map(_modelToEntity).toList();
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
