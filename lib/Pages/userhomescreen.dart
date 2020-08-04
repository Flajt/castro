import 'package:castro/Logic/useraccountlogic.dart';
import 'package:castro/uiblocks/BasicDrawer.dart';
import 'package:castro/uiblocks/BasicPage.dart';
import 'package:castro/uiblocks/SearchInterface.dart';
import 'package:flutter/material.dart';

class UserHomeScreen extends StatefulWidget {
  UserHomeScreen({Key key}) : super(key: key);
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  String currentUser;
  Future userSetupCompleted;
  Future getUserCreds;
  Map<String, dynamic> user;

  @override
  void initState() {
    super.initState();
    ///Calls Future for later usage, prevents unnecessary reloads
    userSetupCompleted = UserAccount.accountCompleted();
    ///User creds
    getUserCreds = UserAccount.getUserCreds(); //  and here aswell
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return BasicPage(
      actions: <Widget>[
        IconButton(
          tooltip: "Refresh",
            icon: Icon(
              Icons.refresh,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                ///Reload option to update if data has changed
                getUserCreds = UserAccount.getUserCreds();
                userSetupCompleted = UserAccount.accountCompleted();
              });
            })
      ],
      requireAppbar: true,
      drawer: UserDrawerStorage(), //Loads Drawer (extandable side menue)
      //uses custom AppBar to load userdata
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            tooltip: "Refresh",
            icon: Icon(Icons.refresh),
            onPressed: () => setState(() {
              ///Same Reload option
              getUserCreds = UserAccount.getUserCreds();//should refresh screen if pressed
              userSetupCompleted = UserAccount.accountCompleted();
            }),
          )
        ],
        centerTitle: true,
        title: FutureBuilder(
            future: getUserCreds,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                user = snapshot.data;
                return Text("Welcome ${user['name']}");
              } else {
                //shows default text if there are issues with the user
                return Text("Welcome");
              }
            }),
      ),
      body: FutureBuilder(
        future:
            userSetupCompleted, //Checks if the user has his finished profile creation
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == false) {
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
                        "Please complete your user profile,\n so you can start to use the app!",
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
            } else {
              return Center(child: SearchInterFace()); 
            }
          } else if (snapshot.hasError) {
            return AlertDialog(
              title: Title(
                child: Text("An error occured!"),
                color: Colors.orange,
              ),
              content: Text(
                  "Please retry it againe.\n Error description: ${snapshot.error.toString()}"),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
