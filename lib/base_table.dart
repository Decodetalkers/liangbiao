import 'package:flutter/material.dart';
import 'form/papers.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'utils.dart';

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
  const BaseTable(
      {Key? key, required this.title, required this.urls, required this.id})
      : super(key: key);
  final String title;
  final List<FromUrl> urls;
  final String? id;
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
        centerTitle: true,
        title: Text(
          "$localpage / $length",
          textAlign: TextAlign.center,
        ),
      ),
      body: Center(
          child: Stack(children: [
        PageView(
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
            Column(children: [
              const SizedBox(
                height: 150,
              ),
              SizedBox(
                  width: 600,
                  height: 200,
                  child: Text(
                    "Finish,score is ${score * 100 / (3 * length)}",
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
            ])
          ],
        ),
        Container(
          alignment: Alignment.topCenter,
          child: LinearProgressIndicator(
            value: localpage / length,
            semanticsLabel: 'Linear progress indicator',
            color: Colors.green,
          ),
        ),
      ])),
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
            var finalscore = score * 100 / (3 * length);
            if (widget.id != null) {
              await http.post(
                Uri.parse("$serveurl/receive"),
                headers: {
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode({
                  "name": widget.id!,
                  "id": widget.title,
                  "score": finalscore,
                  "duration": duration,
                }),
              );
            }
            if (!mounted) return;
            Navigator.pop(context);
          }
        },
        tooltip: 'Increment',
        child: localpage < length
            ? const Icon(Icons.arrow_right)
            : const Icon(Icons.arrow_upward),
      ),
    );
  }
}
