import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

///Handles login logic
class LoginLogic {
  static login(String email, String password, String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      ///TODO: If you sign in as shop but with userdata you will be redirected to shop page, but cant do something
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      await prefs.setString("email", "$email");
      await prefs.setString("type", "$type");
      return true;
    } catch (e) {
      return false;
    }
  }
}