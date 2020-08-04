import 'dart:convert';
import 'dart:io';

import 'package:castro/Logic/tables.dart';
import 'package:castro/Logic/useraccountlogic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

///General Logic for all shop account Logic
class ShopAccoutLogic {
  ///Signs shop owner in
  static signIn(
      String type, String shopname, String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get("username") == null) {
      await prefs.setString("name", shopname);
      await prefs.setString("email", email);
      await prefs.setString("type", "shop");
      AuthResult result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser currentUser = result.user;
      UserUpdateInfo info = UserUpdateInfo();
      info.displayName = shopname;
      await currentUser.updateProfile(info);
    }
  }

  static Future getUserCreds() async {
    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      await user.reload(); // get actual user data to prevent any issues
      return {
        "name": user.displayName,
        "email": user.email,
        "user": user
      }; //returns userdata as map incl. FirebaseUser Oject for futher use
    } catch (e) {
      //fail save
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return {
        "name": prefs.get("name"),
        "email": prefs.get("email"),
        "user": null
      }; //returns this if we can't fetch user via firebase
    }
  }

  ///Checks if the user has finished account creation
  static Future accountCompleted() async {
    bool stepOne;
    bool stepTwo;
    bool stepThree;
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    DatabaseReference reference =
        FirebaseDatabase.instance.reference(); //creates db reference
    DataSnapshot data = await reference
        .child("/shops/${currentUser.uid}")
        .once(); //grabs the db once
    if (data.value != null) {
      stepOne = data.value
          .containsKey("address"); //checks if the address entry exists
      stepTwo = data.value.containsKey("phone");
      stepThree = data.value.containsKey("openingtimes");
      if (stepOne) {
        if (stepTwo && stepThree) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

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
        List<Table> tableList = json.decode(tables);
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
  ///Deletes the user by using [UserAccount.deleteUser()]
  static Future<void> deleteAccount()async{
    await UserAccount.deleteUser();
  }
  ///Uploads the menue file
  static Future<void> uploadMenue(File menue)async{
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    String _uid = currentUser.uid;
    StorageReference storage =  FirebaseStorage().ref();
    ///Adds metadata for possible filtering
    StorageMetadata metadata = StorageMetadata(customMetadata: {"owner":_uid});
    ///File will be stored under users uid, so everytime a new one is uploaded, it will be updated
    storage.child("/$_uid").putFile(menue,metadata);
  }
}
