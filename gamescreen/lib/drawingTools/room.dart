import 'package:flutter/material.dart';

class Room {
  final Offset startpoint;
  final Offset endpoint;
  final String name;
  final String info;

  final Color color;
  final double size;

  Room({
    required this.startpoint,
    required this.endpoint,
    required this.name, 
    this.info = '',

    this.color = Colors.black,
    this.size = 5
  });

}