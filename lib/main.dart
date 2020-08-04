import 'package:castro/Pages/accountsettings.dart';
import 'package:castro/Pages/settings.dart';
import 'package:castro/Pages/shopSettingsPage.dart';
import 'package:castro/Pages/shophomescreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages/loginpage.dart';
import 'Pages/userhomescreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var type = prefs.get("type");
  var username = prefs.get("name");
  var email = prefs.get("email");
  Map<String, dynamic> data = {"email": email, "user": username};
  print(data);
  runApp(MyApp(
    type: type,
    data: data,
  ));
}

class MyApp extends StatelessWidget {
  MyApp({this.type, this.data});
  final type;
  final data;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Castro',
      routes: <String, WidgetBuilder>{
        "/login": (BuildContext context) => LoginPage(),
        "/user": (BuildContext context) => UserHomeScreen(),
        "/user/settings" : (BuildContext context) => AccountPage(),
        "/user/settings/edit" : (BuildContext context) => EditAccoutPage(),
        "/shop" : (BuildContext context) => ShopHomeScreen(),
        "/shop/settings" : (BuildContext context) => ShopSettingsPage(),
      },
      theme: ThemeData(
        backgroundColor: Colors.white,
        accentColor: Colors.black,
        primaryColorDark: Colors.deepOrange,
        iconTheme: IconThemeData(color: Colors.black),
        primaryIconTheme: IconThemeData(color: Colors.black),
        scaffoldBackgroundColor: Colors.white,
        buttonColor: Colors.orange,
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.orange,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: type == null
          ? LoginPage()
          : type == "user"
              ? UserHomeScreen(
                )
              : ShopHomeScreen(),
    );
  }
}
