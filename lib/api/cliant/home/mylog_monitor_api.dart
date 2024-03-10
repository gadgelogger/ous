import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';

class MylogMonitorApi {
  Future<Map<String, String>> mylogMonitor() async {
    var dio = Dio();
    dio.options.headers['Authorization'] =
        'Bearer glsa_gPHPHakicrtftk0xZ4iiDHOlD3kzYivC_478e8cde';

    Response response = await dio.get(
      'https://rss.uptimerobot.com/u1289833-0ef9796d57788bd318da8c890c598a93',
    );

    if (response.statusCode == 200) {
      var document = XmlDocument.parse(response.data);
      var firstItem = document.findAllElements('item').first;

      var title = firstItem.findElements('title').single.innerText;
      var pubDate = firstItem.findElements('pubDate').single.innerText;

      // 日付の整形
      DateFormat originalFormat = DateFormat('E, d MMM yyyy HH:mm:ss Z');
      DateTime dateTime = originalFormat.parse(pubDate);
      String formattedDate = DateFormat('yyyy/MM/dd HH:mm:ss').format(dateTime);

      // ステータスメッセージの設定
      String statusMessage = title.contains('is UP')
          ? '正常に稼働中'
          : (title.contains('is DOWN') ? '障害発生中' : '不明なステータス');

      return {'statusMessage': statusMessage, 'formattedDate': formattedDate};
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }
}
