import 'package:flutter/material.dart';

class Sketch {
  final List<Offset> points;
  final Color color;
  final double size;

  Sketch({
    required this.points,
    this.color = Colors.black,
    this.size = 2
  });

}