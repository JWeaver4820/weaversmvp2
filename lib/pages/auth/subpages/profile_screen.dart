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

   // viewModel.generateList([user.mexican, user.chinese, user.italian, user.breakfast, user.american]);
    // viewModel.setGainWeightChanged(user.gainWeight);
    // viewModel.onBreakfastChanged(false);

  return Column(
        children: [
          _buildDropDown<int?>(List.generate(120, (val) => 18 +val), user.age, viewModel.ageStream, viewModel.onAgeChanged, suffix :"years old" ),
          _buildDropDown<int?>(List.generate(72, (val) => 24 +val), user.height, viewModel.heightStream, viewModel.onHeightChanged,suffix : "inches tall"),
          _buildDropDown<int?>(List.generate(450, (val) => 50 +val), user.weight, viewModel.weightStream, viewModel.onWeightChanged, suffix : "lbs Current Weight"),
          _buildDropDown<int?>(List.generate(450, (val) => 50 +val), user.targetBodyWeight, viewModel.targetStream, viewModel.onTargetChanged, suffix : "lbs Target Body Weight"),
      
      
          _buildDropDown<String?>(jobActivities, user.selectedJobActivity, viewModel.selectedJobActivity, viewModel.onSelectedJobActivityChanged),
          _buildDropDown<String?>(["Male", "Female"], user.selectedGender, viewModel.selectedGender, viewModel.onSelectedGenderChanged),

          _buildCheckboxes(user.breakfast, "Breakfast", viewModel.breakfast, viewModel.onBreakfastChanged),
          _buildCheckboxes(user.mexican, "Mexican", viewModel.mexican, viewModel.onMexicanChanged),
          _buildCheckboxes(user.chinese, "Chinese", viewModel.chinese, viewModel.onChineseChanged),
          _buildCheckboxes(user.italian, "Italian", viewModel.italian,  viewModel.onItalianChanged),
          _buildCheckboxes(user.american, "American", viewModel.american,  viewModel.onAmericanChanged),

         /* StreamBuilder<List<String?>>(builder: (_, snapshot){
            final list = snapshot
            return _buildDropDown(snapshot, value, stream, (p0) => null, suffix)
          })
          _buildDropDown<String?>(List.generate(450, (val) => 50 +val), user.selectedDay, viewModel.selectedDay, viewModel.onSelectedDayChanged, "lbs Current Weight"),
          _buildDropDown<int?>(List.generate(450, (val) => 50 +val), user.daysExercise, viewModel.daysExercise, viewModel.onDaysExerciseChanged, "lbs Current Weight"),
          _buildDropDown<String?>(List.generate(450, (val) => 50 +val), user.selectedJobActivity, viewModel.selectedJobActivity, viewModel.onSelectedJobActivityChanged, "lbs Current Weight"),
          _buildDropDown<String?>(List.generate(450, (val) => 50 +val), user.maintenanceCalories, viewModel.maintenanceCalories, viewModel.onMaintenanceCaloriesChanged, "lbs Current Weight"),*/
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


 /* Widget _buildItem(dynamic data){
    return Container(
  
  margin: const EdgeInsets.only(top: 10),
        decoration: const BoxDecoration(
        color: Colors.blueGrey
      ),
      child: Text(data.toString(), style: TextStyle(color: Colors.white) ), height: 40,
       width: double.maxFinite,);

       Thirty
  }*/

/*   Widget _buildTextField( TextEditingController controller){
    return TextField(
        controller: controller,
        readOnly: isEditProfile,
        textCapitalization: TextCapitalization.sentences,
    );

  } */

  
  DropdownMenuItem<T> _buildStreamButton<T>(T e, String suffix){
   
    return DropdownMenuItem<T>(
      value: e,
      enabled:  isEditProfile,
      child: Text("$e $suffix", style: TextStyle(color: Colors.black),),);
  }

  Widget _buildDropDown <T>(List<T> items, T value, Stream<T> stream, Function(T?) onChanged,{ String suffix = ""}){
  // tempValue =value ;
    return StreamBuilder<T>(builder: (contex, snapshot){
 
      return DropdownButton<T>(items: items.map((value) => _buildStreamButton<T>(value, suffix))
      .toList(), icon: const Icon(Icons.arrow_downward),
      onChanged: onChanged,
      isExpanded: true,
      hint: Text( "${snapshot.data} $suffix"),
       //value: snapshot.data ,
       );
      
    }, stream: stream, initialData: value,);
  }


}