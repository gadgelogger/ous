import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:shake/shake.dart';
import 'package:provider/provider.dart';
import 'package:ous/test.dart';

class Music extends StatefulWidget {
  const Music({Key? key}) : super(key: key);

  @override
  State<Music> createState() => _MusicState();
}

class _MusicState extends State<Music> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/kouka.mp3');
    _controller.initialize().then((_) {
      // 最初のフレームを描画するため初期化後に更新
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

//ここから書く
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeModel>(
      create: (_) => HomeModel()..shakeGesture(context),
      child: Consumer<HomeModel>(builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text('校歌'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Image.network(
                      'https://www.ous.ac.jp/common/files/100/gakka.gif'),
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: (){
                    launch('https://twitter.com/music_genki');
                  },
                  child: Text('楽曲\n@music_genki',textAlign: TextAlign.center,),
                ),
              ),
              VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                colors: new VideoProgressColors(
                  playedColor: Theme.of(context).colorScheme.primary,
                  bufferedColor: Colors.black26,
                  backgroundColor: Colors.black26,
                ),
              ),
              _ProgressText(controller: _controller),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _controller
                          .seekTo(Duration.zero)
                          .then((_) => _controller.play());
                    },
                    child: Icon(Icons.refresh, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                      backgroundColor: Theme.of(context).colorScheme.primary, // <-- Button color
                      foregroundColor: Colors.red, // <-- Splash color
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _controller
                          .seekTo(Duration.zero)
                          .then((_) => _controller.play());
                    },
                    child: Icon(Icons.play_arrow, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                      backgroundColor: Theme.of(context).colorScheme.primary, // <-- Button color
                      foregroundColor: Colors.red, // <-- Splash color
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _controller
                          .seekTo(Duration.zero)
                          .then((_) => _controller.pause());
                    },
                    child: Icon(Icons.pause, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                      backgroundColor: Theme.of(context).colorScheme.primary, // <-- Button color
                      foregroundColor: Colors.red, // <-- Splash color
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _ProgressText extends StatefulWidget {
  final VideoPlayerController controller;

  const _ProgressText({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  __ProgressTextState createState() => __ProgressTextState();
}

class __ProgressTextState extends State<_ProgressText> {
  late VoidCallback _listener;

  __ProgressTextState() {
    _listener = () {
      setState(() {});
    };
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_listener);
  }

  @override
  void deactivate() {
    widget.controller.removeListener(_listener);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final String position = widget.controller.value.position.toString();
    final String duration = widget.controller.value.duration.toString();
    return Text('$position / $duration');
  }
}

//端末を振った際に起こる動作の関数
class HomeModel extends ChangeNotifier {
  shakeGesture(BuildContext context) {
    ShakeDetector.autoStart(
      onPhoneShake: () {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text('陬上Γ繝九Η繝ｼ縺ｫ蜈･繧翫∪縺'),
                actions: [
                  ElevatedButton(
                    child: Text('オ????ー'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Test()),
                      );
                    },
                  ),
                ],
              );
            });
      },
      minimumShakeCount: 10,
    );
  }
}
