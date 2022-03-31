import 'package:flutter/material.dart';
import 'persionmessage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

Future<http.Response> logininto(String name, String passward) {
  return http.post(
    Uri.parse("$serveurl/login"),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      //'X-CUSTOM-HEADER': '123',
      //'Access-Control-Allow-Origin': 'http://localhost:37703'
    },
    body: jsonEncode({
      'name': name,
      'passward': passward,
    }),
  );
}

Future<http.Response> registerinto(String name, String passward) {
  return http.post(
    Uri.parse("$serveurl/register"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'name': name,
      'passward': passward,
    }),
  );
}

class _LoginPageState extends State<LoginPage> {
  //const LoginPage({Key? key}) : super(key: key);
  User? dropdownValue;
  Logintype? howlogin;
  String? passward;
  TextEditingController idController = TextEditingController();
  TextEditingController subidController = TextEditingController();
  TextEditingController passwardController = TextEditingController();
  TextEditingController subpasswardController = TextEditingController();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _subformKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _subformKey2 = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // tabs location
    List<Widget> tabs = <Widget>[
      Column(children: [
        // for scroll
        Expanded(
          child: ListView(
            //  mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ExpansionTile(
                title: () {
                  if (dropdownValue == null) {
                    return const Text("用戶");
                  } else if (dropdownValue == User.student) {
                    return const Text("學生");
                  } else {
                    return const Text("老師");
                  }
                }(),
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
                    decoration:
                        const InputDecoration(hintText: 'Hello student'),
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
                      obscureText: true,
                      controller: passwardController,
                      decoration:
                          const InputDecoration(hintText: 'Enter Passward'),
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
                    decoration:
                        const InputDecoration(hintText: 'Hello Teacher'),
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
                      obscureText: true,
                      decoration:
                          const InputDecoration(hintText: 'Enter Passward'),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "enter passward";
                        }
                        return null;
                      },
                    ))
              ] else
                ...[],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: (dropdownValue == null)
                ? null
                : () async {
                    if (_formKey1.currentState!.validate() &&
                        _formKey2.currentState!.validate()) {
                      if (dropdownValue != null) {
                        var logined = await logininto(
                            idController.text, passwardController.text);
                        var login = jsonDecode(logined.body);
                        if (login["logined"] == true) {
                          // Close the screen and return "Yep!" as the result.
                          Navigator.pop(
                              context,
                              Message(
                                  person: dropdownValue!,
                                  id: login["message"]["name"]));
                        }
                      }
                    }
                  },
            child: const Text('Confirm'),
          ),
        ),
        const SizedBox(height: 20),
      ]),
      Column(children: [
        Expanded(
          child: ListView(
            //  mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ExpansionTile(
                title: () {
                  if (howlogin == null) {
                    return const Text("選擇註冊方式");
                  } else if (howlogin == Logintype.email) {
                    return const Text("郵件");
                  } else {
                    return const Text("匿名");
                  }
                }(),
                children: [
                  ["郵件", Logintype.email],
                  ["匿名", Logintype.anonymous]
                ].map((e) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(e[0].toString()),
                      Checkbox(
                          value: e[1] == howlogin,
                          onChanged: (value) {
                            if (value == true) {
                              setState(() {
                                var temp = e[1];
                                temp as Logintype;
                                howlogin = temp;
                              });
                            }
                          })
                    ],
                  );
                }).toList(),
              ),
              if (howlogin == Logintype.anonymous) ...[
                Row(
                  children: [
                    Expanded(
                      child: Form(
                        key: _subformKey1,
                        child: TextFormField(
                          controller: subidController,
                          decoration:
                              const InputDecoration(hintText: 'Enter a name'),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "enter text";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          var time = DateTime.now().toString();
                          var bytes = utf8.encode(time);
                          var digest = sha1.convert(bytes).toString();
                          subidController.text = digest;
                        },
                        child: const Text("隨機生成id")),
                  ],
                ),
                Form(
                    autovalidateMode: AutovalidateMode.always,
                    onChanged: () {
                      Form.of(primaryFocus!.context!)!.save();
                    },
                    child: TextFormField(
                      controller: subpasswardController,
                      obscureText: true,
                      decoration:
                          const InputDecoration(hintText: 'Enter Passward'),
                      onSaved: (String? value) {
                        setState(() {
                          passward = value;
                        });
                      },
                    )),
                Form(
                    key: _subformKey2,
                    child: TextFormField(
                      //controller: passwardController,
                      obscureText: true,
                      decoration:
                          const InputDecoration(hintText: 'Confirm Passward'),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "enter passward";
                        } else if (value != passward) {
                          return "not the same passward";
                        }
                        return null;
                      },
                    ))
              ] else if (howlogin == Logintype.email)
                ...[]
              else
                ...[],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: (howlogin == null)
                ? null
                : () async {
                    if (_subformKey1.currentState!.validate() &&
                        _subformKey2.currentState!.validate()) {
                      var logined = await registerinto(
                          subidController.text, subpasswardController.text);
                      var login = jsonDecode(logined.body);
                      if (login["logined"] == true) {
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
                                      Text(
                                          'Your id is ${subidController.text}'),
                                      const Text(
                                          'please remember your passward'),
                                      ElevatedButton(
                                          child: const Text('登陸'),
                                          onPressed: () {
                                            //Navigator.pop(context);
                                            Navigator.pop(
                                                context,
                                                Message(
                                                    person: User.student,
                                                    id: subidController.text));
                                          }),
                                    ],
                                  ),
                                ),
                              );
                            });
                      }

                      // Close the screen and return "Yep!" as the result.
                    }
                  },
            child: const Text('Student'),
          ),
        ),
        const SizedBox(height: 20),
      ])
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
