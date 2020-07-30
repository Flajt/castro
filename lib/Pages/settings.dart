import 'package:castro/Logic/useraccountlogic.dart';
import 'package:castro/uiblocks/BasicPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AccountPage extends StatefulWidget {
  AccountPage({Key key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BasicPage(
        requireAppbar: true,
        title: "Account Settings",
        body: Column(
          children: <Widget>[
            ListTile(
              leading: FaIcon(FontAwesomeIcons.solidTrashAlt),
              title: Text("Delte Account"),
              onTap: () {
                showDialog(
                    context: context,
                    child: AlertDialog(
                      title: Title(
                        child: Text(
                          "Are your sure?",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        color: Colors.red,
                      ),
                      shape: Border.all(color: Colors.red),
                      content: Text(
                        "You attempt to delete your account are you sure?\n \nYour data will be deleted beyond recovery (from our side).",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                              UserAccount.deleteUser();
                              Navigator.of(context).popAndPushNamed("/login");
                            },
                            child: Text(
                              "Delete",
                              style: TextStyle(color: Colors.black),
                            )),
                        RaisedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text("Cancel"),
                          color: Colors.orangeAccent,
                        )
                      ],
                    ));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text("Edit account information"),
              onTap: () =>
                  Navigator.of(context).pushNamed("/user/settings/edit"),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
