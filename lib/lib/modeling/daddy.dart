//Create the class for storing the diet daddy data
class DietDaddy {

  final String name;
  final String numDaysExercised;
  final String weight;
  final String targetBodyWeight;
  final String height;
  int? age;

  DietDaddy({ required this.name, required this.numDaysExercised, required this.weight, required this.height, required this.targetBodyWeight, this.age});

}

//The 6 files to edit are: daddy.dart, database.dart, profiledisplay.dart, settingsform.dart, user.dart, authenticate.dart