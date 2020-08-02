import 'package:castro/Logic/useraccountlogic.dart';
import 'package:castro/Logic/validator/basicvalidation.dart';
import 'package:castro/uiblocks/AccountDialogs.dart';
import 'package:castro/uiblocks/BasicPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

///Screen to edit user information
class EditAccoutPage extends StatefulWidget {
  EditAccoutPage({Key key}) : super(key: key);

  @override
  _EditAccoutPageState createState() => _EditAccoutPageState();
}

class _EditAccoutPageState extends State<EditAccoutPage> {
  TextEditingController usernameController; // way to access the new username / stores text inputs
  TextEditingController emailController;
  TextEditingController phoneController;
  TextEditingController addressController;
  bool autovalidate = false;
  @override
  void initState() {
    //Initializes variables to prevent reloading on state changes
    super.initState();
    autovalidate = false;
    usernameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
  }

  @override
  void dispose() {
    //dispose controllers to free resources
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasicPage(
      requireAppbar: true,
      title: "Edit account",
      body: FutureBuilder(
        future: UserAccount.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map data = snapshot.data;
            return Column(
              children: <Widget>[
                ListTile(
                    title: Text("Edit username"),
                    onTap: () => showDialog(
                        context: context,
                        child: AccountDialog(
                            autovalidate: autovalidate,
                            context: context,
                            onSubmitted: () async {
                              if (usernameController.text.isNotEmpty) {
                                FirebaseUser currentuser =
                                    await FirebaseAuth.instance.currentUser();
                                UserUpdateInfo info = UserUpdateInfo();
                                info.displayName = usernameController.text;
                                await currentuser.updateProfile(info);
                                setState(() {
                                  autovalidate = false;
                                });
                                Navigator.of(context).pop();
                              } else {
                                setState(() {
                                  autovalidate = true;
                                });
                              }
                            },
                            title: "Edit username",
                            controller: usernameController,
                            validator: ValidationOptions.isNotEmpty,
                            currentInput: data["name"],
                            labeltext: "Username:",
                            icon: Icon(Icons.person)))),
                Divider(),
                ListTile(
                  title: Text("Edit email"),

                  ///Let's the user edit his email address
                  onTap: () {
                    showDialog(
                        context: context,
                        child: AccountDialog(
                            title: "Edit email",
                            controller: emailController,
                            validator: ValidationOptions.isNotEmpty,
                            currentInput: data["email"],
                            labeltext: "Email:",
                            autovalidate: autovalidate,
                            context: context,
                            onSubmitted: () {
                              FirebaseUser currentUser = data["user"];
                              if (emailController.text.isNotEmpty) {
                                setState(() {
                                  autovalidate = true;
                                });
                                UserAccount.updateEmail(
                                    currentUser, emailController.text);
                                Navigator.of(context).pop();
                              } else {
                                setState(() {
                                  autovalidate = true;
                                });
                              }
                            }));
                  },
                ),
                Divider(),
                ListTile(
                  title: Text("Edit address"),
                  onTap: () {
                    showDialog(
                        context: context,
                        child: AccountDialog(
                            title: "Edit address",
                            controller: addressController,
                            validator: ValidationOptions.isNotEmpty,
                            currentInput: data["address"],
                            labeltext: "Address",
                            autovalidate: autovalidate,
                            context: context,
                            onSubmitted: () {
                              if (addressController.text.isNotEmpty) {
                                UserAccount.editUserAddress(
                                    data["user"], addressController.text);
                                setState(() {
                                  autovalidate = false;
                                });
                                Navigator.of(context)
                                    .pop(); // Pops current route from the stack and returns to the previous one
                              } else {
                                setState(() {
                                  autovalidate = true;
                                });
                              }
                            }));
                  },
                ),
                Divider(),
                ListTile(
                  title: Text("Edit phone number"),
                  onTap: () {
                    showDialog(
                        context: context,
                        child: AccountDialog(
                            prefix: Text("+"),
                            title: "Edit phone number",
                            controller: phoneController,
                            validator: ValidationOptions.isNotEmpty,
                            currentInput: data["phone"],
                            labeltext: "Phone number",
                            autovalidate: autovalidate,
                            context: context,
                            onSubmitted: (){
                              if(phoneController.text.isNotEmpty){
                              UserAccount.updatePhoneNumber(data["user"], phoneController.text);
                              }
                            }));
                  },
                ),
                Divider(),
              ],
            );
          } else if (snapshot.hasError) {
            return AlertDialog(
              title: Title(
                child: Text("An error has occured"),
                color: Colors.red,
              ),
              content: Text(
                  "Please try againe or restart the app.\nIf the problem persists please contact us!"),
            );
          }
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.orange,
          ));
        },
      ),
    );
  }
}
