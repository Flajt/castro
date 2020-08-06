import 'dart:convert';

import 'package:castro/Logic/shopAccountLogic.dart';
import 'package:castro/Logic/shopLogic.dart';
import 'package:castro/Logic/tables.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InfoScreen extends StatefulWidget {
  InfoScreen({Key key}) : super(key: key);

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  Future<List> getTables;
  @override
  void initState() {
    super.initState();
    getTables = ShopLogic.getTables();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        //How to use Streams: learned
        stream: ShopLogic.getTablesasync,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return Column(
              children: <Widget>[
                ListView.builder(itemBuilder: (context, index) {
                  if (snapshot.hasData) {
                    List<ResturantTable> data =
                        json.decode(snapshot.data.toString());
                    return ListTile(
                      leading: Text(data[index].number.toString()),
                      subtitle: Text(data[index].numPersons.toString()),
                      trailing: Text(
                          data[index].where == false ? "Inside" : "Outside"),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: AlertDialog(
                        title: Title(
                            color: Colors.red[600],
                            child: Text("An error has occured")),
                        content: Text(snapshot.error.toString()),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                          backgroundColor: Colors.orange),
                    );
                  }
                }
                ),
              ],
            );
          }
          return Center(child: CircularProgressIndicator(backgroundColor: Colors.orange,));

        });
  }
}
