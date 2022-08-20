import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class post extends StatefulWidget {
  const post({Key? key}) : super(key: key);

  @override
  State<post> createState() => _postState();
}

class _postState extends State<post> {
  String? iscategory = '理学部';
  String? isbumon = 'ラク単';
  String? isnendo = '2022';
  String? isgakki = '春１';
  String? istanni = '1';
  String? iszyugyoukeisiki = 'オンライン(VOD)';

  TextEditingController _textEditingController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('投稿ページ'),
        ),
        body: Container(
          margin: EdgeInsets.all(15),
          child: SingleChildScrollView(
              child: Column(children: [
            Center(
              child: (Text(
                '投稿する学部を選んでください',
                style: TextStyle(fontSize: 20),
              )),
            ),
            Center(
              child: (Text(
                '※基盤and教職関連科目を投稿する場合は学部を選ばずにカテゴリの中の”基盤”か”教職科目”を選んでください。',
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
                DropdownMenuItem(
                  child: Text('テスト投稿'),
                  value: 'テスト投稿',
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
              style: TextStyle(fontSize: 20),
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
              style: TextStyle(fontSize: 20),
            ),
            DropdownButton(
              //4
              items: const [
                //5
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
              style: TextStyle(fontSize: 20),
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
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'マイログに記載されている授業名（正式名称）をコピペして入力してください。。',
              style: TextStyle(fontSize: 15),
            ),
            TextField(
              controller: _textEditingController,
              // この一文を追加
              enabled: true,
              maxLength: 50,
              // 入力数
              style: TextStyle(color: Colors.black),
              obscureText: false,
              maxLines: 1,
              decoration: const InputDecoration(
                icon: Icon(Icons.speaker_notes),
                hintText: '投稿内容を記載します',
                labelText: '例：FBD00100 フレッシュマンセミナー',
              ),
            ),
            Text(
              '講師名を入力してください。',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'マイログに記載されている正式なフルネーム（空白なし）で入力してください。',
              style: TextStyle(fontSize: 15),
            ),
            TextField(
              controller: _textEditingController,
              // この一文を追加
              enabled: true,
              maxLength: 50,
              // 入力数
              style: TextStyle(color: Colors.black),
              obscureText: false,
              maxLines: 1,
              decoration: const InputDecoration(
                icon: Icon(Icons.speaker_notes),
                hintText: '投稿内容を記載します',
                labelText: '例：太郎田中',
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Text(
              '単位数を選んでください',
              style: TextStyle(fontSize: 20),
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
                DropdownMenuItem(
                  child: Text('4'),
                  value: '4',
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
              style: TextStyle(fontSize: 20),
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

          ])),
        ));
  }

  _onSubmitted(String content) {
    CollectionReference posts =
        FirebaseFirestore.instance.collection('$iscategory');
    posts.add({"text": content});

    /// 入力欄をクリアにする
    _textEditingController.clear();
  }
}
