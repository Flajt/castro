import 'dart:ui';
import 'package:castro/Logic/useraccountlogic.dart';
import 'package:castro/Logic/validator/basicvalidation.dart';
import 'package:castro/uiblocks/BasicPage.dart';
import 'package:castro/uiblocks/BasicText.dart';
import 'package:castro/uiblocks/loginDialog.dart';
import 'package:castro/uiblocks/shopLoginDialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailcontroller;
  TextEditingController _nameController;
  TextEditingController _passwordcontroller;
  bool autovalidate = false;
  @override
  void initState() {
    super.initState();
    //auth.FirebaseAuthUi.instance().launchAuth([AuthProvider.email()]);
    _emailcontroller =
        TextEditingController(); //initializing here prevents reinintialization due to statechanges
    _passwordcontroller = TextEditingController();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    // frees resources
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _nameController.dispose();
    super.dispose();
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
                            onPressed: () {
                              showDialog(
                                context: context,
                                child: Center(
                                  child: SingleChildScrollView(
                                    child: RegisterDialog(
                                      onCancel: () {
                                        Navigator.of(context).pop();
                                      },
                                      height: MediaQuery.of(context).size.height,
                                      nameController: _nameController,
                                      passwordController: _passwordcontroller,
                                      emailController: _emailcontroller,
                                      autovalidate: autovalidate,
                                      onRegister: () {
                                        if (_emailcontroller.text.isNotEmpty &&
                                            _nameController.text.isNotEmpty) {
                                          if (_passwordcontroller
                                                  .text.isNotEmpty &&
                                              _passwordcontroller.text.length >=
                                                  6) {
                                            //Simple try catch to prevent errors, by letting the user edit his input
                                            UserAccount.signIn(
                                                "user",
                                                _nameController.text,
                                                _emailcontroller.text,
                                                _passwordcontroller.text);
                                            Navigator.of(context)
                                                .pushNamed("/user");
                                          } else {
                                            setState(() {
                                              autovalidate = true;
                                              _passwordcontroller
                                                  .clear(); //So the user has to add the data againe to prevent mistakes
                                              _emailcontroller.clear();
                                              _nameController.clear();
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            autovalidate = true;
                                            _passwordcontroller
                                                .clear(); //So the user has to add the data againe to prevent mistakes
                                            _emailcontroller.clear();
                                            _nameController.clear();
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.person),
                            label: Text("Kunde"),
                            color: Colors.orange,
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton.icon(
                          onPressed: () {
                            showDialog(
                                context: context,
                                child: Center(
                                  child: SingleChildScrollView(
                                    child: ShopRegisterDialog(
                                        PageController(),
                                        TextEditingController(),
                                        TextEditingController(),
                                        TextEditingController(),
                                        false,
                                        MediaQuery.of(context).size.height),
                                  ),
                                ));
                          },
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
