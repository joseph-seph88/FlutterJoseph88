import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/data/datasources/product_data_source.dart';
import 'package:o2/domain/entities/product.dart';
import 'package:o2/domain/usecases/product/get_products_usecase.dart';
import 'package:o2/domain/usecases/product/get_product_detail_usecase.dart';
import 'package:o2/domain/usecases/product/search_products_usecase.dart';
import 'package:o2/domain/usecases/product/manage_product_usecase.dart';
import 'package:o2/presentation/providers/providers.dart';

// UseCases providers
final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  return GetProductsUseCase(ref.watch(productRepositoryProvider));
});

final getProductDetailUseCaseProvider =
    Provider<GetProductDetailUseCase>((ref) {
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

final productsByCategoryProvider =
    FutureProvider.family<List<Product>, String>((ref, category) async {
  final useCase = ref.watch(getProductsUseCaseProvider);
  return useCase.execute();
});

final productDetailProvider =
    FutureProvider.family<Product?, String>((ref, id) async {
  final useCase = ref.watch(getProductDetailUseCaseProvider);
  return useCase.execute(id);
});

final searchProductsProvider =
    FutureProvider.family<List<Product>, String>((ref, query) async {
  final useCase = ref.watch(searchProductsUseCaseProvider);
  return useCase.execute(query);
});

class ProductNotifier extends StateNotifier<AsyncValue<Product?>> {
  final ManageProductUseCase _manageUseCase;
  final GetProductDetailUseCase _detailUseCase;
  final Ref ref;

  ProductNotifier(this._manageUseCase, this._detailUseCase, this.ref)
      : super(const AsyncValue.loading());

  Future<void> incrementViewCount(String id) async {
    await _manageUseCase.incrementViewCount(id);
    final updatedProduct = await _detailUseCase.execute(id);
    state = AsyncValue.data(updatedProduct);
  }

  Future<void> updateStatus(String id, ProductStatus status) async {
    try {
      await _manageUseCase.updateStatus(id, status);
      final updatedProduct = await _detailUseCase.execute(id);
      state = AsyncValue.data(updatedProduct);

      // 관련 Provider들 갱신
      ref.invalidate(productDetailProvider(id));
      ref.invalidate(productsProvider);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleFavorite(String userId, String productId) async {
    try {
      final isFavorite =
          await _manageUseCase.isFavoriteProduct(userId, productId);
      if (isFavorite) {
        await _manageUseCase.removeFromFavorites(userId, productId);
      } else {
        await _manageUseCase.addToFavorites(userId, productId);
      }
      final updatedProduct = await _detailUseCase.execute(productId);
      state = AsyncValue.data(updatedProduct);

      // 관련 Provider들 갱신
      ref.invalidate(productDetailProvider(productId));
      ref.invalidate(productsProvider);
      ref.invalidate(
          productsByCategoryProvider(updatedProduct?.category ?? ''));
      ref.invalidate(
          isFavoriteProductProvider((userId: userId, productId: productId)));
      ref.invalidate(favoriteProductsProvider(userId));
    } catch (e) {
      rethrow; // 에러를 상위로 전파하여 UI에서 처리하도록 함
    }
  }
}

final productNotifierProvider =
    StateNotifierProvider.family<ProductNotifier, AsyncValue<Product?>, String>(
        (ref, id) {
  final manageUseCase = ref.watch(manageProductUseCaseProvider);
  final detailUseCase = ref.watch(getProductDetailUseCaseProvider);
  return ProductNotifier(manageUseCase, detailUseCase, ref);
});

// ProductDataSource Provider
final productDataSourceProvider = Provider<ProductDataSource>((ref) {
  return ProductDataSource();
});

// 최근 검색어 Provider
final recentSearchesProvider = FutureProvider.autoDispose
    .family<List<String>, String>((ref, userId) async {
  final dataSource = ref.watch(productDataSourceProvider);
  return await dataSource.getRecentSearches(userId);
});

// 최근 검색어 저장 Provider
final saveRecentSearchProvider =
    Provider.family<Future<void> Function(String), String>((ref, userId) {
  final dataSource = ref.watch(productDataSourceProvider);
  return (String keyword) => dataSource.saveRecentSearch(userId, keyword);
});

// 최근 검색어 삭제 Provider
final removeRecentSearchProvider =
    Provider.family<Future<void> Function(String), String>((ref, userId) {
  final dataSource = ref.watch(productDataSourceProvider);
  return (String keyword) => dataSource.removeRecentSearch(userId, keyword);
});

// 최근 검색어 전체 삭제 Provider
final clearRecentSearchesProvider =
    Provider.family<Future<void> Function(), String>((ref, userId) {
  final dataSource = ref.watch(productDataSourceProvider);
  return () => dataSource.clearRecentSearches(userId);
});

// 인기 검색어 Provider
final popularSearchesProvider = FutureProvider<List<String>>((ref) async {
  final dataSource = ref.watch(productDataSourceProvider);
  return dataSource.getPopularSearches();
});

// 검색어 카운트 증가 Provider
final incrementSearchCountProvider =
    Provider<Future<void> Function(String)>((ref) {
  final dataSource = ref.watch(productDataSourceProvider);
  return (String keyword) => dataSource.incrementSearchCount(keyword);
});

// 관심 상품 목록 Provider
final favoriteProductsProvider = FutureProvider.autoDispose
    .family<List<Product>, String>((ref, userId) async {
  // 상품 상태 변경 감지를 위해 productsProvider 구독
  ref.watch(productsProvider);

  final repository = ref.watch(productRepositoryProvider);
  return repository.getFavoriteProducts(userId);
});

// 관심 상품 여부 확인 Provider
final isFavoriteProductProvider = FutureProvider.autoDispose
    .family<bool, ({String userId, String productId})>((ref, params) async {
  // 상품 상태 변경 감지를 위해 productDetailProvider 구독
  ref.watch(productDetailProvider(params.productId));

  final repository = ref.watch(productRepositoryProvider);
  return repository.isFavoriteProduct(params.userId, params.productId);
});

// 판매자 정보를 가져오는 Provider
final sellerProvider = Provider((ref) {
  final repository = ref.read(userRepositoryProvider);
  return (String sellerId) => repository.getUserData(sellerId);
});

// 자동완성 검색을 위한 Provider
final autoCompleteProvider =
    FutureProvider.family<List<String>, String>((ref, query) async {
  if (query.isEmpty) return [];

  final lowercaseQuery = query.toLowerCase();
  final useCase = ref.watch(searchProductsUseCaseProvider);
  final products = await useCase.execute(lowercaseQuery);

  // 검색 결과에서 제목만 추출하여 반환
  return products.map((product) => product.title).take(5).toList();
});
