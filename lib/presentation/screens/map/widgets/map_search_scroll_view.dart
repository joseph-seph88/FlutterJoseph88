import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/presentation/providers/map_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/map_entity.dart';

class MapSearchScrollView extends ConsumerWidget {
  final Future<void> Function(MapEntity searchStoreData) onTap;

  const MapSearchScrollView({required this.onTap, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapProvider);

    return SingleChildScrollView(
      child: Container(
        height: 200,
        color: AppColors.primary.withAlpha(150).withRed(80),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: mapState.searchStoreDataList.length,
          itemBuilder: (context, index) {
            final searchStoreData = mapState.searchStoreDataList[index];
            return ListTile(
                title: Text(
                  searchStoreData.storeName,
                  style:
                      AppStyles.labelMedium.copyWith(color: AppColors.primary),
                ),
                subtitle: Text(searchStoreData.address),
                onTap: () async {
                  final param = {
                    'category': searchStoreData.category['category'],
                    'position': searchStoreData.position,
                  };
                  ref.read(mapParamProvider.notifier).state = param;
                  await onTap(searchStoreData);
                });
          },
        ),
      ),
    );
  }
}
