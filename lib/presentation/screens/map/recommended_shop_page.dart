import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/constants/app_constant.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/map_entity.dart';
import '../../providers/map_provider.dart';

class RecommendedShopPage extends ConsumerWidget {
  RecommendedShopPage({super.key});

  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapProvider);

    void onTap(MapEntity searchData) {
      ref.read(mapProvider.notifier).clearStateSearchData();
      ref.read(selectedMapDataProvider.notifier).state = searchData;
      _focusNode.unfocus();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _textController.dispose();
        _focusNode.dispose();
      });
      context.push('/map/recommendShop/starRating');
    }

    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              _focusNode.unfocus();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _textController.dispose();
                _focusNode.dispose();
              });
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
                  focusNode: _focusNode,
                  onTap: () {
                    if (_focusNode.hasFocus) {
                      _focusNode.unfocus();
                    }
                  },
                  onChanged: (query) {
                    ref.read(mapProvider.notifier).searchStoreData(query);
                  },
                  decoration: InputDecoration(
                      hintText: "업체명으로 검색",
                      hintStyle: AppStyles.labelLarge
                          .copyWith(color: AppColors.textSecondary),
                      suffixIcon: const Icon(Icons.search,
                          color: AppColors.textSecondary),
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
                  itemCount: mapState.searchStoreDataList.isEmpty
                      ? mapState.mapDataList.length
                      : mapState.searchStoreDataList.length,
                  itemBuilder: (context, index) {
                    final searchData = mapState.searchStoreDataList.isEmpty
                        ? mapState.mapDataList[index]
                        : mapState.searchStoreDataList[index];

                    return ListTile(
                      onTap: () {
                        onTap(searchData);
                      },
                      leading: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            child: ClipOval(
                              child: Image.asset(
                                searchData.category['iconPath'],
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                color: searchData.category['iconColor'],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppConstant.amber,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.star,
                                color: AppColors.surface,
                                size: 16,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -5,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${searchData.starRating}',
                                style: const TextStyle(
                                  color: AppColors.surface,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      title: Text(
                        "업체명: ${searchData.storeName}",
                        style: AppStyles.labelLarge
                            .copyWith(color: AppColors.primary),
                      ),
                      subtitle: Text("주소: ${searchData.address}"),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
