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
  //int _counter = 0;
  late int length;
  int localpage = 0;
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

  //void _incrementCounter() {
  //  setState(() {
  //    for (BaseWidget ainside in inside) {
  //      int? d = ainside.score();
  //      if (d != null) {
  //        _counter += d;
  //      }
  //    }
  //  });
  //}
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
          //mainAxisAlignment: MainAxisAlignment.center,
          //children: <Widget>[
          //  //const Text(
          //  //  'You have pushed the button this many times:',
          //  //),
          //  Expanded(
          //      child: ListView(children: [
          //    for (final item in inside) item,
          //    Text(
          //      '$_counter',
          //      style: Theme.of(context).textTheme.headline4,
          //    ),
          //  ])),
          //],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (localpage < length) {
            if (inside[localpage].score() != null &&
                inside[localpage].score()! >= 0) {
              controller.jumpToPage(localpage + 1);
            }
          } else {
            Navigator.pop(context);
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
