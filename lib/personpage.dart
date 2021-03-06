import 'package:flutter/material.dart';
import 'history.dart';
import 'package:http/http.dart' as http;
import './utils.dart';

Future<http.Response> findhelp(String name) {
  return http.post(
    Uri.parse("$serveurl/findhelp"),
    body: name,
  );
}

class StudentPersonPage extends StatelessWidget {
  final String id;
  const StudentPersonPage({Key? key, required this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      //Stack(
      //  alignment: Alignment.center,
      //  children: [
      Container(
          alignment: Alignment.center,
          child: const CircleAvatar(
            backgroundImage: AssetImage('images/student.png'),
            radius: 100,
          )),
      //    Container(
      //      decoration: const BoxDecoration(
      //        color: Colors.black45,
      //      ),
      //      child: const Text(
      //        'Mia B',
      //        style: TextStyle(
      //          fontSize: 20,
      //          fontWeight: FontWeight.bold,
      //          color: Colors.white,
      //        ),
      //      ),
      //    ),
      //  ],
      //),
      Card(
        child: Column(
          children: [
            ListTile(
              title: Text(
                id,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: const Text('My City, CA 99984'),
              leading: Icon(
                Icons.restaurant_menu,
                color: Colors.blue[500],
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text(
                '(408) 555-1212',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              leading: Icon(
                Icons.contact_phone,
                color: Colors.blue[500],
              ),
            ),
            ListTile(
              title: const Text('xuesheng@stu.com'),
              leading: Icon(
                Icons.contact_mail,
                color: Colors.blue[500],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.five_mp),
              title: const Text("History"),
              subtitle: const Text("#history"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HistoryPage(id: id)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.six_mp),
              title: const Text("Help"),
              subtitle: const Text("#Help"),
              onTap: () async {
                //var succeed = await findhelp(id);
                await findhelp(id);
                //print(succeed);
              },
            )
          ],
        ),
      )
    ]);
  }
}

class TeacherPersonPage extends StatelessWidget {
  final String id;
  const TeacherPersonPage({Key? key, required this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      //Stack(
      //  alignment: Alignment.center,
      //  children: [
      Container(
          alignment: Alignment.center,
          child: const CircleAvatar(
            backgroundImage: AssetImage('images/teacher.png'),
            radius: 100,
          )),
      //    Container(
      //      decoration: const BoxDecoration(
      //        color: Colors.black45,
      //      ),
      //      child: const Text(
      //        'Mia B',
      //        style: TextStyle(
      //          fontSize: 20,
      //          fontWeight: FontWeight.bold,
      //          color: Colors.white,
      //        ),
      //      ),
      //    ),
      //  ],
      //),
      Card(
        child: Column(
          children: [
            ListTile(
              title: Text(
                id,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: const Text('My City, CA 99984'),
              leading: Icon(
                Icons.restaurant_menu,
                color: Colors.blue[500],
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text(
                '(408) 555-1212',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              leading: Icon(
                Icons.contact_phone,
                color: Colors.blue[500],
              ),
            ),
            ListTile(
              title: const Text('Laoshi@example.com'),
              leading: Icon(
                Icons.contact_mail,
                color: Colors.blue[500],
              ),
            ),
          ],
        ),
      )
    ]);
  }
}
