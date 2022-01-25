import 'package:flutter/material.dart';
import 'persionmessage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //const LoginPage({Key? key}) : super(key: key);
  User? dropdownValue;
  TextEditingController idController = TextEditingController();
  TextEditingController passwardController = TextEditingController();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = <Widget>[

      ListView(
        //  mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ExpansionTile(
            title: const Text("用戶"),
            children: [
              ["Teacher", User.teacher],
              ["student", User.student]
            ].map((e) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(e[0].toString()),
                  Checkbox(
                      value: e[1] == dropdownValue,
                      onChanged: (value) {
                        if (value == true) {
                          setState(() {
                            var temp = e[1];
                            temp as User;
                            dropdownValue = temp;
                          });
                        }
                      })
                ],
              );
            }).toList(),
          ),
          if (dropdownValue == User.student) ...[
            Form(
              key: _formKey1,
              child: TextFormField(
                controller: idController,
                decoration: const InputDecoration(hintText: 'Hello student'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "enter text";
                  }
                  return null;
                },
              ),
            ),
            Form(
                key: _formKey2,
                child: TextFormField(
                  controller: passwardController,
                  decoration: const InputDecoration(hintText: 'Enter Passward'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "enter passward";
                    }
                    return null;
                  },
                )),
          ] else if (dropdownValue == User.teacher) ...[
            Form(
              key: _formKey1,
              child: TextFormField(
                controller: idController,
                decoration: const InputDecoration(hintText: 'Hello Teacher'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "No teacher";
                  }
                  return null;
                },
              ),
            ),
            Form(
                key: _formKey2,
                child: TextFormField(
                  controller: passwardController,
                  decoration: const InputDecoration(hintText: 'Enter Passward'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "enter passward";
                    }
                    return null;
                  },
                ))
          ] else
            ...[],
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: (dropdownValue == null)
                  ? null
                  : () {
                      if (_formKey1.currentState!.validate() &&
                          _formKey2.currentState!.validate()) {
                        if (dropdownValue != null) {
                          // Close the screen and return "Yep!" as the result.
                          Navigator.pop(context,
                              Message(person: dropdownValue!, id: idController.text));
                        }
                      }
                    },
              child: const Text('Confirm'),
            ),
          ),
        ],
      ),
      ListView(
        //  mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(children: [
            const Expanded(child: Text("hello")),
            DropdownButton<User>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (User? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: <User>[User.student, User.teacher]
                  .map<DropdownMenuItem<User>>((User value) {
                String text;
                if (value == User.student) {
                  text = "Student";
                } else {
                  text = "Teacher";
                }
                return DropdownMenuItem<User>(
                  value: value,
                  child: Text(text),
                );
              }).toList(),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Close the screen and return "Yep!" as the result.
                Navigator.pop(
                    context, Message(person: User.student, id: "Student"));
              },
              child: const Text('Student'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Close the screen and return "Nope." as the result.
                Navigator.pop(
                    context, Message(person: User.teacher, id: "Teacher"));
              },
              child: const Text('Teacher'),
            ),
          )
        ],
      ),
    ];
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Pick an option'),
              bottom: const TabBar(tabs: [
                Tab(
                  text: '登陸',
                  icon: Icon(Icons.login),
                ),
                Tab(
                  text: '註冊',
                  icon: Icon(Icons.app_registration),
                ),
              ]),
            ),
            body: TabBarView(children: tabs)));
  }
}
