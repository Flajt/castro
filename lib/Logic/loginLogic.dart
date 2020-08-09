import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

///Handles login logic
class LoginLogic {
  static login(String email, String password, String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      ///TODO: If you sign in as shop but with userdata you will be redirected to shop page, but cant do something, display error, add forgot password option
      //Note you need to remove the blank space from your input or else it won't work
      //TODO: Maybe use get the current User and reload it before leaving this function
      AuthResult ret = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = ret.user;
      await user.reload();
      await prefs.setString("email", "$email");
      await prefs.setString("type", "$type");
      return true;
    } catch (e) {
      return false;
    }
  }
}
