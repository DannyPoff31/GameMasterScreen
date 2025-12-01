import 'package:flutter/material.dart';
import 'mapDrawer.dart';
import 'drawingTools/room.dart';
import 'drawingTools/sketch.dart';

class CreateMapPage extends StatelessWidget {

  final double? height;
  final double? width;

  final ValueNotifier<Sketch?> currentSketch;
  final ValueNotifier<List<Sketch>> allSketches;
  final List<Room> rooms;

  const CreateMapPage({
    Key? key,
    required this.height,
    required this.width,
    required this.currentSketch,
    required this.allSketches,
    required this.rooms,
  }) : super(key:key);

  void _editDialog(BuildContext context, List<Room> itemSet, int index) {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _descriptionController = TextEditingController();

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
                  decoration: InputDecoration(hintText: '${itemSet[index].name}'),
                ),  
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(hintText: '${itemSet[index].info}'),
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
                Room submit = new Room(startpoint: itemSet[index].startpoint, endpoint: itemSet[index].endpoint, name: _nameController.text, info: _descriptionController.text);

                // Access the input value from _textController.text
                itemSet[index] = submit;
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Widget _itemBox({required List<Room> itemSet, required context, required index}) {
  
  return Padding(
    padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
    child: Container(
      decoration: BoxDecoration(
        
        gradient: LinearGradient(colors: [Color.fromARGB(255, 45, 40, 55), Color.fromARGB(255, 70, 63, 85)], begin: Alignment.bottomCenter, end: Alignment.topCenter),
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: 
            Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('${itemSet[index].name}'),
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
                      itemSet.remove(itemSet[index]);
                    },)
                  ],
                )
              ]
            ),
        ),
      ),
    );
}

  void _createDialog(BuildContext context, List<Room> itemSet, Offset start, Offset end) {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Enter Room Info'),
              content: Column( 
                children: <Widget> [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: 'Name'),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(hintText: 'Description'),
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
                    Room submit = Room(name: _nameController.text, info: _descriptionController.text, startpoint: itemSet[itemSet.length-1].startpoint, endpoint: itemSet[itemSet.length-1].endpoint);
                    itemSet[itemSet.length-1] = submit;
                    print('Submitted text: $submit');
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );
          }
        );
  }

  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Color.fromARGB(255, 45, 40, 55),
        
        title: Text('Gamemaster Screen', style: TextStyle(
          color: Colors.green,
        )),
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
                      child: mapDrawingBoard(
                        height: height, 
                        width: width,
                        currentSketch: currentSketch,
                        allSketches: allSketches,
                        rooms: rooms,
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
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text('Rooms'),
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        print('ROOMS: ${rooms.length}');
                                        _createDialog(context, rooms, rooms[rooms.length-1].startpoint, rooms[rooms.length-1].endpoint);
                                      }, 
                                      child: Text('Create Room')
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: rooms.length,
                            itemBuilder: (context, index) {
                              return _itemBox(itemSet: rooms, context: context, index: index);
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
                        child: Text('')
                      )
                    ),
                    Flexible(
                      child: Text(''),
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