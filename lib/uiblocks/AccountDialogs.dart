import 'package:castro/uiblocks/BasicText.dart';
import 'package:flutter/material.dart';

///Class which defines skeletion for AlertDialogs which are used to update userinfos
class AccountDialog extends AlertDialog {
  AccountDialog({
    ///If needed the prefix to use for phone numbers
    Widget prefix,

    ///Title
    @required String title,

    ///Allows access of input data
    @required TextEditingController controller,

    ///Allows for custom validation rules of the input
    @required Function(String) validator,

    ///To display current data (if existing)
    @required String currentInput,

    ///Label to display
    @required String labeltext,
    Widget icon,

    ///Set to true for validation
    @required bool autovalidate,

    ///To handle location of widgets etc.
    @required BuildContext context,
    ///To deal with button pressed
    @required Function onSubmitted,
    final TextInputType keyboardtype,
  }) : super(
            title: Center(child: Title(color: Colors.orange, child: Text(title))),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Cancel")),
              RaisedButton(
                onPressed: onSubmitted,
                child: Text("Submit"),
                color: Colors.orange,
              )
            ],
            content: Container(
              height: MediaQuery.of(context).size.height * 0.22,
              child: Column(
                children: <Widget>[
                  Text("Current: $currentInput"),
                  Divider(color: Colors.white),
                  BasicTextInput(
                    keybardtype: keyboardtype,
                    phonePrefix: prefix,
                    autovalidate: autovalidate,
                    controller: controller,
                    labeltext: labeltext,
                    icon: icon,
                    validator: validator,
                  )
                ],
              ),
            ));
}
