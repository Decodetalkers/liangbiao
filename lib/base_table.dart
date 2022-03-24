import 'package:flutter/material.dart';
import 'form/papers.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PopTablePage extends StatelessWidget {
  final BaseTable table;
  const PopTablePage({Key? key, required this.table}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tabel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: table,
    );
  }
}

class BaseTable extends StatefulWidget {
  const BaseTable({Key? key, required this.title, required this.urls})
      : super(key: key);
  final String title;
  final List<FromUrl> urls;
  @override
  State<BaseTable> createState() => _BaseTableState();
}

class _BaseTableState extends State<BaseTable> {
  List<BaseWidget> inside = [];
  //int _counter = 0;
  late int length;
  int localpage = 0;
  int score = 0;
  DateTime start = DateTime.now();
  List<int> duration = [];
  @override
  void initState() {
    super.initState();
    for (final url in widget.urls) {
      if (url is VideoUrl) {
        inside.add(videopaper(url: url.geturl()));
      } else if (url is TextUrl) {
        inside.add(textpaper(url: url.geturl()));
      } else {
        inside.add(imagepaper(url: url.geturl()));
      }
    }
    length = inside.length;
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            var time = DateTime.now();
            //print("time is ${time.difference(start).inMilliseconds}");
            setState(() {
              duration.insert(
                  duration.length, time.difference(start).inMilliseconds);
              start = time;
              localpage = index;
            });
          },
          physics: const NeverScrollableScrollPhysics(),
          children:
              //inside.map((e) => SingleChildScrollView(child: e)).toList(),
              [
            for (final item in inside) SingleChildScrollView(child: item),
            const Text("Finish")
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (localpage < length) {
            if (inside[localpage].score() != null &&
                inside[localpage].score()! >= 0) {
              setState(() {
                score += inside[localpage].score()!;
              });
              controller.jumpToPage(localpage + 1);
            }
          } else {
            await http.post(
              Uri.parse("http://127.0.0.1:3000/receive"),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode({
                "id": widget.title,
                "score": score,
                "duration": duration,
              }),
            );
            Navigator.pop(context);
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
