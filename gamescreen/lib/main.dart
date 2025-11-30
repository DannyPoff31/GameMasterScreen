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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 45, 40, 55)),
        scaffoldBackgroundColor: Color.fromARGB(255, 45, 40, 55),
        fontFamily: 'DigitalDream',
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.green,
          displayColor: Colors.green,
        ),
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
  ValueNotifier<List<dynamic>> players = ValueNotifier<List<dynamic>>([]);
  ValueNotifier<List<dynamic>> npc = ValueNotifier<List<dynamic>>([]);
  ValueNotifier<List<dynamic>> npcFrame = ValueNotifier<List<dynamic>>([]);
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

//  void _createDialog(BuildContext context, String subtitle, String name, List itemList) {
//     TextEditingController _nameController = TextEditingController();
//     TextEditingController _healthController = TextEditingController();
//     late List submit;

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Enter ${name} Name'),
//           content: SingleChildScrollView(
//             child: Column( 
//               children: <Widget> [
//                 TextField(
//                   controller: _nameController,
//                   decoration: const InputDecoration(hintText: 'Name'),
//                 ),
//                 TextField(
//                   controller: _healthController,
//                   decoration: const InputDecoration(hintText: 'Health'),
//                 )
//               ],
//             )

//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//             ),
//             TextButton(
//               child: const Text('Submit'),
//               onPressed: () {
//                 List submit = [_nameController.text, subtitle, _healthController.text];
//                 // Access the input value from _textController.text
//                 itemList.add(submit);
//                 print('Submitted text: $submit');
//                 Navigator.of(context).pop(); // Close the dialog
//                 setState(() {
                  
//                 });
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
  final List<TextEditingController> _variableControllers = [];
  final List<TextEditingController> _contentControllers = [];

  void _createDialog(BuildContext context, String subtitle, String name, ValueNotifier<List<dynamic>> itemList) {
    TextEditingController _nameController = TextEditingController();
    late List submit;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Enter ${name} Name'),
              content: Column( 
                children: <Widget> [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: 'Name'),
                  ),
                  Container(
                    height: 300,
                    width: 300,
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _variableControllers.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _variableControllers[index],
                                  decoration: const InputDecoration(hintText: 'Variable'),
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _contentControllers[index],
                                  decoration: const InputDecoration(hintText: 'Content'),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _variableControllers.add(TextEditingController());
                        _contentControllers.add(TextEditingController());
                      });
                    },
                    child: const Icon(Icons.add),
                  ),
                ],
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
                    List submit = [_nameController.text, subtitle];
                    for(int i = 0; i < _variableControllers.length; i++) {
                      submit.add(_variableControllers[i].text);
                      submit.add(_contentControllers[i].text);
                    }
                    itemList.value.add(submit);
                    print('Submitted text: $submit');
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );
          }
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
                players.value[index][0] = _nameController.text;
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
            onPressed: () => _createDialog(context, npcFrame.value[index][0], 'NPC', npc),
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
                  npcFrame.value.removeAt(index);
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
                  npc.value.removeAt(index);
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
                  players.value.removeAt(index);
                });
              },)
          ],
        )
      ]
    )
  );
}


ValueNotifier<List<Sketch>> allSketches = ValueNotifier<List<Sketch>>([Sketch(points:[Offset(10, 10), Offset(15, 15), Offset(20, 20)]), Sketch(points:[Offset(40, 40), Offset(60, 60), Offset(80, 80)]), Sketch(points:[Offset(20, 100), Offset(21, 101), Offset(60, 120)])]);
ValueNotifier<Sketch> currentSketch = ValueNotifier<Sketch>(Sketch(points: []));
double? height = MediaQuery.of(context).size.height * .8;
double? width = MediaQuery.of(context).size.width;
ValueNotifier<List<Room>> rooms = ValueNotifier([ 
  Room(startpoint: Offset(10,10), endpoint: Offset(20,20), name: 'Room1'),
  Room(startpoint: Offset(40,40), endpoint: Offset(80,80), name: 'Room2'),
]);

rooms.value.add(Room(startpoint: Offset(20, 100), endpoint: Offset(60, 120), name:'Room3'));

// MAIN PAGE !!!
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Color.fromARGB(255, 45, 40, 55),
        
        title: Text('Gamemaster Screen', style: TextStyle(
          color: Colors.green,
        )),
      ),
      drawer: Drawer(
        child: Column(
          children: [ Container(
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
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text('Player Characters')
                          )
                        ),
                        Expanded(
                          flex: 2, 
                          child: ElevatedButton(
                            onPressed: () {_createDialog(context,'Hello','Hello',players);},
                              child: const Text('Create Player'),
                            ),
                          ),                        
                      ],
                      )
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: players.value.length,
                        itemBuilder: (BuildContext context, int position) {
                            return _characterBox(info: players.value[position] ?? '', index: position, orientedLeft: false);
                        }
                      ),
                    ),
          ]
        ),
      ),

      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [ 
                // Row 1
                Expanded(
                  flex: 7,
                   child: Padding(
                      padding: EdgeInsetsGeometry.all(8),
                      child: Stack(
                        children: <Widget>[
                          map(
                            height: height, 
                            width: width,
                            rooms: rooms,
                            allSketches: allSketches,
                            callback: _createDialog,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
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
                              }, child: Text('Room Page')),
                            ),
                          ),
                        ]
                      ),
                   ),
                ),
            
                //Row 2
                
                Flexible( 
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0, bottom: 8.0, top: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                        border: BoxBorder.all(
                          color: Colors.green,
                        ),
                      ),
                      
                      child: CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Clock(timeStream: _clockStream),
                          ),
                          SliverToBoxAdapter(
                            child: Row(
                              children: [
                                TextButton(
                                  child: const Text('Edit'),
                                  onPressed: () {
                                    _timeDialog(context);
                                  },),
                                  TextButton(
                                  child: const Text('Start'),
                                  onPressed: () {
                                    if(!clockState) {
                                      clockState = true;
                                    }
                                    else {
                                      clockState = false;
                                    }
                                  },),
                              ],
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
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: npcFrame.value.length,
                                itemBuilder: (BuildContext context, int position) {
                                    return _npcFrameBox(info: npcFrame.value[position] ?? '', index: position);
                                }
                              ),
                            ),
                          ],
                        ),
                    ),
                  )
                  ),
              ],
            ),
          ),

          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                  border: BoxBorder.all(
                    color: Colors.green,
                  )
              
                ),
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text('Instantiated Monsters')
                      )
                    ),
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: npc.value.length,
                        itemBuilder: (BuildContext context, int position) {
                            return _npcBox(info: npc.value[position] ?? '', index: position);
                        }
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}