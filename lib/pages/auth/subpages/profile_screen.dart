import 'package:flutter/material.dart';
import 'package:weaversmvp/models/user.dart';
import 'package:weaversmvp/pages/auth/subpages/profile_viewmodel.dart';
import 'package:weaversmvp/pages/homepage/home_screen_viewmodel.dart';
import 'package:weaversmvp/utils/dart_exts.dart';


class ProfileScreen extends StatefulWidget{
  
  
  final HomeScreenViewModel homeScreenViewModel;
  ProfileScreen({Key? key, required this.homeScreenViewModel}) : super(key: key);

  @override
  ProfileScreenState createState() {
    return ProfileScreenState();
  }
}


class ProfileScreenState extends State<ProfileScreen>{

   bool isEditProfile = false;

    List<String> days = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  List<String> jobActivities = [
    'Not active at all',
    'Slightly active',
    'Active',
    'Very active',
  ];

   @override
  void initState() {
    widget.homeScreenViewModel.updateProfile.listen((event) {
      if(event == null){
        //Show loading
      print("MANY_ERROR => LOADING...");
      }else{
      print("MANY_ERROR => LOADING... $event");
        // Display success
      context.showMesssage("You've successfully updated your profile");
      }
    }, onError: (error){
      print("MANY_ERROR => LOADING... $error");
      // show error
      context.showMesssage(error.toString());
    });
    widget.homeScreenViewModel.getWeight();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    
    return Column(
      
      children: [

        InkWell(onTap: (){
          setState(() {
            
            isEditProfile = !isEditProfile;

            if(!isEditProfile){
              
    
              widget.homeScreenViewModel.doUpdateProfile();
            }
          });
        }, child: Text(isEditProfile ?"SAVE PROFILE": "EDIT PROFILE")),
         StreamBuilder<User?>(builder: (_, snapshot){
           print("StreamBuilder => ${snapshot.data}");
           
        widget.homeScreenViewModel.setDefaults(snapshot.data);
       
      return snapshot.data == null ?const Center(
      child:   CircularProgressIndicator(),
    ): Container(width: double.maxFinite, child: Column(
      children: [
        _buildBody(snapshot.data!)
      ],
    ),);
    }, stream: widget.homeScreenViewModel.profile,
    )
      ],
    );
  }

  
  Widget _buildBody(User user){

    final viewModel = widget.homeScreenViewModel;

    String? goal;
    if(user.gainWeight != null){
        goal = user.gainWeight;
    }else if(user.loseWeight != null){
        goal = user.loseWeight;
    }else{
      goal = user.maintainWeight;
    }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Integer edit profile options
          _buildDropDown<int?>(List.generate(72, (val) => 24 +val), user.height, viewModel.heightStream, viewModel.onHeightChanged,suffix : "inches tall"),
          _buildCurrentWeight(viewModel.weight, "lbs Current Weight"),
          _buildDropDown<int?>(List.generate(120, (val) => 18 +val), user.age, viewModel.ageStream, viewModel.onAgeChanged, suffix :"years old" ),
          _buildDropDown<int?>(List.generate(450, (val) => 50 +val), user.targetBodyWeight, viewModel.targetStream, viewModel.onTargetChanged, suffix : "lbs Target Body Weight"),
          _buildDropDown<int?>(List.generate(12, (val) =>   1 +val), user.hoursSleep, viewModel.hoursSleepStream, viewModel.onHoursSleepChanged, suffix : "hours of sleep/night"),
          _buildDropDown<int?>(List.generate(7, (val) =>    1 +val), user.daysExercise, viewModel.daysExerciseStream, viewModel.onDaysExerciseChanged, suffix : "days exercise/week"),
          _buildDropDown<int?>(List.generate(6000, (val) => 100 +val), user.maintenanceCalories, viewModel.maintenanceCaloriesStream, viewModel.onMaintenanceCaloriesChanged, suffix : "maintenance calories/day"),

          //String edit profile options
          _buildDropDown<String?>(["Gender: Male", "Gender: Female"], user.selectedGender, viewModel.selectedGender, viewModel.onSelectedGenderChanged),
          _buildDropDown<String?>(viewModel.getGoalList(), goal, viewModel.goal, viewModel.onGoalChanged),
          _buildDropDown<String?>(["Not active at all at day job", "Slightly active at day job", "Active at day job", "Very active at day job"], user.selectedJobActivity, viewModel.selectedJobActivity, viewModel.onSelectedJobActivityChanged),
          _buildDropDown<String?>(["Grocery day: Sunday", "Grocery day: Monday", "Grocery day: Tuesday", "Grocery day: Wednesday", "Grocery day: Thursday", "Grocery day: Friday", "Grocery day: Saturday"], user.selectedDay, viewModel.selectedDay, viewModel.onSelectedDayChanged),

          //Checkbox edit profile options
          _buildCheckboxes(user.breakfast, "Breakfast", viewModel.breakfast, viewModel.onBreakfastChanged),
          _buildCheckboxes(user.mexican, "Mexican", viewModel.mexican, viewModel.onMexicanChanged),
          _buildCheckboxes(user.chinese, "Chinese", viewModel.chinese, viewModel.onChineseChanged),
          _buildCheckboxes(user.italian, "Italian", viewModel.italian,  viewModel.onItalianChanged),
          _buildCheckboxes(user.american, "American", viewModel.american,  viewModel.onAmericanChanged),
        ],
      );
  }


  Widget _buildCheckboxes(bool? breakfast, String title, Stream<bool?> stream, Function(bool?) onChanged){
    return StreamBuilder<bool?>(builder: (_, snapshot){
      return Row(
      children: [
        Text(title),
         Checkbox(
          
                value: snapshot.data ?? false,
                onChanged: isEditProfile ? onChanged : null,
         )
      ],
    );
    }, stream: stream,);  
  }

  Widget _buildCurrentWeight(Stream<Weight> stream, String text){
     return StreamBuilder<Weight>(builder: (_, snapshot){

       if(snapshot.hasError){
         return const Text("An error has occurred", textAlign: TextAlign.start,);
       }
       final weight = snapshot.data;
       return Text("${weight?.weightValue ?? 0} $text", textAlign: TextAlign.start,);
     }, stream: stream,);
  }
  
  DropdownMenuItem<T> _buildStreamButton<T>(T e, String suffix){
   
    return DropdownMenuItem<T>(
      value: e,
      enabled:  isEditProfile,
      child: Text("$e $suffix", style: TextStyle(color: Colors.black),),);
  }

  Widget _buildDropDown <T>(List<T> items, T value,
      Stream<T> stream, Function(T?) onChanged,{ String suffix = "", bool isEnabled = true}){
  // tempValue = value ;
    return StreamBuilder<T>(builder: (contex, snapshot){
 
      return DropdownButton<T>(
        items: items.map((value) => _buildStreamButton<T>(value, suffix))
      .toList(), icon: const Icon(Icons.arrow_downward),
      onChanged: isEnabled ?onChanged : null,
      isExpanded: true,
      hint: Text( "${snapshot.data} $suffix"),
       //value: snapshot.data ,
       );
      
    }, stream: stream, initialData: value,);
  }


  @override
  void dispose() {
    widget.homeScreenViewModel.dispose();
    super.dispose();
  }

}