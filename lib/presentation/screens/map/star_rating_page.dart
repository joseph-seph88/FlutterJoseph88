import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/constants/app_constant.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/presentation/providers/map_provider.dart';

class StarRatingPage extends ConsumerWidget {
  StarRatingPage({super.key});

  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapData = ref.read(selectedMapDataProvider);
    int starIndex = ref.watch(starIndexProvider);

    Future<void> onPressedBtn(int index, String mapId) async {
      ref.read(starRatingProvider.notifier).state = index + 1.0;
      await ref.read(mapProvider.notifier).updateStarRating(mapId, starIndex);
      _textController.clear();
      _focusNode.unfocus();
      if (context.mounted) {
        context.pop();
      }
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(
            "${mapData?.storeName}",
            style: AppStyles.titleLarge.copyWith(color: AppColors.primary),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                _textController.clear();
                _focusNode.unfocus();
                context.pop();
              },
              icon: const Icon(Icons.arrow_back_ios_new_outlined))),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const SizedBox(width: 40),
                  const Icon(
                    Icons.star,
                    color: AppConstant.amber,
                    size: 50,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    "${mapData?.starRating}",
                    style:
                        AppStyles.bodySuper.copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(width: 80),
                  Text(
                    "리뷰 ${mapData?.participant}",
                    style:
                        AppStyles.bodyLarge.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) {
                        return IconButton(
                          onPressed: () {
                            if (starIndex == index + 1) {
                              ref.read(starIndexProvider.notifier).state =
                                  starIndex - 1;
                            } else {
                              ref.read(starIndexProvider.notifier).state =
                                  index + 1;
                            }
                          },
                          icon: Icon(
                            index < starIndex ? Icons.star : Icons.star_border,
                            color: AppConstant.amber,
                            size: 40,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                        controller: _textController,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: "리뷰 작성",
                          hintStyle: AppStyles.labelMedium
                              .copyWith(color: AppColors.primary),
                          labelText: "리뷰 작성",
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.primary, width: 1),
                          ),
                        ),
                        maxLines: 3,
                        onTapOutside: (_) => _focusNode.unfocus())),
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  if (mapData!.mapId != null) {
                    await onPressedBtn(starIndex, mapData.mapId!);
                  }
                },
                child: Text("리뷰 등록",
                    style: AppStyles.bodyLarge
                        .copyWith(color: AppColors.surface))),
          ],
        ),
      ),
    );
  }
}
