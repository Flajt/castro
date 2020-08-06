import 'package:castro/Logic/validator/basicvalidation.dart';
import 'package:castro/uiblocks/BasicText.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

///Dialog to register users
class ShopRegisterDialog extends AlertDialog {
  ShopRegisterDialog({
    @required TextEditingController nameController,
    @required TextEditingController emailController,
    @required TextEditingController passwordController,
    @required double height,
    @required Function onPressed,
    @required Function onCancled,
    @required formKey,
  }) : super(
            actions: [
              FlatButton(
                child: Text("Cancel"),
                onPressed: onCancled,
              ),
              RaisedButton(
                onPressed: onPressed,
                child: Text("Register"),
                color: Colors.orange,
              )
            ],
            title: Center(
                child: Title(color: Colors.orange, child: Text("Register"))),
            content: Container(
              height: height * 0.43,
              child: Container(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      BasicTextInput(
                          controller: nameController,
                          labeltext: "Shop name",
                          icon: Icon(Icons.restaurant),
                          validator: ValidationOptions.isNotEmpty),
                      BasicTextInput(
                        controller: emailController,
                        labeltext: "Email",
                        icon: Icon(Icons.email),
                        validator: ValidationOptions.isNotEmpty,
                      ),
                      BasicTextInput(
                        controller: passwordController,
                        labeltext: "Password",
                        obscure: true,
                        validator: ValidationOptions.passwortValidator,
                        icon: Icon(Icons.vpn_key),
                      ),
                    ],
                  ),
                ),
              ),
            ));
}
