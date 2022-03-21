import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashProvider extends ChangeNotifier {
  Future<bool> initConfig(GlobalKey<ScaffoldMessengerState> globalKey) async {
    return true;
  }
}
