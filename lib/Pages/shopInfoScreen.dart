import 'package:castro/Logic/shopLogic.dart';
import 'package:castro/Logic/tables.dart';
import 'package:castro/uiblocks/tableDialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

///Due to the lack of a better name, this Screen displays the tables and an option to add additional ones
class InfoScreen extends StatefulWidget {
  final String uid;
  InfoScreen({Key key, @required this.uid}) : super(key: key);

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  _InfoScreenState({this.uid});
  String uid;
  Future<List> getTables;

  @override
  void initState() {
    super.initState();
    getTables = ShopLogic.getTables();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          height: size.height * 0.1,
          child: ListTile(
            trailing: Tooltip(
              message: "Refresh tables",
              child: IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () => setState(() {
                        //To refresh the screen
                        getTables = ShopLogic.getTables();
                      })),
            ),
            leading: Icon(Icons.add),
            title: Text("Add table"),
            onTap: () {
              showDialog(
                  context: context,
                  child: Center(
                    child: TableDialog(),
                  ));
              //ShopLogic.addTable(tableNum, numPersons, where)
            },
          ),
        ),
        FutureBuilder(
            //How to use Streams: learned
            future: getTables,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List data = snapshot.data;
                //Expaned allows to let a Widget fill the rest of a screen with it's content, realy helpfull
                return Expanded(
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        if (data.isNotEmpty) {
                          return ListTile(
                            leading: CircleAvatar(
                                backgroundColor: Colors.orange,
                                child: Text(data[index].number.toString(),
                                    style: TextStyle(color: Colors.black))),
                            subtitle: Text(
                                "Max. number of people: ${data[index].numPersons.toString()}"),
                            title: Text(data[index].where == false
                                ? "Location: Inside"
                                : "Location: Outside"),
                            trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  ShopLogic.deleteTable(
                                      data[index].number.toString());
                                  setState(() {
                                    getTables = ShopLogic.getTables();
                                  });
                                }),
                          );
                        } else {
                          return ListTile(
                            title: Text("We couldn't find any tables..."),
                          );
                        }
                      }),
                );
              } else if (snapshot.hasError) {
                return AlertDialog(
                  title: Center(child: Text("An error has occured")),
                  content: Text("Message: ${snapshot.error}"),
                );
              }
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.orange,
              ));
            }),
      ],
    );
  }
}
