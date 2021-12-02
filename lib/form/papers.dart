import 'base_widget/widget.dart';
export 'base_widget/widget.dart';
import 'package:flutter/material.dart';

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
_VideoPaper videopaper({required String url}) => _VideoPaper(key: GlobalKey(),url: url);
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

_TextPaper textpaper({required String url}) => _TextPaper(key: GlobalKey(),url: url);
class TextUrl implements FromUrl {
  final String url;
  const TextUrl(this.url);
  @override
  String geturl() {
    return url;
  }
}
