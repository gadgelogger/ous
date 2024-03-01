// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Project imports:
import 'package:ous/apikey.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_api/youtube_api.dart';

class Movie extends StatefulWidget {
  const Movie({Key? key}) : super(key: key);

  @override
  State<Movie> createState() => _MovieState();
}

class _MovieState extends State<Movie> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  static String key = infoMovieKey;

  YoutubeAPI youtube = YoutubeAPI(
    key,
  );
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
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Center(
        child: (videoResult.isEmpty)
            ? const CircularProgressIndicator()
            : ListView(
                children: videoResult.map<Widget>(listItem).toList(),
              ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (await canLaunchUrl(
                Uri.parse('https://www.youtube.com/@user-ms9dw7xq5l/videos'))) {
              await launchUrl(
                  Uri.parse('https://www.youtube.com/@user-ms9dw7xq5l/videos'),
                  mode: LaunchMode.platformDefault);
            } else {
              throw 'Could not launch https://www.youtube.com/@user-ms9dw7xq5l/videos';
            }
          },
          child: const Icon(Icons.movie_creation_outlined)),
    );
  }

  Widget listItem(YouTubeVideo video) {
    return GestureDetector(
        onTap: () async {
          if (await canLaunchUrl(Uri.parse(video.url))) {
            await launchUrl(Uri.parse(video.url),
                mode: LaunchMode.platformDefault);
          } else {
            throw 'Could not launch ${video.url}';
          }
        },
        child: Column(
          children: [
            Card(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 7.0),
                padding: const EdgeInsets.all(12.0),
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
