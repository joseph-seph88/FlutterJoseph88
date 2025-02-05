import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/map_provider.dart';

class LikeShopPage extends ConsumerWidget {
  const LikeShopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _textController = TextEditingController();
    final mapState = ref.watch(mapProvider);
    final likeCounts = ref.watch(likeStarProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text("님이 추천하고 싶은 업체는 어디인가요?"),
            Container(
              padding: AppStyles.defaultPadding,
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                    hintText: "업체명으로 검색",
                    hintStyle: AppStyles.labelLarge
                        .copyWith(color: AppColors.textSecondary),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      color: AppColors.textSecondary,
                      onPressed: () {},
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppStyles.defaultRadius),
                    )),
                style: AppStyles.labelLarge.copyWith(color: Colors.black),
              ),
            ),
            const Text("혹시 이 업체는 어떠세요?"),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: ListView.builder(
                itemCount: mapState.mapDataList.length,
                itemBuilder: (context, index) {
                  final searchData = mapState.mapDataList[index];
                  final likeCount = likeCounts[index] ?? 0;

                  return ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        ref.read(likeStarProvider.notifier).incrementLike(index);
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            child: ClipOval(
                              child: Image.asset(
                                searchData.iconPath,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -5,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$likeCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    title: Text("업체명: ${searchData.storeName}"),
                    subtitle: Text("주소: ${searchData.address}"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
