import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/presentation/providers/image_picker_provider.dart';
import 'package:o2/presentation/providers/image_provider.dart';
import 'package:o2/presentation/widgets/select_location_modal.dart';
import 'package:o2/presentation/providers/auth_provider.dart';
import 'package:o2/data/models/product_model.dart';
import 'package:o2/presentation/providers/product_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WriteScreen extends ConsumerStatefulWidget {
  const WriteScreen({super.key});

  @override
  ConsumerState<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends ConsumerState<WriteScreen> {
  bool _isPriceOfferEnabled = false;
  bool _isSellingMode = true;
  String? _selectedLocationName;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  double? _latitude;
  double? _longitude;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

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

  Future<void> _onSubmit() async {
    // 1. 필수 입력값 검증
    final selectedImages = ref.read(multiImageProvider);
    if (selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('최소 1개의 이미지를 선택해주세요.')),
      );
      return;
    }

    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목을 입력해주세요.')),
      );
      return;
    }

    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('설명을 입력해주세요.')),
      );
      return;
    }

    if (_isSellingMode && _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('가격을 입력해주세요.')),
      );
      return;
    }

    if (_selectedLocationName == null ||
        _latitude == null ||
        _longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('거래 희망 장소를 선택해주세요.')),
      );
      return;
    }

    try {
      final sellerId = ref.read(authProvider)!.id;
      final productId = DateTime.now().millisecondsSinceEpoch.toString();

      // 이미지 업로드
      final imageUrls = await ref.read(uploadProductImagesProvider)(
          sellerId, productId, selectedImages);

      // 상품 정보 생성
      final product = ProductModel(
        id: productId,
        title: _titleController.text,
        description: _descriptionController.text,
        price: _isSellingMode ? int.parse(_priceController.text) : 0,
        locationName: _selectedLocationName!,
        location: GeoPoint(_latitude!, _longitude!),
        category: "기타", // TODO: 카테고리 선택 기능 추가
        images: imageUrls,
        viewCount: 0,
        favoriteCount: 0,
        createdAt: Timestamp.now(),
        sellerId: sellerId,
        isOfferEnabled: _isSellingMode && _isPriceOfferEnabled,
        status: 'active',
        chatCount: 0,
      );

      // 상품 저장
      await ref.read(manageProductUseCaseProvider).createProduct(product);

      if (!mounted) return;

      // 성공 메시지 표시 및 화면 이동
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('상품이 등록되었습니다.')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('상품 등록 중 오류가 발생했습니다.')),
      );
    }
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
                    controller: _titleController,
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
                      controller: _priceController,
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
            // 거래 희망 장소 섹션
            Padding(
              padding: AppStyles.defaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '거래 희망 장소',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: AppStyles.smallSpacing),
                  OutlinedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => SelectLocationModal(
                          onLocationSelected: (locationName, position) {
                            setState(() {
                              _selectedLocationName = locationName;
                              _latitude = position.latitude;
                              _longitude = position.longitude;
                            });
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      side: const BorderSide(color: AppColors.divider),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _selectedLocationName ?? '장소를 선택해주세요',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: _selectedLocationName != null
                                  ? AppColors.text
                                  : AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppStyles.smallSpacing),
                        const Icon(
                          Icons.location_on_outlined,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
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
                    controller: _descriptionController,
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
            onPressed: _onSubmit,
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
