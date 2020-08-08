import 'package:barcode_scan/model/scan_result.dart';
import 'package:barcode_scan/platform_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pdf/widgets.dart';

///Manges the optins a user has regarding shops like, claming tables, bookings a.s.o
class UserShopOptions {
  ///Claims table via QR-Code
  static Future<List> claimTable() async {
    ///TODO: Call the db only once to decrease bandwith and costs!
    //Scans the QR-Code to get the table id
    //TODO: Add cloud function later which removes entrys after 3 weeks for data protection and to free storage
    ScanResult scanner = await BarcodeScanner.scan();
    String content = scanner.rawContent.replaceAll('"', "");
    List<String> split = content.split("-");
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    
    DataSnapshot _ref = await FirebaseDatabase.instance
        .reference()
        .child("/users/${currentUser.uid}/address")
        .once();
    String address = _ref.value;
    String _resturantid = split[0];
    String tablenNumber = split[1];
    DataSnapshot _data = await FirebaseDatabase.instance.reference().child("/shops/$_resturantid").once();
    String name = _data.value["name"];
    print(name);
    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child("/shops/$_resturantid/info/n-$tablenNumber");
    DateTime now = DateTime.now();
    DatabaseReference pushref =  ref.push()..set({
      "arrived" : now.toIso8601String(),
      "gone" : null,
      "name" : currentUser.displayName,
      "phone" : currentUser.phoneNumber??"",
      "address" : address??"",
      "email" : currentUser.email,
    });
    String key = pushref.key;
    DataSnapshot ret = await FirebaseDatabase.instance.reference().child("/shops/$_resturantid").once();
    return [_resturantid, tablenNumber,name,key];
    //TODO: Mark table as blocked
    //Save user information with table and data in Databases
  }
  ///Will be called if you leave a table
  static Future<void>leaveTable(String tableNum,String shopId,String uid){
    DatabaseReference ref =  FirebaseDatabase.instance.reference();
    ref.child("/shops/$shopId/info/n-$tableNum/$uid").update({"gone":DateTime.now().toIso8601String()});
  }

  ///Allows to book a table for [personCuount] persons at [dateTime]
  static Future<void> bookTable(
      String tableid, int personCount, DateTime dateTime) {
    //TODO: Implement
  }
  ///Get's the link for the menu
  static Future<String> getMenu(String shopid)async{
    return await FirebaseStorage.instance.ref().child("$shopid").getDownloadURL();

  }

}
