import 'package:castro/Logic/timeSelectBlockLogic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///Creates a Scrollable time field to selcet time based on either minutes or hours
class TimeSelectBlock extends StatefulWidget {
  //Coded from sratch with PageView and Sized Box
  ///Either minutes or hours
  String timeType;

  ///Function wich will be called if the time changes
  Function(int) onChanged;

  ///[width] and [height] to prevent overflow
  double width;
  double height;

  ///Scales height, default is 0.05
  double scalarh;

  ///Scales width default:0.1
  double scalarw;

  TimeSelectBlock({
    Key key,
    @required this.timeType,
    @required this.onChanged,
    @required this.width,
    @required this.height,
    this.scalarh = 0.05,
    this.scalarw = 0.1,
  }) : super(key: key);
  @override
  _TimeSelectBlockState createState() => _TimeSelectBlockState(
      timeType: timeType,
      width: width,
      height: height,
      onChanged: onChanged,
      scalarh: scalarh,
      scalarw: scalarw);
}

class _TimeSelectBlockState extends State<TimeSelectBlock> {
  String timeType;
  double width;
  double height;
  Function(int) onChanged;
  double scalarh;
  double scalarw;
  _TimeSelectBlockState(
      {@required this.timeType,
      @required this.width,
      @required this.height,
      this.onChanged,
      this.scalarh,
      this.scalarw});
  List<Widget> timeWidgets;
  PageController controller;

  ///Const values improve performance. This one is used to scale the arrows according to the Page height
  static const double iconScalar = 0.021;
  @override
  void initState() {
    super.initState();
    //Calls only once to prevent resource issues, in this case maybe overkill, due to small list
    timeWidgets = TimeSelectBlockLogic.createTimeFields()[timeType];
    controller = PageController();
  }

  @override
  void dispose() {
    //frees resources
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          IconButton(
              iconSize: height * iconScalar,
              icon: Icon(CupertinoIcons.up_arrow,
                  color: ThemeData().iconTheme.color),
              onPressed: () {
                setState(() {
                  controller.previousPage(
                      duration: Duration(milliseconds: 2),
                      curve: Curves.easeOut);
                });
              }),
          SizedBox(
              width: width * scalarw,
              height: height * scalarh,
              child: Center(
                child: PageView(
                  //calls the unchanged method so the user can get the data of the current time
                  onPageChanged: (value) => onChanged(value),
                  scrollDirection: Axis.vertical,
                  controller: controller,
                  children: timeWidgets
                ),
              )),
          IconButton(
              iconSize: height * iconScalar,
              icon: Icon(
                CupertinoIcons.down_arrow,
                color: ThemeData().iconTheme.color,
              ),
              onPressed: () => setState(() {
                    controller.nextPage(
                        duration: Duration(milliseconds: 2),
                        curve: Curves.easeIn);
                  })),
        ],
      ),
    );
  }
}
