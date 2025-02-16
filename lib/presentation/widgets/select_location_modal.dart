import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/presentation/providers/map_provider.dart';
import 'package:o2/presentation/widgets/search_place_view.dart';
import 'package:o2/presentation/widgets/select_location_view.dart';

class SelectLocationModal extends ConsumerStatefulWidget {
  final Function(String locationName, NLatLng position) onLocationSelected;

  const SelectLocationModal({
    super.key,
    required this.onLocationSelected,
  });

  @override
  ConsumerState<SelectLocationModal> createState() =>
      _SelectLocationModalState();
}

class _SelectLocationModalState extends ConsumerState<SelectLocationModal> {
  final _searchController = TextEditingController();
  final GlobalKey<SelectLocationViewState> _mapKey = GlobalKey();
  NaverMapController? get _mapController => _mapKey.currentState?.mapController;
  String? _selectedLocationName;
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _updateLocationInfo(NLatLng position) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final mapUseCase = ref.read(mapUseCaseProvider);
      final placemark = await mapUseCase.transPositionToAddress(position);
      if (placemark != null) {
        final roadAddress = placemark.thoroughfare?.isNotEmpty == true
            ? '${placemark.thoroughfare} ${placemark.subThoroughfare ?? ''}'
            : placemark.street;

        setState(() {
          _selectedLocationName = roadAddress;
        });
      }
    } catch (e) {
      debugPrint('주소 변환 중 오류 발생: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = ref.watch(isSearchingProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              // 드래그 핸들
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // 검색바
              SearchPlaceTextField(textController: _searchController),
              // 검색 결과 또는 지도
              Expanded(
                child: Stack(
                  children: [
                    SelectLocationView(
                      key: _mapKey,
                      onLocationSelected: _updateLocationInfo,
                    ),
                    if (isSearching)
                      Positioned.fill(
                        child: SearchPlaceResultView(
                          textController: _searchController,
                          mapController: _mapController,
                        ),
                      ),
                    Positioned(
                      right: 16,
                      bottom: 80,
                      child: FloatingActionButton(
                        heroTag: 'currentLocation',
                        mini: true,
                        onPressed: () async {
                          final position = await _mapController
                              ?.getLocationOverlay()
                              .getPosition();
                          if (position != null) {
                            _updateLocationInfo(position);
                            final cameraUpdate = NCameraUpdate.withParams(
                                target: position)
                              ..setAnimation(
                                  animation: NCameraAnimation.fly,
                                  duration: const Duration(milliseconds: 500));
                            _mapController?.updateCamera(cameraUpdate);
                          }
                        },
                        backgroundColor: Colors.white,
                        child: const Icon(
                          Icons.my_location,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: SafeArea(
                        child: ElevatedButton(
                          onPressed: _selectedLocationName != null &&
                                  !_isLoading
                              ? () {
                                  final position =
                                      _mapController!.nowCameraPosition.target;
                                  widget.onLocationSelected(
                                    _selectedLocationName!,
                                    position,
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text('이 위치로 선택하기'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
