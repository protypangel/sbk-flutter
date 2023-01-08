import 'package:flutter/cupertino.dart';
import 'package:sbkiz/controller/check_version.dart';

class API {
  final String _url = "localhost:81";
  
  Future<Widget> checkVersion() async {
    return CheckVersion().checkVersion(_url);
  }
}