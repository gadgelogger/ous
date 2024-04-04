import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ous/domain/review_user_posts_provider.dart';
import 'package:ous/gen/review_data.dart';
import 'package:ous/presentation/widgets/review/Post/custom_dropdown.dart';
import 'package:ous/presentation/widgets/review/Post/custom_slider.dart';
import 'package:ous/presentation/widgets/review/Post/custom_text_field.dart';
import 'package:ous/presentation/widgets/review/Post/custom_year_picker.dart';

class EditScreen extends ConsumerStatefulWidget {
  final Review review;
  const EditScreen({super.key, required this.review});

  @override
  ConsumerState<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends ConsumerState<EditScreen> {
  late TextEditingController _zyugyoumeiController;
  late TextEditingController _kousimeiController;
  late String _nenndo;
  late String _gakki;
  late String _tannisuu;
  late String _zyugyoukeisiki;
  late String _syusseki;
  late String _kyoukasyo;
  late TextEditingController _tesutokeisikiController;
  late TextEditingController _komentoController;
  late TextEditingController _tesutokeikouController;
  late TextEditingController _nameController;
  late TextEditingController _sendenController;

  double _omosirosa = 0;
  double _toriyasusa = 0;
  double _sougouhyouka = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('投稿編集'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextField(
              labelText: '講義名',
              controller: _zyugyoumeiController,
            ),
            CustomTextField(
              labelText: '講師名',
              controller: _kousimeiController,
            ),
            CustomYearPicker(
              labelText: '開講年度を選択してください',
              value: _nenndo,
              onChanged: (value) => setState(() => _nenndo = value),
            ),
            CustomDropdown(
              labelText: '開講学期を選択してください',
              value: _gakki,
              items: const [
                MapEntry('春１', '春１'),
                MapEntry('春２', '春２'),
                MapEntry('秋１', '秋１'),
                MapEntry('秋２', '秋２'),
                MapEntry('春１と２', '春１と２'),
                MapEntry('秋１と２', '秋１と２'),
              ],
              onChanged: (value) => setState(() => _gakki = value!),
            ),
            CustomDropdown(
              labelText: '単位数を選択してください',
              value: _tannisuu,
              items: const [
                MapEntry('1', '1'),
                MapEntry('2', '2'),
                MapEntry('3', '3'),
              ],
              onChanged: (value) => setState(() => _tannisuu = value!),
            ),
            CustomDropdown(
              labelText: '授業形式を選択してください',
              value: _zyugyoukeisiki,
              items: const [
                MapEntry('オンライン(VOD)', 'オンライン(VOD)'),
                MapEntry('オンライン(リアルタイム）', 'オンライン(リアルタイム）'),
                MapEntry('対面', '対面'),
                MapEntry('対面とオンライン', '対面とオンライン'),
              ],
              onChanged: (value) => setState(() => _zyugyoukeisiki = value!),
            ),
            CustomDropdown(
              labelText: '出席確認の有無を選択してください',
              value: _syusseki,
              items: const [
                MapEntry('毎日出席を取る', '毎日出席を取る'),
                MapEntry('ほぼ出席を取る', 'ほぼ出席を取る'),
                MapEntry('たまに出席を取る', 'たまに出席を取る'),
                MapEntry('出席確認はなし', '出席確認はなし'),
              ],
              onChanged: (value) => setState(() => _syusseki = value!),
            ),
            CustomDropdown(
              labelText: '教科書の有無を選択してください',
              value: _kyoukasyo,
              items: const [
                MapEntry('あり', 'あり'),
                MapEntry('なし', 'なし'),
              ],
              onChanged: (value) => setState(() => _kyoukasyo = value!),
            ),
            const SizedBox(height: 16),
            CustomSlider(
              labelText: '講義の面白さ',
              value: _omosirosa,
              onChanged: (value) => setState(() => _omosirosa = value),
            ),
            CustomSlider(
              labelText: '単位の取りやすさ',
              value: _toriyasusa,
              onChanged: (value) => setState(() => _toriyasusa = value),
            ),
            CustomSlider(
              labelText: '総合評価',
              value: _sougouhyouka,
              onChanged: (value) => setState(() => _sougouhyouka = value),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              labelText: '講義に関するコメント',
              controller: _komentoController,
              maxLines: 5,
            ),
            CustomTextField(
              labelText: 'テスト形式',
              controller: _tesutokeisikiController,
            ),
            CustomTextField(
              labelText: 'テスト傾向',
              controller: _tesutokeikouController,
              maxLines: 5,
            ),
            CustomTextField(
              labelText: 'ニックネーム',
              controller: _nameController,
            ),
            CustomTextField(
              labelText: '宣伝',
              controller: _sendenController,
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final updatedReview = Review(
                  ID: widget.review.ID,
                  accountemail: widget.review.accountemail,
                  accountname: widget.review.accountname,
                  accountuid: widget.review.accountuid,
                  bumon: widget.review.bumon,
                  date: widget.review.date,
                  gakki: _gakki,
                  komento: _komentoController.text,
                  kousimei: _kousimeiController.text,
                  kyoukasyo: _kyoukasyo,
                  name: _nameController.text,
                  nenndo: _nenndo,
                  omosirosa: _omosirosa,
                  senden: _sendenController.text,
                  sougouhyouka: _sougouhyouka,
                  syusseki: _syusseki,
                  tannisuu: int.tryParse(_tannisuu),
                  tesutokeikou: _tesutokeikouController.text,
                  tesutokeisiki: _tesutokeisikiController.text,
                  toriyasusa: _toriyasusa,
                  zyugyoukeisiki: _zyugyoukeisiki,
                  zyugyoumei: _zyugyoumeiController.text,
                );

                await FetchUserReviews().updateReview(updatedReview);

                ref.refresh(fetchUserReviews);

                if (mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('保存'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        backgroundColor: Colors.red,
        child: const Icon(Icons.delete),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final review = widget.review;
    _zyugyoumeiController = TextEditingController(text: review.zyugyoumei);
    _kousimeiController = TextEditingController(text: review.kousimei);
    _nenndo = review.nenndo ?? '';
    _gakki = review.gakki ?? '春１';
    _tannisuu = review.tannisuu?.toString() ?? '1';
    _zyugyoukeisiki = review.zyugyoukeisiki ?? 'オンライン(VOD)';
    _syusseki = review.syusseki ?? '毎日出席を取る';
    _kyoukasyo = review.kyoukasyo ?? 'あり';
    _tesutokeisikiController =
        TextEditingController(text: review.tesutokeisiki);
    _komentoController = TextEditingController(text: review.komento);
    _tesutokeikouController = TextEditingController(text: review.tesutokeikou);
    _nameController = TextEditingController(text: review.name);
    _sendenController = TextEditingController(text: review.senden);

    _omosirosa = review.omosirosa?.toDouble() ?? 0;
    _toriyasusa = review.toriyasusa?.toDouble() ?? 0;
    _sougouhyouka = review.sougouhyouka?.toDouble() ?? 0;
  }
}
