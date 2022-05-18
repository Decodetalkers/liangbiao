import 'package:flutter/material.dart';
import 'package:liangbiao/utils.dart';
//import 'http_get/get_menu.dart';
//import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'dart:convert';

import 'history.dart';
import 'package:http/http.dart' as http;

Future<http.Response> deletehelp(String name) {
  return http.post(
    Uri.parse("$serveurl/finishhelp"),
    body: name,
  );
}

Future<List<String>?> fetchHelps(String url) async {
  var menuget = await http.get(Uri.parse(url));
  if (menuget.statusCode == 200) {
    var json = jsonDecode(menuget.body);
    return (json as List).map((e) => e["id"].toString()).toList();
  } else {
    return null;
  }
}

class TeacherFlashPage extends StatefulWidget {
  final List<String> forhelpers;
  const TeacherFlashPage({Key? key, required this.forhelpers})
      : super(key: key);
  @override
  TeacherFlashPageState createState() => TeacherFlashPageState();
}

class TeacherFlashPageState extends State<TeacherFlashPage> {
  late List<String> forhelpers;
  @override
  void initState() {
    super.initState();
    forhelpers = widget.forhelpers;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {
          var newhelpers = await fetchHelps("$serveurl/gethelps");
          if (newhelpers != null) {
            setState(() {
              forhelpers = newhelpers;
            });
          }
        },
        child: ListView(
          children: forhelpers
              .map((id) => ListTile(
                    title: Text(
                      id,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    onLongPress: () {
                      showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 200,
                              color: Colors.amber,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const Text('Delete?'),
                                    ElevatedButton(
                                        child: const Text('Finish'),
                                        onPressed: () async {
                                          await deletehelp(id);
                                          setState(() {
                                            forhelpers.remove(id);
                                          });
                                          if (!mounted) return;
                                          Navigator.pop(context);
                                        }),
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HistoryPage(id: id)));
                    },
                  ))
              .toList(),
        ));
  }
}

class TeacherPage extends StatelessWidget {
  const TeacherPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>?>(
        future: fetchHelps("$serveurl/gethelps"),
        builder: (BuildContext context, AsyncSnapshot<List<String>?> snapshot) {
          if (snapshot.hasData) {
            return TeacherFlashPage(
                forhelpers: snapshot.data!); //return const Text("Beat");
            //return const Text("test");
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
            return Center(
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            );
          }
        });
  }
}
