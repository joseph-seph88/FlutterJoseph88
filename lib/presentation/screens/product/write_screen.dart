import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/presentation/providers/image_picker_provider.dart';

class WriteScreen extends ConsumerStatefulWidget {
  const WriteScreen({super.key});

  @override
  ConsumerState<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends ConsumerState<WriteScreen> {
  bool _isPriceOfferEnabled = false;
  bool _isSellingMode = true;

  Future<void> _pickImage() async {
    try {
      await ref.read(multiImageProvider.notifier).pickImages();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지를 선택하는 중 오류가 발생했습니다.')),
      );
    }
  }

  void _removeImage(int index) {
    ref.read(multiImageProvider.notifier).removeImage(index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedImages = ref.watch(multiImageProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('내 물건 팔기'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('임시저장'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 선택 영역
            Container(
              height: 120,
              padding: AppStyles.defaultPadding,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: selectedImages.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return GestureDetector(
                      onTap: selectedImages.length < 10 ? _pickImage : null,
                      child: Container(
                        width: 88,
                        height: 88,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius:
                              BorderRadius.circular(AppStyles.defaultRadius),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.camera_alt_outlined),
                            const SizedBox(height: 4),
                            Text(
                              '${selectedImages.length}/10',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final imageIndex = index - 1;
                  final image = selectedImages[imageIndex];

                  return Stack(
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppStyles.defaultRadius),
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(AppStyles.defaultRadius),
                          child: Image.file(
                            image,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.error),
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 12,
                        child: GestureDetector(
                          onTap: () => _removeImage(imageIndex),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const Divider(height: 1),
            // 제목 입력
            Padding(
              padding: AppStyles.defaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '제목',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: AppStyles.smallSpacing),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: '제목',
                    ),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // 거래 방식
            Padding(
              padding: AppStyles.defaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '거래 방식',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: AppStyles.smallSpacing),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _isSellingMode = true;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: _isSellingMode
                                  ? theme.colorScheme.primary
                                  : AppColors.divider,
                            ),
                          ),
                          child: Text(
                            '판매하기',
                            style: TextStyle(
                              color: _isSellingMode
                                  ? theme.colorScheme.primary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppStyles.smallSpacing),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _isSellingMode = false;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: !_isSellingMode
                                  ? theme.colorScheme.primary
                                  : AppColors.divider,
                            ),
                          ),
                          child: Text(
                            '나눔하기',
                            style: TextStyle(
                              color: !_isSellingMode
                                  ? theme.colorScheme.primary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // 가격 입력
            if (_isSellingMode) ...[
              Padding(
                padding: AppStyles.defaultPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '가격',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(width: AppStyles.smallSpacing),
                        Checkbox(
                          value: _isPriceOfferEnabled,
                          onChanged: (value) {
                            setState(() {
                              _isPriceOfferEnabled = value ?? false;
                            });
                          },
                          activeColor: theme.colorScheme.primary,
                        ),
                        Text(
                          '가격 제안 받기',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.text,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppStyles.smallSpacing),
                    TextField(
                      keyboardType: TextInputType.number,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.text,
                      ),
                      decoration: const InputDecoration(
                        hintText: '가격을 입력해주세요.',
                        suffixText: '원',
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
            ],
            // 설명 입력
            Padding(
              padding: AppStyles.defaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '자세한 설명',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: AppStyles.smallSpacing),
                  TextField(
                    maxLines: 8,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.text,
                    ),
                    decoration: const InputDecoration(
                      hintText:
                          '인창동에 올릴 게시글 내용을 작성해 주세요.\n(판매 금지 물품은 게시가 제한될 수 있어요.)',
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            const SizedBox(height: 64),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppStyles.defaultPadding,
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
              '작성 완료',
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.surface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
