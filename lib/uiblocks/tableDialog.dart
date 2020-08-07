import 'package:castro/Logic/shopLogic.dart';
import 'package:castro/Logic/validator/basicvalidation.dart';
import 'package:castro/uiblocks/BasicText.dart';
import 'package:flutter/material.dart';

class TableDialog extends StatefulWidget {
  TableDialog({Key key}) : super(key: key);

  @override
  _TableDialogState createState() => _TableDialogState();
}

class _TableDialogState extends State<TableDialog> {
  ///Inside or outside (false/true)
  bool _where = false;

  ///Max. num. of persons for this table
  double _personCount = 0;

  ///For text validation
  GlobalKey<FormState> formKey;

  ///Saves table number
  TextEditingController tableNumberController;
  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    tableNumberController = TextEditingController();
  }

  @override
  void dispose() {
    tableNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          RaisedButton(
            onPressed: () async {
              if (formKey.currentState.validate()) {
                ShopLogic.addTable(int.parse(tableNumberController.text),
                    _personCount.toInt(), _where);
                setState(() {
                });
                Navigator.of(context).pop();
                
              }
            },
            child: Text("Submit"),
          )
        ],
        title: Center(
            child: Title(
          color: Colors.orange,
          child: Text("Add table"),
        )),
        content: Container(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                BasicTextInput(
                  validator: ValidationOptions.isNotEmpty,
                  controller: tableNumberController,
                  labeltext: "Table number",
                  keybardtype: TextInputType.number,
                ),
                //First slider I've used so far; (value)=>function(value) pipes output into the function
                Text("People:$_personCount"),
                Slider.adaptive(
                  value: _personCount,
                  onChanged: (persons) =>
                      setState(() => _personCount = persons),
                  divisions: 10,
                  max: 10,
                ),
                //.adaptive allows to render Cupertino switch
                Row(
                  children: [
                    Text("Table location: "),
                    Text(
                      _where == false ? "Inside" : "Outside",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Switch.adaptive(
                      value: _where,
                      activeColor: Colors.orange,
                      onChanged: (value) => setState(() => _where = value),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
