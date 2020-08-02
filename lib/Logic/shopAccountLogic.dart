import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
///General Logic for all shop account Logic
class ShopAccoutLogic {
  ///Signs shop owner in
  static signIn(
    String type, String shopname, String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get("username") == null) {
      await prefs.setString("name", shopname);
      await prefs.setString("email", email);
      await prefs.setString("type", "shop");
      AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser currentUser = result.user;
      UserUpdateInfo info = UserUpdateInfo();
      info.displayName = shopname;
      await currentUser.updateProfile(info);
    }
  }
}
