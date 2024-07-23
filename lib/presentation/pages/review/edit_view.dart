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
  late TextEditingController _tesutokeisikiController;
  late TextEditingController _komentoController;
  late TextEditingController _tesutokeikouController;
  late TextEditingController _nameController;
  late TextEditingController _sendenController;

  late String _nenndo;
  late String _gakki;
  late String _tannisuu;
  late String _zyugyoukeisiki;
  late String _syusseki;
  late String _kyoukasyo;

  double _omosirosa = 0;
  double _toriyasusa = 0;
  double _sougouhyouka = 0;

  @override
  void initState() {
    super.initState();
    final review = widget.review;
    _zyugyoumeiController = TextEditingController(text: review.zyugyoumei);
    _kousimeiController = TextEditingController(text: review.kousimei);
    _tesutokeisikiController =
        TextEditingController(text: review.tesutokeisiki);
    _komentoController = TextEditingController(text: review.komento);
    _tesutokeikouController = TextEditingController(text: review.tesutokeikou);
    _nameController = TextEditingController(text: review.name);
    _sendenController = TextEditingController(text: review.senden);

    _nenndo = review.nenndo ?? '';
    _gakki = review.gakki ?? '春１';
    _tannisuu = review.tannisuu?.toString() ?? '1';
    _zyugyoukeisiki = review.zyugyoukeisiki ?? 'オンライン(VOD)';
    _syusseki = review.syusseki ?? '毎日出席を取る';
    _kyoukasyo = review.kyoukasyo ?? 'あり';

    _omosirosa = review.omosirosa?.toDouble() ?? 0;
    _toriyasusa = review.toriyasusa?.toDouble() ?? 0;
    _sougouhyouka = review.sougouhyouka?.toDouble() ?? 0;
  }

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
            _buildTextField('講義名', _zyugyoumeiController),
            _buildTextField('講師名', _kousimeiController),
            _buildYearPicker(),
            _buildDropdown('開講学期を選択してください', _gakki, _gakkiItems),
            _buildDropdown('単位数を選択してください', _tannisuu, _tannisuuItems),
            _buildDropdown(
              '授業形式を選択してください',
              _zyugyoukeisiki,
              _zyugyoukeisikiItems,
            ),
            _buildDropdown('出席確認の有無を選択してください', _syusseki, _syussekiItems),
            _buildDropdown('教科書の有無を選択してください', _kyoukasyo, _kyoukasyoItems),
            const SizedBox(height: 16),
            _buildSlider(
              '講義の面白さ',
              _omosirosa,
              (value) => setState(() => _omosirosa = value),
            ),
            _buildSlider(
              '単位の取りやすさ',
              _toriyasusa,
              (value) => setState(() => _toriyasusa = value),
            ),
            _buildSlider(
              '総合評価',
              _sougouhyouka,
              (value) => setState(() => _sougouhyouka = value),
            ),
            const SizedBox(height: 16),
            _buildTextField('講義に関するコメント', _komentoController, maxLines: 5),
            _buildTextField('テスト形式', _tesutokeisikiController),
            _buildTextField('テスト傾向', _tesutokeikouController, maxLines: 5),
            _buildTextField('ニックネーム', _nameController),
            _buildTextField('宣伝', _sendenController, maxLines: 5),
            const SizedBox(height: 16),
            _buildSaveButton(),
            const SizedBox(height: 16),
          ],
        ),
      ),
      floatingActionButton: _buildDeleteButton(context),
    );
  }

  Widget _buildTextField(
    String labelText,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return CustomTextField(
      labelText: labelText,
      controller: controller,
      maxLines: maxLines,
    );
  }

  Widget _buildYearPicker() {
    return CustomYearPicker(
      labelText: '開講年度を選択してください',
      value: _nenndo,
      onChanged: (value) => setState(() => _nenndo = value),
    );
  }

  Widget _buildDropdown(
    String labelText,
    String value,
    List<MapEntry<String, String>> items,
  ) {
    return CustomDropdown(
      labelText: labelText,
      value: value,
      items: items,
      onChanged: (value) => setState(() => value = value!),
    );
  }

  Widget _buildSlider(
    String labelText,
    double value,
    ValueChanged<double> onChanged,
  ) {
    return CustomSlider(
      labelText: labelText,
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
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

        ref.watch(fetchUserReviews);

        if (mounted) {
          if (!context.mounted) return;

          Navigator.pop(context);
        }
      },
      child: const Text('保存'),
    );
  }

  FloatingActionButton _buildDeleteButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('削除しますか？'),
          content: const Text('この操作は取り消せません'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () async {
                await FetchUserReviews().deleteReview(widget.review);
                if (!context.mounted) return;

                ref.watch(fetchUserReviews);

                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('削除'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.red,
      child: const Icon(Icons.delete),
    );
  }

  static const _gakkiItems = [
    MapEntry('春１', '春１'),
    MapEntry('春２', '春２'),
    MapEntry('秋１', '秋１'),
    MapEntry('秋２', '秋２'),
    MapEntry('春１と２', '春１と２'),
    MapEntry('秋１と２', '秋１と２'),
  ];

  static const _tannisuuItems = [
    MapEntry('1', '1'),
    MapEntry('2', '2'),
    MapEntry('3', '3'),
  ];

  static const _zyugyoukeisikiItems = [
    MapEntry('オンライン(VOD)', 'オンライン(VOD)'),
    MapEntry('オンライン(リアルタイム）', 'オンライン(リアルタイム）'),
    MapEntry('対面', '対面'),
    MapEntry('対面とオンライン', '対面とオンライン'),
  ];

  static const _syussekiItems = [
    MapEntry('毎日出席を取る', '毎日出席を取る'),
    MapEntry('ほぼ出席を取る', 'ほぼ出席を取る'),
    MapEntry('たまに出席を取る', 'たまに出席を取る'),
    MapEntry('出席確認はなし', '出席確認はなし'),
  ];

  static const _kyoukasyoItems = [
    MapEntry('あり', 'あり'),
    MapEntry('なし', 'なし'),
  ];
}
