import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Duration delay = Duration(seconds: 1);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(delay: delay, title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.delay, required this.title});

  final Duration delay;

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Clock {
  //String time = '0';
  var stopwatch  = Stopwatch();

  Clock();

  void startStopWatch() {
    stopwatch.start();
  }

  String print() {
    return stopwatch.elapsed.toString();
  }

}

class ClockTest extends StatelessWidget {
  final Clock mainClock;

  const ClockTest({
    Key? key,
    required this.mainClock,
  }) : super(key: key);

  // void incrementTime() {
  //     setState(() {
  //       print(mainClock.print());
  //     });
  //   }

  @override
  Widget build(BuildContext context) {
    return Text(
      mainClock.print(),
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  List players = ['Steve!'];
  List npc = ['Jeff the monster', 'something', 'something', 'something', 'something', 'something'];
  List npcFrame = ['Monster'];


// 
    late final StreamController<int> _controller = StreamController<int>(
    onPause: () {
      print('paused');
    },
    onListen: () async {

      int x = 0;

      while(!_controller.isClosed) {
        await Future<void>.delayed(widget.delay);
        _controller.add(x);
        x++;
      }

      await Future<void>.delayed(widget.delay);

      print('closed');

      if (!_controller.isClosed) {
        _controller.close();
      }
    },
  );

  late StreamSubscription<int> subscription;

  Stream<int> get _bids => _controller.stream;

  @override
  void dispose() {
    if (!_controller.isClosed) {
      _controller.close();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    void startListening() {
    subscription = _controller.stream.listen(
      (data) => print('Received: $data'),
      onError: (error) => print('Error: $error'),
      onDone: () => print('Stream done'),
    );
  } 




  void pauseStream() {
    if (subscription.isPaused == false) {
      subscription.pause();
      print('Stream paused');
    }
  }

  void resumeStream() {
    if (subscription.isPaused) {
      subscription.resume();
      print('Stream resumed');
    }
  }

  //startListening();

    Clock mainClock = Clock();


    // Timer _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
    //   incrementTime();
    // });

  void _showInputDialog(BuildContext context) {
    TextEditingController _textController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Your Name'),
          content: TextField(
            controller: _textController,
            decoration: const InputDecoration(hintText: 'Your name'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                // Access the input value from _textController.text
                players.add(_textController.text);
                print('Submitted text: ${_textController.text}');
                Navigator.of(context).pop(); // Close the dialog
                setState(() {
                  
                });
              },
            ),
          ],
        );
      },
    );
  }





// MAIN PAGE !!!
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Hello'),
      ),

      body: Row(
        mainAxisSize: MainAxisSize.min,
        children: [ 
          // Row 1
          Flexible(
             child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  //constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.75),
                        spreadRadius: 1,
                        blurRadius:  .5,
                        offset: Offset(.5, 1), // changes position of shadow
                      )
                    ],
                  ),
                  child: Row( 
                    children: [ 
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text('Player Characters')
                        )
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: ElevatedButton(
                          onPressed: () => _showInputDialog(context),
                            child: const Text('Open Input Dialog'),
                          )
                        )
                      ]
                    )
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: players.length,
                    itemBuilder: (BuildContext context, int position) {
                      return _characterBox(name: players[position]);
                    }
                  ),
                ),
              ]
            ),
          ),

          //Row 2
          
          Flexible( 
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: const Text('Time:'),
                ),
                SliverToBoxAdapter(
                  child: BidsStatus(bids: _bids),
                ),
                SliverToBoxAdapter(
                    child: Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: npc.length,
                        itemBuilder: (BuildContext context, int position) {
                          return _npcBox(name: npc[position]);
                        }
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: npcFrame.length,
                        itemBuilder: (BuildContext context, int position) {
                          return _npcFrameBox(name: npcFrame[position]);
                        }
                      ),
                    ),
                  ),
                ],
              )
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         pauseStream();
        },
        tooltip: 'Start',
        child: const Icon(Icons.add),
      ),
    );
  }
}

Widget _characterBox({required name, }) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(20.0), // top-right
        bottomRight: Radius.circular(20.0), // bottom-right
      ),
    ),
    child: Column(
      
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.person_2_outlined),
          title: Text('$name'),
          subtitle: Text('???'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
              child: const Text('Edit'),
              onPressed: () {
                /* ... */
              },),
              TextButton(
              child: const Text('Delete'),
              onPressed: () {
                /* ... */
              },)
          ],
        )
      ]
    )
  );
}

Widget _npcBox({required name}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0), // top-left
        bottomLeft: Radius.circular(20.0), // bottom-left
      ),
    ),
    child: Column(
      
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.person_2_outlined),
          title: Text('$name'),
          subtitle: Text('???'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
              child: const Text('Edit'),
              onPressed: () {
                /* ... */
              },),
              TextButton(
              child: const Text('Delete'),
              onPressed: () {
                /* ... */
              },)
          ],
        )
      ]
    )
  );
}


Widget _npcFrameBox({required name, }) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0), // top-left
        bottomLeft: Radius.circular(20.0), // bottom-left
      ),
    ),
    child: Row(
      
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded( 
          child: ListTile(
            leading: Icon(Icons.person_2_outlined),
            title: Text('$name'),
            subtitle: Text('???'),
          )
        ),
        Expanded( 
          child: IconButton(
            onPressed: () {

            },
            icon: const Icon(Icons.add_circle_outline)
          )
        )
      ]
    )
  );
}





class BidsStatus extends StatelessWidget {
  const BidsStatus({required this.bids, super.key});

  final Stream<int>? bids;


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: bids,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        List<Widget> children;
          children = <Widget>[
                const Icon(Icons.info, color: Colors.blue, size: 60),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(snapshot.hasData ? '${snapshot.data}' : '0'),
                ),
              ];
            return Column(mainAxisAlignment: MainAxisAlignment.center, children: children);
      });

      
  }
}