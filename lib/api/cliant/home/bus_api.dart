import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class BusService {
  Future<String> fetchBusApproachCaption(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var document = parse(response.body);
      var approachCaption = document.getElementsByClassName('approachCaption');
      if (approachCaption.isNotEmpty) {
        return approachCaption[0].text.trim();
      } else {
        return '終了';
      }
    } else {
      throw Exception('バス情報の取得に失敗しました。');
    }
  }
}
