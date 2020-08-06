import 'package:castro/Logic/shopAccountLogic.dart';
import 'package:castro/Logic/validator/basicvalidation.dart';
import 'package:castro/uiblocks/BasicPage.dart';
import 'package:castro/uiblocks/BasicText.dart';
import 'package:castro/uiblocks/timeSelectBlock.dart';
import 'package:flutter/material.dart';

///Class which defines skeletion for AlertDialogs which are used to update userinfos
class AccountDialog extends AlertDialog {
  AccountDialog({
    ///If needed the prefix to use for phone numbers
    Widget prefix,

    ///FormKey for validation
    GlobalKey<FormState> formKey,

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
    bool autovalidate,

    ///To handle location of widgets etc.
    @required BuildContext context,

    ///To deal with button pressed
    @required Function onSubmitted,
    final TextInputType keyboardtype,

    ///For more information
    String helptext
  }) : super(
            title:
                Center(child: Title(color: Colors.orange, child: Text(title))),
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
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Text("Current: $currentInput",overflow: TextOverflow.ellipsis,),
                    Divider(color: Colors.white),
                    BasicTextInput(
                      helptext: helptext,
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
              ),
            ));
}

/*
///Dialog for Openingtimes, allows shops to add their openingtimes
class OpeningTimesDialog extends AlertDialog {
  OpeningTimesDialog({
    String title,

    ///TextEditingController for mondays - friday [mon],[tue],[wed],[thu],[fri],[sat],[sun]
    @required TextEditingController mon,
    @required TextEditingController tue,
    @required TextEditingController wed,
    @required TextEditingController thu,
    @required TextEditingController fri,
    @required TextEditingController sat,
    @required TextEditingController sun,

    ///FormKey for validation
    @required GlobalKey<FormState> formKey,

    ///Function to exceute once the user finishes his input
    @required Function onSubmitt,

    ///To allow [Navigator.of(context).pop()]
    @required BuildContext context,
  }) : super(
          title: Center(
            child: Title(
              color: Colors.orange,
              title: title,
              child: Text(title),
            ),
          ),
          actions: [
            FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Cancel")),
            RaisedButton(
              onPressed: onSubmitt,
              child: Text("Submit"),
            )
          ],
          content: Container(
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  Text(
                      "Write your input like this:\ne.g 12-14 or 12-14,16-17 for mulitple opening times."),
                  BasicTextInput(
                    labeltext: "Monday",
                    controller: mon,
                    validator: ValidationOptions.isNotEmpty,
                  ),
                  BasicTextInput(
                    labeltext: "Tuesday",
                    controller: tue,
                    validator: ValidationOptions.isNotEmpty,
                  ),
                  BasicTextInput(
                    labeltext: "Wednesday",
                    controller: wed,
                    validator: ValidationOptions.isNotEmpty,
                  ),
                  BasicTextInput(
                    validator: ValidationOptions.isNotEmpty,
                    labeltext: "Thursday",
                    controller: thu,
                  ),
                  BasicTextInput(
                    validator: ValidationOptions.isNotEmpty,
                    labeltext: "Friday",
                    controller: fri,
                  ),
                  BasicTextInput(
                    validator: ValidationOptions.isNotEmpty,
                    labeltext: "Saturday",
                    controller: sat,
                  ),
                  BasicTextInput(
                    validator: ValidationOptions.isNotEmpty,
                    controller: sun,
                    labeltext: "Sunday",
                  ),
                ],
              ),
            ),
          ),
        );
}
*/
///Widget which allows to pick opening times of the shop
class OpenIngTimePicker extends StatefulWidget {
  OpenIngTimePicker({Key key}) : super(key: key);

  @override
  _OpenIngTimePickerState createState() => _OpenIngTimePickerState();
}

class _OpenIngTimePickerState extends State<OpenIngTimePicker> {
  @override
  Widget build(BuildContext context) {
    ///Gets size of the screen, for Widget size calculation
    Size size = MediaQuery.of(context).size;

    ///Will store the openingtimes for a day, allows for multiple openingtimes a day
    Map<String, List<String>> openingTimes = {};
    /*
    TODO: implement later if time
    ///Stores widgets to display alread selected opening times, index = [days]
    Map<String, List<Widget>> _widgetStorage = {};*/

    ///Children title for the listView; Helps for more "dynamic" generation of context
    const List days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];

    return AlertDialog(
      actions: [FlatButton(onPressed: ()=>Navigator.of(context).pop(), child: Text("Cancel")),RaisedButton(child: Text("Submit"),onPressed: 
      (){
        ShopAccoutLogic.editOpeningTimes(openingTimes);
      }
      )],
        title: Center(
            child:
                Title(color: Colors.orange, child: Text("Edit opening times"))),
        content: Container(
            child: ListView.builder(

                ///Builds the fields for each day
                itemCount: days.length,
                itemBuilder: (context, index) {
                  print("building");
                  ///Creates an empty list to store openingtimes in it
                  openingTimes[days[index]] = [];
                  //_widgetStorage[days[index]] = [];
                  return TimePickerExpansionTile(
                    title: days[index].toString(),
                    onSubmitted: (ohour,ominute,chour,cminute){
                      print(ohour);
                      print(openingTimes);
                      openingTimes[days[index]].add("${ohour??0}:${ominute??0}-${chour??0}:${cminute??0}");
                      print(openingTimes);
                    },
                  );
                })));
  }
}

class TimePickerExpansionTile extends StatefulWidget {
  String title;
  Function(int, int, int, int) onSubmitted;
  TimePickerExpansionTile({Key key,@required this.title,@required this.onSubmitted})
      : super(key: key);

  @override
  _TimePickerExpansionTileState createState() =>
      _TimePickerExpansionTileState(title: title,onSubmitted: onSubmitted);
}
///Helper class which builds the custom [ExpansionTiles] for [OpenIngTimePicker]
class _TimePickerExpansionTileState extends State<TimePickerExpansionTile> {
  _TimePickerExpansionTileState({this.title, this.onSubmitted});
  ///Title for Expansiontile
  String title;

  ///Function to call on submitted
  Function(int, int, int, int) onSubmitted;

  ///Openint time
  int ohour;
  int ominutes;

  ///Closing times
  int chour;
  int cminutes;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ExpansionTile(
        title: Center(
            child: Title(
          child: Text(title),
          color: Colors.orange,
        )),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TimeSelectBlock(
                  timeType: "hours",
                  //this setState calling might note be the smartest idea, due to constant Widget tree rebuilding, maybe use Provider ?
                  onChanged: (value) => setState(() => ohour =
                      value), //This is used for one liner commands, so you don't need the braces
                  width: size.width,
                  height: size.height),
              Text(":"),
              TimeSelectBlock(
                  timeType: "minutes",
                  onChanged: (value) => setState(() => ominutes = value),
                  width: size.width,
                  height: size.height),
              Text("-"),
              TimeSelectBlock(
                  timeType: "hours",
                  onChanged: (value) => setState(() => chour =
                      value), //This is used for one liner commands, so you don't need the braces
                  width: size.width,
                  height: size.height),
              Text(":"),
              TimeSelectBlock(
                  timeType: "minutes",
                  onChanged: (value) => setState(() => cminutes =
                      value), //This is used for one liner commands, so you don't need the braces
                  width: size.width,
                  height: size.height),
            ],
          ),
          FlatButton(
            onPressed: () {
                onSubmitted(ohour, ominutes, chour, cminutes);
            },
            child: Text("Submit",
                style: TextStyle(
                  color: Colors.orange,
                )),
          )
        ]);
    ;
  }
}
