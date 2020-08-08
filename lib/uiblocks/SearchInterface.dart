import 'package:castro/Logic/userShopOptions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
///User interface for further options
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
          onTap: ()async{
            List ret = await UserShopOptions.claimTable();
            Navigator.of(context).pushNamed("/user/shopTable",arguments: {"key":ret[3],"tableNumber":ret[1],"resturantid":ret[0],"name":ret[2]});
          },
        )
      ],
    ));
  }
}
