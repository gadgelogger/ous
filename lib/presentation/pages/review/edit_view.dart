import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ous/domain/review_user_posts_provider.dart';
import 'package:ous/gen/review_data.dart';

class EditScreen extends ConsumerStatefulWidget {
  final Review review;
  const EditScreen({super.key, required this.review});

  @override
  ConsumerState<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends ConsumerState<EditScreen> {
  late TextEditingController _zyugyoumeiController;
  late TextEditingController _kousimeiController;
  late TextEditingController _nenndoController;
  late TextEditingController _tannisuuController;
  late TextEditingController _zyugyoukeisikiController;
  late TextEditingController _syussekiController;
  late TextEditingController _kyoukasyoController;
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
            TextFormField(
              controller: _zyugyoumeiController,
              decoration: const InputDecoration(labelText: '講義名'),
            ),
            TextFormField(
              controller: _kousimeiController,
              decoration: const InputDecoration(labelText: '講師名'),
            ),
            TextFormField(
              controller: _nenndoController,
              decoration: const InputDecoration(labelText: '年度'),
            ),
            TextFormField(
              controller: _tannisuuController,
              decoration: const InputDecoration(labelText: '単位数'),
            ),
            TextFormField(
              controller: _zyugyoukeisikiController,
              decoration: const InputDecoration(labelText: '授業形式'),
            ),
            TextFormField(
              controller: _syussekiController,
              decoration: const InputDecoration(labelText: '出席確認の有無'),
            ),
            TextFormField(
              controller: _kyoukasyoController,
              decoration: const InputDecoration(labelText: '教科書の有無'),
            ),
            TextFormField(
              controller: _tesutokeisikiController,
              decoration: const InputDecoration(labelText: 'テスト形式'),
            ),
            const SizedBox(height: 16),
            Text('講義の面白さ: ${_omosirosa.toStringAsFixed(0)}'),
            Slider(
              value: _omosirosa,
              min: 1,
              max: 5,
              divisions: 5,
              onChanged: (value) {
                setState(() {
                  _omosirosa = value;
                });
              },
            ),
            Text('単位の取りやすさ: ${_toriyasusa.toStringAsFixed(0)}'),
            Slider(
              value: _toriyasusa,
              min: 1,
              max: 5,
              divisions: 5,
              onChanged: (value) {
                setState(() {
                  _toriyasusa = value;
                });
              },
            ),
            Text('総合評価: ${_sougouhyouka.toStringAsFixed(0)}'),
            Slider(
              value: _sougouhyouka,
              min: 1,
              max: 5,
              divisions: 5,
              onChanged: (value) {
                setState(() {
                  _sougouhyouka = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _komentoController,
              decoration: const InputDecoration(labelText: '講義に関するコメント'),
              maxLines: 5,
            ),
            TextFormField(
              controller: _tesutokeikouController,
              decoration: const InputDecoration(labelText: 'テスト傾向'),
              maxLines: 5,
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'ニックネーム'),
            ),
            TextFormField(
              controller: _sendenController,
              decoration: const InputDecoration(labelText: '宣伝'),
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
                  gakki: widget.review.gakki,
                  komento: _komentoController.text,
                  kousimei: _kousimeiController.text,
                  kyoukasyo: _kyoukasyoController.text,
                  name: _nameController.text,
                  nenndo: _nenndoController.text,
                  omosirosa: _omosirosa,
                  senden: _sendenController.text,
                  sougouhyouka: _sougouhyouka,
                  syusseki: _syussekiController.text,
                  tannisuu: int.tryParse(
                    _tannisuuController.text,
                  ),
                  tesutokeikou: _tesutokeikouController.text,
                  tesutokeisiki: _tesutokeisikiController.text,
                  toriyasusa: _toriyasusa,
                  zyugyoukeisiki: _zyugyoukeisikiController.text,
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
    );
  }

  @override
  void initState() {
    super.initState();
    final review = widget.review;
    _zyugyoumeiController = TextEditingController(text: review.zyugyoumei);
    _kousimeiController = TextEditingController(text: review.kousimei);
    _nenndoController = TextEditingController(text: review.nenndo);
    _tannisuuController =
        TextEditingController(text: review.tannisuu?.toString());
    _zyugyoukeisikiController =
        TextEditingController(text: review.zyugyoukeisiki);
    _syussekiController = TextEditingController(text: review.syusseki);
    _kyoukasyoController = TextEditingController(text: review.kyoukasyo);
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
