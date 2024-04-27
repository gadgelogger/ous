//ユーザー情報の編集画面

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ous/domain/user_providers.dart';
import 'package:ous/gen/assets.gen.dart';
import 'package:ous/infrastructure/user_repository.dart';

class MyPageEdit extends ConsumerWidget {
  final ImagePicker _picker = ImagePicker();
  MyPageEdit({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDataAsyncValue = ref.watch(userStreamProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウント情報編集'),
      ),
      body: userDataAsyncValue.when(
        data: (userData) {
          final nameController =
              TextEditingController(text: userData?.displayName);
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final image =
                          await _picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        final imageUrl = await ref
                            .read(userRepositoryProvider)
                            .uploadProfileImage(image);
                        if (imageUrl != null) {
                          await ref.read(userRepositoryProvider).updateUser(
                                userData?.uid ?? '',
                                photoURL: imageUrl,
                              );
                        }
                      }
                    },
                    child: CircleAvatar(
                      radius: 100,
                      backgroundImage: userData?.photoURL != ''
                          ? NetworkImage(userData?.photoURL ?? '')
                          : null,
                      child: userData?.photoURL == ''
                          ? const Icon(Icons.person, size: 100)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(controller: nameController),
                  ElevatedButton(
                    onPressed: () async {
                      await ref.read(userRepositoryProvider).updateUser(
                            userData?.uid ?? '',
                            name: nameController.text,
                          );
                      if (!context.mounted) return;
                      ProviderScope.containerOf(context)
                          .refresh(userStreamProvider);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('プロフィールが更新されました。')),
                      );
                      Navigator.of(context).pop();
                    },
                    child: const Text('保存'),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Assets.icon.error.path,
                width: 150.0,
              ),
              Text('エラー: $error'),
            ],
          ),
        ),
      ),
    );
  }
}
