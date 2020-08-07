import 'package:castro/Logic/shopAccountLogic.dart';
import 'package:castro/Pages/shopInfoScreen.dart';
import 'package:castro/uiblocks/BasicDrawer.dart';
import 'package:castro/uiblocks/BasicPage.dart';
import 'package:flutter/material.dart';

class ShopHomeScreen extends StatefulWidget {
  ShopHomeScreen({Key key}) : super(key: key);

  @override
  _ShopHomeScreenState createState() => _ShopHomeScreenState();
}

class _ShopHomeScreenState extends State<ShopHomeScreen> {
  Future accountComplete;
  Future getShopCreds;
  String uid;
  @override
  void initState() {
    super.initState();
    accountComplete = ShopAccoutLogic.accountCompleted();
    getShopCreds = ShopAccoutLogic.getShopCreds();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return BasicPage(
      drawer: ShopDrawerStorage(),
      requireAppbar: true,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: (){
            setState(() {
              accountComplete = ShopAccoutLogic.accountCompleted();
            });
          })
        ],
          centerTitle: true,
          title: Title(
              color: Colors.orange,
              child: FutureBuilder(
                future: getShopCreds,
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    Map _data = snapshot.data;
                    String name = _data["name"];
                    if(_data["user"]!=null){
                    uid = _data["user"].uid;
                    }
                    return Text(name);
                  }else{
                    return Text("Welcome");
                  }
                }))),
      body: FutureBuilder(
          future: accountComplete, builder: (context, snapshot) {
            if(snapshot.hasData){
              bool data = snapshot.data;
              if(data){
                return InfoScreen(
                  uid: uid,
                );
              }
              else{
                return Stack(children: [
                //Stack allows to place Widgets on top of each other, in this case it's used to place the Icon ontop of the card which displays the message
                Center(
                  child: Container(
                    width: _size.width * 0.8,
                    height: _size.height * 0.2,
                    padding: EdgeInsets.all(10.0),
                    child: Card(
                      color: Colors.orange,
                      child: Center(
                          child: Text(
                        "Please complete your user profile,\n so you can start to use the App!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      )),
                    ),
                  ),
                ),
                Positioned(
                  child: Icon(
                    Icons.warning,
                    color: Colors.black,
                  ),
                  height: _size.height * 0.77,
                  width: _size.width,
                )
              ]);
              }
            }else if (snapshot.hasError){
              return AlertDialog(
                title: Title(color: Colors.red[600], child: Text("An error has occured")),
                content: Text(snapshot.error),
              );
            }
          }),
    );
  }
}
