import 'package:flutter/material.dart';
///Defines basic Layout of the Page
class BasicPage extends Scaffold { 
  BasicPage({
    String title,
    @required Widget body,
    List<Widget> actions,
    bool requireAppbar, //If an appbar is required
    AppBar appBar,
    dynamic drawer,
    }
  ) : super(
          appBar: requireAppbar ? appBar==null? 
              AppBar(
                centerTitle: true,
                  title: Title(color: Colors.orange, child: Text(title)),
                  actions: actions,
                ) : appBar : null,
          body: body,
          drawer:drawer,
        );
}


