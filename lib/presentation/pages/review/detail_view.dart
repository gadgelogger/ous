import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 追加
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ous/gen/review_data.dart';
import 'package:ous/infrastructure/admobHelper.dart';
import 'package:ous/presentation/pages/setting/iap_screen.dart';
import 'package:ous/presentation/widgets/review/detail/date_section.dart';
import 'package:ous/presentation/widgets/review/detail/gauge_section.dart';
import 'package:ous/presentation/widgets/review/detail/modal_widget.dart';
import 'package:ous/presentation/widgets/review/detail/outdated_post_info.dart';
import 'package:ous/presentation/widgets/review/detail/report_button.dart';
import 'package:ous/presentation/widgets/review/detail/text_section.dart';

class DetailScreen extends ConsumerStatefulWidget {
  // 修正: ConsumerStatefulWidgetに変更
  final Review review;
  const DetailScreen({super.key, required this.review});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  // 修正: ConsumerStateに変更
  late BannerAd _bannerAd;
  bool _isAdFree = false;

  @override
  void initState() {
    super.initState();
    _isAdFree = ref.read(inAppPurchaseManager).isAdFree; // 修正: ref.readを使用
    if (!_isAdFree) {
      _bannerAd = AdmobHelper.getReviewBottomBannerAd()..load();
    }
  }

  @override
  void dispose() {
    if (!_isAdFree) {
      _bannerAd.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final review = widget.review;
    return Scaffold(
      appBar: AppBar(
        title: Text(review.zyugyoumei ?? '不明'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutdatedPostInfo(review: review),
                    TextSection(title: '講義名', content: review.zyugyoumei),
                    TextSection(title: '講師名', content: review.kousimei),
                    TextSection(title: '年度', content: review.nenndo),
                    TextSection(
                      title: '単位数',
                      content: review.tannisuu?.toString(),
                    ),
                    TextSection(title: '授業形式', content: review.zyugyoukeisiki),
                    TextSection(title: '出席確認の有無', content: review.syusseki),
                    TextSection(title: '教科書の有無', content: review.kyoukasyo),
                    TextSection(title: 'テスト形式', content: review.tesutokeisiki),
                    const Divider(),
                    GaugeSection(
                      title: '講義の面白さ',
                      value: review.omosirosa?.toDouble() ?? 0,
                    ),
                    GaugeSection(
                      title: '単位の取りやすさ',
                      value: review.toriyasusa?.toDouble() ?? 0,
                    ),
                    GaugeSection(
                      title: '総合評価',
                      value: review.sougouhyouka?.toDouble() ?? 0,
                    ),
                    const Divider(),
                    TextSection(title: '講義に関するコメント', content: review.komento),
                    TextSection(title: 'テスト傾向', content: review.tesutokeikou),
                    TextSection(title: 'ニックネーム', content: review.name),
                    DateSection(title: '投稿日・更新日', date: review.date),
                    TextSection(title: '宣伝', content: review.senden),
                    const SizedBox(height: 20.0),
                    const ReportButton(),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ),
          if (!_isAdFree)
            SafeArea(
              child: SizedBox(
                height: 50,
                child: AdWidget(ad: _bannerAd),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return ModalWidget(review: review);
            },
          );
        },
        child: const Icon(Icons.share),
      ),
    );
  }
}
