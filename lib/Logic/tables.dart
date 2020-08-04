///Table class with all information
class Table{
  ///Table number
  final int number;
  ///Max. number of persons which can fit at one table
  final int numPersons;
  ///String is the table inside or outside (0=inside, 1=outside)
  final bool where;
  ///If the table is booked
  final bool reserved;
  ///Time the table is booked
  final time;
  Table({this.number,this.numPersons,this.where,this.reserved,this.time});
}