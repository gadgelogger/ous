import 'package:flutter/material.dart';
import 'package:ous/home.dart';
import 'package:url_launcher/url_launcher.dart';


class Link extends StatelessWidget {
  const Link({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: Icon(Icons.home),
        onPressed: (){
          Navigator.pop(
            context,
            MaterialPageRoute(builder: (context) => home()),
          );
        },
      ),
      title: Text('リンク集'),

    ),
    body: ListView(
      children: <Widget>[
        ListTile(
          title: Text('マイログ',),
          subtitle: Text('学生がよくみるもの'),
          trailing: Icon(Icons.link),
            onTap: () => launch('https://mylog.pub.ous.ac.jp/uprx/up/pk/pky501/Pky50101.xhtml')
        ),
        ListTile(
            title: Text('気象警報と休校について',),
            subtitle: Text('学生がよくみるもの'),
            trailing: Icon(Icons.link),
            onTap: () => launch('https://www.ous.ac.jp/students/weather/')
        ),
        ListTile(
            title: Text('講義時間について',),
            subtitle: Text('学生がよくみるもの'),
            trailing: Icon(Icons.link),
            onTap: () => launch('https://www.ous.ac.jp/campuslife/class/')
        ),
        ListTile(
            title: Text('シラバス',),
            subtitle: Text('学生がよくみるもの'),
            trailing: Icon(Icons.link),
            onTap: () => launch('https://mylog.pub.ous.ac.jp/uprx/up/pk/pky001/Pky00101.xhtml?guestlogin=Kmh006')
        ),
        ListTile(
            title: Text('学生便覧',),
            subtitle: Text('学生がよくみるもの'),
            trailing: Icon(Icons.link),
            onTap: () => launch('https://www.ous.ac.jp/outline/disclosure/handbook/')
        ),
        ListTile(
            title: Text('事務窓口',),
            subtitle: Text('学生がよくみるもの'),
            trailing: Icon(Icons.link),
            onTap: () => launch('https://www.ous.ac.jp/campuslife/services/')
        ),
        ListTile(
            title: Text('各種相談窓口',),
            subtitle: Text('学生がよくみるもの'),
            trailing: Icon(Icons.link),
            onTap: () => launch('http://www.ous.ac.jp/students/counseling/')
        ),
        ListTile(
            title: Text('各種証明書・申請書の発行',),
            subtitle: Text('学生がよくみるもの'),
            trailing: Icon(Icons.link),
            onTap: () => launch('https://www.ous.ac.jp/students/certificate/')
        ),
        ListTile(
            title: Text('履修モデル',),
            subtitle: Text('講義・シラバス'),
            trailing: Icon(Icons.link),
            onTap: () => launch('https://www.ous.ac.jp/outline/disclosure/model/')
        ),
        ListTile(
            title: Text('教育の目標と方針',),
            subtitle: Text('講義・シラバス'),
            trailing: Icon(Icons.link),
            onTap: () => launch('https://www.ous.ac.jp/outline/disclosure/kyouiku/')
        ),
        ListTile(
            title: Text('オフィスアワー',),
            subtitle: Text('講義・シラバス'),
            trailing: Icon(Icons.link),
            onTap: () => launch('https://www.ous.ac.jp/campuslife/officehour/')
        ),
        ListTile(
            title: Text('既取得単位の認定制度（入学年次のみ）',),
            subtitle: Text('講義・シラバス'),
            trailing: Icon(Icons.link),
            onTap: () => launch('https://www.ous.ac.jp/admissions/credittransfer/')
        ),
        ListTile(
            title: Text('大学コンソーシアム岡山（単位互換）',),
            subtitle: Text('講義・シラバス'),
            trailing: Icon(Icons.link),
            onTap: () => launch('http://www.consortium-okayama.jp/')
        ),
        ListTile(
            title: Text('放送大学（単位互換）',),
            subtitle: Text('講義・シラバス'),
            trailing: Icon(Icons.link),
            onTap: () => launch('https://www.ouj.ac.jp/')
        ),
        ListTile(
            title: Text('クラスチューター一覧',),
            subtitle: Text('各種相談窓口・各種証明書・申請書発行'),
            trailing: Icon(Icons.link),
            onTap: () => launch('https://www.ous.ac.jp/common/files//128/202105251644200483109.pdf')
        ),
        ListTile(
            title: Text('給付金（入学金・学費等）',),
            subtitle: Text('授業料・各種制度'),
            trailing: Icon(Icons.link),
            onTap: () => launch('http://www.ous.ac.jp/students/fee01/')
        ),
        ListTile(
            title: Text('大規模自然災害で被災したとき',),
            subtitle: Text('授業料・各種制度'),
            trailing: Icon(Icons.link),
            onTap: () => launch('https://www.ous.ac.jp/common/files/128/kitei2018.pdf')
        ),
        ListTile(
            title: Text('奨学金制度',),
            subtitle: Text('授業料・各種制度'),
            trailing: Icon(Icons.link),
            onTap: () => launch('https://www.ous.ac.jp/students/schorlarship/')
        ),
        ListTile(
            title: Text('保険制度',),
            subtitle: Text('授業料・各種制度'),
            trailing: Icon(Icons.link),
            onTap: () => launch('https://www.ous.ac.jp/students/insurance/')
        ),
        ListTile(
            title: Text('キャリア支援センター',),
            subtitle: Text('サポート・学生支援・施設'),
            trailing: Icon(Icons.link),
            onTap: () => launch('http://career.office.ous.ac.jp/')
        ),
        ListTile(
            title: Text('教学資格課（資格取得）',),
            subtitle: Text('サポート・学生支援・施設'),
            trailing: Icon(Icons.link),
            onTap: () => launch('http://career.office.ous.ac.jp/kyousyoku/')
        ),
        ListTile(
            title: Text('情報基盤センター',),
            subtitle: Text('サポート・学生支援・施設'),
            trailing: Icon(Icons.link),
            onTap: () => launch('http://www.center.ous.ac.jp/')
        ),
        ListTile(
            title: Text('化学ボランティアセンター',),
            subtitle: Text('サポート・学生支援・施設'),
            trailing: Icon(Icons.link),
            onTap: () => launch('http://ridai-svc.org/')
        ),
        ListTile(
            title: Text('厚生施設営業日程',),
            subtitle: Text('サポート・学生支援・施設'),
            trailing: Icon(Icons.link),
            onTap: () => launch('https://www.ous.ac.jp/common/files//128/202202031316400965765.pdf')
        ),
        ListTile(
            title: Text('図書館',),
            subtitle: Text('サポート・学生支援・施設'),
            trailing: Icon(Icons.link),
            onTap: () => launch('http://www.lib.ous.ac.jp/')
        ),
        ListTile(
            title: Text('健康管理センター',),
            subtitle: Text('サポート・学生支援・施設'),
            trailing: Icon(Icons.link),
            onTap: () => launch('http://www1.ous.ac.jp/kenkan/')
        ),
        ListTile(
            title: Text('障がい学生支援規定',),
            subtitle: Text('サポート・学生支援・施設'),
            trailing: Icon(Icons.link),
            onTap: () => launch('https://www.ous.ac.jp/common/files//128/20191213shougai_kitei.pdf')
        ),
        ListTile(
            title: Text('障がい学生支援に関するガイドライン',),
            subtitle: Text('学生がよくみるもの'),
            trailing: Icon(Icons.link),
            onTap: () => launch('https://www.ous.ac.jp/common/files//128/202002200918550267479.pdf')
        ),
        ListTile(
            title: Text('教職特別課程',),
            subtitle: Text('学生がよくみるもの'),
            trailing: Icon(Icons.link),
            onTap: () => launch('http://www.ous.ac.jp/students/kyousyoku/')
        ),
        ListTile(
            title: Text('寄付金について',),
            subtitle: Text('学生がよくみるもの'),
            trailing: Icon(Icons.link),
            onTap: () => launch('http://www.donation.fm/ous/')
        ),
        ListTile(
            title: Text('教員データベース',),
            subtitle: Text('学生がよくみるもの'),
            trailing: Icon(Icons.link),
            onTap: () => launch('https://mylog.pub.ous.ac.jp/gyoseki/japanese/index.html')
        ),
        ListTile(
            title: Text('研究者ナビゲーター',),
            subtitle: Text('学生がよくみるもの'),
            trailing: Icon(Icons.link),
            onTap: () => launch('http://renkei.office.ous.ac.jp/ousresnavi/')
        ),

        new Divider(
          height: 1.0,
          indent: 1.0,
        ),
      ],
    ),
  );
}