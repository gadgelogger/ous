// Flutter imports:
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Link extends StatelessWidget {
  const Link({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('リンク集'),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: const Text(
                'マイログ',
              ),
              subtitle: const Text('学生がよくみるもの'),
              trailing: const Icon(Icons.link),
              onTap: () => launchUrlString(
                'https://mylog.pub.ous.ac.jp/uprx/up/pk/pky501/Pky50101.xhtml',
              ),
            ),
            ListTile(
              title: const Text(
                '気象警報と休校について',
              ),
              subtitle: const Text('学生がよくみるもの'),
              trailing: const Icon(Icons.link),
              onTap: () =>
                  launchUrlString('https://www.ous.ac.jp/students/weather/'),
            ),
            ListTile(
              title: const Text(
                '講義時間について',
              ),
              subtitle: const Text('学生がよくみるもの'),
              trailing: const Icon(Icons.link),
              onTap: () =>
                  launchUrlString('https://www.ous.ac.jp/campuslife/class/'),
            ),
            ListTile(
              title: const Text(
                'シラバス',
              ),
              subtitle: const Text('学生がよくみるもの'),
              trailing: const Icon(Icons.link),
              onTap: () => launchUrlString(
                'https://mylog.pub.ous.ac.jp/uprx/up/pk/pky001/Pky00101.xhtml?guestlogin=Kmh006',
              ),
            ),
            ListTile(
              title: const Text(
                '学生便覧',
              ),
              subtitle: const Text('学生がよくみるもの'),
              trailing: const Icon(Icons.link),
              onTap: () => launchUrlString(
                'https://www.ous.ac.jp/outline/disclosure/handbook/',
              ),
            ),
            ListTile(
              title: const Text(
                '事務窓口',
              ),
              subtitle: const Text('学生がよくみるもの'),
              trailing: const Icon(Icons.link),
              onTap: () =>
                  launchUrlString('https://www.ous.ac.jp/campuslife/services/'),
            ),
            ListTile(
              title: const Text(
                '各種相談窓口',
              ),
              subtitle: const Text('学生がよくみるもの'),
              trailing: const Icon(Icons.link),
              onTap: () =>
                  launchUrlString('http://www.ous.ac.jp/students/counseling/'),
            ),
            ListTile(
              title: const Text(
                '各種証明書・申請書の発行',
              ),
              subtitle: const Text('学生がよくみるもの'),
              trailing: const Icon(Icons.link),
              onTap: () => launchUrlString(
                'https://www.ous.ac.jp/students/certificate/',
              ),
            ),
            ListTile(
              title: const Text(
                '履修モデル',
              ),
              subtitle: const Text('講義・シラバス'),
              trailing: const Icon(Icons.link),
              onTap: () => launchUrlString(
                'https://www.ous.ac.jp/outline/disclosure/model/',
              ),
            ),
            ListTile(
              title: const Text(
                '教育の目標と方針',
              ),
              subtitle: const Text('講義・シラバス'),
              trailing: const Icon(Icons.link),
              onTap: () => launchUrlString(
                'https://www.ous.ac.jp/outline/disclosure/kyouiku/',
              ),
            ),
            ListTile(
              title: const Text(
                'オフィスアワー',
              ),
              subtitle: const Text('講義・シラバス'),
              trailing: const Icon(Icons.link),
              onTap: () => launchUrlString(
                'https://www.ous.ac.jp/campuslife/officehour/',
              ),
            ),
            ListTile(
              title: const Text(
                '既取得単位の認定制度（入学年次のみ）',
              ),
              subtitle: const Text('講義・シラバス'),
              trailing: const Icon(Icons.link),
              onTap: () => launchUrlString(
                'https://www.ous.ac.jp/admissions/credittransfer/',
              ),
            ),
            ListTile(
              title: const Text(
                '大学コンソーシアム岡山（単位互換）',
              ),
              subtitle: const Text('講義・シラバス'),
              trailing: const Icon(Icons.link),
              onTap: () => launchUrlString('http://www.consortium-okayama.jp/'),
            ),
            ListTile(
              title: const Text(
                '放送大学（単位互換）',
              ),
              subtitle: const Text('講義・シラバス'),
              trailing: const Icon(Icons.link),
              onTap: () => launchUrlString('https://www.ouj.ac.jp/'),
            ),
            ListTile(
              title: const Text(
                'クラスチューター一覧',
              ),
              subtitle: const Text('各種相談窓口・各種証明書・申請書発行'),
              trailing: const Icon(Icons.link),
              onTap: () => launchUrlString(
                'https://www.ous.ac.jp/common/files//128/202105251644200483109.pdf',
              ),
            ),
            ListTile(
              title: const Text(
                '給付金（入学金・学費等）',
              ),
              subtitle: const Text('授業料・各種制度'),
              trailing: const Icon(Icons.link),
              onTap: () =>
                  launchUrlString('http://www.ous.ac.jp/students/fee01/'),
            ),
            ListTile(
              title: const Text(
                '大規模自然災害で被災したとき',
              ),
              subtitle: const Text('授業料・各種制度'),
              trailing: const Icon(Icons.link),
              onTap: () => launchUrlString(
                'https://www.ous.ac.jp/common/files/128/kitei2018.pdf',
              ),
            ),
            ListTile(
              title: const Text(
                '奨学金制度',
              ),
              subtitle: const Text('授業料・各種制度'),
              trailing: const Icon(Icons.link),
              onTap: () => launchUrlString(
                'https://www.ous.ac.jp/students/schorlarship/',
              ),
            ),
            ListTile(
              title: const Text(
                '保険制度',
              ),
              subtitle: const Text('授業料・各種制度'),
              trailing: const Icon(Icons.link),
              onTap: () =>
                  launchUrlString('https://www.ous.ac.jp/students/insurance/'),
            ),
            ListTile(
              title: const Text(
                'キャリア支援センター',
              ),
              subtitle: const Text('サポート・学生支援・施設'),
              trailing: const Icon(Icons.link),
              onTap: () => launchUrlString('http://career.office.ous.ac.jp/'),
            ),
            ListTile(
              title: const Text(
                '教学資格課（資格取得）',
              ),
              subtitle: const Text('サポート・学生支援・施設'),
              trailing: const Icon(Icons.link),
              onTap: () =>
                  launchUrlString('http://career.office.ous.ac.jp/kyousyoku/'),
            ),
            ListTile(
              title: const Text(
                '情報基盤センター',
              ),
              subtitle: const Text('サポート・学生支援・施設'),
              trailing: const Icon(Icons.link),
              onTap: () => launchUrlString('http://www.center.ous.ac.jp/'),
            ),
            ListTile(
              title: const Text(
                '化学ボランティアセンター',
              ),
              subtitle: const Text('サポート・学生支援・施設'),
              trailing: const Icon(Icons.link),
              onTap: () => launchUrlString('http://ridai-svc.org/'),
            ),
            ListTile(
              title: const Text(
                '厚生施設営業日程',
              ),
              subtitle: const Text('サポート・学生支援・施設'),
              trailing: const Icon(Icons.link),
              onTap: () => launchUrlString(
                'https://www.ous.ac.jp/common/files//128/202202031316400965765.pdf',
              ),
            ),
            ListTile(
              title: const Text(
                '図書館',
              ),
              subtitle: const Text('サポート・学生支援・施設'),
              trailing: const Icon(Icons.link),
              onTap: () => launchUrlString('http://www.lib.ous.ac.jp/'),
            ),
            ListTile(
              title: const Text(
                '健康管理センター',
              ),
              subtitle: const Text('サポート・学生支援・施設'),
              trailing: const Icon(Icons.link),
              onTap: () => launchUrlString('http://www1.ous.ac.jp/kenkan/'),
            ),
            ListTile(
              title: const Text(
                '障がい学生支援規定',
              ),
              subtitle: const Text('サポート・学生支援・施設'),
              trailing: const Icon(Icons.link),
              onTap: () => launchUrlString(
                'https://www.ous.ac.jp/common/files//128/20191213shougai_kitei.pdf',
              ),
            ),
            ListTile(
              title: const Text(
                '障がい学生支援に関するガイドライン',
              ),
              subtitle: const Text('学生がよくみるもの'),
              trailing: const Icon(Icons.link),
              onTap: () => launchUrlString(
                'https://www.ous.ac.jp/common/files//128/202002200918550267479.pdf',
              ),
            ),
            ListTile(
              title: const Text(
                '教職特別課程',
              ),
              subtitle: const Text('学生がよくみるもの'),
              trailing: const Icon(Icons.link),
              onTap: () =>
                  launchUrlString('http://www.ous.ac.jp/students/kyousyoku/'),
            ),
            ListTile(
              title: const Text(
                '寄付金について',
              ),
              subtitle: const Text('学生がよくみるもの'),
              trailing: const Icon(Icons.link),
              onTap: () => launchUrlString('http://www.donation.fm/ous/'),
            ),
            ListTile(
              title: const Text(
                '教員データベース',
              ),
              subtitle: const Text('学生がよくみるもの'),
              trailing: const Icon(Icons.link),
              onTap: () => launchUrlString(
                'https://mylog.pub.ous.ac.jp/gyoseki/japanese/index.html',
              ),
            ),
            ListTile(
              title: const Text(
                '研究者ナビゲーター',
              ),
              subtitle: const Text('学生がよくみるもの'),
              trailing: const Icon(Icons.link),
              onTap: () =>
                  launchUrlString('http://renkei.office.ous.ac.jp/ousresnavi/'),
            ),
            const Divider(
              height: 1.0,
              indent: 1.0,
            ),
          ],
        ),
      );
}
