import 'package:castro/Logic/signout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDrawerStorage extends StatelessWidget {
  const UserDrawerStorage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(leading: Icon(Icons.account_circle),onTap: ()=>Navigator.of(context).pushNamed("/user/settings"),title: Text("Account"),),
          Divider(color: Colors.black38),
          ListTile(leading: Icon(Icons.favorite),onTap: (){},title: Text("Lieblings Resturants"),),
          Divider(color: Colors.black38),
          ListTile(leading:Icon(Icons.exit_to_app),onTap: (){
            signout();
            Navigator.of(context).popAndPushNamed("/");
          },title: Text("Logout"),),
        ],
      ),
    );
  }
}