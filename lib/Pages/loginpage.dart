import 'dart:ui';
import 'package:castro/Logic/useraccountlogic.dart';
import 'package:castro/uiblocks/BasicPage.dart';
import 'package:firebase_auth_ui/providers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:firebase_auth_ui/firebase_auth_ui.dart" as auth;

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailcontroller;
  TextEditingController _passwordcontroller;
  @override
  void initState() {
    super.initState();
    //auth.FirebaseAuthUi.instance().launchAuth([AuthProvider.email()]);
    _emailcontroller = TextEditingController();
    _passwordcontroller =
        TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return SafeArea(
      child: BasicPage(
        requireAppbar: false,
        body: Stack(
          children: <Widget>[
            Image.asset(
              "assets/wine.jpg",
              fit: BoxFit.fill,
              width: _size.width,
              height: _size.height,
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(13.0),
                width: _size.width * 0.7,
                height: _size.height * 0.33,
                child: Card(
                  color: Colors.amber,
                  elevation: 10.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Title(
                          child: Text("Registrieren",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0)),
                          color: Colors.orange,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton.icon(
                            onPressed: () async{
                              await auth.FirebaseAuthUi.instance()
                                  .launchAuth([AuthProvider.email()]);
                              UserAccount.signIn("user");
                              Navigator.of(context).pushNamed("/user");
                            },
                            icon: Icon(Icons.person),
                            label: Text("Kunde"),
                            color: Colors.orange,
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton.icon(
                          onPressed: () {},
                          icon: FaIcon(FontAwesomeIcons.store),
                          label: Text("Resturant"),
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
