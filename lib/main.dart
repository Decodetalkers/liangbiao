import 'package:flutter/material.dart';
import 'personpage.dart';
import 'student.dart';

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
  final times = ["2022.1.10", "2022.1.20", "2022.1.30", "2022.1.31"];
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<String> titles;
  late List<String> times;
  int _index = 0;
  late List<Widget?> mainpages;
  Widget? personpage;
  int _mainpageindex = 0;
  bool _logined = false;
  User loginer = User.other;
  @override
  void initState() {
    super.initState();
    titles = widget.titles;
    times = widget.times;
    mainpages = [StudentPage(titles: titles, times: times), null];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('量表'),
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
                                          _logined = false;
                                          _index = 0;
                                          loginer = User.other;
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
                  child: const Icon(Icons.exit_to_app),
                )),
        ],
      ),
      body: [mainpages[_mainpageindex], personpage][_index],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.pages), label: '设置'),
        ],
        currentIndex: _index,
        fixedColor: Colors.blue,
        onTap: (int index) {
          if (_logined == true || index == 0) {
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
                          const Text('Modal BottomSheet'),
                          ElevatedButton(
                              child: const Text('Student'),
                              onPressed: () {
                                setState(() {
                                  _logined = true;
                                  _index = 1;
                                  loginer = User.student;
                                  mainpages[1] = const StudentPersonPage();
                                  personpage = const StudentPersonPage();
                                });
                                Navigator.pop(context);
                              }),
                          ElevatedButton(
                              child: const Text('Teacher'),
                              onPressed: () {
                                setState(() {
                                  _logined = true;
                                  _index = 1;
                                  loginer = User.teacher;
                                  mainpages[1] = const TeacherPersonPage();
                                  personpage = const TeacherPersonPage();
                                });
                                Navigator.pop(context);
                              })
                        ],
                      ),
                    ),
                  );
                });
          }
        },
      ),
      //bottomSheet: _showBottomSheet(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_mainpageindex == 0) {
              _mainpageindex = 1;
            } else {
              _mainpageindex = 0;
            }
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
