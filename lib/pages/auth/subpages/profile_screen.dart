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

   bool isEditProfile =false;

   @override
  void initState() {
    widget.homeScreenViewModel.updateProfile.listen((event) {
      if(event == null){
        //Show loading
      print("MANY_ERROR => LOADING...");
      }else{
        // Display success
      context.showMesssage("You've successfully updated your profile");
      }
    }, onError: (error){
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

  return Column(
        children: [
          _buildDropDown<int?>(List.generate(120, (val) => 18 +val),
           user.age, viewModel.ageStream, viewModel.onAgeChanged ),
          _buildDropDown<int?>(List.generate(72, (val) => 24 +val), user.height, viewModel.heigtStream, viewModel.onHeightChanged),
          _buildDropDown<int?>(List.generate(450, (val) => 50 +val), user.weight, viewModel.weightStream, viewModel.onWeightChanged),
          _buildDropDown<int?>(List.generate(450, (val) => 50 +val), user.targetBodyWeight, viewModel.targetStream, viewModel.onTargetChanged)
        ],
      );
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

  
  DropdownMenuItem<T> _buildStreamButton<T>(T e, T? selectedValue){
    print("value => $selectedValue");
    return DropdownMenuItem<T>(
      value:e,
      enabled:  isEditProfile,
      child: Text(e.toString(), style: TextStyle(color: Colors.black),),);
  }

  Widget _buildDropDown <T>(List<T> items, T value, Stream<T> stream, Function(T?) onChanged){
  // tempValue =value ;
    return StreamBuilder<T>(builder: (contex, snapshot){

      return DropdownButton<T>(items: items.map((value) => _buildStreamButton<T>(value, snapshot.data))
      .toList(), icon: const Icon(Icons.arrow_downward),
      onChanged: onChanged,
      isExpanded: true,

       value: snapshot.data,);
      
    }, stream: stream,);
  }


}