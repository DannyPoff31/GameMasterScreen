import 'package:flutter/material.dart';
import 'package:newproject/drawingTools/sketch.dart';
import 'dart:async';
import 'clock.dart';
import 'mapDrawer.dart';
import 'map.dart';
import 'drawingTools/room.dart';


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


class _MyHomePageState extends State<MyHomePage> {
  List players = [];
  List npc = [];
  List npcFrame = [];
  bool clockState = false;
  int sec = 0;
  int min = 0;
  int hour = 0;  
  List<int> time = [0, 0, 0];

  late final StreamController<List<int>> _controller = StreamController<List<int>>(
    onListen: () async {    
      while(!_controller.isClosed) {
        await Future<void>.delayed(widget.delay);
        if(clockState) {
          sec++;
          if(sec >= 60) {
            min++;
            sec = 0;
          }
          if(min >= 60) {
            hour++;
            min = 0;
          }
          if(hour >= 24) {
            hour = 0;
          }
          time[0] = hour;
          time[1] = min;
          time[2] = sec;
          _controller.sink.add(time);
        }
      }

      await Future<void>.delayed(widget.delay);

      if (!_controller.isClosed) {
        _controller.close();
      }
    },
  );

  late StreamSubscription<List<int>> subscription;
  Stream<List<int>> get _clockStream => _controller.stream;

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

  bool _isEditingText = false;
  var _editingController = TextEditingController();
  String initialText = "Initial Text";

Widget _editTitleTextField() {
  if (_isEditingText) {
    return Center(
      child: TextField(
        onSubmitted: (newValue){
          setState(() {
            initialText = newValue;
            _isEditingText = false;
          });
        },
        autofocus: true,
        controller: _editingController,
      ),
    );
  }
  return InkWell(
    onTap: () {
      setState(() {
        _isEditingText = true;
      });
    },
    child: Text(
  initialText,
  style: TextStyle(
    color: Colors.black,
    fontSize: 18.0,
  ),
  )
  );
}

  void _showInputDialog(BuildContext context, List type, String subtitle) {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _healthController = TextEditingController();
    late List submit;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Player'),
          content: SingleChildScrollView(
            child: Column( 
              children: <Widget> [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(hintText: 'Name'),
                ),
                TextField(
                  controller: _healthController,
                  decoration: const InputDecoration(hintText: 'Health'),
                )
              ],
            )

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
                List submit = [_nameController.text, subtitle, _healthController.text];
                // Access the input value from _textController.text
                type.add(submit);
                print('Submitted text: $submit');
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

  void _createDialog(BuildContext context, String subtitle, String name, List itemList) {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _healthController = TextEditingController();
    late List submit;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter ${name} Name'),
          content: SingleChildScrollView(
            child: Column( 
              children: <Widget> [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(hintText: 'Name'),
                ),
                TextField(
                  controller: _healthController,
                  decoration: const InputDecoration(hintText: 'Health'),
                )
              ],
            )

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
                List submit = [_nameController.text, subtitle, _healthController.text];
                // Access the input value from _textController.text
                itemList.add(submit);
                print('Submitted text: $submit');
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

  void _timeDialog(BuildContext context) {
    TextEditingController _secController = TextEditingController();
    TextEditingController _minController = TextEditingController();
    TextEditingController _hourController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter time'),
          content: SingleChildScrollView(
            child: Column( 
              children: <Widget> [
                TextField(
                  controller: _secController,
                  decoration: const InputDecoration(hintText: 'Seconds'),
                ),
                TextField(
                  controller: _minController,
                  decoration: const InputDecoration(hintText: 'Minutes'),
                ), 
                TextField(
                  controller: _hourController,
                  decoration: const InputDecoration(hintText: 'Hours'),
                )
              ],
            )

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
                sec = int.parse(_secController.text);
                min = int.parse(_minController.text);
                hour = int.parse(_hourController.text);
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

// TextField builder?
// ListView.builder(
//   itemCount: _controllers.length,
//   itemBuilder: (context, index) {
//     return TextField(
//       controller: _controllers[index],
//       decoration: InputDecoration(labelText: 'Item ${index + 1}'),
//     );
//   },
// );


  void _playerEditDialog(BuildContext context, int index) {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _textController = TextEditingController();
    //TextEditingController _hourController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter new Values'),
          content: SingleChildScrollView(
            child: Column( 
              children: <Widget> [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(hintText: 'name'),
                ),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(hintText: 'other'),
                ),                
              ],
            )

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
                players[index][0] = _nameController.text;
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


Widget _npcFrameBox({required info, required index}) {
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
            title: Text('${info[0]} | ${info[2]}'),
            subtitle: Text('${info[1]}'),
          )
        ),
        Flexible( 
          child: IconButton(
            onPressed: () => _createDialog(context, npcFrame[index][0], 'NPC', npc),
            icon: const Icon(Icons.add_circle_outline)
          )
        ),
        Row(
          children: [
            TextButton(
              child: const Text('Edit'),
              onPressed: () {
                _playerEditDialog(context, index);
              },),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                setState(() {
                  npcFrame.removeAt(index);
                });
              },)
          ],
        )
      ]
    )
  );
}

Widget _npcBox({required info, required index}) {

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
          title: Text('${info[0]}'),
          subtitle: Text('${info[1]}'),
        ),
        _editTitleTextField(),
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
                setState(() {
                  npc.removeAt(index);
                });
              },)
          ],
        )
      ]
    )
  );
}

Widget _characterBox({required info, required index, required bool orientedLeft}) {
  BorderRadius side;
  if(orientedLeft) {
    side = BorderRadius.only(
      topLeft: Radius.circular(20.0), // top-left
      bottomLeft: Radius.circular(20.0), // bottom-left
    ); 
  }
  else {
    side = BorderRadius.only(
      topRight: Radius.circular(20.0), // top-right
      bottomRight: Radius.circular(20.0), // bottom-right
    );
  } 

  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: side
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.person_2_outlined),
          title: Text('${info[0]}'),
          subtitle: Text('${info[1]}'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
              child: const Text('Edit'),
              onPressed: () {
                _playerEditDialog(context, index);
              },),
              TextButton(
              child: const Text('Delete'),
              onPressed: () {
                setState(() {
                  players.removeAt(index);
                });
              },)
          ],
        )
      ]
    )
  );
}


ValueNotifier<List<Sketch>> allSketches = ValueNotifier<List<Sketch>>([Sketch(points:[Offset(0, 0), Offset(5, 5), Offset(10, 10)]), Sketch(points:[Offset(20, 20), Offset(60, 60), Offset(80, 80)]),]);
ValueNotifier<Sketch> currentSketch = ValueNotifier<Sketch>(Sketch(points: []));
double? height = MediaQuery.of(context).size.height;
double? width = MediaQuery.of(context).size.width;
List<Room> rooms = [ 
  Room(startpoint: Offset(0,0), endpoint: Offset(10,10), name: 'Room1'),
  Room(startpoint: Offset(20,20), endpoint: Offset(80,80), name: 'Room2'),
];

rooms.add(Room(startpoint: Offset(20, 100), endpoint: Offset(60, 120), name:'Room3'));

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
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () => _createDialog(context,'','',players),
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
                        return _characterBox(info: players[position] ?? '', index: position, orientedLeft: false);
                    }
                  ),
                ),
                Expanded(
                  child: map(
                    height: height, 
                    width: width,
                    rooms: rooms,
                    allSketches: allSketches,
                    callback: _createDialog,
                  )
                ),
                // Expanded(child: mapDrawingBoard(
                //   height: MediaQuery.of(context).size.height, 
                //   width: MediaQuery.of(context).size.width,
                //   currentSketch: currentSketch,
                //   allSketches: allSketches,
                // ),)
              ]
            ),
          ),

          //Row 2
          
          Flexible( 
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                   child: ElevatedButton(onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => mapDrawingBoard(
                          height: height, 
                          width: width,
                          currentSketch: currentSketch,
                          allSketches: allSketches,
                          rooms: rooms,
                        ),
                      ),
                    );
                  }, child: Text('Create a Room'))
                ),
                SliverToBoxAdapter(
                  child: const Text('Time:'),
                ),
                SliverToBoxAdapter(
                  child: Clock(timeStream: _clockStream),
                ),
                SliverToBoxAdapter(
                  child: TextButton(
                    child: const Text('Edit'),
                    onPressed: () {
                      _timeDialog(context);
                    },),
                ),
                SliverToBoxAdapter(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text('Instantiated Monsters')
                    )
                  ),
                ),
                SliverToBoxAdapter(
                    child: Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: npc.length,
                        itemBuilder: (BuildContext context, int position) {
                            return _npcBox(info: npc[position] ?? '', index: position);
                        }
                      ),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text('Monster Types')
                    )
                  ),
                ),
                SliverToBoxAdapter(
                  child: Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                    onPressed: () => _createDialog(context,'','',npcFrame),
                      child: const Text('Open Input Dialog'),
                    )
                  )
                ),
                  SliverToBoxAdapter(
                    child: Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: npcFrame.length,
                        itemBuilder: (BuildContext context, int position) {
                            return _npcFrameBox(info: npcFrame[position] ?? '', index: position);
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
          if(!clockState) {
            clockState = true;
          }
          else {
            clockState = false;
          }
        },
        tooltip: 'Start',
        child: const Icon(Icons.add),
      ),
    );
  }
}