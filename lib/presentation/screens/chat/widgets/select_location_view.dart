import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/domain/usecases/map_use_case.dart';

class SelectLocationView extends ConsumerStatefulWidget {
  final Function(NLatLng) onLocationSelected;
  const SelectLocationView({super.key, required this.onLocationSelected});

  @override
  ConsumerState<SelectLocationView> createState() => SelectLocationViewState();

  static SelectLocationViewState? of(BuildContext context) =>
      context.findAncestorStateOfType<SelectLocationViewState>();
}

class SelectLocationViewState extends ConsumerState<SelectLocationView> {
  NaverMapController? mapController;
  bool _isInfoWindowPressed = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        NaverMap(
          onMapReady: (controller) {
            mapController = controller;
            ref.read(_currentTargetProvider.notifier).state =
                AsyncData(mapController!.nowCameraPosition.target);
          },
          onCameraChange: (reason, animated) {
            ref.read(_currentTargetProvider.notifier).state =
                const AsyncLoading();
          },
          onCameraIdle: () {
            ref.read(_currentTargetProvider.notifier).state =
                AsyncData(mapController!.nowCameraPosition.target);
          },
        ),
        _buildCenterMarker(),
      ],
    );
  }

  Widget _buildCenterMarker() {
    const double height = 100;

    return Transform.translate(
      offset: const Offset(0, -0.5 * height),
      child: SizedBox(
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildInfoWindow(),
            const SizedBox(height: 8),
            Image.asset(
              'assets/icons/marker.png',
              height: 32,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoWindow() {
    final currentAddress = ref.watch(_currentAddressProvider);

    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          _isInfoWindowPressed = true;
        });
      },
      onTapUp: (details) {
        setState(() {
          _isInfoWindowPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _isInfoWindowPressed = false;
        });
      },
      onTap: currentAddress.isLoading ? null : () {
        final target = ref.read(_currentTargetProvider).value;
        if (target == null) return;

        widget.onLocationSelected(target);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: _isInfoWindowPressed ? Colors.grey : AppColors.surface,
          border: Border.all(),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 1),
              blurRadius: 1,
            )
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: currentAddress.when(
          data: (data) {
            return _buildInfoWindowText(data?.street ?? 'null');
          },
          error: (error, stackTrace) {
            return const Text('주소를 불러오던 중 오류가 발생했습니다');
          },
          loading: () {
            return Transform.scale(
              scale: 0.5,
              child: const CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoWindowText(String address) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '장소 선택',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 14,
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7),
              child: Text(
                address,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const Icon(Icons.chevron_right),
      ],
    );
  }
}

final _currentTargetProvider =
    StateProvider.autoDispose<AsyncValue<NLatLng>>((ref) {
  return const AsyncLoading();
});

final _currentAddressProvider = FutureProvider.autoDispose<Placemark?>((ref) {
  final target = ref.watch(_currentTargetProvider);
  final mapUseCase = ref.read(mapUseCaseProvider);

  return target.when(
    data: (data) => mapUseCase.transAddressFromGeo(data),
    error: (error, stackTrace) => Future.error(error),
    loading: () => Future.delayed(const Duration(days: 365)),
  );
});