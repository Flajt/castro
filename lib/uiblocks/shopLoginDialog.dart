import 'package:castro/Logic/validator/basicvalidation.dart';
import 'package:castro/uiblocks/BasicText.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

///Dialog to register users
class ShopRegisterDialog extends AlertDialog {
  ShopRegisterDialog(
    PageController controller,
    TextEditingController nameController,
    TextEditingController emailController,
    TextEditingController passwordController,
    bool autovalidate,
    double height
  ) : super(
            title: Center(child: Title(color: Colors.orange, child: Text("Register"))),
            content: Container(
              height: height * 0.43,
              child: PageView(
                scrollDirection: Axis.horizontal, // In which direction the user can scroll
                controller: controller,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        BasicTextInput(
                            controller: nameController,
                            labeltext: "Shop name",
                            icon: Icon(Icons.restaurant),
                            autovalidate: autovalidate,
                            validator: ValidationOptions.isNotEmpty),
                        BasicTextInput(
                          controller: emailController,
                          labeltext: "Email",
                          icon: Icon(Icons.email),
                          autovalidate: autovalidate,
                          validator: ValidationOptions.isNotEmpty,
                        ),
                        BasicTextInput(
                          controller: passwordController,
                          labeltext: "Passwort",
                          obscure: true,
                          autovalidate: autovalidate,
                          validator: ValidationOptions.passwortValidator,
                          icon:Icon(Icons.vpn_key),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Text("test"),
                  )
                ],
              ),
            ));
}
