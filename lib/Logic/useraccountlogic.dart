import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth_ui/firebase_auth_ui.dart' as auth;
class UserAccount {
  ///Allows the user to let the database save data on device to improve usability
  static Future<void> setoffline(bool value) async {
    await FirebaseDatabase.instance.setPersistenceEnabled(value);
  }

  ///Querrys the database if the user has already completed his account
  static Future accountCompleted() async {
    DatabaseReference reference =
        FirebaseDatabase.instance.reference(); //creates db reference
    bool ret =
        reference.buildArguments().containsKey("done"); // querrys db for key
    return ret; //returns wether it's there or not
  }

  ///Signs the user in
  static signIn(String userType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get("email") == null) {
      FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
      prefs.setString("email", "${currentUser.email}");

      ///Saves the email
      prefs.setString("name", "${currentUser.displayName}");

      ///display name
      prefs.setString("type", userType);

      ///and type of user
    }
  }

  ///Returns a Firebase User
  static getUserCreds() async {
    //TODO: Check if 2 methods are needed. 1 for customer and 1 for shop?
    //FirebaseUser user = await FirebaseAuth.instance.currentUser();
    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();

      return {
        "name": user.displayName,
        "email": user.email,
        "user": user
      }; //returns userdata as map incl. FirebaseUser Oject for futher use
    } catch (e) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return {
        "name": prefs.get("name"),
        "email": prefs.get("email"),
        "user": null
      }; //returns this if we can't fetch user via firebase
    }
  }

  ///Deletes currentUser and clear SharedPreferences
  static deleteUser() async {
    //TODO: Check if we need to remove database entrys manually? 2. Send follow up email ?
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
        ///Deletes user from firebase
    await currentUser.delete();
    auth.FirebaseAuthUi.instance().delete();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  ///Gets the users account information
  static Future getUserData() async {
    String address;
    FirebaseDatabase dbinstance = FirebaseDatabase.instance;
    Map<String, dynamic> data = getUserCreds(); //cals get user creds
    FirebaseUser user = data["user"];
    String uid = user.uid; // get user unique identifier
    DatabaseReference db = dbinstance.reference().child("/users/$uid"); //creates db reference
    DataSnapshot ret = await db.once(); // get's the db's data
    Map values = ret.value; // converts it into native values -> Map

    if (values.containsKey(uid) == true) {
      //trys to fetch users uid
      address = values[uid]["address"];
    } else {
      address = "";
    }
    if (user != null) {
      data["phone"] = user.phoneNumber; //adds users phone number and adress
      data["address"] = address;
      return data;
    } else {
      return null;
    }
  }

  ///Updates the users current email adress
  static updateEmail(FirebaseUser currentUser, String email) async {
    await currentUser.updateEmail(email);
  }
  ///Updates the users address
  static editUserAddress(FirebaseUser user, String address) async {
    FirebaseDatabase instance = FirebaseDatabase.instance;
    DatabaseReference reference = instance.reference();
    String id = user.uid;
    await reference.child("/users/$id").update({"address": address});
  }
  static updatePhoneNumber(FirebaseUser currentUser,String phonenumber) async {
    await currentUser.updatePhoneNumberCredential(null); 
  }
}
