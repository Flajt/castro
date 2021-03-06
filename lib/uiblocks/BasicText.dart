import 'package:castro/Logic/validator/basicvalidation.dart';
import 'package:flutter/material.dart';

///Class responsible for the look of the text InputFields, with basic configuration
class BasicTextInput extends StatelessWidget {
  final bool obscure;
  final TextEditingController controller;
  final dynamic icon;
  final String labeltext;
  final dynamic validator;
  final bool autovalidate;
  final String helptext;
  final Widget phonePrefix;
  final TextInputType keybardtype;
  const BasicTextInput(
      {Key key,
      this.obscure,
      @required this.controller,
      @required this.labeltext,
      this.icon,
      this.validator,
      this.helptext,
      this.autovalidate,
      this.phonePrefix,
      this.keybardtype})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: TextFormField(
          keyboardType: keybardtype??TextInputType.text,
      autovalidate: autovalidate ?? false,
      validator: (value) => validator(value),
      obscureText: obscure ?? false,
      controller: controller,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        prefix: phonePrefix,
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
            borderRadius: BorderRadius.circular(13)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(10)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(13)),
        helperText: helptext ?? "",
        hoverColor: Colors.orange,
        //counterStyle: TextStyle(color: Colors.white),
        //focusColor: Colors.green,
        filled: true,

        icon: icon,
        labelText: labeltext,
        labelStyle: TextStyle(color: Colors.black),
        hintStyle: TextStyle(color: Colors.orange),
        fillColor: Colors.white,
        //border: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent,width: 1.0,),
        // borderRadius: BorderRadius.all(
        // Radius.circular(10.0)
        //)
        //)
        //),
      ),
    ));
  }
}
