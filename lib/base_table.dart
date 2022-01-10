import 'package:flutter/material.dart';
import 'form/papers.dart';

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
            //const Text(
            //  'You have pushed the button this many times:',
            //),
            Expanded(
                child: ListView(children: [
              for (final item in inside) item,
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
            ])),
          ],
        ),
      ),
      //bottomNavigationBar: BottomNavigationBar(
      //  items: const <BottomNavigationBarItem>[
      //    BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
      //    BottomNavigationBarItem(icon: Icon(Icons.pages), label: '设置'),
      //  ],
      //  currentIndex: 0,
      //  fixedColor: Colors.blue,
      //),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
