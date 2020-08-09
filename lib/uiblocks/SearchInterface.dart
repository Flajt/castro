import 'package:castro/Logic/resturant.dart';
import 'package:castro/Logic/tables.dart';
import 'package:castro/Logic/userShopOptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:search_page/search_page.dart';
import 'package:url_launcher/url_launcher.dart';

///User interface for further options
class SearchInterFace extends StatefulWidget {
  SearchInterFace({Key key}) : super(key: key);

  @override
  _SearchInterFaceState createState() => _SearchInterFaceState();
}

class _SearchInterFaceState extends State<SearchInterFace> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    const List _days = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"];
    /*List<Resturant> resturants = [        | for tests only
      Resturant(
          name: "Vulcano",
          address: "30177 Hannover,Constantinstraße 95",
          tags: ["italien", "cocktails", "pizza"]),
      Resturant(
          name: "Cristo",
          address: "30900 Wedemark, Veilchenstraße 92",
          tags: ["greek", "beer", "family friendly"]),
      Resturant(
          name: "Morto",
          address: "30199,Fantasia, Mauernrück 8",
          tags: ["french", "high cuisine", "wine"]),
    ];*/
    return Container(
        child: Column(
      children: <Widget>[
        Container(color: Colors.black),
        ListTile(
          leading: FaIcon(FontAwesomeIcons.qrcode),
          title: Text("Scan Code"),
          onTap: () async {
            List ret = await UserShopOptions.claimTable();
            Navigator.of(context).pushNamed("/user/shopTable", arguments: {
              "key": ret[3],
              "tableNumber": ret[1],
              "resturantid": ret[0],
              "name": ret[2]
            });
          },
        ),
        FutureBuilder(
            future: UserShopOptions.getResturants(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListTile(
                  leading: Icon(Icons.search),
                  title: Text("Search Resturant"),
                  onTap: () {
                    showSearch(
                        context: context,
                        delegate: SearchPage<Resturant>(
                          searchLabel: "Search resturants",
                          suggestion: Center(
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  "assets/search.svg",
                                  width: size.width,
                                  height: size.height * 0.4,
                                ),
                                Text(
                                  "Search resturants via name, address or tags",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          failure: Center(
                            child: Text("No resturant found..."),
                          ),
                          filter: (resturant) => [
                            resturant.name,
                            resturant.address,
                            resturant.tags
                                .toString()
                                .replaceAll("[", "")
                                .replaceAll("]",
                                    ""), //converts tags to a string and removes list brackets
                          ],
                          builder: (resturant) => ListTile(
                            leading: Icon(Icons.restaurant),
                            title: Text(resturant.name),
                            subtitle: Text(resturant.address),
                            onTap: () {
                              showDialog(
                                context: context,
                                child: AlertDialog(
                                  actions: [
                                    Tooltip(
                                      message: "View menu",
                                      child: IconButton(
                                          icon: Icon(Icons.restaurant_menu),
                                          onPressed: () => Navigator.of(context)
                                                  .pushNamed("/user/menu",
                                                      arguments: {
                                                    "shopid": resturant.key
                                                  })),
                                    ),
                                    Tooltip(
                                      message: "Navigate to",
                                      child: IconButton(
                                          icon:
                                              Icon(FontAwesomeIcons.mapMarked),
                                          onPressed: () {
                                            MapsLauncher.launchQuery(
                                                resturant.address);
                                          }),
                                    ),
                                    Tooltip(
                                      message: "Call",
                                      child: IconButton(
                                        icon: Icon(FontAwesomeIcons.phone),
                                        onPressed: () async {
                                          if (resturant.phone.isNotEmpty) {
                                            //Checks if the device supports phone calls, if not it will do nothing
                                            if (await canLaunch(
                                                "tel:${resturant.phone}")) {
                                              launch("tel:${resturant.phone}");
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                    RaisedButton(
                                        child: Text("Exit"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }),
                                  ],
                                  title: Center(
                                      child: Title(
                                    child: Text(resturant.name),
                                    color: Colors.orange,
                                  )),
                                  content: Container(
                                      height: size.height * 0.5,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Opening times:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0),
                                          ),
                                          Padding(padding: EdgeInsets.all(8)),
                                          Expanded(
                                            child: ListView.builder(
                                                itemCount: resturant
                                                    .openingTimes.keys.length,
                                                itemBuilder: (context, index) {
                                                  /*List days = resturant
                                                      .openingTimes.keys
                                                      .toList();
                                                      days.sort();*/
                                                  String day = _days[index];
                                                  //Creates opening times and removes brackets for cleaner look
                                                  String openingTime = resturant.openingTimes[day]
                                                      .toString()
                                                      .replaceAll("[", "")
                                                      .replaceAll("]", "");
                                                  return Center(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text(
                                                        "$day : $openingTime",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ),
                                          Text(
                                            "Tags: ${resturant.tags.toString().replaceAll("[", "").replaceAll("]", "")}",
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      )),
                                ),
                              );
                            },
                          ),
                          items: snapshot.data,
                        ));
                  },
                );
              } else if (snapshot.hasError) {
                return AlertDialog(
                  title: Center(child: Text("An error has occured!")),
                  content: Text(snapshot.error.toString()),
                );
              } else {
                return Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Colors.orange,
                ));
              }
            }),
      ],
    ));
  }
}
