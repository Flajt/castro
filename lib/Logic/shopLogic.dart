import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:castro/Logic/tables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_extend/share_extend.dart';

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
      if (snapshot.value.containsKey("tables") &&
          snapshot.value["tables"] != null) {
        List<ResturantTable> tableList = [];
        Map tables = values["tables"];
        for (String key in tables.keys) {
          String index = key.split("-")[1];
          if (key != null) {
            tableList.add(ResturantTable(
              number: int.parse(index),
              numPersons: tables[key]["numPersons"],
              where: tables[key]["where"],
            ));
          } else {
            continue;
          }
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
    //! The set operator was important without it it wouldnt't work out, I would either get a list and later a map back wich is not helpfull
    reference
        .child("/shops/$uid/tables/n-${tableNum.toString()}")
        .set({"where": where, "numPersons": numPersons});

    ///Creates QR-Code for table in a folder hidden from the user
    Directory appDocDir =
        await getApplicationSupportDirectory(); //getApplicationSupportDirectory();
    String appDocPath = appDocDir.path;
    http.Client client = http.Client();
    //Calls an api for QR-Code generation
    var ret = await client.get(Uri.encodeFull(
        'https://chart.googleapis.com/chart?cht=qr&chs=200x200&chl="/$uid-$tableNum"'));
    //Creates file to store the QR-Code
    File file = File("$appDocPath/$tableNum.png");
    //file.writeAsBytesSync(ret.bodyBytes);
    await file.writeAsBytes(ret.bodyBytes);
  }

  ///Deletes the selected table
  static void deleteTable(String number) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    String uid = currentUser.uid;
    Directory dir = await getApplicationSupportDirectory();
    String path = dir.path;
    File("$path/$number.png").deleteSync();
    await FirebaseDatabase.instance
        .reference()
        .child("/shops/$uid/tables/n-$number")
        .remove();
  }

  ///Places the QR-Codes in a file for the user to download
  static Future downloadQrCodes() async {
    //This value should be used to calculated how many Qr codes fit on one page -> the goal is 3
    const int splitable = 3;
    //Creates pdf Document canvas
    final document = pw.Document();
    //get's directory locations
    //Directory testdir = await getExternalStorageDirectory();
    Directory savedir = await getApplicationSupportDirectory();
    Directory dir = await getApplicationSupportDirectory();
    List qrCodes = await dir.list().toList();
    //Converts to String
    List<String> qrCodeStorage = qrCodes.map((e) => e.path.toString()).toList();
    List test = [];
    //Itearates through all file names to find the ones wich are .png, and ignores the others
    for (String i in qrCodeStorage) {
      if (i.contains("png")) {
        test.add(i);
      }
    }
    int pageCount = (test.length / splitable).floor();
    int overflow = test.length.remainder(splitable);
    print(overflow);
    //How many QR-Codes are currently on the page, will be resetted at 2
    int currentIteration = 0;

    List tablenums = test.map((e) => e.split("/").last.split(".")[0]).toList();
    List<pw.Widget> _widgets = [];
    //iterates through Qr-Code paths -> This was one of the longsest parts because this is the most mysterious loop I've every created....
    for (int numCurrentItems = 0;
        numCurrentItems < test.length;
        numCurrentItems++) {
      //print("$numCurrentItems from ${test.length}");
      _widgets.addAll(_createBlockEntry(
          document, test[numCurrentItems], tablenums[numCurrentItems]));
      if (splitable > test.length ||
          (test.length - numCurrentItems) == overflow) {
        if (test.length == numCurrentItems) {
          document.addPage(pw.Page(
              pageFormat: PdfPageFormat.a4,
              build: (pw.Context context) {
                return pw.Container(
                    child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: _widgets));
              }));
        }
        //This condition needs rework
        if (test.length > overflow) {
          document.addPage(pw.Page(
              pageFormat: PdfPageFormat.a4,
              build: (pw.Context context) {
                return pw.Container(
                    child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: _widgets));
              }));
        }
      }

      currentIteration += 1;

      if (currentIteration == splitable) {
        List wid = _widgets;
        document.addPage(pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Container(
                  child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: wid));
            }));
        currentIteration = 0;
        _widgets = [];
      }
    }
    Uint8List data = document.save();
    //Test for checking the file layout
    await File("${savedir.path.toString()}/qr.pdf").writeAsBytes(data);
    await ShareExtend.share("${savedir.path.toString()}/qr.pdf", "file",
        subject: "Your Castro Qr-Codes");
  }

  ///Helper function which creates one Qr-Code with table number and advertisment
  static _createBlockEntry(
      pw.Document document, String fileName, String tableNum) {
    return [
      pw.Text("Created with: Castro",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.Container(
          child: pw.Image(PdfImage.file(document.document,
              bytes: File(fileName).readAsBytesSync()))),
      pw.Text("Table: $tableNum",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.Divider(),
    ];
  }

  static Future<void> downloadVisitorData() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    String uid = currentUser.uid;
    DataSnapshot ret = await FirebaseDatabase.instance
        .reference()
        .child("/shops/$uid/info")
        .once();
    Map data = ret.value;
    String _name = currentUser.displayName;
    //Used to prevent long time storage of sensetive data
    Directory tempDir = await getTemporaryDirectory();
    File file = File(tempDir.path + "/${_name}_visitordata.pdf");
    pw.Document document = pw.Document();
    //A4 page Size is expected, this page is the first page of the document
    pw.Page initalPageData = pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text("Visitor history",
                  style: pw.TextStyle(
                      fontSize: 20.0, fontWeight: pw.FontWeight.bold)),
              pw.Padding(padding: pw.EdgeInsets.all(8)),
              pw.Text("Created ${DateTime.now()}"),
              pw.Divider(color: PdfColor(1, 1, 1), height: 10.0),
              pw.Center(
                  child: pw.Text("This file contains personal information!",
                      style: pw.TextStyle(
                          fontSize: 16.0, fontWeight: pw.FontWeight.bold))),
              pw.Center(
                  child: pw.Text(
                      "Don't share this document with non Gov. third parties",
                      style: pw.TextStyle(
                          fontSize: 16.0, fontWeight: pw.FontWeight.bold))),
              pw.Divider(color: PdfColor.fromRYB(0, 0, 0)),
              pw.Text("This file has been generated with: Castro")
            ]);
      },
    );
    //Adds inital page data
    document.addPage(initalPageData);

    ///These three loops iterate through the data structure
    for (var tablename in data.keys) {
      for (var table in data[tablename].keys) {
        Map currentData = data[tablename][table];
        document.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Center(child:pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
              pw.Text(
                tablename.replaceAll("n-", "Table number: "),
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold, fontSize: 16.0),
              ),
              pw.Divider(color: PdfColor(1, 1, 1)),
              pw.Text("Arrived at:${currentData["arrived"]}",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Padding(padding: pw.EdgeInsets.all(8)),
              pw.Text("Left at: ${currentData["gone"] ?? ""}",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Padding(padding: pw.EdgeInsets.all(8)),
              pw.Text("Name: ${currentData["name"]}",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Padding(padding: pw.EdgeInsets.all(8)),
              pw.Text("Phone: ${currentData["phone"] ?? ""}"),
              pw.Padding(padding: pw.EdgeInsets.all(8)),
              pw.Text("E-Mail: ${currentData["email"] ?? ""}"),
              pw.Padding(padding: pw.EdgeInsets.all(8)),
              pw.Text("Address: ${currentData["address"] ?? ""}"),
              pw.Padding(padding: pw.EdgeInsets.all(8)),
            ]));
          },
        ));
      }
    }
    Uint8List pdf = document.save();
    //saves file
    file.writeAsBytesSync(pdf);
    // Share dialog to share file
    await ShareExtend.share(tempDir.path + "/${_name}_visitordata.pdf", "file",
        subject: "$_name Visitor history");
  }
}
