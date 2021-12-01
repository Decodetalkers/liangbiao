import 'package:flutter/material.dart';

abstract class BaseWidget implements Widget{
	int? score();
}
abstract class FromUrl {
	String geturl();
//	UrlBase urltype();
}
//enum UrlBase{
//	videourl,
//	texturl,
//}
