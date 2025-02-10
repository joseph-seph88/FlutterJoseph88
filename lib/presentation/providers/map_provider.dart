import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/domain/usecases/map_use_case.dart';
import '../../domain/entities/map_entity.dart';
import '../state/map_state.dart';
import '../screens/map/widgets/map_bottom_sheet.dart';

// 거래 희망 장소
final transactionLocationProvider =
    StateProvider<Map<String, dynamic>>((ref) => {});

// 바텀 시트
final bottomSheetProvider = Provider((ref) => MapBottomSheet());

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

// Map Notifier
final mapProvider = StateNotifierProvider<MapNotifier, MapState>((ref) {
  final mapUseCase = ref.read(mapUseCaseProvider);
  return MapNotifier(mapUseCase);
});

class MapNotifier extends StateNotifier<MapState> {
  final MapUseCaseImpl _mapUseCase;

  MapNotifier(this._mapUseCase)
      : super(MapState(
          isLoading: false,
          error: '',
          transAddress: '',
          positionData: const LatLng(lat: 37.499889, lng: 126.920056),
          mapDataList: [],
          staticCategory: [],
          predictionList: [],
          searchStoreDataList: [],
          markersSet: {},
        ));

  Future<void> addMarker(GeoPoint position, Map<String, dynamic> category,
      String address, String storeName) async {
    const double starRating = 0;
    const int participant = 0;
    state = state.copyWith(isLoading: true, error: '');
    try {
      await _mapUseCase.addMarker(
          position, address, category, storeName, starRating, participant);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void clearStateSearchData() {
    state = state.copyWith(searchStoreDataList: []);
  }

  void clearMapMarkers() {
    state = state.copyWith(markersSet: {});
  }

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
    }
  }

  Future<NMarker?> setMapMarker(MapEntity marker) async {
    state = state.copyWith(error: '');
    try {
      final markerData = NMarker(
          id: marker.mapId ?? '1',
          position:
              NLatLng(marker.position.latitude, marker.position.longitude),
          icon: NOverlayImage.fromAssetImage(marker.category['iconPath']),
          iconTintColor: marker.category['iconColor'],
          size: const NSize(20, 20));

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
    }
    return null;
  }

  Future<void> getAllMapData() async {
    state = state.copyWith(error: '');
    try {
      final dataList = await _mapUseCase.getAllMapData();
      state = state.copyWith(mapDataList: dataList);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> setAddress(String address) async {
    state = state.copyWith(error: '');
    try {
      state = state.copyWith(transAddress: address);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> transPositionToAddress(NLatLng currentPosition) async {
    state = state.copyWith(error: '');
    try {
      final placeAddress =
          await _mapUseCase.transAddressFromGeo(currentPosition);
      if (placeAddress?.street != null) {
        String transAddress = placeAddress!.street!;
        List<String> parts = transAddress.split(' ');

        if (parts.length >= 3) {
          transAddress = parts.sublist(parts.length - 3).join(' ');
        }

        state = state.copyWith(transAddress: transAddress);
      } else {
        state = state.copyWith(transAddress: '알 수 없는 주소');
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<LatLng?> transAddressToPosition(String address) async {
    state = state.copyWith(error: '');
    try {
      final positionData = await _mapUseCase.transPositionFromAddress(address);
      if (positionData != null) {
        state = state.copyWith(positionData: positionData);
        return positionData;
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
    return null;
  }

  void get getStaticCategoryData {
    final staticCategory = _mapUseCase.getStaticCategoryData;
    state = state.copyWith(staticCategory: staticCategory);
  }

  Future<void> getPredictionList(String input) async {
    state = state.copyWith(error: '');
    try {
      final result = await _mapUseCase.getPredictions(input);
      state = state.copyWith(predictionList: result);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

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
      throw Exception("프로바이더 에러");
    }
  }

  void searchStoreData(String query) {
    final queryWithoutSpace = query.replaceAll(' ', '');

    final searchData = state.mapDataList.where((mapData) {
      final storeName = mapData.storeName.replaceAll(' ', '');
      return storeName.contains(queryWithoutSpace);
    }).toList();

    state = state.copyWith(searchStoreDataList: searchData);
  }
}
