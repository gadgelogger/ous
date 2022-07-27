import 'package:flutter/material.dart';

class post extends StatefulWidget {
  const post({Key? key}) : super(key: key);

  @override
  State<post> createState() => _postState();
}

class _postState extends State<post> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('投稿ページ'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.only(top: 10),
            child:Text(
                '投稿する学部（カテゴリ）を選択してください\n※基盤and教職関連科目を投稿する場合は学部を選ばずにカテゴリの中の"基盤"か"教職科目”を選んでください。',
                style: TextStyle(fontSize: 15),
              ),
    ),
            Divider(),
            Text('ここに要素を入れる'),
            Divider(),
            Padding(padding: EdgeInsets.only(top: 10),
              child:Text(
                '投稿する講義の部門（ラク単orエグ単）を選択してください。',
                style: TextStyle(fontSize: 15),
              ),
            ),
            Divider(),
            Text('ここに要素を入れる'),
            Divider(),
            Text('data'),
            Divider(),
            Text('ここに要素を入れる'),
            Divider(),


          ],
        ),
      ),
    );
  }
}
