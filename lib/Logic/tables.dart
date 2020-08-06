///Table class with all information
class ResturantTable{
  ///Table number
  final int number;
  ///Max. number of persons which can fit at one table
  final int numPersons;
  ///String is the table inside or outside (0=inside, 1=outside)
  final bool where;
  ResturantTable({this.number,this.numPersons,this.where});
}