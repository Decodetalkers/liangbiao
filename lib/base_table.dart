import 'package:flutter/material.dart';
import 'form/papers.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'utils.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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
      {Key? key,
      required this.title,
      required this.urls,
      required this.id,
      required this.tabletype})
      : super(key: key);
  final String tabletype;
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
      // example show message
      body: Center(
          child: Stack(children: [
        Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/bubble.jpg"),
                fit: BoxFit.cover,
              ),
            ),
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
              children: [
                for (final item in inside)
                  SingleChildScrollView(
                    child: item,
                  ),
                Column(children: [
                  const SizedBox(
                    height: 150,
                  ),
                  const Image(image: AssetImage('images/scoreshow.png')),
                  SizedBox(
                      width: 600,
                      height: 200,
                      child: Text(
                        (score * 100 / (3 * length)).toStringAsFixed(2),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  const SizedBox(
                      width: 600,
                      height: 100,
                      child: Text(
                        "Duration",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  Expanded(
                      child: charts.BarChart(
                    [
                      charts.Series<int, String>(
                          id: "time",
                          colorFn: (datanum, index) =>
                              charts.MaterialPalette.blue.shadeDefault,
                          domainFn: (datum, index) => index.toString(),
                          measureFn: (datum, index) => datum,
                          data: duration)
                    ],
                    animate: true,
                  ))
                ])
              ],
            )),
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
                  "tabletype": widget.tabletype,
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
