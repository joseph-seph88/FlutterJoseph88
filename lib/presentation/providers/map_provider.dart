import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/core/constants/app_constant.dart';
import 'package:o2/domain/usecases/map_use_case.dart';
import '../../core/theme/app_theme.dart';
import '../../data/datasources/map_data_source.dart';
import '../../data/repositories/map_repository_impl.dart';
import '../../domain/entities/map_entity.dart';
import '../state/map_state.dart';
import '../screens/map/widgets/map_bottom_sheet.dart';

// 바텀 시트
final bottomSheetProvider = Provider((ref) => MapBottomSheet());

// 업체 검색 관리
final isStoreSearchProvider = StateProvider<bool>((ref) => false);

// 스트림 검색 관리
final isStreamProvider = StateProvider<bool>((ref) => false);

// 초기화 관련 시점 관리
final isInitProvider = StateProvider<bool>((ref) => false);

// 카테 고리
final categoryProvider = StateProvider<String>((ref) => "");

// 별점
final starRatingProvider = StateProvider<double>((ref) => 0);

// 별점 인덱스
final starIndexProvider = StateProvider<int>((ref) => 0);

// 선택된 맵 데이터
final selectedMapDataProvider = StateProvider<MapEntity?>((ref) => null);

// 맵 반경 검색 파라미터
final mapParamProvider = StateProvider<Map<String, dynamic>>((ref) => {});

// 맵 반경 검색 스트림
final mapDataStreamProvider =
    StreamProvider.autoDispose<List<MapEntity>>((ref) {
  final mapUseCase = ref.watch(mapUseCaseProvider);
  final mapParam = ref.watch(mapParamProvider);

  if (!mapParam.containsKey('category') || !mapParam.containsKey('position')) {
    return Stream.value([]);
  }
  String category = mapParam['category'];
  GeoPoint position = mapParam['position'];

  return mapUseCase.getMapDataWithIcon(category, position).map((mapModels) {
    return mapModels.whereType<MapEntity>().toList();
  });
});

// 파이어스토어
final fireStoreProvider = Provider((ref) => FirebaseFirestore.instance);

// 플레이스 SDK
final placesSdkProvider = Provider<FlutterGooglePlacesSdk>((ref) {
  return FlutterGooglePlacesSdk('AIzaSyCWjE7YvMlqTO-Tyb4mSez58w0T1CSwrMk',
      locale: const Locale('ko', 'KR'));
});

// 맵 유스케이스
final mapUseCaseProvider = Provider((ref) {
  final mapRepository = ref.read(mapRepositoryProvider);
  return MapUseCaseImpl(mapRepository);
});

// 맵 레포지토리
final mapRepositoryProvider = Provider<MapRepositoryImpl>((ref) {
  final mapDataSource = ref.read(mapDataSourceProvider);
  return MapRepositoryImpl(mapDataSource);
});

// 맵 데이터 소스
final mapDataSourceProvider = Provider((ref) {
  final fireStore = ref.read(fireStoreProvider);
  final placeSdk = ref.read(placesSdkProvider);
  return MapDataSource(fireStore, placeSdk);
});

// 맵 노티파이어
final mapProvider = StateNotifierProvider<MapNotifier, MapState>((ref) {
  final mapUseCase = ref.read(mapUseCaseProvider);
  return MapNotifier(mapUseCase);
});

class MapNotifier extends StateNotifier<MapState> {
  final MapUseCaseImpl _mapUseCase;
  Timer? _debounceTimer;

  MapNotifier(this._mapUseCase)
      : super(MapState(
          isLoading: false,
          error: '',
          transAddress: '',
          mapDataList: [],
          staticCategory: [],
          searchStoreDataList: [],
          markersSet: {},
          betweenDistance: [],
          asyncTransAddress: const AsyncValue.loading(),
          asyncTargetPosition: const AsyncValue.loading(),
          asyncPredictionList: const AsyncValue.data([]),
        ));

// 등록된 맵정보 가져오기
  Future<void> getAllMapData(NLatLng nLatLng) async {
    state = state.copyWith(error: '');
    try {
      final dataList = await _mapUseCase.getAllMapData();
      List<double> distanceList = [];

      for (var mapData in dataList) {
        var storePoint = mapData.position;
        double distance = transPositionToDistance(
            nLatLng, NLatLng(storePoint.latitude, storePoint.longitude));
        distanceList.add(distance);
      }

      state =
          state.copyWith(mapDataList: dataList, betweenDistance: distanceList);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      throw Exception('[MAP:NOTIFIER_맵프로 에러] ${e.toString()}');
    }
  }

// 맵 정보 등록
  Future<void> addMarker(NLatLng position, Map<String, dynamic> category,
      String address, String storeName) async {
    const double starRating = 0;
    const int participant = 0;
    final geoPosition = GeoPoint(position.latitude, position.longitude);

    state = state.copyWith(error: '');
    try {
      await _mapUseCase.addMarker(
          geoPosition, address, category, storeName, starRating, participant);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      throw Exception("프로바이더 에러 ${e.toString()}");
    }
  }

// 맵 마커 리스트 state 등록
  Future<void> setMapMarkers(List<MapEntity> markers) async {
    state = state.copyWith(markersSet: {}, error: '');
    try {
      final Set<NMarker> newMarkers = {};
      for (var marker in markers) {
        final streamMarker = NMarker(
            id: marker.mapId ?? '1',
            position:
                NLatLng(marker.position.latitude, marker.position.longitude),
            icon: NOverlayImage.fromAssetImage(marker.category['iconPath']),
            iconTintColor: marker.category['iconColor'],
            size: const NSize(20, 20));

        streamMarker.setOnTapListener((overlay) async {
          final infoWindow = NInfoWindow.onMarker(
            id: marker.mapId ?? '1',
            text: marker.address,
          );

          bool isOpen = await streamMarker.hasOpenInfoWindow();
          if (!isOpen) {
            await streamMarker.openInfoWindow(infoWindow);
          }
        });
        newMarkers.add(streamMarker);
      }
      state = state.copyWith(markersSet: newMarkers);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      throw Exception('[MAP:NOTIFIER_맵프로 에러] ${e.toString()}');
    }
  }

// 맵 마커 state 등록
  Future<NMarker> setMapMarker(MapEntity marker) async {
    state = state.copyWith(error: '');
    try {
      final markerData = NMarker(
          id: marker.mapId ?? '1',
          position:
              NLatLng(marker.position.latitude, marker.position.longitude),
          icon: const NOverlayImage.fromAssetImage(AppConstant.locationPath),
          iconTintColor: AppColors.primary,
          size: const NSize(50, 50));

      markerData.setOnTapListener((overlay) async {
        final infoWindow = NInfoWindow.onMarker(
          id: marker.mapId ?? '1',
          text: marker.address,
        );

        bool isOpen = await markerData.hasOpenInfoWindow();
        if (!isOpen) {
          await markerData.openInfoWindow(infoWindow);
        }
      });
      return markerData;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      throw Exception('[MAP:NOTIFIER_맵프로 에러] ${e.toString()}');
    }
  }

// 등록된 업체 중 쿼리
  void updateStoreList(String query) async {
    state = state.copyWith(isLoading: true, error: '');
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 1), () async {
      try {
        final queryWithoutSpace = query.replaceAll(' ', '');
        final searchData = state.mapDataList.where((mapData) {
          final storeName = mapData.storeName.replaceAll(' ', '');
          return storeName.contains(queryWithoutSpace);
        }).toList();
        state = state.copyWith(searchStoreDataList: searchData);
      } catch (e) {
        state = state.copyWith(isLoading: false, error: e.toString());
        throw Exception('[MAP:NOTIFIER_맵프로 에러] ${e.toString()}');
      } finally {
        state = state.copyWith(isLoading: false);
      }
    });
  }

// state에 별점 업데이트
  Future<void> updateStarRating(String mapId, int starRating) async {
    state = state.copyWith(error: '');
    try {
      final mapData = await _mapUseCase.getMapData(mapId);
      final starRatingCalc =
          (mapData.starRating * mapData.participant + starRating) /
              (mapData.participant + 1);
      final newStarRating = double.parse(starRatingCalc.toStringAsFixed(1));
      final participant = mapData.participant + 1;
      final result =
          await _mapUseCase.updateStarRating(mapId, participant, newStarRating);

      final updatedList = state.mapDataList.map((mapEntity) {
        if (mapEntity.mapId == mapId) {
          return MapEntity(
            mapId: mapEntity.mapId,
            starRating: result.starRating,
            participant: result.participant,
            position: mapEntity.position,
            address: mapEntity.address,
            storeName: mapEntity.storeName,
            category: mapEntity.category,
          );
        }
        return mapEntity;
      }).toList();
      state = state.copyWith(mapDataList: updatedList);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      throw Exception('[MAP:NOTIFIER_맵프로 에러] ${e.toString()}');
    }
  }

  void get getStaticCategoryData {
    final staticCategory = _mapUseCase.getStaticCategoryData;
    state = state.copyWith(staticCategory: staticCategory);
  }

  void clearStateSearchData() {
    state = state.copyWith(searchStoreDataList: []);
  }

  void clearMapMarkers() {
    state = state.copyWith(markersSet: {});
  }

// 좌표값 주소 변환
  Future<void> transPositionToAddress(NLatLng targetPosition) async {
    state = state.copyWith(
        error: '', transAddress: '', asyncTransAddress: const AsyncLoading());
    try {
      final placeAddress =
          await _mapUseCase.transPositionToAddress(targetPosition);
      final transAddress = placeAddress?.street ?? "알수없음";

      state = state.copyWith(
          transAddress: transAddress,
          asyncTransAddress: AsyncValue.data(transAddress));
    } catch (e) {
      state = state.copyWith(error: e.toString());
      throw Exception('[MAP:NOTIFIER_맵프로 에러] ${e.toString()}');
    }
  }

// 내 타겟 좌표 업데이트
  Future<void> updateTargetPosition(NLatLng targetPosition) async {
    state =
        state.copyWith(error: '', asyncTargetPosition: const AsyncLoading());
    try {
      state =
          state.copyWith(asyncTargetPosition: AsyncValue.data(targetPosition));
      await transPositionToAddress(targetPosition);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      throw Exception('[MAP:NOTIFIER_맵프로 에러] ${e.toString()}');
    }
  }

  // 장소 검색 정보 업데이트
  Future<void> updatePredictionList(String input) async {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 1), () async {
      state =
          state.copyWith(error: '', asyncPredictionList: const AsyncLoading());

      try {
        final predictions = await _mapUseCase.getPredictions(input);
        state =
            state.copyWith(asyncPredictionList: AsyncValue.data(predictions));
      } catch (e) {
        state = state.copyWith(error: e.toString());
        throw Exception('[MAP:NOTIFIER_맵프로 에러] ${e.toString()}');
      }
    });
  }

// placeId로 좌표값 가져오기
  Future<LatLng?> transPlaceIdToLatLng(String placeId) {
    state = state.copyWith(error: '');
    try {
      return _mapUseCase.getLatLng(placeId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      throw Exception('[MAP:NOTIFIER_맵프로 에러] ${e.toString()}');
    }
  }

// 내 위치와 등록된 업체 간 거리 가져오기
  double transPositionToDistance(NLatLng myPosition, NLatLng storePosition) {
    state = state.copyWith(error: '');
    try {
      final betweenDistance = myPosition.distanceTo(storePosition);
      double distanceToKm = betweenDistance * 0.001;
      String formattedDistance = distanceToKm.toStringAsFixed(2);
      double distanceKm = double.parse(formattedDistance);
      return distanceKm;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      throw Exception('[MAP:NOTIFIER_맵프로 에러] ${e.toString()}');
    }
  }
}
