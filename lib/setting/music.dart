// Flutter imports:
import 'package:flutter/material.dart';
// Project imports:
import 'package:ous/test.dart';
// Package imports:
import 'package:provider/provider.dart';
import 'package:shake/shake.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

//端末を振った際に起こる動作の関数
class HomeModel extends ChangeNotifier {
  shakeGesture(BuildContext context) {
    ShakeDetector.autoStart(
      onPhoneShake: () {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text('陬上Γ繝九Η繝ｼ縺ｫ蜈･繧翫∪縺'),
              actions: [
                ElevatedButton(
                  child: const Text('オ????ー'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Test()),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
      minimumShakeCount: 10,
    );
  }
}

class Music extends StatefulWidget {
  const Music({Key? key}) : super(key: key);

  @override
  State<Music> createState() => _MusicState();
}

class __ProgressTextState extends State<_ProgressText> {
  late VoidCallback _listener;

  __ProgressTextState() {
    _listener = () {
      setState(() {});
    };
  }

  @override
  Widget build(BuildContext context) {
    final String position = widget.controller.value.position.toString();
    final String duration = widget.controller.value.duration.toString();
    return Text('$position / $duration');
  }

  @override
  void deactivate() {
    widget.controller.removeListener(_listener);
    super.deactivate();
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_listener);
  }
}

class _MusicState extends State<Music> {
  late VideoPlayerController _controller;

  //ここから書く
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeModel>(
      create: (_) => HomeModel()..shakeGesture(context),
      child: Consumer<HomeModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: const Text('校歌'),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Image.network(
                      'https://www.ous.ac.jp/common/files/100/gakka.gif',
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      launch('https://twitter.com/music_genki');
                    },
                    child: const Text(
                      '楽曲\n@music_genki',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                  colors: VideoProgressColors(
                    playedColor: Theme.of(context).colorScheme.primary,
                    bufferedColor: Colors.black26,
                    backgroundColor: Colors.black26,
                  ),
                ),
                _ProgressText(controller: _controller),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _controller
                            .seekTo(Duration.zero)
                            .then((_) => _controller.play());
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary, // <-- Button color
                        foregroundColor: Colors.red, // <-- Splash color
                      ),
                      child: const Icon(Icons.refresh, color: Colors.white),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _controller
                            .seekTo(Duration.zero)
                            .then((_) => _controller.play());
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary, // <-- Button color
                        foregroundColor: Colors.red, // <-- Splash color
                      ),
                      child: const Icon(Icons.play_arrow, color: Colors.white),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _controller
                            .seekTo(Duration.zero)
                            .then((_) => _controller.pause());
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary, // <-- Button color
                        foregroundColor: Colors.red, // <-- Splash color
                      ),
                      child: const Icon(Icons.pause, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/kouka.mp3');
    _controller.initialize().then((_) {
      // 最初のフレームを描画するため初期化後に更新
      setState(() {});
    });
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
