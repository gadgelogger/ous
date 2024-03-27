import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ous/domain/post_provider.dart';
import 'package:ous/presentation/widgets/review/Post/custom_dropdown.dart';
import 'package:ous/presentation/widgets/review/Post/custom_slider.dart';
import 'package:ous/presentation/widgets/review/Post/custom_text_field.dart';
import 'package:ous/presentation/widgets/review/Post/custom_year_picker.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:url_launcher/url_launcher.dart';

// 投稿ページ
class PostPage extends ConsumerWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postModel = ref.watch(postProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('投稿ページ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              final url = Uri.parse('https://tan-q-bot-unofficial.com/rule/');
              launchUrl(url);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            CustomDropdown(
              labelText: '投稿する学部を選択してください',
              value: postModel.category,
              items: const [
                MapEntry('rigaku', '理学部'),
                MapEntry('kougakubu', '工学部'),
                MapEntry('zyouhou', '情報理工学部'),
                MapEntry('seibutu', '生物地球学部'),
                MapEntry('kyouiku', '教育学部'),
                MapEntry('keiei', '経営学部'),
                MapEntry('zyuui', '獣医学部'),
                MapEntry('seimei', '生命科学部'),
                MapEntry('kiban', '基盤教育科目'),
                MapEntry('kyousyoku', '教職関連科目'),
              ],
              onChanged: (value) => postModel.setCategory(value!),
            ),
            const SizedBox(height: 16),
            CustomDropdown(
              labelText: '投稿する講義のカテゴリを選択してください',
              value: postModel.bumon,
              items: const [
                MapEntry('ラク単', 'ラク単'),
                MapEntry('エグ単', 'エグ単'),
                MapEntry('普通', '普通'),
              ],
              onChanged: (value) => postModel.setBumon(value!),
            ),
            const SizedBox(height: 16),
            CustomYearPicker(
              labelText: '開講年度を選択してください',
              value: postModel.nenndo,
              onChanged: (value) => postModel.setNendo(value),
            ),
            const SizedBox(height: 16),
            CustomDropdown(
              labelText: '開講学期を選択してください',
              value: postModel.gakki,
              items: const [
                MapEntry('春１', '春１'),
                MapEntry('春２', '春２'),
                MapEntry('秋１', '秋１'),
                MapEntry('秋２', '秋２'),
                MapEntry('春１と２', '春１と２'),
                MapEntry('秋１と２', '秋１と２'),
              ],
              onChanged: (value) => postModel.setGakki(value!),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              labelText: '授業名を入力してください',
              hintText: 'FBD00100 フレッシュマンセミナー',
              controller: postModel.zyugyoumeiController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              labelText: '講師名を入力してください',
              hintText: '太郎田中',
              controller: postModel.kousimeiController,
            ),
            const SizedBox(height: 16),
            CustomDropdown(
              labelText: '単位数を選択してください',
              value: postModel.tanni,
              items: const [
                MapEntry('1', '1'),
                MapEntry('2', '2'),
              ],
              onChanged: (value) => postModel.setTanni(value!),
            ),
            const SizedBox(height: 16),
            CustomDropdown(
              labelText: '授業形式を選択してください',
              value: postModel.zyugyoukeisiki,
              items: const [
                MapEntry('オンライン(VOD)', 'オンライン(VOD)'),
                MapEntry('オンライン(リアルタイム）', 'オンライン(リアルタイム）'),
                MapEntry('対面', '対面'),
                MapEntry('対面とオンライン', '対面とオンライン'),
              ],
              onChanged: (value) => postModel.setZyugyoukeisiki(value!),
            ),
            const SizedBox(height: 16),
            CustomSlider(
              labelText: '総合評価',
              value: postModel.hyouka,
              onChanged: (value) => postModel.setHyouka(value),
            ),
            CustomSlider(
              labelText: '授業の面白さ',
              value: postModel.omosirosa,
              onChanged: (value) => postModel.setOmosirosa(value),
            ),
            CustomSlider(
              labelText: '単位の取りやすさ',
              value: postModel.toriyasusa,
              onChanged: (value) => postModel.setToriyasusa(value),
            ),
            const SizedBox(height: 16),
            CustomDropdown(
              labelText: '出席確認の有無を選択してください',
              value: postModel.syusseki,
              items: const [
                MapEntry('毎日出席を取る', '毎日出席を取る'),
                MapEntry('ほぼ出席を取る', 'ほぼ出席を取る'),
                MapEntry('たまに出席を取る', 'たまに出席を取る'),
                MapEntry('出席確認はなし', '出席確認はなし'),
              ],
              onChanged: (value) => postModel.setSyusseki(value!),
            ),
            const SizedBox(height: 16),
            CustomDropdown(
              labelText: '教科書の有無を選択してください',
              value: postModel.kyoukasyo,
              items: const [
                MapEntry('あり', 'あり'),
                MapEntry('なし', 'なし'),
              ],
              onChanged: (value) => postModel.setKyoukasyo(value!),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              labelText: 'レビューを入力してください',
              hintText: 'この講義は楽で〜...',
              maxLines: 5,
              controller: postModel.komentoController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              labelText: 'テスト形式を入力してください',
              hintText: 'ありorなしorレポートorその他...',
              controller: postModel.tesutokeisikiController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              labelText: 'テストの傾向を入力してください',
              hintText: 'テストは主に教科書から...',
              maxLines: 5,
              controller: postModel.tesutokeikouController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              labelText: '投稿者名(公開されます)',
              hintText: 'ニックネーム',
              controller: postModel.nameController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              labelText: '宣伝欄です。サークルや組織などの宣伝にご活用ください',
              hintText: '〇〇サークルに属しています！入部よろしく！',
              maxLines: 5,
              controller: postModel.sendenController,
            ),
            const SizedBox(height: 32),
            SlideAction(
              outerColor: Theme.of(context).colorScheme.primary,
              innerColor: Colors.white,
              sliderButtonIcon: const Icon(
                Icons.send,
                color: Colors.black,
              ),
              text: 'スワイプして送信',
              textStyle: const TextStyle(fontSize: 18, color: Colors.black),
              onSubmit: () => _submitForm(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  void _resetForm(WidgetRef ref) {
    ref.read(postProvider).setBumon('ラク単');
    ref.read(postProvider).setCategory('rigaku');
    ref.read(postProvider).setGakki('春１');
    ref.read(postProvider).setHyouka(3);
    ref.read(postProvider).setKyoukasyo('あり');
    ref.read(postProvider).setNendo('');
    ref.read(postProvider).setOmosirosa(3);
    ref.read(postProvider).setSyusseki('毎日出席を取る');
    ref.read(postProvider).setTanni('1');
    ref.read(postProvider).setToriyasusa(3);
    ref.read(postProvider).setZyugyoukeisiki('オンライン(VOD)');
  }

  void _showErrorMessages(BuildContext context, List<String> errorMessages) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('エラー'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: errorMessages.map((message) => Text(message)).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _submitForm(BuildContext context, WidgetRef ref) async {
    final errorMessages = ref.read(postProvider).validateForm();
    if (errorMessages.isNotEmpty) {
      _showErrorMessages(context, errorMessages);
      return;
    }

    final result = await ref.read(postProvider).submit();
    if (result) {
      _showSnackBar(context, '投稿が完了しました。');
      _resetForm(ref);
      HapticFeedback.vibrate();
    } else {
      _showSnackBar(context, '投稿に失敗しました。');
    }
  }
}
