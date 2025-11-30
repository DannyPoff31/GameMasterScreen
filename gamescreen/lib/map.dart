import 'package:flutter/material.dart';
import 'drawingTools/sketch.dart';
import 'drawingTools/room.dart';
import 'mapDrawer.dart';

class map extends StatelessWidget {
  final double? height;
  final double? width;
  final ValueNotifier<List<Sketch>> allSketches;
  
  final ValueNotifier<List<Room>> rooms;

  void Function(BuildContext, String, String, ValueNotifier<List<dynamic>>) callback;

  map({
    required this.height,
    required this.width,
    required this.allSketches,
    required this.rooms,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        for(int i = 0; i < rooms.value.length; i++) {
          double startx = rooms.value[i].startpoint.dx;
          double endx = rooms.value[i].endpoint.dx;
          double starty = rooms.value[i].startpoint.dy;
          double endy = rooms.value[i].endpoint.dy;
          final box = context.findRenderObject() as RenderBox;
          final offset = box.globalToLocal(event.position);

          if(offset.dx < endx && offset.dx > startx && offset.dy < endy && offset.dy > starty) {
            print(rooms.value[i].name);
            callback(context, 'Hello', rooms.value[i].name, rooms);
          } 
        }
        if(event.position.dx < 40 && event.position.dy-height! < 40) {
          print('Click');
        }
      },
      child: SizedBox(
          height: height,
          width: width,
          // Rebuild the CustomPaint whenever the list of sketches changes
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
              border: BoxBorder.all(
                color: Colors.green,
              )
            ),
            child: ValueListenableBuilder<List<Sketch>>(
              valueListenable: allSketches,
              builder: (context, sketchesValue, _) {
                return CustomPaint(
                  painter: mapDrawer(
                    sketches: sketchesValue,
                    rooms: rooms,
                  ),
                );
              },
            ),
          ),
        ),
    );
  }
}