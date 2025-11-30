import 'package:flutter/material.dart';

class Clock extends StatelessWidget {
  const Clock({required this.timeStream, super.key});

  final Stream<List<int>>? timeStream;


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
      stream: timeStream,
      builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
        int hour = snapshot.data?[0] ?? 0; 
        int min = snapshot.data?[1] ?? 0;
        int sec = snapshot.data?[2] ?? 0;

        return Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Text(
              snapshot.hasData ? '${hour ~/ 10}${hour % 10}:${min ~/ 10}${min % 10}:${sec ~/ 10}${sec % 10}' : '00:00:00',
              style: TextStyle(
                fontFamily: 'DigitalDream',
                fontSize: 48,
                fontWeight: FontWeight.w700,),
                    ),
          ),
      );
    });  
  }
}