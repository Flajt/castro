import 'dart:convert';
import 'package:castro/Logic/tables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

///Handles non account based logic
class ShopLogic {
  ///Get's the tables of the resurant
  static Future<List> getTables() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    String uid = currentUser.uid;
    DatabaseReference reference = FirebaseDatabase.instance.reference();
    DataSnapshot snapshot = await reference.child("/shops/$uid").once();
    if (snapshot.value != null) {
      Map values = snapshot.value;
      if (snapshot.value.containsKey("tables")) {
        print(values["tables"]);
        String tables = values["tables"];
        List<ResturantTable> tableList = json.decode(tables);
        return tableList;
      } else {
        return [false];
      }
    } else {
      return [false];
    }
  }

  ///Adds table to db
  static Future<void> addTable(int tableNum, int numPersons, int where) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    String uid = currentUser.uid;
    DatabaseReference reference = FirebaseDatabase.instance.reference();
    reference.child("/shops/$uid").update({
      "tables": {
        "tableNum": tableNum,
        "numPersons": numPersons,
        "where": where,
        "reserved": {},
      }
    });
  }
  static get getTablesasync async *{
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    String uid = currentUser.uid;
    FirebaseDatabase.instance.reference().child("/shops/$uid/tables").onValue;
  }
}
