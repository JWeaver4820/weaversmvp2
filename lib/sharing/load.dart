import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

//During loading, this is what will be displayed - Diet Daddy colors
class Loading extends StatelessWidget {

  //Create widget for the loading, flutters spinkit
  @override
  Widget build(BuildContext context) {
    return Container(

      color: Colors.teal[600],
      child: const Center(

        child: SpinKitChasingDots(

          color: Colors.teal,
          size: 50.0,

        ),

      ),

    );
  }

}