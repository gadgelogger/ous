// Flutter imports:
import 'package:flutter/material.dart';
// Project imports:
import 'package:ous/infrastructure/account_image_uploader_service.dart';
import 'package:ous/infrastructure/account_name_updater_service.dart';

class UserHeader extends StatelessWidget {
  final String name;
  final String status;
  final String image;
  final String email;
  final String uid;
  final TextEditingController _nameController = TextEditingController();
  UserHeader({
    Key? key,
    required this.name,
    required this.status,
    required this.image,
    required this.email,
    required this.uid,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // ユーザー情報のヘッダーUIに集中
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: GestureDetector(
            onTap: () {
              ImageUploader().pickAndUploadImage(context);
            },
            child: ImageUploader().isUploading
                ? const CircularProgressIndicator()
                : SizedBox(
                    height: 150,
                    width: 150,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          fit: StackFit.expand,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(image),
                            ),
                            Positioned(
                              bottom: 0,
                              right: -25,
                              child: RawMaterialButton(
                                onPressed: () {},
                                fillColor: const Color(0xFFF5F6F9),
                                padding: const EdgeInsets.all(7),
                                shape: const CircleBorder(),
                                child: Icon(
                                  Icons.photo_camera_outlined,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 30),
        const Text(
          'アカウント名',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController, // テキストフィールドを制御するためのTextEditingController
          decoration: InputDecoration(
            hintText: name,
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                // 名前の変更処理
                final newName = _nameController.text;
                final result = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('確認'),
                    content: Text('アカウント名を「$newName」に変更しますか？'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('キャンセル'),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ],
                  ),
                );

                if (result == true) {
                  // OKが押されたら名前を変更
                  if (!context.mounted) return;

                  AccountNameUpdater().updateDisplayName(newName, context);
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '役職',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: status,
            border: const OutlineInputBorder(),
            enabled: false,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'メールアドレス',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: email,
            border: const OutlineInputBorder(),
            enabled: false,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'ID',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: uid,
            border: const OutlineInputBorder(),
          ),
          enabled: false,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
