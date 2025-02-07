import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:o2/presentation/providers/auth_provider.dart';

import '../../../core/theme/app_theme.dart';

class MyProfileScreen extends ConsumerWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final auth = ref.watch(authProvider)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("프로필"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: Padding(
        padding: AppStyles.defaultPadding,
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: ref.read(authProvider)?.image != null &&
                          ref.read(authProvider)!.image!.isNotEmpty
                      ? NetworkImage(ref.read(authProvider)!.image!)
                      : null,
                  child: ref.read(authProvider)?.image == null ||
                          ref.read(authProvider)!.image!.isEmpty
                      ? const Icon(Icons.person_outline)
                      : null,
                ),
                const SizedBox(width: AppStyles.defaultSpacing),
                Text(
                  auth.name,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppStyles.defaultSpacing),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileEditScreen()),
                  );
                },
                child: Text(
                  "프로필 수정",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.text,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final nameController = TextEditingController();
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController.text = ref.read(authProvider)!.name;
  }

  Future<void> updateProfile() async {
    final filePath =
        "Uploads/${DateTime.now().toIso8601String()}_${_selectedImage!.path.split('/').last}";
    final storageRef = FirebaseStorage.instance.ref().child(filePath);
    final uploadTask = storageRef.putFile(_selectedImage!);
    final taskSnapshot = await uploadTask;
    String url = await taskSnapshot.ref.getDownloadURL();

    final userEntity = ref.read(authProvider)!.copyWith(
          name: nameController.text,
          image: url,
        );

    ref.read(authProvider.notifier).updateProfile(userEntity);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("프로필 수정이 완료되었습니다."),
      ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("프로필 수정"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: updateProfile,
            child: const Text("완료"),
          ),
        ],
      ),
      body: Padding(
        padding: AppStyles.defaultPadding,
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                if (_isLoading) return;

                try {
                  setState(() {
                    _isLoading = true;
                  });

                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                    maxWidth: 512,
                    maxHeight: 512,
                  );

                  if (image != null) {
                    setState(() {
                      _selectedImage = File(image.path);
                    });
                  }
                } finally {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : ref.read(authProvider)?.image != null &&
                                ref.read(authProvider)!.image!.isNotEmpty
                            ? NetworkImage(ref.read(authProvider)!.image!)
                            : null,
                    child: _selectedImage == null &&
                            (ref.read(authProvider)?.image == null ||
                                ref.read(authProvider)!.image!.isEmpty)
                        ? const Icon(Icons.person_outline)
                        : null,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppStyles.defaultSpacing),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "이름",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.text,
                ),
              ),
            ),
            const SizedBox(height: AppStyles.smallSpacing),
            TextField(
              controller: nameController,
              style:
                  theme.textTheme.bodyMedium?.copyWith(color: AppColors.text),
            ),
          ],
        ),
      ),
    );
  }
}
