import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html/dom.dart' as UserModel;
import 'package:provider/provider.dart';
import "package:universal_html/controller.dart";
import 'package:flutter/material.dart';
import 'package:universal_html/parsing.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:ous/apikey.dart';
class movie extends StatefulWidget {
  const movie({Key? key}) : super(key: key);

  @override
  State<movie> createState() => _movieState();
}

class _movieState extends State<movie> {
  static String key = "${info_movie_key}";




  YoutubeAPI youtube = YoutubeAPI(key,);
  List<YouTubeVideo> videoResult = [];

  Future<void> callAPI() async {
    String query = "【おかりかチャンネル】岡山理科大学の現役学生による公式YouTubeチャンネル";

    videoResult = await youtube.search(
      query,
      order: 'relevance',
      videoDuration: 'any',
    );
    videoResult = await youtube.nextPage();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    callAPI();
    print('hello');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: (videoResult == null || videoResult.length == 0)?
        CircularProgressIndicator():
        ListView(
          children: videoResult.map<Widget>(listItem).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () =>
          {launch('https://www.youtube.com/@user-ms9dw7xq5l/videos')},
          child: Icon(Icons.movie_creation_outlined)),
    );
  }

  Widget listItem(YouTubeVideo video) {
    return GestureDetector(
        onTap: () {
          launch(video.url);
        },
        child: Column(
          children: [
            Card(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 7.0),
                padding: EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Image.network(
                        video.thumbnail.small.url ?? '',
                        width: 120.0,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            video.title,
                            softWrap: true,
                            style: TextStyle(fontSize: 18.0.sp),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
