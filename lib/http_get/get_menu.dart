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

class FoldTable {
  final String id;
  FoldTable({
    required this.id,
  });
  factory FoldTable.fromJson(dynamic json) => FoldTable(id: json["id"]);
}

class FoldMenu {
  final List<Index> pages;
  final String tabletype;
  FoldMenu({
    required this.pages,
    required this.tabletype,
  });
}

Future<FoldMenu?> fetchMenu(String url) async {
  var menuget = await http.get(Uri.parse(url));
  if (menuget.statusCode == 200) {
    var json = jsonDecode(menuget.body);
    //var menu = json["menu"];
    return FoldMenu(
        tabletype: json["tabletype"],
        pages: (json["menu"] as List).map((e) => Index.fromJson(e)).toList());
  } else {
    return null;
  }
}

Future<List<FoldTable>?> fetchFolds(String url) async {
  var menuget = await http.get(Uri.parse(url));
  if (menuget.statusCode == 200) {
    var json = jsonDecode(menuget.body);
    return (json as List).map((e) => FoldTable.fromJson(e)).toList();
  } else {
    return null;
  }
}
