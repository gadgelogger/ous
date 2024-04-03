// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:intl/intl.dart';
// Project imports:
import 'package:ous/gen/review_data.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:url_launcher/url_launcher_string.dart';
// ... import statements ...

class DetailScreen extends StatefulWidget {
  final Review review;
  const DetailScreen({super.key, required this.review});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    final review = widget.review;
    return Scaffold(
      appBar: AppBar(
        title: Text(review.zyugyoumei ?? '不明'),
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _outdatedPostInfo(),
              _buildTextSection(context, '講義名', review.zyugyoumei),
              _buildTextSection(context, '講師名', review.kousimei),
              _buildTextSection(context, '年度', review.nenndo),
              _buildTextSection(context, '単位数', review.tannisuu?.toString()),
              _buildTextSection(context, '授業形式', review.zyugyoukeisiki),
              _buildTextSection(context, '出席確認の有無', review.syusseki),
              _buildTextSection(context, '教科書の有無', review.kyoukasyo),
              _buildTextSection(context, 'テスト形式', review.tesutokeisiki),
              const Divider(),
              _buildGaugeSection(
                context,
                '講義の面白さ',
                review.omosirosa?.toDouble() ?? 0,
              ),
              _buildGaugeSection(
                context,
                '単位の取りやすさ',
                review.toriyasusa?.toDouble() ?? 0,
              ),
              _buildGaugeSection(
                context,
                '総合評価',
                review.sougouhyouka?.toDouble() ?? 0,
              ),
              const Divider(),
              _buildTextSection(context, '講義に関するコメント', review.komento),
              _buildTextSection(context, 'テスト傾向', review.tesutokeikou),
              _buildTextSection(context, 'ニックネーム', review.name),
              _buildDateSection(context, '投稿日・更新日', review.date),
              _buildTextSection(context, '宣伝', review.senden),
              const SizedBox(height: 20.0),
              _buildReportButton(context),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSection(BuildContext context, String title, DateTime? date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Text(
            date != null ? DateFormat('yyyy年MM月dd日 HH:mm').format(date) : '不明',
            style: const TextStyle(fontSize: 15),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildGaugeSection(BuildContext context, String title, double value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: 200,
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0,
                maximum: 5,
                showLabels: false,
                showTicks: false,
                axisLineStyle: const AxisLineStyle(
                  thickness: 0.2,
                  cornerStyle: CornerStyle.bothCurve,
                  color: Color.fromARGB(139, 134, 134, 134),
                  thicknessUnit: GaugeSizeUnit.factor,
                ),
                pointers: <GaugePointer>[
                  RangePointer(
                    value: value,
                    cornerStyle: CornerStyle.bothCurve,
                    color: Theme.of(context).colorScheme.primary,
                    width: 0.2,
                    sizeUnit: GaugeSizeUnit.factor,
                  ),
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    positionFactor: 0.1,
                    angle: 90,
                    widget: Text(
                      '${value.toStringAsFixed(0)} / 5',
                      style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReportButton(BuildContext context) {
    return SizedBox(
      height: 40.0,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            style: BorderStyle.solid,
            width: 1.0,
          ),
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: GestureDetector(
          onTap: () async {
            launchUrlString(
              'https://docs.google.com/forms/d/e/1FAIpQLSepC82BWAoARJVh4WeGCFOuIpWLyaPfqqXn524SqxyBSA9LwQ/viewform',
            );
          },
          child: const Center(
            child: Text(
              'この投稿を開発者に報告する',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextSection(
    BuildContext context,
    String title,
    String? content,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: SelectableText(
            content ?? '不明',
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  Widget _outdatedPostInfo() {
    final review = widget.review;
    final postDate = review.date;
    final currentDate = DateTime.now();
    final difference = currentDate.difference(postDate!);
    final years = difference.inDays ~/ 365;

    if (years >= 1) {
      return Container(
        height: 70,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Icon(Icons.info_outline),
              Text(
                'この投稿は投稿日から$years年以上経過しています。\n情報が古い可能性があります。',
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
