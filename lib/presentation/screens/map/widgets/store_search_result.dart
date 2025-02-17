import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:o2/domain/entities/map_entity.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../providers/map_provider.dart';

class StoreSearchResult extends ConsumerWidget {
  final Future<void> Function(MapEntity storeData) searchResultOnTap;

  const StoreSearchResult(this.searchResultOnTap, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapProvider);

    return Container(
      height: 200,
      color: AppColors.surface.withAlpha(200),
      child: mapState.isLoading
          ? const Center(
              child: SizedBox(
                width: 70,
                height: 70,
                child: LoadingIndicator(
                  indicatorType: Indicator.pacman,
                  colors: [AppColors.primary],
                ),
              ),
            )
          : (mapState.searchStoreDataList.isEmpty)
              ? Center(
                  child: Text(
                    '해당 업체는 등록되지 않은 업체입니다.',
                    style: AppStyles.labelLarge
                        .copyWith(color: AppColors.textSecondary),
                  ),
                )
              : ListView.builder(
                  itemCount: mapState.searchStoreDataList.length,
                  itemBuilder: (context, index) {
                    final storeData = mapState.searchStoreDataList[index];
                    final distance = mapState.betweenDistance[index];

                    return ListTile(
                      title: Row(
                        children: [
                          Text(storeData.storeName,
                              style: AppStyles.labelLarge
                                  .copyWith(color: AppColors.primary)),
                          const SizedBox(width: 10),
                          Text('${distance}km',
                              style: AppStyles.labelMedium
                                  .copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                      subtitle: Text(storeData.address),
                      trailing: const Icon(Icons.outbond_outlined),
                      onTap: () => searchResultOnTap(storeData),
                    );
                  },
                ),
    );
  }
}
