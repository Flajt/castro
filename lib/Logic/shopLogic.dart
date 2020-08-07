import 'package:castro/Logic/tables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
        List<ResturantTable> tableList = [];
        print(values["tables"].runtimeType);
        Map tables = values["tables"];
        for (String key in tables.keys){
          tableList.add(
            ResturantTable(
              number: int.parse(key),
              numPersons: tables[key]["numPersons"],
              where: tables[key]["where"],
            )
          );
        }

        return tableList;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  ///Adds table to db
  static Future<void> addTable(int tableNum, int numPersons, bool where) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    String uid = currentUser.uid;
    DatabaseReference reference = FirebaseDatabase.instance.reference();
    reference.child("/shops/$uid/tables").update({
      "$tableNum": {
        "numPersons": numPersons,
        "where": where,
      }
    });
    ///Creates QR-Code for table in a folder
  }
  ///Deletes the selected table
  static void deleteTable(String number)async{
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    String uid = currentUser.uid;
    await FirebaseDatabase.instance.reference().child("/shops/$uid/tables/$number").remove();
  }
}