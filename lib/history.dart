import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'utils.dart';

import 'package:fl_chart/fl_chart.dart' as charts;

class TimePage extends StatelessWidget {
  final List<int> duration;
  const TimePage({Key? key, required this.duration}) : super(key: key);
  charts.BarChartGroupData generateGroupData(int x, int y) {
    return charts.BarChartGroupData(
      x: x,
      barRods: [charts.BarChartRodData(toY: y.toDouble())],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Duration"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(40),
            child: charts.BarChart(charts.BarChartData(
                barGroups: duration
                    .asMap()
                    .map((key, value) =>
                        MapEntry(key, generateGroupData(key, value)))
                    .values
                    .toList()))));
  }
}

class HistoryPage extends StatelessWidget {
  final String id;
  const HistoryPage({Key? key, required this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
      ),
      body: MyStatefulWidget(id: id),
    );
  }
}

class Score {
  final String id;
  final String tabletype;
  final double score;
  final List<int> duration;
  Score({
    required this.id,
    required this.score,
    required this.tabletype,
    required this.duration,
  });
  factory Score.fromJson(dynamic json) => Score(
      id: json["id"],
      tabletype: json["tabletype"],
      score: json["score"],
      duration: List<int>.from(json["duration"] as List));
}

Future<List<Score>> fetchhistory(String input) async {
  var historyget = await http.post(
    Uri.parse("$serveurl/history"),
    body: input,
  );
  if (historyget.statusCode == 200) {
    var json = jsonDecode(historyget.body);
    return (json as List).map((e) => Score.fromJson(e)).toList();
  } else {
    throw "Nothing";
  }
}

class MyStatefulWidget extends StatefulWidget {
  final String id;
  const MyStatefulWidget({Key? key, required this.id}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2!,
      textAlign: TextAlign.center,
      child: FutureBuilder<List<Score>>(
        future: fetchhistory(
            widget.id), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<List<Score>> snapshot) {
          Widget output;
          if (snapshot.hasData) {
            var data = snapshot.data!;
            List<double> scores = [0, 0, 0, 0];
            List<int> length = [0, 0, 0, 0];
            for (var ascore in data) {
              switch (ascore.tabletype) {
                case 'a':
                  scores[0] = scores[0] + ascore.score;
                  length[0] = length[0] + 1;
                  break;
                case 'b':
                  scores[1] = scores[1] + ascore.score;
                  length[1] = length[1] + 1;
                  break;
                case 'c':
                  scores[2] = scores[2] + ascore.score;
                  length[2] = length[2] + 1;
                  break;
                case 'd':
                  scores[3] = scores[3] + ascore.score;
                  length[3] = length[3] + 1;
                  break;
                default:
              }
            }
            for (var i = 0; i < 4; i++) {
              if (length[i] != 0) {
                scores[i] = scores[i] / length[i];
              }
            }

            output = Column(children: [
              Expanded(
                  child: RadarChart.light(
                ticks: const [0, 20, 40, 60, 80, 100],
                features: const ["a", "b", "c", "d"],
                data: [scores],
                useSides: true,
              )),
              Expanded(
                  child: ListView(
                children: (data)
                    .map((e) => ListTile(
                          title: Text(e.id),
                          subtitle: Text(
                              "score = ${e.score}   tabletype = ${e.tabletype}"),
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TimePage(
                                        duration: e.duration,
                                      )),
                            );
                          },
                        ))
                    .toList(),
              ))
            ]);
          } else if (snapshot.hasError) {
            List<Widget> children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
            output = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            );
          } else {
            List<Widget> children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ];
            output = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            );
          }
          return output;
        },
      ),
    );
  }
}
