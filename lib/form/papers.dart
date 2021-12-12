import 'base_widget/widget.dart';
export 'base_widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

typedef _VideoPaperKey = GlobalKey<_VideoPaperState>;

class _VideoPaper extends StatefulWidget implements BaseWidget {
  late final _VideoPaperKey _key;
  late final String _url;
  _VideoPaper({required _VideoPaperKey key, required String url})
      : super(key: key) {
    _key = key;
    _url = url;
  }
  @override
  int? score() {
    return _key.currentState?.a;
  }

  @override
  State<_VideoPaper> createState() => _VideoPaperState();
}

class _VideoPaperState extends State<_VideoPaper> {
  int a = 4;
  int? select;
  late VideoPlayerController _controller;
  late final String url;
  IconData playstate = Icons.play_arrow;
  final selects = ["A", "B", "C", "D"];
  @override
  void initState() {
    super.initState();
    url = widget._url;
    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Stack(alignment: Alignment.bottomCenter, children: <Widget>[
        _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
        VideoProgressIndicator(_controller, allowScrubbing: true),
        ClosedCaption(text: _controller.value.caption.text),
        IconButton(
          icon: Icon(playstate),
          onPressed: () {
            setState(() {
              if (_controller.value.isPlaying) {
                _controller.pause();
                playstate = Icons.play_arrow;
              } else {
                _controller.play();
                playstate = Icons.stop;
              }
            });
          },
        ),
      ]),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: selects
            .asMap()
            .map((i, item) => MapEntry(
                i,
                Checkbox(
                  value: i == select,
                  onChanged: (val) {
                    setState(() {
                      select = i;
                    });
                  },
                )))
            .values
            .toList(),
      )
    ]);
  }
}

class VideoUrl implements FromUrl {
  final String url;
  const VideoUrl(this.url);
  @override
  String geturl() {
    return url;
  }
}

_VideoPaper videopaper({required String url}) =>
    _VideoPaper(key: GlobalKey(), url: url);
typedef _TextPaperKey = GlobalKey<_TextPaperState>;

class _TextPaper extends StatefulWidget implements BaseWidget {
  late final _TextPaperKey _key;
  late final String _url;
  _TextPaper({required _TextPaperKey key, required String url})
      : super(key: key) {
    _key = key;
    _url = url;
  }
  @override
  int? score() {
    _key.toString();
    return 2;
  }

  @override
  State<_TextPaper> createState() => _TextPaperState();
}

class _TextPaperState extends State<_TextPaper> {
  late final String url;
  @override
  void initState() {
    super.initState();
    url = widget._url;
  }

  @override
  Widget build(BuildContext context) {
    return Text(url);
  }
}

_TextPaper textpaper({required String url}) =>
    _TextPaper(key: GlobalKey(), url: url);

class TextUrl implements FromUrl {
  final String url;
  const TextUrl(this.url);
  @override
  String geturl() {
    return url;
  }
}
