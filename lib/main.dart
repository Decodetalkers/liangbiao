import 'package:flutter/material.dart';
import 'form/papers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(
        title: 'Flutter Demo Home Page',
        urls: [
          VideoUrl("sssss"),
          VideoUrl("ttttt"),
          TextUrl("aaaaa"),
          TextUrl("bbbbb"),
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.urls})
      : super(key: key);
  final String title;
  final List<FromUrl> urls;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<BaseWidget> inside = [];
  int _counter = 0;
  @override
  void initState() {
    super.initState();
    for (final url in widget.urls) {
      if (url is VideoUrl) {
        inside.add(videopaper(url: url.geturl()));
      } else {
        inside.add(textpaper(url: url.geturl()));
      }
    }
  }

  void _incrementCounter() {
    setState(() {
      for (BaseWidget ainside in inside) {
        int? d = ainside.score();
        if (d != null) {
          _counter += d;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            for (final item in inside) item,
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.pages), label: '设置'),
        ],
        currentIndex: 0,
        fixedColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
