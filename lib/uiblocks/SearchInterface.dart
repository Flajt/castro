import 'package:castro/Logic/userShopOptions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchInterFace extends StatefulWidget {
  SearchInterFace({Key key}) : super(key: key);

  @override
  _SearchInterFaceState createState() => _SearchInterFaceState();
}

class _SearchInterFaceState extends State<SearchInterFace> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Container(color:Colors.black),
        ListTile(
          leading: FaIcon(FontAwesomeIcons.qrcode),
          title: Text("Scan Code"),
          onTap: UserShopOptions.claimTable,
        )
      ],
    ));
  }
}
