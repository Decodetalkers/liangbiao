import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

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
  final double score;
  Score({
    required this.id,
    required this.score,
  });
  factory Score.fromJson(dynamic json) =>
      Score(id: json["id"], score: json["score"]);
}

Future<List<Score>> fetchhistory(String input) async {
  var historyget = await http.post(
    Uri.parse("http://127.0.0.1:3000/history"),
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
            output = ListView(
              children: (snapshot.data!)
                  .map((e) => ListTile(
                        title: Text(e.id),
                        subtitle: Text("score = ${e.score}"),
                      ))
                  .toList(),
            );
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
