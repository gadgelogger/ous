import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class post extends StatefulWidget {
  const post({Key? key}) : super(key: key);

  @override
  State<post> createState() => _postState();
}

class _postState extends State<post> {
  //投稿データ
  String? iscategory = 'rigaku';
  String? isbumon = 'ラク単';
  String? isnendo = '';
  String? isgakki = '春１';
  String? iszyugyoumei = '';
  String? iskousimei = '';
  String? istanni = '1';
  String? iszyugyoukeisiki = 'オンライン(VOD)';
  String? issyusseki = '毎日出席を取る';
  String? iskyoukasyo = 'あり';
  String? istesutokeisiki = '';
  String? istesutokeikou = '';
  String? isname = '';

  String? iskomento = '';
  String? issenden = '';

  //総合評価
  double _hyouka = 0;

  //面白さ
  double _omosirosa = 0;

  //単位の取りやすさ
  double _toriyasusa = 0;

  //投稿者の情報
  String? name;
  String? email;
  String? image;

//投稿者の情報をFirebaseAuthから取得
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final uid = FirebaseAuth.instance.currentUser?.uid;

  Future<void> getData() async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    setState(() {
      name = snapshot.get('displayName');
      email = snapshot.get('email');
    });
  }

//投稿日
  final DateTime now = DateTime.now();

  final TextEditingController _textEditingController0 = TextEditingController();

  final TextEditingController _textEditingController1 = TextEditingController();
  final TextEditingController _textEditingController2 = TextEditingController();
  final TextEditingController _textEditingController3 = TextEditingController();
  final TextEditingController _textEditingController4 = TextEditingController();
  final TextEditingController _textEditingController5 = TextEditingController();
  final TextEditingController _textEditingController6 = TextEditingController();
  final TextEditingController _textEditingController7 = TextEditingController();

//投稿したら一番上まで移動
  final ScrollController _scrollController = ScrollController();

//スライドボタンの状態をリセットするため
  final slideActionKey = GlobalKey<SlideActionState>();

  final String _randomId = const Uuid().v4();

  @override
  void initState() {
    super.initState();
    getData();
  }

  //アプリレビュー
  Future<void> _requestReview() async {
    final InAppReview inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('投稿ページ'),
          actions: [
            IconButton(
                icon: const Icon(Icons.computer),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: const Text(
                          "スマホで投稿するのが\nめんどくさい人へ",
                          textAlign: TextAlign.center,
                        ),
                        content: const Text(
                          "下記のボタンを押すとPC用クライアントを開きます。\n\nこれをニアバイシェアやAirdrop等を使いPCに送ってください。\n\nhttps://ous-unoffical-20d2c.web.app/\n手動で入力する場合は↑を入力してください。",
                          textAlign: TextAlign.center,
                        ),
                        actions: <Widget>[
                          // ボタン領域
                          TextButton(
                            child: const Text("俺はスマホを貫くぜ"),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                              child: const Text("開く"),
                              onPressed: () {
                                launch('https://ous-unoffical-20d2c.web.app/');
                              }),
                        ],
                      );
                    },
                  );
                }),
          ],
        ),
        body: Scrollbar(
            child: Padding(
                padding: const EdgeInsets.all(15.0), //全方向にパディング１００

                child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '投稿する学部を選んでください',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          (const Text(
                            '※基盤and教職関連科目を投稿する場合は学部を選ばずに\nカテゴリの中の”基盤”か”教職科目”を選んでください。',
                            style: TextStyle(color: Colors.red),
                          )),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 200.sw,
                            child: DropdownButton(
                              //4
                              isExpanded: true,

                              items: const [
                                //5
                                DropdownMenuItem(
                                  value: 'rigaku',
                                  child: Text('理学部'),
                                ),
                                DropdownMenuItem(
                                  value: 'kougakubu',
                                  child: Text('工学部'),
                                ),
                                DropdownMenuItem(
                                  value: 'zyouhou',
                                  child: Text('情報理工学部'),
                                ),
                                DropdownMenuItem(
                                  value: 'seibutu',
                                  child: Text('生物地球学部'),
                                ),
                                DropdownMenuItem(
                                  value: 'kyouiku',
                                  child: Text('教育学部'),
                                ),
                                DropdownMenuItem(
                                  value: 'keiei',
                                  child: Text('経営学部'),
                                ),
                                DropdownMenuItem(
                                  value: 'zyuui',
                                  child: Text('獣医学部'),
                                ),
                                DropdownMenuItem(
                                  value: 'seimei',
                                  child: Text('生命科学部'),
                                ),
                                DropdownMenuItem(
                                  value: 'kiban',
                                  child: Text('基盤教育科目'),
                                ),
                                DropdownMenuItem(
                                  value: 'kyousyoku',
                                  child: Text('教職科目'),
                                ),
                              ],
                              //6
                              onChanged: (String? value) {
                                setState(() {
                                  iscategory = value;
                                });
                              },
                              //7
                              value: iscategory,
                            ),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          const Text(
                            '投稿する授業の部門を選んでください',
                          ),
                          SizedBox(
                            width: 200.sw,
                            child: DropdownButton(
                              //4
                              isExpanded: true,

                              items: const [
                                //5
                                DropdownMenuItem(
                                  value: 'ラク単',
                                  child: Text('ラク単'),
                                ),
                                DropdownMenuItem(
                                  value: 'エグ単',
                                  child: Text('エグ単'),
                                ),
                                DropdownMenuItem(
                                  value: '普通',
                                  child: Text('普通'),
                                ),
                              ],
                              //6
                              onChanged: (String? value) {
                                setState(() {
                                  isbumon = value;
                                });
                              },
                              //7
                              value: isbumon,
                            ),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          const Text(
                            '年度を記入してください',
                          ),
                          TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4)
                            ],
                            controller: _textEditingController0,
                            // この一文を追加
                            enabled: true,
                            // 入力数
                            obscureText: false,
                            maxLines: null,
                            decoration: const InputDecoration(
                              labelText: '例：2023',
                            ),
                            onChanged: (String value) {
                              setState(() {
                                isnendo = value;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          const Text(
                            '開講学期を選んでください',
                          ),
                          SizedBox(
                            width: 200.sw,
                            child: DropdownButton(
                              //4
                              isExpanded: true,

                              items: const [
                                //5
                                DropdownMenuItem(
                                  value: '春１',
                                  child: Text('春１'),
                                ),
                                DropdownMenuItem(
                                  value: '春２',
                                  child: Text('春２'),
                                ),
                                DropdownMenuItem(
                                  value: '秋１',
                                  child: Text('秋１'),
                                ),
                                DropdownMenuItem(
                                  value: '秋２',
                                  child: Text('秋２'),
                                ),
                                DropdownMenuItem(
                                  value: '春１と２',
                                  child: Text('春１と２'),
                                ),
                                DropdownMenuItem(
                                  value: '秋１と２',
                                  child: Text('秋１と２'),
                                ),
                              ],
                              //6
                              onChanged: (String? value) {
                                setState(() {
                                  isgakki = value;
                                });
                              },
                              //7
                              value: isgakki,
                            ),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          const Text(
                            '授業名を入力してください。',
                          ),
                          const Text(
                            'マイログに記載されている授業名（正式名称）をコピペして入力してください。。',
                            style: TextStyle(fontSize: 15),
                          ),
                          TextField(
                            controller: _textEditingController1,
                            // この一文を追加
                            enabled: true,
                            // 入力数
                            obscureText: false,
                            maxLines: null,
                            decoration: const InputDecoration(
                              labelText: 'FBD00100 フレッシュマンセミナー',
                            ),
                            onChanged: (String value) {
                              setState(() {
                                iszyugyoumei = value;
                              });
                            },
                          ),
                          const Text(
                            '講師名を入力してください。',
                          ),
                          const Text(
                            'マイログに記載されている正式なフルネーム（空白なし）で入力してください。',
                            style: TextStyle(fontSize: 15),
                          ),
                          TextField(
                            controller: _textEditingController2,
                            // この一文を追加
                            enabled: true,
                            // 入力数
                            obscureText: false,
                            maxLines: null,
                            decoration: const InputDecoration(
                              labelText: '太郎田中',
                            ),
                            onChanged: (String value) {
                              setState(() {
                                iskousimei = value;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          const Text(
                            '単位数を選んでください',
                          ),
                          SizedBox(
                            width: 200.sw,
                            child: DropdownButton(
                              //4
                              isExpanded: true,

                              items: const [
                                //5
                                DropdownMenuItem(
                                  value: '1',
                                  child: Text('1'),
                                ),
                                DropdownMenuItem(
                                  value: '2',
                                  child: Text('2'),
                                ),
                              ],
                              //6
                              onChanged: (String? value) {
                                setState(() {
                                  istanni = value;
                                });
                              },
                              //7
                              value: istanni,
                            ),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          const Text(
                            '授業形式を選んでください',
                          ),
                          SizedBox(
                            width: 200.sw,
                            child: DropdownButton(
                              //4
                              isExpanded: true,

                              items: const [
                                //5
                                DropdownMenuItem(
                                  value: 'オンライン(VOD)',
                                  child: Text('オンライン(VOD)'),
                                ),
                                DropdownMenuItem(
                                  value: 'オンライン(リアルタイム）',
                                  child: Text('オンライン(リアルタイム）'),
                                ),
                                DropdownMenuItem(
                                  value: '対面',
                                  child: Text('対面'),
                                ),
                                DropdownMenuItem(
                                  value: '対面とオンライン',
                                  child: Text('対面とオンライン'),
                                ),
                              ],
                              //6
                              onChanged: (String? value) {
                                setState(() {
                                  iszyugyoukeisiki = value;
                                });
                              },
                              //7
                              value: iszyugyoukeisiki,
                            ),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          const Text(
                            '総合評価',
                            style: TextStyle(fontSize: 20),
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                _hyouka.toStringAsFixed(0),
                                style: const TextStyle(fontSize: 24),
                              ),
                              Slider(
                                value: _hyouka,
                                min: 0,
                                max: 5,
                                onChanged: (double value) {
                                  setState(() {
                                    _hyouka = value.roundToDouble();
                                  });
                                },
                              )
                            ],
                          ),
                          const Text(
                            '授業の面白さ',
                            style: TextStyle(fontSize: 20),
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                _omosirosa.toStringAsFixed(0),
                                style: const TextStyle(fontSize: 24),
                              ),
                              Slider(
                                value: _omosirosa,
                                min: 0,
                                max: 5,
                                onChanged: (double value) {
                                  setState(() {
                                    _omosirosa = value.roundToDouble();
                                  });
                                },
                              )
                            ],
                          ),
                          const Text(
                            '単位の取りやすさ',
                            style: TextStyle(fontSize: 20),
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                _toriyasusa.toStringAsFixed(0),
                                style: const TextStyle(fontSize: 24),
                              ),
                              Slider(
                                value: _toriyasusa,
                                min: 0,
                                max: 5,
                                onChanged: (double value) {
                                  setState(() {
                                    _toriyasusa = value.roundToDouble();
                                  });
                                },
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          const Text(
                            '出席確認の有無',
                          ),
                          SizedBox(
                            width: 200.sw,
                            child: DropdownButton(
                              //4
                              isExpanded: true,

                              items: const [
                                //5
                                DropdownMenuItem(
                                  value: '毎日出席を取る',
                                  child: Text('毎日出席を取る'),
                                ),
                                DropdownMenuItem(
                                  value: 'ほぼ出席を取る',
                                  child: Text('ほぼ出席を取る'),
                                ),
                                DropdownMenuItem(
                                  value: 'たまに出席を取る',
                                  child: Text('たまに出席を取る'),
                                ),
                                DropdownMenuItem(
                                  value: '出席確認はなし',
                                  child: Text('出席確認はなし'),
                                ),
                              ],
                              //6
                              onChanged: (String? value) {
                                setState(() {
                                  issyusseki = value;
                                });
                              },
                              //7
                              value: issyusseki,
                            ),
                          ),
                          const Text(
                            '教科書の有無',
                          ),
                          SizedBox(
                            width: 200.sw,
                            child: DropdownButton(
                              //4
                              isExpanded: true,

                              items: const [
                                //5
                                DropdownMenuItem(
                                  value: 'あり',
                                  child: Text('あり'),
                                ),
                                DropdownMenuItem(
                                  value: 'なし',
                                  child: Text('なし'),
                                ),
                              ],
                              //6
                              onChanged: (String? value) {
                                setState(() {
                                  iskyoukasyo = value;
                                });
                              },
                              //7
                              value: iskyoukasyo,
                            ),
                          ),
                          const Text(
                            'コメント',
                          ),
                          TextField(
                            controller: _textEditingController3,
                            // この一文を追加
                            enabled: true,
                            maxLength: null,
                            // 入力数
                            obscureText: false,
                            maxLines: null,
                            decoration: const InputDecoration(
                              labelText: 'この講義は楽で〜...',
                            ),
                            onChanged: (String value) {
                              setState(() {
                                iskomento = value;
                              });
                            },
                          ),
                          const Text(
                            'テスト形式（期末）',
                          ),
                          TextField(
                            controller: _textEditingController4,
                            // この一文を追加
                            enabled: true,
                            maxLength: 20,
                            // 入力数
                            obscureText: false,
                            maxLines: null,
                            decoration: const InputDecoration(
                              labelText: 'ありorなしorレポートorその他...',
                            ),
                            onChanged: (String value) {
                              setState(() {
                                istesutokeisiki = value;
                              });
                            },
                          ),
                          const Text(
                            'テストの傾向',
                          ),
                          const Text(
                            'テストの範囲やどのような問題が出るのかを書いてもらえるとありがたいです',
                          ),
                          TextField(
                            controller: _textEditingController5,
                            // この一文を追加
                            enabled: true,
                            maxLength: null,

                            // 入力数
                            obscureText: false,
                            maxLines: null,
                            decoration: const InputDecoration(
                              labelText: 'テストは主に教科書から...',
                            ),
                            onChanged: (String value) {
                              setState(() {
                                istesutokeikou = value;
                              });
                            },
                          ),
                          const Text('投稿者名を入力してください'),
                          TextField(
                            controller: _textEditingController7,
                            // この一文を追加
                            enabled: true,
                            maxLength: 20,
                            // 入力数
                            obscureText: false,
                            maxLines: null,
                            decoration: const InputDecoration(
                              labelText: 'ニックネーム',
                            ),
                            onChanged: (String value) {
                              setState(() {
                                isname = value;
                              });
                            },
                          ),
                          const Text(
                            '宣伝箇所',
                          ),
                          const Text(
                              '※サークルの宣伝や団体宣伝などが可能です。広報にご活用ください。入力された文字はそのまま反映されますのでご注意ください。'),
                          TextField(
                            controller: _textEditingController6,
                            // この一文を追加
                            enabled: true,
                            maxLength: null,
                            // 入力数
                            obscureText: false,
                            maxLines: null,
                            decoration: const InputDecoration(
                              labelText: '〇〇サークルに属しています！入部よろしく！',
                            ),
                            onChanged: (String value) {
                              setState(() {
                                issenden = value;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          SlideAction(
                              outerColor:
                                  Theme.of(context).colorScheme.secondary,
                              key: slideActionKey,
                              onSubmit: () async {
                                showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      title: const Text(
                                        "投稿ありがとうございます！",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content: const Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            SizedBox(
                                                width: 100,
                                                height: 100,
                                                child: Image(
                                                  image: AssetImage(
                                                      'assets/icon/rocket.gif'),
                                                  fit: BoxFit.cover,
                                                )),
                                            Text(
                                              'クッソ長いアンケートに答えていただきありがとうございます！\n頂いたアンケートはアプリ内で共有されすぐに反映されます。',
                                              textAlign: TextAlign.center,
                                            ),
                                          ]),
                                      actions: <Widget>[
                                        // ボタン領域
                                        TextButton(
                                            child: const Text("おっけー"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              _requestReview();
                                              slideActionKey.currentState!
                                                  .reset();
                                            }),
                                      ],
                                    );
                                  },
                                );
                                await FirebaseFirestore.instance
                                    .collection(iscategory!) // コレクションID
                                    .doc() // ここは空欄だと自動でIDが付く
                                    .set({
                                      'bumon': isbumon,
                                      'gakki': isgakki,
                                      'komento': iskomento,
                                      'kousimei': iskousimei,
                                      'nenndo': isnendo,
                                      'omosirosa': _omosirosa,
                                      'senden': issenden,
                                      'sougouhyouka': _hyouka,
                                      'syusseki': issyusseki,
                                      'tannisuu': istanni,
                                      'tesutokeisiki': istesutokeisiki,
                                      'toriyasusa': _toriyasusa,
                                      'zyugyoukeisiki': iszyugyoukeisiki,
                                      'zyugyoumei': iszyugyoumei,
                                      'name': isname,
                                      'accountname': name,
                                      'accountemail': email,
                                      'accountuid': uid,
                                      'tesutokeikou': istesutokeikou,
                                      'kyoukasyo': iskyoukasyo,
                                      'date': Timestamp.fromDate(now),
                                      'ID': _randomId,
                                    })
                                    .then((value) => print("新規登録に成功"))
                                    .catchError((error) =>
                                        print("新規登録に失敗しました!: $error"));
                                _textEditingController0.clear();
                                _textEditingController1.clear();
                                _textEditingController2.clear();
                                _textEditingController3.clear();
                                _textEditingController4.clear();
                                _textEditingController5.clear();
                                _textEditingController6.clear();
                                _textEditingController7.clear();
                              },
                              child: const Text(
                                'スワイプして送信',
                                style: TextStyle(color: Colors.black),
                              )),
                          const SizedBox(
                            height: 100,
                          ),
                        ])))));
  }
}
