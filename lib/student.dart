import 'package:flutter/material.dart';
import 'form/papers.dart';
import 'base_table.dart';
import 'package:quiver/iterables.dart';
import 'http_get/get_menu.dart';
class StudentPage extends StatefulWidget {
  final List<String> titles;
  final List<String> times;
  const StudentPage({Key? key, required this.times, required this.titles})
      : super(key: key);

  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  late List<String> titles;
  late List<String> times;
  //bool _showbottomsheet = true;
  @override
  void initState() {
    super.initState();
    titles = widget.titles;
    times = widget.times;
  }

  Future<void> _handrefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      titles = titles.reversed.toList();
      times = times.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: ListView(
            children: zip([titles, times])
                .map((e) => HomePageButton(
                      text: e[0],
                      date: e[1],
                      onPressed: () async {
												var output = await fetchMenu("http://localhost:3000/json/MjAyMi0wMy0xNCAxNTozMjoxMC4xMjMwMjE5NDYgVVRD");
												List<FromUrl> urls = [];
												if(output != null) {
													urls = output.map(
														(e) {
															if(e.filetype == "TXT"){
																return const TextUrl( "test");
															}else if(e.filetype == "Image") {
																return ImageUrl("http://localhost:3000/image/MjAyMi0wMy0xNCAxNTozMjoxMC4xMjMwMjE5NDYgVVRD\$${e.name}");
															}else {
																return VideoUrl("http://localhost:3000/image/MjAyMi0wMy0xNCAxNTozMjoxMC4xMjMwMjE5NDYgVVRD\$${e.name}");
															}
														}
													).toList();
												}
                        //setState(() {
                        //  _showbottomsheet = false;
                        //});
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BaseTable(
                                    title: 'Table',
                                    urls: urls, 
																		//[
                                    //  VideoUrl(
                                    //      'http://localhost:3000/image/MjAyMi0wMy0xNCAwODozMToyOC45ODc5MjExMjUgVVRD\$0.mp4'),
                                    //  VideoUrl(
                                    //      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
                                    //  TextUrl("aaaaa"),
                                    //  TextUrl("bbbbb"),
																		//	ImageUrl("http://localhost:3000/image/MjAyMi0wMy0xNCAwODozMToyOC45ODc5MjExMjUgVVRD\$2.png"),
                                    //],
                                  )),
                        );
                      },
                    ))
                .toList()),
        onRefresh: _handrefresh);
  }
}

typedef ClickCallback = void Function();

class HomePageButton extends StatefulWidget {
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
  State<HomePageButton> createState() => _HomePageButtonState();
}

class _HomePageButtonState extends State<HomePageButton> {
  Color color = Colors.white;
  void _inchangeColor() {
    setState(() {
      if (color == Colors.white) {
        color = Colors.grey;
      } else {
        color = Colors.white;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        border: Border.all(width: 30, color: color),
      ),
      child: GestureDetector(
        onTapDown: (_infomation) {
          _inchangeColor();
        },
        onTapUp: (_infomation) {
          _inchangeColor();
          widget.onPressed();
        },
        onTapCancel: _inchangeColor,
        child: RichText(
          text: TextSpan(children: [
            TextSpan(
                text: widget.text + "\n\n\n",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                )),
            TextSpan(
                text: widget.date,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                )),
          ]),
        ),
      ),
    );
  }
}
