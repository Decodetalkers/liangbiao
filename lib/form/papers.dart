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
  int a = -1;
  int? select;
  late VideoPlayerController _controller;
  late final String url;
  IconData playstate = Icons.play_arrow;
  final selects = ["非常符合", "比较符合", "较不符合", "很不符合"];
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
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: selects
            .asMap()
            .map((i, item) => MapEntry(
                i,
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Checkbox(
                        value: i == select,
                        onChanged: (val) {
                          setState(() {
                            select = i;
                            a = i;
                          });
                        },
                      ),
                      Text(item)
                    ])))
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
    return _key.currentState?.a;
  }

  @override
  State<_TextPaper> createState() => _TextPaperState();
}

class _TextPaperState extends State<_TextPaper> {
  late final String url;
  int a = -1;
  int? select;
  final selects = ["非常符合", "比较符合", "较不符合", "很不符合"];
  @override
  void initState() {
    super.initState();
    url = widget._url;
  }

  @override
  Widget build(BuildContext context) {
    //return Text(url);
    return Column(
      children: [
        Text(url),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: selects
              .asMap()
              .map((i, item) => MapEntry(
                  i,
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Checkbox(
                          value: i == select,
                          onChanged: (val) {
                            setState(() {
                              select = i;
                              a = i;
                            });
                          },
                        ),
                        Text(item)
                      ])))
              .values
              .toList(),
        )
      ],
    );
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

typedef _ImagePaperKey = GlobalKey<_ImagePaperState>;

class _ImagePaper extends StatefulWidget implements BaseWidget {
  late final _ImagePaperKey _key;
  late final String _url;
  _ImagePaper({required _ImagePaperKey key, required String url})
      : super(key: key) {
    _key = key;
    _url = url;
  }
  @override
  int? score() {
    return _key.currentState?.a;
  }

  @override
  State<_ImagePaper> createState() => _ImagePaperState();
}

class _ImagePaperState extends State<_ImagePaper> {
  late final String url;
  int a = -1;
  int? select;
  final selects = ["非常符合", "比较符合", "较不符合", "很不符合"];
  @override
  void initState() {
    super.initState();
    url = widget._url;
  }

  @override
  Widget build(BuildContext context) {
    //return Text(url);
    return Column(
      children: [
        Image.network(url),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: selects
              .asMap()
              .map((i, item) => MapEntry(
                  i,
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Checkbox(
                          value: i == select,
                          onChanged: (val) {
                            setState(() {
                              select = i;
                              a = i;
                            });
                          },
                        ),
                        Text(item)
                      ])))
              .values
              .toList(),
        )
      ],
    );
  }
}

_ImagePaper imagepaper({required String url}) =>
    _ImagePaper(key: GlobalKey(), url: url);

class ImageUrl implements FromUrl {
  final String url;
  const ImageUrl(this.url);
  @override
  String geturl() {
    return url;
  }
}
