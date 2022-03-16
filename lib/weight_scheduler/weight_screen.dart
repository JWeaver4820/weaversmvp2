import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weaversmvp/weight_scheduler/weight_viewmodel.dart';

class WeightScreen extends StatefulWidget{
 
  WeightScreen({Key? key});
 
  @override
  WeightScreenState createState() {
    return WeightScreenState();
  }
  

}

class WeightScreenState extends State<WeightScreen>{

  bool isPop = false;
  
  final weightViewModel = WeightViewModel();

  TextEditingController weightController = TextEditingController();

  @override
  void initState() {
    weightViewModel.updateWeight.listen((event) {
      Navigator.of(context).pop();
    }, onError: (error){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$error"), duration: const Duration(seconds: 5),));
    } );
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(child: buildBody(), onWillPop: () async{
          return false;
        }),
    );
  }


  Widget buildBody(){
    return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(20 ),
            color: Colors.blueAccent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Text("7 Day Weight Update", style: TextStyle(color: Colors.white, fontSize: 17),),),
                Expanded(child: TextField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Enter weight",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                  ),
                ), flex: 0,),
               const  SizedBox(height: 15,),
                Expanded(child: ElevatedButton(onPressed: (){

                  if(weightController.text.isEmpty)return;

                  try{
                    weightViewModel.updateWeights(int.parse(weightController.text));

                  }catch(exception){
                    print(exception);
                  }
         
                }, child: Text("Proceed")), flex: 0,)
              ],
            ),
          ));
        
  }
}