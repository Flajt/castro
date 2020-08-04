import 'package:castro/Logic/shopAccountLogic.dart';
import 'package:flutter/material.dart';

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
    getTables = ShopAccoutLogic.getTables(); 
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getTables,
      builder: (context, snapshot){
      if(snapshot.hasData){
        return Column(
          children: <Widget>[
            ListView.builder(itemBuilder: (context, index) {

            }),
          ],
        );
      }
    });
  }
}
