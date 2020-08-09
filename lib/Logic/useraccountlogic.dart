import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAccount {
  ///Allows the user to let the database save data on device to improve usability, will be called in main. Default: true
  static Future<void> setoffline(bool value) async {
    await FirebaseDatabase.instance.setPersistenceEnabled(value);
  }

  ///Querrys the database if the user has already completed his account
  static Future accountCompleted() async {
    bool stepOne;
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    DatabaseReference reference =
        FirebaseDatabase.instance.reference(); //creates db reference
    DataSnapshot data = await reference
        .child("/users/${currentUser.uid}")
        .once(); //grabs the db once
    if (data.value != null) {
      stepOne = data.value
          .containsKey("address"); //checks if the address entry exists
      if (stepOne) {
        if (currentUser.phoneNumber!=null) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    }
  }

  ///Signs the user in
  static signIn(
      String userType, String username, String email, String passwort) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get("name") == null) {
      AuthResult result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: passwort);
      FirebaseUser currentUser = result.user;
      UserUpdateInfo info = UserUpdateInfo();
      info.displayName = username;
      await currentUser.updateProfile(info);

      ///Saves the email
      await prefs.setString("email", "${currentUser.email}");

      ///display name
      await prefs.setString("name", "$username");

      ///and type of user
      await prefs.setString("type", userType);
    }
  }

  ///Returns a Firebase User
  static Future getUserCreds() async {
    //FirebaseUser user = await FirebaseAuth.instance.currentUser();
    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      await user.reload(); // get actual user data to prevent any issues
      return {
        "name": user.displayName,
        "email": user.email,
        "user": user
      }; //returns userdata as map incl. FirebaseUser Oject for futher use
    } catch (e) {
      //fail save
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return {
        "name": prefs.get("name"),
        "email": prefs.get("email"),
        "user": null
      }; //returns this if we can't fetch user via firebase
    }
  }

  ///Deletes currentUser and clear SharedPreferences
  static Future<void> deleteUser() async {
    //TODO: Check if we need to remove database entrys manually? 2. Send follow up email ?
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

    ///Deletes user from firebase
    await currentUser.delete();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  ///Gets the users account information
  static Future getUserData() async {
    String address;
    FirebaseDatabase dbinstance = FirebaseDatabase.instance;
    Map<String, dynamic> data = await getUserCreds(); //cals get user creds
    FirebaseUser user = data["user"];
    String uid = user.uid; // get user unique identifier
    DatabaseReference db =
        dbinstance.reference().child("/users/$uid"); //creates db reference
    DataSnapshot ret = await db.once(); // get's the db's data
    Map values = ret.value; // converts it into native values -> Map
    if (values != null) {
      if (values.containsKey("address") == true) {
        //trys to fetch users uid
        address = values["address"];
      } else {
        address = "";
      }
    } else {
      address = null;
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
  static Future<void> updateEmail(
      FirebaseUser currentUser, String email) async {
    await currentUser.updateEmail(email);
  }

  ///Updates the users address
  static editUserAddress(FirebaseUser user, String address) async {
    FirebaseDatabase instance = FirebaseDatabase.instance;
    DatabaseReference reference = instance.reference();
    String id = user.uid;
    await reference.child("/users/$id").update({"address": address});
    await user.reload();
  }

  static Future<bool> updatePhoneNumber(
      FirebaseUser currentUser, String phonenumber) async {
    //Workaround, idealy the phone number would be added via   currentUser.updatePhoneNumberCredential(credential) method, which would require

    bool completed = true;
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+$phonenumber",
        timeout: Duration(seconds: 120),
        verificationCompleted: (credital) =>
            currentUser.updatePhoneNumberCredential(credital),
        verificationFailed: (exeception) {
          print(exeception.message);
          completed = false;
        },
        codeSent: null,
        codeAutoRetrievalTimeout: null);
    await currentUser.reload();
    return completed;
  }
}
