import 'package:flutter/material.dart';

class GameDoor {
  final id;
  String text;
  Color background;
  bool enabled;

  GameDoor({this.id, this.text="", this.background = Colors.grey, this.enabled = true});

}