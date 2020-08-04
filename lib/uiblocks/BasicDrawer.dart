import 'dart:io';

import 'package:castro/Logic/shopAccountLogic.dart';
import 'package:castro/Logic/signout.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDrawerStorage extends StatelessWidget {
  const UserDrawerStorage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.account_circle,color: Colors.black,),
            onTap: () => Navigator.of(context).pushNamed("/user/settings"),
            title: Text("Account"),
          ),
          Divider(color: Colors.black38),
          ListTile(
            leading: Icon(Icons.favorite,color: Colors.black,),
            onTap: () {},
            title: Text("Favorite resturants"),
          ),
          Divider(color: Colors.black38),
          ListTile(
            leading: Icon(Icons.exit_to_app,color: Colors.black,),
            onTap: () {
              signout();
              Navigator.of(context).popAndPushNamed("/login");
            },
            title: Text("Logout"),
          ),
        ],
      ),
    );
  }
}

class ShopDrawerStorage extends StatelessWidget {
  const ShopDrawerStorage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.account_circle,color: Colors.black,),
            onTap: () => Navigator.of(context).pushNamed("/shop/settings"),
            title: Text("Account"),
          ),
          Divider(color: Colors.black38),
          ListTile(
            leading: Icon(Icons.restaurant_menu,color: Colors.black),
            onTap: () async{
              File menue = await FilePicker.getFile(allowedExtensions: ["pdf"],type: FileType.custom);
              ShopAccoutLogic.uploadMenue(menue);
            },
            title: Text("Menue"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.file_download,color: Colors.black,),
            title: Text("Download visitor history"),
            onTap: (){},
          ),
          Divider(color: Colors.black38),
          ListTile(
            leading: Icon(Icons.exit_to_app,color: Colors.black,),
            onTap: () {
              signout();
              Navigator.of(context).popAndPushNamed("/login");
            },
            title: Text("Logout"),
          )
        ],
      ),
    );
  }
}
