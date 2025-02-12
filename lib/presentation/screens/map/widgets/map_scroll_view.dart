import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/core/utils/color_trans_util.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../providers/map_provider.dart';

class MapScrollView extends ConsumerWidget {
  final ScrollController scrollController;
  final GeoPoint geoPosition;
  final Future<void> Function(String category, GeoPoint geoPosition)
      onButtonPressed;

  const MapScrollView(this.scrollController, this.geoPosition,
      {required this.onButtonPressed, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapProvider);
    String? currentAddress = mapState.transAddress;

    return SingleChildScrollView(
      controller: scrollController,
      child: Container(
        color: AppColors.surface,
        child: Column(
          children: [
            Container(
              padding: AppStyles.defaultPadding.copyWith(
                top: AppStyles.verticalPadding.top + 10,
                bottom: AppStyles.verticalPadding.bottom + 10,
              ),
              color: AppColors.surface,
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      currentAddress,
                      style: AppStyles.labelLarge
                          .copyWith(color: AppColors.primary),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: mapState.staticCategory.length,
                  itemBuilder: (context, index) {
                    final categoryData = mapState.staticCategory[index];
                    final categoryColor = ColorTransUtil.transStringToColor(
                        categoryData['iconColor']);
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow:  [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(200),
                            offset: const Offset(-5, 7),
                            blurRadius: 7,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(categoryProvider.notifier).state =
                              categoryData['category'];
                          onButtonPressed(
                              categoryData['category'], geoPosition);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          side: const BorderSide(
                              color: AppColors.primary, width: 0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 12),
                                decoration: BoxDecoration(
                                  color: categoryColor.withAlpha(50),
                                  shape: BoxShape.circle,
                                ),
                                child: ImageIcon(
                                  AssetImage(categoryData['iconPath']),
                                  size: 50,
                                  color: categoryColor,
                                ),
                              ),
                            ),
                            Text(
                              categoryData['category'],
                              style: AppStyles.labelLarge.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
