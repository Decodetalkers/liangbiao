import 'dart:convert';

import 'package:http/http.dart' as http;
class Index {
	final String filetype;
	final String name;
	Index({
		required this.filetype,
		required this.name,
	});
	factory Index.fromJson(dynamic json) => 
		Index(filetype: json["filetype"], name: json["name"]);
}
Future<List<Index>?> fetchMenu(String url) async {
	var menuget = await http.get(Uri.parse(url));
	if (menuget.statusCode == 200) {
		var json = jsonDecode(menuget.body);
		return (json as List).map((e) => Index.fromJson(e)).toList();
	}else {
		return null;
	}
}
