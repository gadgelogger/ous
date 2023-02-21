import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ous/review.dart';
import 'package:slide_to_act/slide_to_act.dart';

class post extends StatefulWidget {
  const post({Key? key}) : super(key: key);

  @override
  State<post> createState() => _postState();
}

class _postState extends State<post> {
  //投稿データ
  String? iscategory = '理学部';
  String? isbumon = 'ラク単';
  String? isnendo = '2022';
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
  var _hyouka = 0.0;
  var _hyouka_text = '0';

  //面白さ
  var _omosirosa = 0.0;
  var _omosirosa_text = '0';

  //単位の取りやすさ
  var _toriyasusa = 0.0;
  var _toriyasusa_text = '0';

  //投稿者の情報
  String? name;
  String? email;
  String? image;
  String? uid;

//投稿者の情報をFirebaseAuthから取得
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // here, don't declare new variables, set the members instead
        setState(() {
          name = user.displayName; // <-- User ID
          email = user.email; // <-- Their email
          image = user.photoURL;
          uid = user.uid;
        });
      }
    });
  }


  TextEditingController _textEditingController1 = TextEditingController();
  TextEditingController _textEditingController2 = TextEditingController();
  TextEditingController _textEditingController3 = TextEditingController();
  TextEditingController _textEditingController4 = TextEditingController();
  TextEditingController _textEditingController5 = TextEditingController();
  TextEditingController _textEditingController6 = TextEditingController();
  TextEditingController _textEditingController7 = TextEditingController();






  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('投稿ページ'),
        ),
        body: Container(
          child: Scrollbar(
              isAlwaysShown: true,
              child: Padding(
                  padding: EdgeInsets.all(15.0), //全方向にパディング１００

                  child: SingleChildScrollView(
                      child: Column(children: [
                    Center(
                      child: (Text(
                        '投稿する学部を選んでください',
                        style: GoogleFonts.notoSans(
                          // フォントをnotoSansに指定(
                          textStyle: TextStyle(
                            fontSize: 25,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                    ),
                    Center(
                      child: (Text(
                        '※基盤and教職関連科目を投稿する場合は学部を選ばずに\nカテゴリの中の”基盤”か”教職科目”を選んでください。',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red),
                      )),
                    ),
                    DropdownButton(
                      //4
                      items: const [
                        //5
                        DropdownMenuItem(
                          child: Text('理学部'),
                          value: '理学部',
                        ),
                        DropdownMenuItem(
                          child: Text('工学部'),
                          value: '工学部',
                        ),
                        DropdownMenuItem(
                          child: Text('情報理工学部'),
                          value: '情報理工学部',
                        ),
                        DropdownMenuItem(
                          child: Text('生物地球学部'),
                          value: '生物地球学部',
                        ),
                        DropdownMenuItem(
                          child: Text('教育学部'),
                          value: '教育学部',
                        ),
                        DropdownMenuItem(
                          child: Text('経営学部'),
                          value: '経営学部',
                        ),
                        DropdownMenuItem(
                          child: Text('獣医学部'),
                          value: '獣医学部',
                        ),
                        DropdownMenuItem(
                          child: Text('生命科学部'),
                          value: '生命科学部',
                        ),
                        DropdownMenuItem(
                          child: Text('基盤教育科目'),
                          value: '基盤教育科目',
                        ),
                        DropdownMenuItem(
                          child: Text('教職科目'),
                          value: '教職科目',
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
                    const SizedBox(
                      height: 32,
                    ),


                    Text(
                      '投稿する授業の部門を選んでください',
                      style: GoogleFonts.notoSans(
                        // フォントをnotoSansに指定(
                        textStyle: TextStyle(
                          fontSize: 20,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DropdownButton(
                      //4
                      items: const [
                        //5
                        DropdownMenuItem(
                          child: Text('ラク単'),
                          value: 'ラク単',
                        ),
                        DropdownMenuItem(
                          child: Text('エグ単'),
                          value: 'エグ単',
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
                    const SizedBox(
                      height: 32,
                    ),
                    Text(
                      '年度を選んでください',
                      style: GoogleFonts.notoSans(
                        // フォントをnotoSansに指定(
                        textStyle: TextStyle(
                          fontSize: 20,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DropdownButton(
                      //4
                      items: const [
                        //5
                        DropdownMenuItem(
                          child: Text('2023'),
                          value: '2023',
                        ),
                        DropdownMenuItem(
                          child: Text('2022'),
                          value: '2022',
                        ),
                        DropdownMenuItem(
                          child: Text('2021'),
                          value: '2021',
                        ),
                        DropdownMenuItem(
                          child: Text('2020'),
                          value: '2020',
                        ),
                      ],
                      //6
                      onChanged: (String? value) {
                        setState(() {
                          isnendo = value;
                        });
                      },
                      //7
                      value: isnendo,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Text(
                      '開講学期を選んでください',
                      style: GoogleFonts.notoSans(
                        // フォントをnotoSansに指定(
                        textStyle: TextStyle(
                          fontSize: 20,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DropdownButton(
                      //4
                      items: const [
                        //5
                        DropdownMenuItem(
                          child: Text('春１'),
                          value: '春１',
                        ),
                        DropdownMenuItem(
                          child: Text('春２'),
                          value: '春２',
                        ),
                        DropdownMenuItem(
                          child: Text('秋１'),
                          value: '秋１',
                        ),
                        DropdownMenuItem(
                          child: Text('秋２'),
                          value: '秋２',
                        ),
                        DropdownMenuItem(
                          child: Text('春１と２'),
                          value: '春１と２',
                        ),
                        DropdownMenuItem(
                          child: Text('秋１と２'),
                          value: '秋１と２',
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
                    const SizedBox(
                      height: 32,
                    ),
                    Text(
                      '授業名を入力してください。',
                      style: GoogleFonts.notoSans(
                        // フォントをnotoSansに指定(
                        textStyle: TextStyle(
                          fontSize: 20,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
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
                        icon: Icon(Icons.rate_review_outlined),
                        labelText: 'FBD00100 フレッシュマンセミナー',
                      ),
                      onChanged: (String value) {
                        setState(() {
                          iszyugyoumei = value;
                        });
                      },
                    ),
                    Text(
                      '講師名を入力してください。',
                      style: GoogleFonts.notoSans(
                        // フォントをnotoSansに指定(
                        textStyle: TextStyle(
                          fontSize: 20,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
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
                        icon: Icon(Icons.rate_review_outlined),
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
                    Text(
                      '単位数を選んでください',
                      style: GoogleFonts.notoSans(
                        // フォントをnotoSansに指定(
                        textStyle: TextStyle(
                          fontSize: 20,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DropdownButton(
                      //4
                      items: const [
                        //5
                        DropdownMenuItem(
                          child: Text('1'),
                          value: '1',
                        ),
                        DropdownMenuItem(
                          child: Text('2'),
                          value: '2',
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
                    const SizedBox(
                      height: 32,
                    ),
                    Text(
                      '授業形式を選んでください',
                      style: GoogleFonts.notoSans(
                        // フォントをnotoSansに指定(
                        textStyle: TextStyle(
                          fontSize: 20,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DropdownButton(
                      //4
                      items: const [
                        //5
                        DropdownMenuItem(
                          child: Text('オンライン(VOD)'),
                          value: 'オンライン(VOD)',
                        ),
                        DropdownMenuItem(
                          child: Text('オンライン(リアルタイム）'),
                          value: 'オンライン(リアルタイム）',
                        ),
                        DropdownMenuItem(
                          child: Text('対面'),
                          value: '対面',
                        ),
                        DropdownMenuItem(
                          child: Text('対面とオンライン'),
                          value: '対面とオンライン',
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
                    const SizedBox(
                      height: 32,
                    ),
                    Text(
                      '総合評価',
                      style: TextStyle(fontSize: 20),
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          _hyouka_text,
                          style: TextStyle(fontSize: 24),
                        ),
                        Slider(
                          value: _hyouka,
                          min: 0,
                          max: 5,
                          onChanged: (double value) {
                            setState(() {
                              _hyouka = value.roundToDouble();
                              _hyouka_text = ' $_hyouka';
                            });
                          },
                        )
                      ],
                    ),
                    Text(
                      '授業の面白さ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          _omosirosa_text,
                          style: TextStyle(fontSize: 24),
                        ),
                        Slider(
                          value: _omosirosa,
                          min: 0,
                          max: 5,
                          onChanged: (double value) {
                            setState(() {
                              _omosirosa = value.roundToDouble();
                              _omosirosa_text = ' $_omosirosa';
                            });
                          },
                        )
                      ],
                    ),
                    Text(
                      '単位の取りやすさ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          _toriyasusa_text,
                          style: TextStyle(fontSize: 24),
                        ),
                        Slider(
                          value: _toriyasusa,
                          min: 0,
                          max: 5,
                          onChanged: (double value) {
                            setState(() {
                              _toriyasusa = value.roundToDouble();
                              _toriyasusa_text = ' $_toriyasusa';
                            });
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Text(
                      '出席確認の有無',
                      style: GoogleFonts.notoSans(
                        // フォントをnotoSansに指定(
                        textStyle: TextStyle(
                          fontSize: 20,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DropdownButton(
                      //4
                      items: const [
                        //5
                        DropdownMenuItem(
                          child: Text('毎日出席を取る'),
                          value: '毎日出席を取る',
                        ),
                        DropdownMenuItem(
                          child: Text('ほぼ出席を取る'),
                          value: 'ほぼ出席を取る',
                        ),
                        DropdownMenuItem(
                          child: Text('たまに出席を取る'),
                          value: 'たまに出席を取る',
                        ),
                        DropdownMenuItem(
                          child: Text('出席確認はなし'),
                          value: '出席確認はなし',
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
                    Text(
                      '教科書の有無',
                      style: GoogleFonts.notoSans(
                        // フォントをnotoSansに指定(
                        textStyle: TextStyle(
                          fontSize: 20,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DropdownButton(
                      //4
                      items: const [
                        //5
                        DropdownMenuItem(
                          child: Text('あり'),
                          value: 'あり',
                        ),
                        DropdownMenuItem(
                          child: Text('なし'),
                          value: 'なし',
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
                    Text(
                      'コメント',
                      style: GoogleFonts.notoSans(
                        // フォントをnotoSansに指定(
                        textStyle: TextStyle(
                          fontSize: 20,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                        icon: Icon(Icons.rate_review_outlined),
                        labelText: 'この講義は楽で〜...',
                      ),
                      onChanged: (String value) {
                        setState(() {
                          iskomento = value;
                        });
                      },
                    ),
                    Text(
                      'テスト形式（期末）',
                      style: GoogleFonts.notoSans(
                        // フォントをnotoSansに指定(
                        textStyle: TextStyle(
                          fontSize: 20,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                        icon: Icon(Icons.rate_review_outlined),
                        labelText: 'ありorなしorレポートorその他...',
                      ),
                      onChanged: (String value) {
                        setState(() {
                          istesutokeisiki = value;
                        });
                      },
                    ),
                    Text(
                      'テストの傾向',
                      style: GoogleFonts.notoSans(
                        // フォントをnotoSansに指定(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
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
                        icon: Icon(Icons.rate_review_outlined),
                        labelText: 'テストは主に教科書から...',

                      ),
                      onChanged: (String value) {
                        setState(() {
                          istesutokeikou = value;
                        });
                      },
                    ),
                        Text(
                            '投稿者名を入力してください'),
                        TextField(
                          controller: _textEditingController7,
                          // この一文を追加
                          enabled: true,
                          maxLength: 20,
                          // 入力数
                          obscureText: false,
                          maxLines: null,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.drive_file_rename_outline_outlined),
                            labelText: 'ニックネーム',
                          ),
                          onChanged: (String value) {
                            setState(() {
                              isname = value;
                            });
                          },
                        ),
                    Text(
                      '宣伝箇所',
                      style: GoogleFonts.notoSans(
                        // フォントをnotoSansに指定(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
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
                        icon: Icon(Icons.rate_review_outlined),
                        labelText: '〇〇サークルに属しています！入部よろしく！',
                      ),
                      onChanged: (String value) {
                        setState(() {
                          issenden = value;
                        });
                      },
                    ),
                        SizedBox(
                          height: 50,
                        ),
                    SlideAction(
                        outerColor: Colors.lightGreen[200],
                        child: Text('送信する',style: TextStyle(color: Colors.black),),
                        onSubmit: () async {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: Text(
                                  "投稿ありがとうございます！",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                          width: 100,
                                          height: 100,
                                        child:
                                Image(
                                image: AssetImage('assets/icon/rocket.gif'),
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
                                    child: Text("おっけー"),
                                    onPressed: (){
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          // 遷移先のクラス
                                          builder: (BuildContext context) =>  Review(),
                                        ),
                                      );
                                    }
                                  ),
                                ],
                              );
                            },
                          );

                          await FirebaseFirestore.instance
                              .collection('test_collection1') // コレクションID
                              .doc() // ここは空欄だと自動でIDが付く
                              .set({
                                'bumon': isbumon,
                                'gakki': isgakki,
                                'komento': iskomento,
                                'kousimei': iskousimei,
                                'nenndo': isnendo,
                                'omosirosa': _omosirosa_text,
                                'senden': issenden,
                                'sougouhyouka': _hyouka_text,
                                'syusseki': issyusseki,
                                'tannisuu': istanni,
                                'tesutokeisiki': istesutokeisiki,
                                'toriyasusa': _toriyasusa_text,
                                'zyugyoukeisiki': iszyugyoukeisiki,
                                'zyugyoumei': iszyugyoumei,
                            'name': isname,
                            'accountname':name,
                            'accountemail':email,
                            'accountuid':uid,
                            'tesutokeikou':istesutokeikou,

                          })
                              .then((value) => print("新規登録に成功"))
                              .catchError(
                                  (error) => print("新規登録に失敗しました!: $error"));
                          _textEditingController1.clear();
                          _textEditingController2.clear();
                          _textEditingController3.clear();
                          _textEditingController4.clear();
                          _textEditingController5.clear();
                          _textEditingController6.clear();
                          _textEditingController7.clear();

                        }),
                    const SizedBox(
                      height: 100,
                    ),
                  ])))),
        ));
  }
}
