import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class MyColors {
  Color primary = Colors.orangeAccent;
  Color alice = Color.fromRGBO(247, 252, 255, 1);
}

class MyFonts {
  TextStyle headingBold = new TextStyle(
      color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold);
  TextStyle headingLight = new TextStyle(
      color: Colors.black, fontSize: 30, fontWeight: FontWeight.w300);

  TextStyle smallHeadingBold = new TextStyle(
      color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold);
  TextStyle smallHeadingLight = new TextStyle(
      color: Colors.black, fontSize: 22, fontWeight: FontWeight.w300);
}
