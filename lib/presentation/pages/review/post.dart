import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

// Providerの定義
final postProvider = ChangeNotifierProvider((ref) => PostModel());

class CustomDropdown extends StatelessWidget {
  final String labelText;
  final List<MapEntry<String, String>> items;
  final String value;
  final void Function(String?)? onChanged;

  const CustomDropdown({
    Key? key,
    required this.labelText,
    required this.items,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      value: value,
      items: items.map((MapEntry<String, String> item) {
        return DropdownMenuItem<String>(
          value: item.key,
          child: Text(item.value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

class CustomSlider extends StatelessWidget {
  final String labelText;
  final double value;
  final void Function(double)? onChanged;

  const CustomSlider({
    Key? key,
    required this.labelText,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Slider(
          value: value,
          min: 1,
          max: 5,
          divisions: 4,
          label: value.round().toString(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// カスタムウィジェット
class CustomTextField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final int? maxLines;
  final TextEditingController controller;

  const CustomTextField({
    Key? key,
    required this.labelText,
    this.hintText,
    this.maxLines = 1,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      maxLines: maxLines,
    );
  }
}

class CustomYearPicker extends StatelessWidget {
  final String labelText;
  final String value;
  final void Function(String)? onChanged;

  const CustomYearPicker({
    Key? key,
    required this.labelText,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          initialDatePickerMode: DatePickerMode.year,
        );
        if (picked != null && onChanged != null) {
          onChanged!(picked.year.toString());
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value.isNotEmpty ? value : '年度を選択',
              style: TextStyle(
                fontSize: 16,
                color: value.isNotEmpty ? Colors.black : Colors.grey,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}

class PostModel extends ChangeNotifier {
  String category = 'rigaku';
  String bumon = 'ラク単';
  String nenndo = '';
  String gakki = '春１';
  String tanni = '1';
  String zyugyoukeisiki = 'オンライン(VOD)';
  String syusseki = '毎日出席を取る';
  String kyoukasyo = 'あり';
  double hyouka = 3;
  double omosirosa = 3;
  double toriyasusa = 3;

  final zyugyoumeiController = TextEditingController();
  final kousimeiController = TextEditingController();
  final komentoController = TextEditingController();
  final tesutokeisikiController = TextEditingController();
  final tesutokeikouController = TextEditingController();
  final nameController = TextEditingController();
  final sendenController = TextEditingController();

  void setBumon(String value) {
    bumon = value;
    notifyListeners();
  }

  void setCategory(String value) {
    category = value;
    notifyListeners();
  }

  void setGakki(String value) {
    gakki = value;
    notifyListeners();
  }

  void setHyouka(double value) {
    hyouka = value;
    notifyListeners();
  }

  void setKyoukasyo(String value) {
    kyoukasyo = value;
    notifyListeners();
  }

  void setNendo(String value) {
    nenndo = value;
    notifyListeners();
  }

  void setOmosirosa(double value) {
    omosirosa = value;
    notifyListeners();
  }

  void setSyusseki(String value) {
    syusseki = value;
    notifyListeners();
  }

  void setTanni(String value) {
    tanni = value;
    notifyListeners();
  }

  void setToriyasusa(double value) {
    toriyasusa = value;
    notifyListeners();
  }

  void setZyugyoukeisiki(String value) {
    zyugyoukeisiki = value;
    notifyListeners();
  }

  Future<void> submit() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    final postId = const Uuid().v4();

    await FirebaseFirestore.instance.collection(category).doc(postId).set({
      'userId': uid,
      'bumon': bumon,
      'gakki': gakki,
      'tannisuu': tanni,
      'zyugyoukeisiki': zyugyoukeisiki,
      'syusseki': syusseki,
      'kyoukasyo': kyoukasyo,
      'sougouhyouka': hyouka,
      'omosirosa': omosirosa,
      'toriyasusa': toriyasusa,
      'nenndo': nenndo,
      'zyugyoumei': zyugyoumeiController.text,
      'kousimei': kousimeiController.text,
      'komento': komentoController.text,
      'tesutokeisiki': tesutokeisikiController.text,
      'tesutokeikou': tesutokeikouController.text,
      'name': nameController.text,
      'senden': sendenController.text,
      'date': DateTime.now(),
    });
  }
}

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
              sliderButtonIcon: const Icon(Icons.send),
              text: 'スワイプして送信',
              textStyle: const TextStyle(fontSize: 18),
              onSubmit: () => postModel.submit(),
            ),
          ],
        ),
      ),
    );
  }
}
