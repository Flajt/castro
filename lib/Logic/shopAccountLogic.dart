import 'dart:io';
import 'package:castro/Logic/useraccountlogic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
      AuthResult result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser currentUser = result.user;
      UserUpdateInfo info = UserUpdateInfo();
      info.displayName = shopname;
      String uid = currentUser.uid;
      FirebaseDatabase.instance
          .reference()
          .child("/shops/$uid")
          .set({"name": currentUser.displayName});

      await currentUser.updateProfile(info);
    }
  }

  static Future getShopCreds() async {
    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      await user.reload(); // get actual user data to prevent any issues
      return {
        "name": user.displayName,
        "email": user.email,
        "user": user,
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

  ///Checks if the user has finished account creation
  static Future accountCompleted() async {
    bool stepOne;
    bool stepTwo;
    bool stepThree;
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    DatabaseReference reference =
        FirebaseDatabase.instance.reference(); //creates db reference
    DataSnapshot data = await reference
        .child("/shops/${currentUser.uid}")
        .once(); //grabs the db once
    if (data.value != null) {
      stepOne = data.value
          .containsKey("address"); //checks if the address entry exists
      stepTwo = data.value.containsKey("phone");
      stepThree = data.value.containsKey("openingtimes");
      if (stepOne) {
        if (stepTwo && stepThree) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  ///Deletes the user by using [UserAccount.deleteUser()]
  static Future<void> deleteAccount() async {
    await UserAccount.deleteUser();
  }

  ///Uploads the menue file
  static Future<void> uploadMenue(File menue) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    String _uid = currentUser.uid;
    StorageReference storage = FirebaseStorage().ref();

    ///Adds metadata for possible filtering
    StorageMetadata metadata = StorageMetadata(customMetadata: {"owner": _uid});

    ///File will be stored under users uid, so everytime a new one is uploaded, it will be updated
    storage.child("/$_uid").putFile(menue, metadata);
  }

  static Future<void> editeEmail(String email) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    await UserAccount.updateEmail(currentUser, email);
  }

  ///Updates the name of the shop
  static Future<void> editName(String newShopname) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    UserUpdateInfo info = UserUpdateInfo();
    info.displayName = newShopname;
    await currentUser.updateProfile(info);
  }

  ///Updates resturant address
  static Future<void> updateAddress(String address) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    String uid = currentUser.uid;
    DatabaseReference reference = FirebaseDatabase.instance.reference();
    await reference
        .child("/shops/$uid")
        .buildArguments()
        .update("address", (value) => address);
  }

  ///Gets the user data
  static Future getShopData() async {
    String address;
    Map openingtimes;
    String phone;
    List tags;
    FirebaseDatabase dbinstance = FirebaseDatabase.instance;
    Map<String, dynamic> data = await getShopCreds(); //calls to get user creds
    FirebaseUser user = data["user"];
    String uid = user.uid; // get user unique identifier
    DatabaseReference db =
        dbinstance.reference().child("/shops/$uid"); //creates db reference
    DataSnapshot ret = await db.once(); // get's the db's data
    Map values = ret.value; // converts it into native values -> Map
    if (values != null) {
      if (values.containsKey("address") == true) {
        //trys to fetch users uid
        address = values["address"];
      } else {
        address = "";
      }
      if (values.containsKey("openingtimes") == true) {
        print(values);
        openingtimes = values["openingtimes"];
      } else {
        openingtimes = {"Monday": ""};
      }
      if (values.containsKey("phone")) {
        phone = values["phone"];
      } else {
        phone = "";
      } if(values.containsKey("tags")){
         tags = values["tags"];
      }
      else{
        tags = []; 
      }
    } else {
      address = null;
    }
    if (user != null) {
      data["phone"] = phone; //adds users phone number and adress
      data["address"] = address;
      data["openingtimes"] = openingtimes;
      data["tags"] = tags;
      return data;
    } else {
      return null;
    }
  }

  ///Updates phone number of the shop
  static Future<void> editPhoneNumber(String phonenumber) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    String uid = currentUser.uid;
    DatabaseReference reference = FirebaseDatabase.instance.reference();
    reference.child("/shops/$uid").update({"phone": phonenumber});
  }

  ///Updates the shops address
  static Future<void> editAddress(
      FirebaseUser currentUser, String address) async {
    DatabaseReference reference = FirebaseDatabase.instance.reference();
    reference
        .child("/shops/${currentUser.uid}")
        .update({"address": address});
  }

  ///Updates opening times of the shop
  static Future<void> editOpeningTimes(
      Map<String, List<String>> openingTimes) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    String uid = currentUser.uid;
    DatabaseReference reference = FirebaseDatabase.instance.reference();
    await reference.child("/shops/$uid").update({"openingtimes": openingTimes});
  }

  ///Updates resturant tags on what they offer
  static Future<void> editTags(List<String> tags) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    String uid = currentUser.uid;
    DatabaseReference reference = FirebaseDatabase.instance.reference();
    await reference.child("/shops/$uid").update({"tags": tags});
  }
}
