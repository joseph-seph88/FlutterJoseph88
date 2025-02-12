import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/core/theme/app_theme.dart';
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
  NaverMapController? _mapController;
  String? _selectedLocationName;
  NLatLng? _selectedPosition;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                child: isSearching
                    ? SearchPlaceResultView(
                        textController: _searchController,
                        mapController: _mapController,
                      )
                    : Stack(
                        children: [
                          SelectLocationView(
                            onLocationSelected: (position) {
                              setState(() {
                                _selectedPosition = position;
                              });
                            },
                          ),
                          // 하단 선택 버튼
                          Positioned(
                            left: 16,
                            right: 16,
                            bottom: 16,
                            child: SafeArea(
                              child: ElevatedButton(
                                onPressed: _selectedPosition != null
                                    ? () {
                                        if (_selectedLocationName != null &&
                                            _selectedPosition != null) {
                                          widget.onLocationSelected(
                                            _selectedLocationName!,
                                            _selectedPosition!,
                                          );
                                        }
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
                                child: const Text('이 위치로 선택하기'),
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
