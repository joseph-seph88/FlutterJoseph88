import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/data/datasources/product_data_source.dart';
import 'package:o2/domain/entities/product.dart';
import 'package:o2/domain/repositories/product_repository.dart';
import 'package:o2/domain/usecases/product/get_products_usecase.dart';
import 'package:o2/domain/usecases/product/get_product_detail_usecase.dart';
import 'package:o2/domain/usecases/product/search_products_usecase.dart';
import 'package:o2/domain/usecases/product/manage_product_usecase.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  throw UnimplementedError(); // DI 설정에서 실제 구현체를 주입해야 합니다.
});

// UseCases providers
final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  return GetProductsUseCase(ref.watch(productRepositoryProvider));
});

final getProductDetailUseCaseProvider = Provider<GetProductDetailUseCase>((ref) {
  return GetProductDetailUseCase(ref.watch(productRepositoryProvider));
});

final searchProductsUseCaseProvider = Provider<SearchProductsUseCase>((ref) {
  return SearchProductsUseCase(ref.watch(productRepositoryProvider));
});

final manageProductUseCaseProvider = Provider<ManageProductUseCase>((ref) {
  return ManageProductUseCase(ref.watch(productRepositoryProvider));
});

// Data providers
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final useCase = ref.watch(getProductsUseCaseProvider);
  return useCase.execute();
});

final productsByCategoryProvider = FutureProvider.family<List<Product>, String>((ref, category) async {
  final useCase = ref.watch(getProductsUseCaseProvider);
  return useCase.execute(); // TODO: 카테고리 필터링 로직 추가 필요
});

final productDetailProvider = FutureProvider.family<Product?, String>((ref, id) async {
  final useCase = ref.watch(getProductDetailUseCaseProvider);
  return useCase.execute(id);
});

final searchProductsProvider = FutureProvider.family<List<Product>, String>((ref, query) async {
  final useCase = ref.watch(searchProductsUseCaseProvider);
  return useCase.execute(query);
});

class ProductNotifier extends StateNotifier<AsyncValue<Product?>> {
  final ManageProductUseCase _manageUseCase;
  final GetProductDetailUseCase _detailUseCase;

  ProductNotifier(this._manageUseCase, this._detailUseCase) : super(const AsyncValue.loading());

  Future<void> incrementViewCount(String id) async {
    await _manageUseCase.incrementViewCount(id);
    final updatedProduct = await _detailUseCase.execute(id);
    state = AsyncValue.data(updatedProduct);
  }

  Future<void> toggleLike(String id, bool isLiked) async {
    await _manageUseCase.toggleLike(id, isLiked);
    final updatedProduct = await _detailUseCase.execute(id);
    state = AsyncValue.data(updatedProduct);
  }
}

final productNotifierProvider = StateNotifierProvider.family<ProductNotifier, AsyncValue<Product?>, String>((ref, id) {
  final manageUseCase = ref.watch(manageProductUseCaseProvider);
  final detailUseCase = ref.watch(getProductDetailUseCaseProvider);
  return ProductNotifier(manageUseCase, detailUseCase);
});

// ProductDataSource Provider
final productDataSourceProvider = Provider<ProductDataSource>((ref) {
  return ProductDataSource();
});

// 최근 검색어 Provider
final recentSearchesProvider = FutureProvider.autoDispose.family<List<String>, String>((ref, userId) async {
  final dataSource = ref.watch(productDataSourceProvider);
  return await dataSource.getRecentSearches(userId);
});

// 최근 검색어 저장 Provider
final saveRecentSearchProvider = Provider.family<Future<void> Function(String), String>((ref, userId) {
  final dataSource = ref.watch(productDataSourceProvider);
  return (String keyword) => dataSource.saveRecentSearch(userId, keyword);
});

// 최근 검색어 삭제 Provider
final removeRecentSearchProvider = Provider.family<Future<void> Function(String), String>((ref, userId) {
  final dataSource = ref.watch(productDataSourceProvider);
  return (String keyword) => dataSource.removeRecentSearch(userId, keyword);
});

// 최근 검색어 전체 삭제 Provider
final clearRecentSearchesProvider = Provider.family<Future<void> Function(), String>((ref, userId) {
  final dataSource = ref.watch(productDataSourceProvider);
  return () => dataSource.clearRecentSearches(userId);
});

// 인기 검색어 Provider
final popularSearchesProvider = FutureProvider<List<String>>((ref) async {
  final dataSource = ref.watch(productDataSourceProvider);
  return dataSource.getPopularSearches();
});

// 검색어 카운트 증가 Provider
final incrementSearchCountProvider = Provider<Future<void> Function(String)>((ref) {
  final dataSource = ref.watch(productDataSourceProvider);
  return (String keyword) => dataSource.incrementSearchCount(keyword);
});
