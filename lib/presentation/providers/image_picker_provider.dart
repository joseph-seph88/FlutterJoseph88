import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:o2/core/utils/image_utils.dart';

final imagePickerProvider = Provider<ImagePicker>((ref) => ImagePicker());

// 단일 이미지 선택용 (채팅에서 사용)
final selectedImageProvider =
    StateNotifierProvider.autoDispose<SelectedImageNotifier, File?>(
        (ref) => SelectedImageNotifier(ref.read(imagePickerProvider)));

// 다중 이미지 선택용 (상품 등록에서 사용)
final multiImageProvider = StateNotifierProvider.autoDispose<MultiImageNotifier,
        List<ImageLoadingState>>(
    (ref) => MultiImageNotifier(ref.read(imagePickerProvider)));

class SelectedImageNotifier extends StateNotifier<File?> {
  final ImagePicker _picker;

  SelectedImageNotifier(this._picker) : super(null);

  Future<void> pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final originalFile = File(pickedFile.path);
        final compressedFile = await ImageUtils.compressImage(
          originalFile,
          quality: 85,
          minWidth: 1024,
          minHeight: 1024,
        );
        state = compressedFile;
      }
    } catch (e) {
      rethrow;
    }
  }

  void clear() {
    state = null;
  }
}

class ImageLoadingState {
  final File file;
  final bool isLoading;

  ImageLoadingState({
    required this.file,
    this.isLoading = true,
  });

  ImageLoadingState copyWith({
    File? file,
    bool? isLoading,
  }) {
    return ImageLoadingState(
      file: file ?? this.file,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class MultiImageNotifier extends StateNotifier<List<ImageLoadingState>> {
  final ImagePicker _picker;
  static const int maxImages = 10;

  MultiImageNotifier(this._picker) : super([]);

  Future<void> pickImages() async {
    try {
      final pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        final originalFiles =
            pickedFiles.map((xFile) => File(xFile.path)).toList();

        // 먼저 로딩 상태로 이미지 추가
        final newImages = [...state];
        for (var file in originalFiles) {
          if (newImages.length < maxImages) {
            newImages.add(ImageLoadingState(file: file));
          }
        }
        state = newImages;

        // 압축 작업 수행
        final compressedFiles = await ImageUtils.compressImages(
          originalFiles,
          quality: 85,
          minWidth: 1024,
          minHeight: 1024,
        );

        // 압축된 이미지로 상태 업데이트
        final updatedImages = state.map((loadingState) {
          final index = originalFiles.indexOf(loadingState.file);
          if (index != -1) {
            return ImageLoadingState(
              file: compressedFiles[index],
              isLoading: false,
            );
          }
          return loadingState;
        }).toList();

        state = updatedImages;
      }
    } catch (e) {
      rethrow;
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < state.length) {
      final newImages = [...state];
      newImages.removeAt(index);
      state = newImages;
    }
  }

  void clear() {
    state = [];
  }

  List<File> getFiles() {
    return state.map((loadingState) => loadingState.file).toList();
  }
}
