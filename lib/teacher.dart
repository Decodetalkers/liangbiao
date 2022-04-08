import 'package:flutter/material.dart';
import 'package:liangbiao/utils.dart';
import 'http_get/get_menu.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';

class TeacherPage extends StatelessWidget {
  const TeacherPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Historys>?>(
        future: fetchHistory("$serveurl/allhistory"),
        builder:
            (BuildContext context, AsyncSnapshot<List<Historys>?> snapshot) {
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
            return RadarChart.dark(
              ticks: const [0, 20, 40, 60, 80, 100],
              features: const ["a", "b", "c", "d"],
              data: [scores],
              useSides: true,
            );
            //return const Text("Beat");
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
