import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/constants/app_constant.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/presentation/providers/map_provider.dart';
import 'package:o2/presentation/providers/review_provider.dart';
import 'package:o2/presentation/widgets/custom_snack_bar.dart';

class StarRatingPage extends ConsumerWidget {
  StarRatingPage({super.key});

  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapData = ref.read(selectedMapDataProvider);
    int starIndex = ref.watch(starIndexProvider);
    final reviewState = ref.watch(reviewProvider);

    Future<void> onPressedBtn(int index, String mapId) async {
      ref.read(starRatingProvider.notifier).state = index + 1.0;
      await ref.read(mapProvider.notifier).updateStarRating(mapId, starIndex);
      Map<String, dynamic> storeReview = {
        'mapId': mapId,
        'comment': _textController.text
      };
      await ref.read(reviewProvider.notifier).addStoreReview(storeReview);
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
                  Row(
                    children: [
                      Text(
                        "${mapData?.starRating}",
                        style: AppStyles.bodySuper
                            .copyWith(color: AppColors.primary),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "(평점)",
                        style: AppStyles.bodyLarge
                            .copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(width: 60),
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
                Text(
                  '내 별점: $starIndex 점',
                  style:
                      AppStyles.labelMedium.copyWith(color: AppColors.primary),
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
                        style:
                            AppStyles.labelLarge.copyWith(color: Colors.black),
                        maxLines: 3,
                        onTapOutside: (_) => _focusNode.unfocus())),
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  if (mapData!.mapId != null &&
                      _textController.text.isNotEmpty) {
                    final isUse = await ref
                        .read(reviewProvider.notifier)
                        .isDuplicateStoreReview(mapData.mapId);
                    if (isUse) {
                      await onPressedBtn(starIndex, mapData.mapId!);
                    } else {
                      if (!context.mounted) return;
                      CustomSnackBar.customSnackBar(
                          context: context, message: "이미 등록된 리뷰가 있습니다.");
                      context.pop();
                    }
                  } else {
                    if (!context.mounted) return;
                    CustomSnackBar.customSnackBar(
                        context: context, message: "리뷰를 입력하세요.");
                  }
                },
                child: Text("리뷰 등록",
                    style: AppStyles.bodyLarge
                        .copyWith(color: AppColors.surface))),
            const SizedBox(height: 30),
            ListView.builder(
              shrinkWrap: true,
              itemCount: reviewState.asyncStoreReviewList.when(
                data: (data) => data.length,
                loading: () => 0,
                error: (error, stackTrace) => 0,
              ),
              itemBuilder: (context, index) {
                return reviewState.asyncStoreReviewList.when(
                  data: (data) {
                    final review = data[index];
                    return Card(
                      elevation: 4,
                      color: Colors.lightGreen[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${review.email} 님',
                              style: AppStyles.bodyLarge.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '리뷰 내용 : ${review.storeReview?['comment'] ?? '아직 후기가 없습니다.'}',
                              style: AppStyles.bodyMedium.copyWith(
                                color: AppColors.text,
                                height: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  loading: () {
                    return const Center(child: CircularProgressIndicator());
                  },
                  error: (error, stackTrace) {
                    return Center(child: Text('에러 발생: $error'));
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
