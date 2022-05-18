// 需要加一個background
// 老師的pages

import 'package:flutter/material.dart';
import 'package:liangbiao/loginpage.dart';
import 'package:liangbiao/teacher.dart';
import 'utils.dart';
import 'personpage.dart';
import 'student.dart';
import 'persionmessage.dart';
import 'http_get/get_menu.dart';

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
        primarySwatch: Colors.purple,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  final titles = ["量表一", "量表二", "量表三", "量表四", "量表五", "量表六", "量表七", "量表八"];
  //final times = ["2022.1.10", "2022.1.20", "2022.1.30", "2022.1.31","2022.6.4","2022.7.7"];
  //final List<String> times = [];
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late List<String> titles;
  //late List<String> times;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  int _index = 0;
  // This is the page of the first page, If you are a student , It will be the first one, else, second one
  late List<Widget?> mainpages;
  Widget? personpage;
  int _mainpageindex = 0;
  bool _logined = false;
  final List<String> _mainpagename = ["主页", "设置"];
  User? loginer;
  @override
  void initState() {
    super.initState();
    titles = widget.titles;
    //times = widget.times;
    var pageone = FutureBuilder<List<FoldTable>?>(
        future: fetchFolds("$serveurl/folds"),
        builder:
            (BuildContext context, AsyncSnapshot<List<FoldTable>?> snapshot) {
          if (snapshot.hasData) {
            List<String> times = [];
            if (snapshot.data != null) {
              times = snapshot.data!.map((e) => e.id).toList();
            }
            //return const Text("Beat");
            return StudentPage(
              times: times,
              titles: titles,
              id: null,
              refreshIndicatorKey: _refreshIndicatorKey,
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
    mainpages = [pageone, null];
  }

  @override
  Widget build(BuildContext context) {
    void navigateAndDisplaySelection(BuildContext context) async {
      // Navigator.push returns a Future that completes after calling
      // Navigator.pop on the Selection Screen.
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      if (result != null) {
        result as Message;
        setState(() {
          _logined = true;
          _index = 1;
          if (result.person == User.student) {
            _mainpageindex = 0;
            loginer = User.student;
						mainpages[0] = StudentMainPage(id: result.id, titles: titles, refreshIndicatorKey: _refreshIndicatorKey);            //mainpages[1] = StudentPersonPage(id: result.id);
            personpage = StudentPersonPage(id: result.id);
          } else {
            _mainpageindex = 1;
            loginer = User.teacher;
            mainpages[1] =
                TeacherPage(refreshIndicatorKey: _refreshIndicatorKey);
            personpage = TeacherPersonPage(id: result.id);
          }
        });

      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_mainpagename[_index]),
        actions: [
          if (_logined == true)
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
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
                                  const Text('Modal BottomSheet'),
                                  ElevatedButton(
                                      child: const Text('sure'),
                                      onPressed: () {
                                        setState(() {
                                          _mainpageindex = 0;
                                          _logined = false;
                                          _index = 0;
                                          loginer = null;
                                          mainpages[1] = null;
                                          personpage = null;
                                        });
                                        Navigator.pop(context);
                                      }),
                                  ElevatedButton(
                                      child: const Text('Cancer'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      })
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: const Icon(Icons.logout),
                ))
          else
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
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
                                  const Text('Login'),
                                  ElevatedButton(
                                      child: const Text('登陆'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        navigateAndDisplaySelection(context);
                                      }),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: Row(children: const [
                    Icon(Icons.login),
                    Text("登陸"),
                  ]),
                ))
        ],
      ),
      body: [mainpages[_mainpageindex], personpage][_index],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.pages), label: '设置'),
        ],
        currentIndex: _index,
        fixedColor: Colors.purple,
        onTap: (int index) {
          if (_logined == true) {
            setState(() {
              _index = index;
            });
          } else {
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
                          const Text('Login'),
                          ElevatedButton(
                              child: const Text('登陆'),
                              onPressed: () {
                                Navigator.pop(context);
                                navigateAndDisplaySelection(context);
                              }),
                        ],
                      ),
                    ),
                  );
                });
          }
        },
      ),
      floatingActionButton: _index == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                // Show refresh indicator programmatically on button tap.
                _refreshIndicatorKey.currentState?.show();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
            )
          : null,
    );
  }
}
