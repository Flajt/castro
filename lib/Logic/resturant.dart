
///Resturant class for searchbar
class Resturant{
  ///Unique key to find resturant later on 
  final key;
  ///Name of the resturant
  final String name;
  ///List of tags -> to describe themselfs
  final List tags;
  ///Were the resturant is located
  final String address;
  ///Map containig the opening times
  final Map openingTimes;
  ///String phone number 
  final String phone;
  Resturant({this.name,this.tags,this.address,this.key,this.openingTimes,this.phone});
    ///TODO: Maybe use better address for querrying,
}