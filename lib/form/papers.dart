import 'base_widget/widget.dart';
import 'package:flutter/material.dart';
typedef VideoPaperKey = GlobalKey<_VideoPaperState>;
class VideoPaper extends StatefulWidget implements BaseWidget {
	late final VideoPaperKey _key;
	VideoPaper({required VideoPaperKey key}) : super(key:key){
		_key = key;
	}
	@override
	int score() {
		_key.toString();
		return 0;
	}
	@override
	State<VideoPaper> createState() => _VideoPaperState();
}
class _VideoPaperState extends State<VideoPaper> {
	@override
	Widget build(BuildContext context) {
		return const Text("ssss");
	}
}
typedef TextPaperKey = GlobalKey<_TextPaperState>;
class TextPaper extends StatefulWidget implements BaseWidget {
	late final TextPaperKey _key;
	TextPaper({required TextPaperKey key}): super(key:key){
		_key = key;
	}
	@override
	int score() {
		_key.toString();
		return 0;
	}
	@override
	State<TextPaper> createState() => _TextPaperState();
}
class _TextPaperState extends State<TextPaper> {
	@override
	Widget build(BuildContext context) {
		return const Text('ssssssss');
	}
}
