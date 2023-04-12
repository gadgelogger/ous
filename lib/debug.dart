import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  // ログイン情報を設定する
  final loginId = 'i21i062yy';
  final password = 'Tk5rduwn';

  // セッションを開始する
  final client = HttpClient();
  final request = await client.postUrl(Uri.parse('https://mylog.pub.ous.ac.jp/uprx/up/pk/pky001/Pky00101.do'));

  // POSTデータを設定する
  final postData = {
    'form1:htmlUserId': loginId,
    'form1:htmlPassword': password,
    'form1:loginButton': 'ログイン',
  };
  final encodedData = utf8.encode(Uri(queryParameters: postData).query);
  request.headers.add(HttpHeaders.contentTypeHeader, 'application/x-www-form-urlencoded');
  request.headers.add(HttpHeaders.contentLengthHeader, encodedData.length.toString());
  request.add(utf8.encode(Uri(queryParameters: postData).query));

  // リクエストを送信する
  final response = await request.close();

  // レスポンスからCookieを取得する
  final cookies = response.cookies;
  final sessionId = cookies.firstWhere((cookie) => cookie.name == 'JSESSIONID').value;

  // Cookieを使用して、データを取得する
  final dataRequest = await client.getUrl(Uri.parse('https://mylog.pub.ous.ac.jp/uprx/up/xu/xub001/Xub00101.xhtml'));
  dataRequest.headers.add(HttpHeaders.cookieHeader, 'JSESSIONID=$sessionId');
  final dataResponse = await dataRequest.close();
  final data = await dataResponse.transform(utf8.decoder).join();

  // 取得したデータを表示する
  print(data);

  // クライアントをクローズする
  client.close();
}
