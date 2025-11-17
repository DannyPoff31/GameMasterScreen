import 'package:flutter/material.dart';

class Clock extends StatelessWidget {
  const Clock({required this.timeStream, super.key});

  final Stream<List<int>>? timeStream;


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
      stream: timeStream,
      builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
        int hour = snapshot.data![0]; 
        int min = snapshot.data![1];
        int sec = snapshot.data![2];

        List<Widget> children;
          children = <Widget>[
                const Icon(Icons.info, color: Colors.blue, size: 60),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(snapshot.hasData ? '${hour ~/ 10}${hour % 10}:${min ~/ 10}${min % 10}:${sec ~/ 10}${sec % 10}' : '00:00:00'),
                ),
              ];
            return Column(mainAxisAlignment: MainAxisAlignment.center, children: children);
      });

      
  }
}