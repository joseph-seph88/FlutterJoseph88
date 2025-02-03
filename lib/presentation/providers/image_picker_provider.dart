import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final imagePickerProvider = Provider<ImagePicker>((ref) => ImagePicker());

final selectedImageProvider =
    StateNotifierProvider.autoDispose<SelectedImageNotifier, XFile?>(
        (ref) => SelectedImageNotifier(ref.read(imagePickerProvider)));

class SelectedImageNotifier extends StateNotifier<XFile?> {
  final ImagePicker _picker;

  SelectedImageNotifier(this._picker) : super(null);
  
  void pickImage() async {
    state = await _picker.pickImage(source: ImageSource.gallery);
  }

  void clear() {
    state = null;
  }
}
