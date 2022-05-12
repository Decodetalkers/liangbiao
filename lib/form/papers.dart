import 'base_widget/widget.dart';
export 'base_widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

typedef VideoPaperKey = GlobalKey<VideoPaperState>;

class VideoPaper extends StatefulWidget implements BaseWidget {
  late final VideoPaperKey _key;
  late final String _url;
  VideoPaper({required VideoPaperKey key, required String url})
      : super(key: key) {
    _key = key;
    _url = url;
  }
  @override
  int? score() {
    return _key.currentState?.a;
  }

  @override
  State<VideoPaper> createState() => VideoPaperState();
}

class VideoPaperState extends State<VideoPaper> {
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
      const Image(
        image: AssetImage('images/HIT.png'),
        //fit: BoxFit.fill,
      ),
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
      const SizedBox(
        height: 20,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: selects
            .asMap()
            .map((i, item) => MapEntry(
                i,
                Column(children: [
                  Container(
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.purple,
                              blurRadius: 4,
                              offset: Offset(4, 8))
                        ],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: SizedBox(
                          height: 100,
                          width: 300,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0)),
                              primary:
                                  select == i ? Colors.white : Colors.black,
                              padding: EdgeInsets.zero,
                              backgroundColor:
                                  select == i ? Colors.purple : Colors.white,
                              //backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                select = i;
                                a = i;
                              });
                            },
                            child: Container(
                              alignment: AlignmentDirectional.centerStart,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 24, horizontal: 28),
                              child: Text(
                                item,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ))),
                  const SizedBox(
                    height: 20,
                  )
                ])))
            .values
            .toList(),
      ),
      const SizedBox(
        height: 100,
      ),
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

VideoPaper videopaper({required String url}) =>
    VideoPaper(key: GlobalKey(), url: url);
typedef TextPaperKey = GlobalKey<TextPaperState>;

class TextPaper extends StatefulWidget implements BaseWidget {
  late final TextPaperKey _key;
  late final String _url;
  TextPaper({required TextPaperKey key, required String url})
      : super(key: key) {
    _key = key;
    _url = url;
  }
  @override
  int? score() {
    return _key.currentState?.a;
  }

  @override
  State<TextPaper> createState() => TextPaperState();
}

class TextPaperState extends State<TextPaper> {
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
        //const SizedBox(
        //  height: 100,
        //),
        const Image(
          image: AssetImage('images/HIT.png'),
          //fit: BoxFit.fill,
        ),
        const SizedBox(
          height: 50,
        ),
        SizedBox(
            width: 400,
            height: 200,
            child: Text(
              url,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            )),
        const SizedBox(
          height: 20,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: selects
              .asMap()
              .map((i, item) => MapEntry(
                  i,
                  Column(children: [
                    Container(
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.purple,
                                blurRadius: 4,
                                offset: Offset(4, 8))
                          ],
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: SizedBox(
                            height: 100,
                            width: 300,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                primary:
                                    select == i ? Colors.white : Colors.black,
                                padding: EdgeInsets.zero,
                                backgroundColor:
                                    select == i ? Colors.purple : Colors.white,
                                //backgroundColor: Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  select = i;
                                  a = i;
                                });
                              },
                              child: Container(
                                alignment: AlignmentDirectional.centerStart,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 24, horizontal: 28),
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ))),
                    const SizedBox(
                      height: 20,
                    )
                  ])))
              .values
              .toList(),
        ),
        const SizedBox(
          height: 100,
        ),
      ],
    );
  }
}

TextPaper textpaper({required String url}) =>
    TextPaper(key: GlobalKey(), url: url);

class TextUrl implements FromUrl {
  final String url;
  const TextUrl(this.url);
  @override
  String geturl() {
    return url;
  }
}

typedef ImagePaperKey = GlobalKey<ImagePaperState>;

class ImagePaper extends StatefulWidget implements BaseWidget {
  late final ImagePaperKey _key;
  late final String _url;
  ImagePaper({required ImagePaperKey key, required String url})
      : super(key: key) {
    _key = key;
    _url = url;
  }
  @override
  int? score() {
    return _key.currentState?.a;
  }

  @override
  State<ImagePaper> createState() => ImagePaperState();
}

class ImagePaperState extends State<ImagePaper> {
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
        const Image(
          image: AssetImage('images/HIT.png'),
          //fit: BoxFit.fill,
        ),
        //FittedBox(
        //	fit:BoxFit.fitWidth,
        //	child: Image.asset('images/HIT.jpg'),
        //),
        Image.network(url),
        const SizedBox(
          height: 20,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: selects
              .asMap()
              .map((i, item) => MapEntry(
                  i,
                  Column(children: [
                    Container(
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.purple,
                                blurRadius: 4,
                                offset: Offset(4, 8))
                          ],
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: SizedBox(
                            height: 100,
                            width: 300,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                primary:
                                    select == i ? Colors.white : Colors.black,

                                padding: EdgeInsets.zero,
                                backgroundColor:
                                    select == i ? Colors.purple : Colors.white,
                                //backgroundColor: Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  select = i;
                                  a = i;
                                });
                              },
                              child: Container(
                                alignment: AlignmentDirectional.centerStart,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 24, horizontal: 28),
                                child: Text(
                                  item,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ))),
                    const SizedBox(
                      height: 20,
                    )
                  ])))
              .values
              .toList(),
        ),
        const SizedBox(
          height: 100,
        ),
      ],
    );
  }
}

ImagePaper imagepaper({required String url}) =>
    ImagePaper(key: GlobalKey(), url: url);

class ImageUrl implements FromUrl {
  final String url;
  const ImageUrl(this.url);
  @override
  String geturl() {
    return url;
  }
}
