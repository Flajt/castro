import 'package:flutter/material.dart';

///Handles needed functions for the [TimeSelectBlock] Widget
class TimeSelectBlockLogic {
  ///Creates TextFields containg all hours and minutes of a day
  static Map<String, List<Widget>> createTimeFields()  {
    List<Widget> hours = []; //saves hours
    List<Widget> minutes = []; //saves minutes
    
    for (int i = 0; i <= 23; i++){
      hours.add(Center(child: Container(child: Text(i.toString()))));
    }
      for (int i = 0; i <= 59; i++) {
        minutes.add(Center(child: Container(child: Text(i.toString()))));
      }
    return {"hours": hours, "minutes": minutes};
  }
}
