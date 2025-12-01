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
  List<List> players = [];
  List<List> npc = [];
  List<List> npcFrame = [];
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

final List<TextEditingController> _variableControllers = [];
final List<TextEditingController> _contentControllers = [];

  Widget _modularTextField() {

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .5,
              width: MediaQuery.of(context).size.width * .25,
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
                              decoration: InputDecoration(hintText: 'Variable'),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _contentControllers[index],
                              decoration: InputDecoration(hintText: 'Content'),
                            ),
                          ),
                        ],
                      );                 
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        if(_variableControllers.isNotEmpty) {
                          _variableControllers.removeLast();
                          _contentControllers.removeLast();
                        }
                      });
                    },
                    child: const Icon(Icons.remove),
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
          ],
        );
      }
    );
  }

  final List<TextEditingController> _editControllers = [];
  Widget _modularEditField(List item) {
    for(int i = 0; i < item.length-1; i++) {
      _editControllers.add(TextEditingController());
    }

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .5,
              width: MediaQuery.of(context).size.width * .25,
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _editControllers.length,
                  itemBuilder: (context, index) {
                    print('Index $index');
                    if(index.isOdd) {
                      return Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _editControllers[index-1],
                              decoration: InputDecoration(hintText: item[index]),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _editControllers[index],
                              decoration: InputDecoration(hintText: item[index+1]),
                            ),
                          ),
                        ],
                      );   
                    }
                    return SizedBox.shrink();              
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        if(_variableControllers.isNotEmpty) {
                          _editControllers.removeLast();
                          _editControllers.removeLast();
                        }
                      });
                    },
                    child: const Icon(Icons.remove),
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _editControllers.add(TextEditingController());
                      _editControllers.add(TextEditingController());
                    });
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        );
      }
    );
  }

  void _createDialog(BuildContext context, String subtitle, String name, List itemSet) {
    TextEditingController _nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Enter ${name} Name'),
              content: Column( 
                children: <Widget> [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: 'Name'),
                  ),
                  _modularTextField(),
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
                    List submit = ['${_nameController.text} - $subtitle',];
                    for(int i = 0; i < _variableControllers.length; i++) {
                      submit.add(_variableControllers[i].text);
                      submit.add(_contentControllers[i].text);
                    }
                    // Access the input value from _textController.text
                    itemSet.add(submit);
                    print('Submitted text: $submit');
                    Navigator.of(context).pop(); // Close the dialog
                    setState(() {
                      
                    });
                  },
                ),
              ],
            );
          }
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

  void _editDialog(BuildContext context, List<List> itemSet, int index) {
    TextEditingController _nameController = TextEditingController();

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
                  decoration: InputDecoration(hintText: '${itemSet[index][0]}'),
                ),
                _modularEditField(itemSet[index]),              
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
                List submit = ['${_nameController.text}'];

                for(int i = 0; i < _editControllers.length; i++) {
                  submit.add(_editControllers[i].text);
                }
                // Access the input value from _textController.text
                itemSet[index] = submit;
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

Widget _itemBox({required List<List> itemSet, required List item, required index, bool? isFrame}) {
  Widget frameButton;
  if(isFrame ?? false) {
    frameButton = IconButton(
      onPressed: () => _createDialog(context, npcFrame[index][0], 'NPC', npc),
      icon: const Icon(Icons.add_circle_outline)
    );
  }
  else {
    frameButton = SizedBox.shrink();
  }

  
  return Padding(
    padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
    child: Container(
      decoration: BoxDecoration(
        
        gradient: LinearGradient(colors: [Color.fromARGB(255, 45, 40, 55), Color.fromARGB(255, 70, 63, 85)], begin: Alignment.bottomCenter, end: Alignment.topCenter),
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            frameButton,
            Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                itemCount: item.length-1,
                itemBuilder: (context, index) {
                  if(index == 0) {
                    return Text('${item[index]}');
                  }
                  if(index.isOdd) {
                    return Text('${item[index]}: ${item[index+1]}');
                  }
                  return SizedBox.shrink();
                }
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Text('Edit'),
                    onPressed: () {
                      _editDialog(context, itemSet, index);
                    },),
                    TextButton(
                    child: const Text('Delete'),
                    onPressed: () {
                      setState(() {
                        itemSet.removeAt(index);
                      });
                    },)
                  ],
                )
              ]
            ),
          ],
        ),
      ),
    ),
  );
}


ValueNotifier<List<Sketch>> allSketches = ValueNotifier<List<Sketch>>([Sketch(points:[Offset(10, 10), Offset(15, 15), Offset(20, 20)]), Sketch(points:[Offset(40, 40), Offset(60, 60), Offset(80, 80)]), Sketch(points:[Offset(20, 100), Offset(21, 101), Offset(60, 120)])]);
ValueNotifier<Sketch> currentSketch = ValueNotifier<Sketch>(Sketch(points: []));
double? height = MediaQuery.of(context).size.height * .8;
double? width = MediaQuery.of(context).size.width;
List<Room> rooms = [ 
  Room(startpoint: Offset(10,10), endpoint: Offset(20,20), name: 'Room1'),
  Room(startpoint: Offset(40,40), endpoint: Offset(80,80), name: 'Room2'),
];

rooms.add(Room(startpoint: Offset(20, 100), endpoint: Offset(60, 120), name:'Room3'));

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
                        itemCount: players.length,
                        itemBuilder: (BuildContext context, int position) {
                            return _itemBox(itemSet: players, item: players[position], index: position);
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
                            child: Container(
                              decoration: BoxDecoration(
                                border: BorderDirectional(bottom: BorderSide(color: Colors.green))
                              ),
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
                          ),
                          SliverToBoxAdapter(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text('Stat Blocks')
                                  ),
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => _createDialog(context,'','',npcFrame),
                                      child: const Text('Create new block'),
                                    ),
                                ),
                                ],
                              )
                            ),
                            SliverToBoxAdapter(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: npcFrame.length,
                                itemBuilder: (BuildContext context, int position) {
                                    return _itemBox(itemSet: npcFrame, item: npcFrame[position], index: position, isFrame: true);
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
                        itemCount: npc.length,
                        itemBuilder: (BuildContext context, int position) {
                            return _itemBox(itemSet: npc, item: npc[position], index: position);
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