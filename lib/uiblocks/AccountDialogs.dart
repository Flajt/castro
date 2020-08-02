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
    @required Function onSubmitted,
  }) : super(
            title: Title(color: Colors.orange, child: Text(title)),
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
            content: Column(
              children: <Widget>[
                Text(currentInput),
                BasicTextInput(
                  phonePrefix: prefix,
                  autovalidate: autovalidate,
                  controller: controller,
                  labeltext: labeltext,
                  icon: icon,
                  validator: validator,
                )
              ],
            ));
}
