import 'dart:io';
import 'package:ai_hair_official/core/utils/logger_util.dart';
import 'package:ai_hair_official/core/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ai_hair_official/features/hair/presentation/cubits/hair_cubit.dart';
import 'package:ai_hair_official/features/hair/presentation/cubits/hair_state.dart';

class PhotoUploadPage extends StatelessWidget {
  const PhotoUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HAIR DREAMER')),
      body: BlocConsumer<HairCubit, HairState>(
        listener: (context, state) {
          if (state is HairImageSelection &&
              state.manipulationErrorMessage != null) {
            ToastUtil.showError(context, state.manipulationErrorMessage!);
            logger.d(state.manipulationErrorMessage);
          }
          if (state is HairImageSelection &&
              state.recommandErrorMessage != null) {
            ToastUtil.showError(context, state.recommandErrorMessage!);
            logger.d(state.recommandErrorMessage);
          }
        },
        builder: (context, state) {
          if (state is HairImageSelection) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildImageSelector(context, state.userImage, 1),
                      _buildImageSelector(context, state.otherImage, 2),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: (state.userImage != null &&
                                state.otherImage != null &&
                                !state.isLoading)
                            ? () => _mainpulationImages(context)
                            : null,
                        child: state.isLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                                '합성 하기',
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                      ),
                      const SizedBox(width: 24),
                      ElevatedButton(
                        onPressed: (state.userImage != null && !state.isLoading)
                            ? () => _recommandImages(context)
                            : null,
                        child: state.isLoading
                            ? const CircularProgressIndicator()
                            : const Text('추천 받기'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (state.manipulationResult != null &&
                      state.manipulationResult!.resultImageUrl.isNotEmpty)
                    Column(
                      children: [
                        const Text('합성 결과'),
                        _buildResultImage(
                            state.manipulationResult!.resultImageUrl)
                      ],
                    )
                  else
                    const Text('합성된 이미지가 없습니다.'),
                  const SizedBox(height: 24),
                  if (state.recommandResult != null &&
                      state.recommandResult!.resultImageUrl.isNotEmpty)
                    Column(
                      children: [
                        const Text('추천 결과'),
                        _buildResultImage(state.recommandResult!.resultImageUrl)
                      ],
                    )
                  else
                    const Text('추천된 이미지가 없습니다.'),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildImageSelector(BuildContext context, File? image, int index) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8)),
      child: image == null
          ? IconButton(
              icon: const Icon(Icons.add_a_photo, size: 50),
              onPressed: () => _pickImage(context, index))
          : Stack(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(image,
                        width: 200, height: 200, fit: BoxFit.fill)),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => _removeImage(context, index),
                    style:
                        IconButton.styleFrom(backgroundColor: Colors.black54),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildResultImage(String imageUrl) {
    return Image.network(
      imageUrl,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, color: Colors.red, size: 40),
                SizedBox(height: 8),
                Text('이미지를 불러올 수 없습니다', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(BuildContext context, int index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      if (context.mounted) {
        context.read<HairCubit>().selectImage(file, index);
      }
    }
  }

  void _removeImage(BuildContext context, int index) {
    final cubit = context.read<HairCubit>();
    cubit.removeImage(index);
  }

  void _mainpulationImages(BuildContext context) {
    context.read<HairCubit>().manipulationHairStyle('3', '888');
  }

  void _recommandImages(BuildContext context) {
    context.read<HairCubit>().recommandHairStyle('5', '777');
  }
}
