import 'dart:io';
import 'package:o2/data/datasources/product_data_source.dart';
import 'package:o2/data/models/product_model.dart';
import 'package:o2/domain/entities/product.dart';
import 'package:o2/domain/repositories/product_repository.dart';
import 'package:o2/domain/repositories/image_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDataSource _dataSource;
  final ImageRepository _imageRepository;

  ProductRepositoryImpl(this._dataSource, this._imageRepository);

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
  Future<void> createProduct(ProductModel product) async {
    try {
      // 1. 이미지 업로드 먼저 시작 (이미지가 있는 경우)
      Future<List<String>>? imageUploadFuture;
      if (product.images.isNotEmpty) {
        final files = product.images.map((path) => File(path)).toList();
        imageUploadFuture = _imageRepository.uploadProductImages(
          product.sellerId,
          product.id,
          files,
        );
      }

      // 2. 이미지 업로드가 진행되는 동안 기본 상품 정보 저장
      await _dataSource
          .createProductWithTransaction(product.copyWith(images: const []));

      // 3. 이미지 업로드 완료 대기 및 URL 업데이트
      if (imageUploadFuture != null) {
        final uploadedImageUrls = await imageUploadFuture;
        if (uploadedImageUrls.isNotEmpty) {
          await _dataSource.updateProductImagesWithBatch(
            product.id,
            uploadedImageUrls,
          );
        }
      }
    } catch (error) {
      try {
        await _dataSource.rollbackProductCreation(product.id);
      } catch (rollbackError) {
        // 롤백 실패 시에도 원래 에러를 throw
      }
      throw Exception('상품 등록 실패: $error');
    }
  }

  @override
  Future<void> updateStatus(String id, ProductStatus status) async {
    await _dataSource.updateStatus(id, status.code);
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
  Future<List<Product>> getSalesProducts(String userId) async {
    final snapshots = await _dataSource.getSalesProducts(userId);
    return snapshots
        .map((doc) => Product.fromModel(ProductModel.fromFirebase(doc)))
        .toList();
  }

  @override
  Future<bool> isFavoriteProduct(String userId, String productId) async {
    return await _dataSource.isFavoriteProduct(userId, productId);
  }

  @override
  Future<void> deleteProduct(String id) async {
    await _dataSource.deleteProduct(id);
  }
}
