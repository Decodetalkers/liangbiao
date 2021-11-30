import 'base_widget/widget.dart';
import 'package:flutter/material.dart';
class Video extends StatefulWidget implements BaseWidget {
	const Video({required Key key}) : super(key:key);
	@override
	int score() {
		return 0;
	}
	@override
	State<Video> createState() =>_VideoState();
}
class _VideoState extends State<Video> {
	@override
	Widget build(BuildContext context) {
		return const Text("ssss");
	}
}
