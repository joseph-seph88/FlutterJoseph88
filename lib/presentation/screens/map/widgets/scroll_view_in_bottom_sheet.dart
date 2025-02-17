import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/color_trans_util.dart';
import '../../../providers/map_provider.dart';

class ScrollViewInBottomSheet extends ConsumerWidget {
  final ScrollController scrollController;
  final Future<void> Function(String category) onButtonPressed;

  const ScrollViewInBottomSheet(this.scrollController, this.onButtonPressed,
      {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapProvider);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 30,
            width: 65,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                Icons.drag_handle,
                color: AppColors.primary.withAlpha(100),
                size: 30,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
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
                              mapState.transAddress,
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
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio: 1.0,
                          ),
                          itemCount: mapState.staticCategory.length,
                          itemBuilder: (context, index) {
                            final categoryData = mapState.staticCategory[index];
                            final categoryColor =
                                ColorTransUtil.transStringToColor(
                                    categoryData['iconColor']);
            
                            return Container(
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withAlpha(200),
                                    offset: const Offset(-5, 7),
                                    blurRadius: 7,
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  ref.read(isStreamProvider.notifier).state = true;
                                  ref.read(categoryProvider.notifier).state =
                                      categoryData['category'];
                                  onButtonPressed(categoryData['category']);
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
            ),
          ),
        ],
      ),
    );
  }
}
