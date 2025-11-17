import 'package:flutter/material.dart';
import 'drawingTools/sketch.dart';
import 'drawingTools/room.dart';

class mapDrawer extends CustomPainter {
  final List<Sketch> sketches;
  final String mode;
  List<Room> rooms;

  mapDrawer({
    required this.sketches,
    this.mode = 'Room',
    required this.rooms,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for(Sketch sketch in sketches) {
      final points = sketch.points;
      // nothing to draw
      if (points.isEmpty) continue;

      final path = Path();
      // If only one point, draw a dot. If two points, draw a straight line.
      if (points.length == 1) {
        path.addOval(Rect.fromCircle(center: points.first, radius: sketch.size / 2));
      // If two points, draw a straight line.
      } else if (points.length == 2) {
        path.moveTo(points[0].dx, points[0].dy);
        path.lineTo(points[1].dx, points[1].dy);
      // If 3+ points and mode == Room, draw a straight line.
      } else if (mode == 'Room') {
        path.moveTo(points.first.dx, points.first.dy);

        path.lineTo(points.last.dx, points.first.dy);
        path.lineTo(points.last.dx, points.last.dy);
        path.lineTo(points.first.dx, points.last.dy);
        path.lineTo(points.first.dx, points.first.dy);
      } else {
        // curved line for 3+ points
        path.moveTo(points.first.dx, points.first.dy);

        for (int i = 1; i < points.length - 1; ++i) {
          final p0 = points[i];
          final p1 = points[i + 1];
          path.quadraticBezierTo(
            p0.dx,
            p0.dy,
            (p0.dx + p1.dx) / 2,
            (p0.dy + p1.dy) / 2,
          );
        }

        // ensure the path reaches the final point
        path.lineTo(points.last.dx, points.last.dy);
      }

      Paint paint = Paint() 
        ..color = sketch.color 
        ..strokeWidth = sketch.size 
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawPath(path, paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}


class mapDrawingBoard extends StatelessWidget {
  final double? height;
  final double? width;

  final ValueNotifier<Sketch?> currentSketch;
  final ValueNotifier<List<Sketch>> allSketches;
  final List<Room> rooms;

  const mapDrawingBoard({
    Key? key,
    required this.height,
    required this.width,
    required this.currentSketch,
    required this.allSketches,
    required this.rooms,
  }) : super(key:key);

  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildAllPaths(),
        buildPath(context), 
      ]
    );
  }

  Widget buildAllPaths() {
    return RepaintBoundary(
      child: SizedBox(
        height: height,
        width: width,
        // Rebuild the CustomPaint whenever the list of sketches changes
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
    );
  }

  Widget buildPath(BuildContext context) {
    Offset start = Offset(0, 0);
    return Listener(
      onPointerDown: (event) {
        final box = context.findRenderObject() as RenderBox;
        final offset = box.globalToLocal(event.position);

        currentSketch.value = Sketch(points: [offset]);
        print('Start: $offset');
        start = offset;
      } ,
      onPointerMove: (event) {
        final box = context.findRenderObject() as RenderBox;
        final offset = box.globalToLocal(event.position);
        
        final points = List<Offset>.from(currentSketch.value?.points ?? [])
          ..add(offset);
        currentSketch.value = Sketch(points: points);
      } ,
      onPointerUp: (event) {
        final box = context.findRenderObject() as RenderBox;
        final offset = box.globalToLocal(event.position); 

        allSketches.value = List<Sketch>.from(allSketches.value)
          ..add(currentSketch.value!);
          rooms.add(Room(startpoint: Offset(start.dx, start.dy), endpoint: Offset(offset.dx, offset.dy), name: 'ROOM!'));
          print('Room Added');
      },  
      child: RepaintBoundary(
        child: SizedBox(
          height: height,
          width: width,
          // Rebuild the current path when the currentSketch notifier changes
          child: ValueListenableBuilder<Sketch?>(
            valueListenable: currentSketch,
            builder: (context, current, _) {
              final List<Sketch> drawList = current == null ? [] : [current];
              return CustomPaint(
                painter: mapDrawer(
                  sketches: drawList,
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