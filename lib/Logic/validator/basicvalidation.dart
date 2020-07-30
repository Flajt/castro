///Stores basic TextInput validation options
class ValidationOptions {
  ///Checks if the input is not empty
  static isNotEmpty(String value) {
    if (value.isEmpty) {
      return "This field must be completed!";
    } else {
      return null;
    }
  }
}
