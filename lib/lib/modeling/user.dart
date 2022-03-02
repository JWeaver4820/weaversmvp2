//Create the class for managing the different users in firebase backend
class FBUser {
  
  final String uid;
  FBUser({ required this.uid });

}

//Create class for managing the users data in firebase backend
class FBUserData{

  final String uid;
  final String name;
  final String numDaysExercised;
  final String weight;
  final String height;
  final String targetBodyWeight;
  final int age;

  FBUserData(  {

    required this.uid, 
    required this.numDaysExercised, 
    required this.name,
    required this.weight,
    required this.height,
    required this.targetBodyWeight,
    required this.age
    
    } );

}