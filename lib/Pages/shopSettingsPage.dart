import 'package:castro/Logic/shopAccountLogic.dart';
import 'package:castro/uiblocks/BasicDrawer.dart';
import 'package:castro/uiblocks/BasicPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
///Responsible for displaying the settings
class ShopSettingsPage extends StatefulWidget {
  ShopSettingsPage({Key key}) : super(key: key);

  @override
  _ShopSettingsPageState createState() => _ShopSettingsPageState();
}

class _ShopSettingsPageState extends State<ShopSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return BasicPage(
      requireAppbar: true,
      title: "Settings",
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Edit name"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.email),
            title:Text("Edit email")
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text("Edit phone number"),
          ),
          Divider(),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.calendarAlt),
            title: Text("Edit opening times"),
          ),
          Divider(),
          AbsorbPointer(
            child: ListTile(
              leading: FaIcon(FontAwesomeIcons.moneyBillAlt),
              title: Text("Edit payment infomation"),
              subtitle: Text("Coming soon..."),
            ),
          ),
          Divider(),
          ListTile(
            title: Text("Delte account"),
            leading: Icon(Icons.delete),
            onTap: (){
              showDialog(context: context,child: AlertDialog(
                title: Title(color: Colors.red[600], child: Text("Are you sure?")),
                content: Text("Your data will be removed and lost forever are you sure?\n You should download all files with your customer history beforehand!"),
                actions: <Widget>[
                  FlatButton(onPressed: (){
                    ShopAccoutLogic.deleteAccount();
                    Navigator.of(context).popAndPushNamed("/login");
                  }, child: Text("Procced!"))
                ],
              ));
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}