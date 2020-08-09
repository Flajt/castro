import 'package:castro/Logic/userShopOptions.dart';
import 'package:castro/uiblocks/BasicPage.dart';
import 'package:flutter/material.dart';
import 'package:pdf_flutter/pdf_flutter.dart';

///Displays the Menu
class MenuPage extends StatefulWidget {
  MenuPage({Key key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    String shopid = data["shopid"];
    Size size = MediaQuery.of(context).size;
    return BasicPage(
        requireAppbar: false,
        body: FutureBuilder(
            future: UserShopOptions.getMenu(shopid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return PDF.network(
                  snapshot.data,
                  height: size.height,
                  width: size.width,
                );
              } else {
                return Center(
                  child:
                      CircularProgressIndicator(backgroundColor: Colors.orange),
                );
              }
            }));
  }
}