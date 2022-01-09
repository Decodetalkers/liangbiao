import 'package:flutter/material.dart';
import 'form/papers.dart';
import 'base_table.dart';
import 'package:quiver/iterables.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liangbiao',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  final titles = ["量表一", "量表二", "量表三", "量表四"];
  final times = ["2022.1.10", "2022.1.20", "2022.1.30"];
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<String> titles;
  late List<String> times;
  @override
  void initState() {
    super.initState();
    titles = widget.titles;
    times = widget.times;
  }

  Future<void> _handrefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      titles = titles.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
      ),
      body: RefreshIndicator(
          child: ListView(
              children: zip([titles, times])
                  .map((e) => HomePageButton(
                        text: e[0],
                        date: e[1],
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BaseTable(
                                      title: 'Table',
                                      urls: [
                                        VideoUrl(
                                            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
                                        VideoUrl(
                                            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
                                        TextUrl("aaaaa"),
                                        TextUrl("bbbbb"),
                                      ],
                                    )),
                          );
                        },
                      ))
                  .toList()),
          onRefresh: _handrefresh),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.pages), label: '设置'),
        ],
        currentIndex: 0,
        fixedColor: Colors.blue,
      ),
    );
  }
}

typedef ClickCallback = void Function();

class HomePageButton extends StatefulWidget {
  const HomePageButton(
      {Key? key,
      required this.text,
      required this.date,
      required this.onPressed})
      : super(key: key);
  final String text;
  final String date;
  final ClickCallback onPressed;
  @override
  State<HomePageButton> createState() => _HomePageButtonState();
}

class _HomePageButtonState extends State<HomePageButton> {
  Color color = Colors.white;
  void _inchangeColor() {
    setState(() {
      if (color == Colors.white) {
        color = Colors.grey;
      } else {
        color = Colors.white;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        border: Border.all(width: 30, color: color),
      ),
      child: GestureDetector(
        onTapDown: (d) {
          _inchangeColor();
        },
        onTapUp: (d) {
          _inchangeColor();
          widget.onPressed();
        },
        child: RichText(
          text: TextSpan(children: [
            TextSpan(
                text: widget.text + "\n\n\n",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                )),
            TextSpan(
                text: widget.date,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                )),
          ]),
        ),
      ),
    );
  }
}
