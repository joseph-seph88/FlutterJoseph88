import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/domain/usecases/map_use_case.dart';
import 'package:o2/presentation/providers/providers.dart';

class SearchPlaceTextField extends ConsumerStatefulWidget {
  final TextEditingController textController;

  const SearchPlaceTextField({super.key, required this.textController});

  @override
  ConsumerState createState() => _SearchPlaceTextFieldState();
}

class _SearchPlaceTextFieldState extends ConsumerState<SearchPlaceTextField> {
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: const BoxDecoration(color: AppColors.surface),
      child: _buildSearchTextField(context),
    );
  }

  Widget _buildSearchTextField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: ColorScheme.of(context).surfaceContainerHigh,
      ),
      child: TextField(
        controller: widget.textController,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: '장소명으로 검색',
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          filled: true,
          fillColor: ColorScheme.of(context).surfaceContainerHigh,
        ),
        onChanged: (value) {
          if (_debounce?.isActive ?? false) _debounce?.cancel();
          if (value.isEmpty) {
            ref.read(isSearchingProvider.notifier).state = false;
            return;
          }

          _debounce = Timer(const Duration(seconds: 1), () {
            ref.read(isSearchingProvider.notifier).state =
                widget.textController.text.isNotEmpty;
          });
        },
        onSubmitted: (_) {},
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
      ),
    );
  }
}

class SearchPlaceResultView extends ConsumerWidget {
  final TextEditingController textController;
  final NaverMapController? mapController;
  final _searchResultProvider = FutureProvider.autoDispose
      .family<List<AutocompletePrediction>, String>((ref, input) {
    final mapUseCase = ref.read(mapUseCaseProvider);
    return mapUseCase.getPredictions(input);
  });

  SearchPlaceResultView(
      {super.key,
      required this.textController,
      this.mapController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(_searchResultProvider(textController.text));

    return Container(
      color: AppColors.surface,
      child: result.when(
        data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];

              return ListTile(
                title: Text(item.primaryText),
                subtitle: Text(item.secondaryText),
                trailing: const Icon(Icons.outbond_outlined),
                onTap: () async {
                  final latLng = await ref.read(getLatLngProvider)(item.placeId);
                  if (latLng == null) return;

                  final nLatLng = NLatLng(latLng.lat, latLng.lng);
                  final cameraUpdate = NCameraUpdate.withParams(target: nLatLng)
                    ..setAnimation(animation: NCameraAnimation.none);

                  mapController?.updateCamera(cameraUpdate);
                  textController.clear();
                  ref.read(isSearchingProvider.notifier).state = false;
                },
              );
            },
          );
        },
        error: (error, stackTrace) {
          return const Center(child: Text('검색 중 오류가 발생했습니다.'));
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

final isSearchingProvider = StateProvider.autoDispose<bool>((ref) => false);