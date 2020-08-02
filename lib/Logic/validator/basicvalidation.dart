///Stores basic TextInput validation options
class ValidationOptions {
  ///Checks if the input is not empty
  static String isNotEmpty(String value) {
    if (value.isEmpty) {
      return "This field must not be empty!";
    } else {
      return null;
    }
  }
  static String passwortValidator(String password){
    if(password.isEmpty || password.length <6){
      return "6 characters incl. special characters are required!";
    }
    else{
      return null;
    }
  }
}
