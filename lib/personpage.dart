import 'package:flutter/material.dart';

class PersonPage extends StatelessWidget {
  const PersonPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text(
            'Person',
          ),
        ],
      ),
    );
  }
}
