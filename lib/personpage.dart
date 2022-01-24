import 'package:flutter/material.dart';

class StudentPersonPage extends StatelessWidget {
  const StudentPersonPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Stack(
        alignment: Alignment.center,
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('images/test.png'),
            radius: 100,
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.black45,
            ),
            child: const Text(
              'Mia B',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      Card(
        child: Column(
          children: [
            ListTile(
              title: const Text(
                '1625 Main Street',
                style: TextStyle(fontWeight: FontWeight.w500),
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
          ],
        ),
      )
    ]);
  }
}

class TeacherPersonPage extends StatelessWidget {
  const TeacherPersonPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Stack(
        alignment: Alignment.center,
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('images/test.png'),
            radius: 100,
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.black45,
            ),
            child: const Text(
              'Mia B',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      Card(
        child: Column(
          children: [
            ListTile(
              title: const Text(
                '1625 Main Street',
                style: TextStyle(fontWeight: FontWeight.w500),
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
