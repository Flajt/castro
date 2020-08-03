import 'package:barcode_scan/model/scan_result.dart';
import 'package:barcode_scan/platform_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdf/widgets.dart';

///Manges the optins a user has regarding shops like, claming tables, bookings a.s.o
class UserShopOptions{
  ///Claims table via QR-Code
  static Future<void> claimTable()async{
    //Scans the QR-Code to get the table id
   ScanResult scanner =  await BarcodeScanner.scan();
    //TODO: Mark table as blocked
    //Save user information with table and data in Databases
  }
  ///Allows to book a table for [personCuount] persons at [dateTime]
  static Future<void> bookTable(String tableid, int personCount,DateTime dateTime){
    //TODO: Implement
  }
}