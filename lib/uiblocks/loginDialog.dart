import 'package:castro/Logic/validator/basicvalidation.dart';
import 'package:castro/uiblocks/BasicText.dart';
import "package:flutter/material.dart";
///Dialog for user Registration
class RegisterDialog extends AlertDialog {
  RegisterDialog({
    @required TextEditingController nameController,
    @required TextEditingController passwordController,
    @required TextEditingController emailController,
    ///If validation should be true
    @required bool autovalidate,
    @required double height,

    ///Function which will be run on if the registe button is pressed
    Function onRegister,

    ///Function which will be run if the cancel button is pressed
    Function onCancel,
  }) : super(
            title: Center(
              child: Title(
                child: Text("Register"),
                color: Colors.orange,
              ),
            ),
            content: Container(
              height: height * 0.43,
              child: Column(
                children: <Widget>[
                  BasicTextInput(
                    validator: ValidationOptions.isNotEmpty,
                    autovalidate: autovalidate,
                    controller: nameController,
                    labeltext: "Username:",
                    icon: Icon(Icons.person),
                  ),
                  Divider(),
                  BasicTextInput(
                      autovalidate: autovalidate,
                      controller: emailController,
                      labeltext: "Email",
                      icon: Icon(Icons.email),
                      validator: ValidationOptions.isNotEmpty),
                  Divider(),
                  BasicTextInput(
                      autovalidate: autovalidate,
                      controller: passwordController,
                      labeltext: "Passwort",
                      validator: ValidationOptions.passwortValidator,
                      icon: Icon(Icons.vpn_key),
                      obscure: true)
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(onPressed: onCancel, child: Text("Cancel")),
              RaisedButton(
                onPressed: onRegister,
                color: Colors.orange,
                child: Text("Register"),
              )
            ]);
}
