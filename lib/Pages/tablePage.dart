import 'package:castro/Logic/shopAccountLogic.dart';
import 'package:castro/Logic/shopLogic.dart';
import 'package:castro/Logic/userShopOptions.dart';
import 'package:castro/uiblocks/BasicPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdf_flutter/pdf_flutter.dart';

class TablePage extends StatefulWidget {
  TablePage({Key key}) : super(key: key);

  @override
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Map data = ModalRoute.of(context).settings.arguments;
    String id = data["resturantid"];
    DateTime now = data["now"];
    String tableNum = data["tableNumber"];
    String resturantName = data["name"];
    String key = data["key"]; //Placeholder
    return BasicPage(
      actions: [
        IconButton(
            icon: Icon(
              Icons.restaurant_menu,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed("/user/menu", arguments: {"shopid": id});
            }),
      ],
      requireAppbar: true,
      title: "Welcome at $resturantName!", //TODO: At resturant name
      body: Column(
        children: [
          SvgPicture.asset(
            "assets/table.svg",
            width: size.width,
            height: size.height * 0.5,
          ),
          Text(
            "Welcome at table: $tableNum",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          Tooltip(
              message: "Press if you leave the table",
              child: RaisedButton(
                  onPressed: () {
                    UserShopOptions.leaveTable(tableNum, id, key);
                    showDialog(
                        context: context,
                        child: AlertDialog(
                          actions: [
                            RaisedButton(
                                color: Colors.orange,
                                onPressed: () => Navigator.of(context)
                                    .popAndPushNamed("/user"),
                                child: Text("Good bye!"))
                          ],
                          title: Center(
                              child: Text(
                            "Thank you for your visit",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                          content: Container(
                            height: size.height * 0.45,
                            child: Column(children: [
                              SvgPicture.asset(
                                "assets/leaving.svg",
                                width: size.width * 0.4,
                                height: size.height * 0.4,
                              ),
                              Text("We were happy to serve you!",
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ]),
                          ),
                        ));
                  },
                  color: Colors.orange,
                  child: Text("Leaving")))
        ],
      ),
    );
  }
}

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
