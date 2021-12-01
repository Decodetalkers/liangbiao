import 'base_widget/widget.dart';
export 'base_widget/widget.dart';
import 'package:flutter/material.dart';

typedef VideoPaperKey = GlobalKey<_VideoPaperState>;

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
  State<VideoPaper> createState() => _VideoPaperState();
}

class _VideoPaperState extends State<VideoPaper> {
  int a = 2;
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

class VideoUrl implements FromUrl {
  final String url;
  const VideoUrl(this.url);
  @override
  String geturl() {
    return url;
  }
}

typedef TextPaperKey = GlobalKey<_TextPaperState>;

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
    _key.toString();
    return 2;
  }

  @override
  State<TextPaper> createState() => _TextPaperState();
}

class _TextPaperState extends State<TextPaper> {
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

class TextUrl implements FromUrl {
  final String url;
  const TextUrl(this.url);
  @override
  String geturl() {
    return url;
  }
}
