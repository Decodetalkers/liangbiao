import 'package:flutter/material.dart';
import 'form/papers.dart';
import 'base_table.dart';
import 'package:quiver/iterables.dart';
import 'http_get/get_menu.dart';
import 'package:http/http.dart' as http;
import 'utils.dart';

Future<String?> _fetchTxt(String url) async {
  var menuget = await http.get(Uri.parse(url));
  if (menuget.statusCode == 200) {
    return menuget.body;
  } else {
    return null;
  }
}

class StudentPage extends StatefulWidget {
  final List<String> titles;
  final List<String> times;
  final String? id;
  const StudentPage(
      {Key? key, required this.times, required this.titles, required this.id})
      : super(key: key);

  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  late List<String> titles;
  late List<String> times;
  late String? id;
  //bool _showbottomsheet = true;
  @override
  void initState() {
    super.initState();
    titles = widget.titles;
    times = widget.times;
    id = widget.id;
  }

  Future<void> _handrefresh() async {
    //await Future.delayed(const Duration(seconds: 2));
    var output = await fetchFolds("$serveurl/folds");

    if (output != null) {
      List<String> times2 = output.map((e) => e.id).toList();
      setState(() {
        times = times2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: ListView(
            children: zip([titles, times])
                .map((message) => HomePageButton(
                      text: message[0],
                      date: message[1],
                      onPressed: () async {
                        var output =
                            await fetchMenu("$serveurl/json/${message[1]}");
                        List<FromUrl> urls = [];
                        if (output != null) {
                          for (var e in output) {
                            var index = urls.length;
                            if (e.filetype == "TXT") {
                              var txt = await _fetchTxt(
                                  "$serveurl/txt/${message[1]}\$${e.name}");
                              if (txt != null) {
                                urls.insert(index, TextUrl(txt));
                              } else {
                                urls.insert(index, const TextUrl("Not fond"));
                              }
                            } else if (e.filetype == "Image") {
                              urls.insert(
                                  index,
                                  ImageUrl(
                                      "$serveurl/image/${message[1]}\$${e.name}"));
                            } else {
                              urls.insert(
                                  index,
                                  VideoUrl(
                                      "$serveurl/image/${message[1]}\$${e.name}"));
                            }
                          }
                        }
                        //setState(() {
                        //  _showbottomsheet = false;
                        //});
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BaseTable(
                                    title: message[1],
                                    urls: urls,
                                    id: id,
                                  )),
                        );
                      },
                    ))
                .toList()),
        onRefresh: _handrefresh);
  }
}

typedef ClickCallback = void Function();

//class HomePageButton extends StatefulWidget {
//  const HomePageButton(
//      {Key? key,
//      required this.text,
//      required this.date,
//      required this.onPressed})
//      : super(key: key);
//  final String text;
//  final String date;
//  final ClickCallback onPressed;
//  @override
//  State<HomePageButton> createState() => _HomePageButtonState();
//}
class HomePageButton extends StatelessWidget {
  const HomePageButton(
      {Key? key,
      required this.text,
      required this.date,
      required this.onPressed})
      : super(key: key);
  final String text;
  final String date;
  final ClickCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        title: RichText(
            text: TextSpan(
          text: "\n$text\n\n",
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        )),
        subtitle: RichText(
            text: TextSpan(
          text: "id: $date\n",
          style: const TextStyle(
            fontSize: 10,
          ),
        )),
        onTap: onPressed,
      ),
      const SizedBox(
        height: 10,
      )
    ]);
  }
}
//class _HomePageButtonState extends State<HomePageButton> {
//  Color color = Colors.white;
//  void _inchangeColor() {
//    setState(() {
//      if (color == Colors.white) {
//        color = Colors.grey;
//      } else {
//        color = Colors.white;
//      }
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      decoration: BoxDecoration(
//        color: color,
//        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
//        border: Border.all(width: 30, color: color),
//      ),
//      child: GestureDetector(
//        onTapDown: (_infomation) {
//          _inchangeColor();
//        },
//        onTapUp: (_infomation) {
//          _inchangeColor();
//          widget.onPressed();
//        },
//        onTapCancel: _inchangeColor,
//        child: RichText(
//          text: TextSpan(children: [
//            TextSpan(
//                text: widget.text + "\n\n\n",
//                style: const TextStyle(
//                  color: Colors.black,
//                  fontSize: 21,
//                  fontWeight: FontWeight.w700,
//                )),
//            TextSpan(
//                text: widget.date,
//                style: const TextStyle(
//                  color: Colors.black,
//                  fontSize: 14,
//                  fontWeight: FontWeight.w400,
//                )),
//          ]),
//        ),
//      ),
//    );
//  }
//}
