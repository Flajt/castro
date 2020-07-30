
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
///Clears SharedPreferances and Firebase -> Signs out
Future<void>signout()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear(); //removes all entrys of the user from the disk to prevent auto login
  await FirebaseAuth.instance.signOut(); //signs you out from firebase and clears diskcache
}