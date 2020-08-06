import 'package:castro/Logic/shopAccountLogic.dart';
import 'package:castro/Logic/validator/basicvalidation.dart';
import 'package:castro/uiblocks/AccountDialogs.dart';
import 'package:castro/uiblocks/BasicPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

///Responsible for displaying the settings
class ShopSettingsPage extends StatefulWidget {
  ShopSettingsPage({Key key}) : super(key: key);

  @override
  _ShopSettingsPageState createState() => _ShopSettingsPageState();
}

class _ShopSettingsPageState extends State<ShopSettingsPage> {
  ///FormKeys for text validation
  GlobalKey<FormState> nameFormKey;
  GlobalKey<FormState> emailFormKey;
  GlobalKey<FormState> phoneFormKey;
  GlobalKey<FormState> openFormKey;
  GlobalKey<FormState> addressFormKey;
  GlobalKey<FormState> tagFormKey;

  ///TextEditingControllers for text input
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _phoneController;
  TextEditingController _addressController;
  TextEditingController _tagController;

  ///TextEditingControllers for openingtimes
  TextEditingController mon;
  TextEditingController tue;
  TextEditingController wed;
  TextEditingController thu;
  TextEditingController fri;
  TextEditingController sat;
  TextEditingController sun;
  Future getShopData;

  @override
  void initState() {
    super.initState();
    getShopData = ShopAccoutLogic.getShopData();
    nameFormKey = GlobalKey<FormState>();
    emailFormKey = GlobalKey<FormState>();
    phoneFormKey = GlobalKey<FormState>();
    openFormKey = GlobalKey<FormState>();
    addressFormKey = GlobalKey<FormState>();
    tagFormKey = GlobalKey<FormState>();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _tagController = TextEditingController();
    mon = TextEditingController();
    tue = TextEditingController();
    wed = TextEditingController();
    thu = TextEditingController();
    fri = TextEditingController();
    sat = TextEditingController();
    sun = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _tagController.dispose();
    mon.dispose();
    tue.dispose();
    wed.dispose();
    thu.dispose();
    fri.dispose();
    sat.dispose();
    sun.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasicPage(
      requireAppbar: true,
      title: "Settings",
      body: FutureBuilder(
        future: getShopData,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            Map data = snapshot.data;
            return ListView(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.person),
                    title: Text("Edit name"),
                    onTap: () {
                      showDialog(
                          context: context,
                          child: AccountDialog(
                              formKey: nameFormKey,
                              title: "Edit name",
                              controller: _nameController,
                              validator: ValidationOptions.isNotEmpty,
                              currentInput: data["name"],
                              labeltext: "Name",
                              context: context,
                              onSubmitted: () {
                                if (nameFormKey.currentState.validate()) {
                                  ShopAccoutLogic.editName(
                                      _nameController.text);
                                  Navigator.of(context).pop();
                                }
                              }));
                    }),
                Divider(),
                ListTile(
                    leading: Icon(Icons.email),
                    title: Text("Edit email"),
                    onTap: () {
                      showDialog(
                          context: context,
                          child: AccountDialog(
                              formKey: emailFormKey,
                              title: "Edit email",
                              controller: _emailController,
                              validator: ValidationOptions.isNotEmpty,
                              currentInput: data["email"],
                              labeltext: "Email",
                              context: context,
                              onSubmitted: () {
                                if (emailFormKey.currentState.validate()) {
                                  ShopAccoutLogic.editeEmail(
                                      _emailController.text);
                                  Navigator.of(context).pop();
                                }
                              }));
                    }),
                Divider(),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text("Edit phone number"),
                  onTap: () {
                    showDialog(
                        context: context,
                        child: AccountDialog(
                            title: "Edit phone number",
                            controller: _phoneController,
                            validator: ValidationOptions.isNotEmpty,
                            currentInput: data["phone"],
                            labeltext: "phone number",
                            context: context,
                            formKey: phoneFormKey,
                            onSubmitted: () {
                              if (phoneFormKey.currentState.validate()) {
                                ShopAccoutLogic.editPhoneNumber(
                                    _phoneController.text);
                                Navigator.of(context).pop();
                              }
                            }));
                  },
                ),
                Divider(),
                ListTile(
                    leading: FaIcon(FontAwesomeIcons.calendarAlt),
                    title: Text("Edit opening times"),
                    onTap: () {
                      showDialog(context: context, child: OpenIngTimePicker());
                    }),
                Divider(),
                ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text("Address"),
                  onTap: () {
                    showDialog(
                        context: context,
                        child: AccountDialog(
                            title: "Edit address",
                            formKey: addressFormKey,
                            controller: _addressController,
                            validator: ValidationOptions.isNotEmpty,
                            currentInput: data["address"],
                            labeltext: "Address",
                            context: context,
                            onSubmitted: () {
                              if (addressFormKey.currentState.validate()) {
                                ShopAccoutLogic.editAddress(
                                    data["user"], _addressController.text);
                                Navigator.of(context).pop();
                              }
                            }));
                  },
                ),
                Divider(),
                AbsorbPointer(
                  child: ListTile(
                    leading: FaIcon(FontAwesomeIcons.moneyBillAlt),
                    title: Text("Edit payment infomation"), //For later
                    subtitle: Text("Coming soon..."),
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Icon(FontAwesomeIcons.tags),
                  title: Text("Edit tags"),
                  subtitle: Text("What do you offer?"),
                  onTap: () {
                    showDialog(
                        context: context,
                        child: AccountDialog(
                          formKey: tagFormKey,
                            helptext: "Sperate with comma: , ",
                            title: "Edit tags",
                            controller: _tagController,
                            validator: ValidationOptions.isNotEmpty,
                            currentInput: data["tags"].toString(),
                            labeltext: "Tags",
                            context: context,
                            onSubmitted: () {
                              if(tagFormKey.currentState.validate()){
                                List tags = _tagController.text.split(",");
                                ShopAccoutLogic.editTags(tags);
                                Navigator.of(context).pop();
                              }
                            }));
                  },
                ),
                Divider(),
                ListTile(
                  title: Text("Delte account"),
                  leading: Icon(Icons.delete),
                  onTap: () {
                    showDialog(
                        context: context,
                        child: AlertDialog(
                          title: Title(
                              color: Colors.red[600],
                              child: Text("Are you sure?")),
                          content: Text(
                              "Your data will be removed and lost forever are you sure?\n You should download all files with your customer history beforehand!"),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  ShopAccoutLogic.deleteAccount();
                                  Navigator.of(context)
                                      .popAndPushNamed("/login");
                                },
                                child: Text("Procced!"))
                          ],
                        ));
                  },
                ),
                Divider(),
              ],
            );
          } else if (snapshot.hasError) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("An error has occured!"),
            );
          } else {
            Center(
                child:
                    CircularProgressIndicator(backgroundColor: Colors.orange));
          }
          return Center(
              child: CircularProgressIndicator(backgroundColor: Colors.orange));
        },
      ),
    );
  }
}
