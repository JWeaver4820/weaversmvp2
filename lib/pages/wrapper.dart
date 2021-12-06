import 'package:flutter/material.dart';
import 'package:weaversmvp/modeling/user.dart';
import 'package:weaversmvp/pages/auth/auth.dart';
import 'package:weaversmvp/pages/homepage/homepage.dart';
import 'package:provider/provider.dart';

//Create the wrapper class and keys
class Wrapper extends StatelessWidget {
  
  const Wrapper({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<FBUser?>(context);

    if (user == null){
      return const Auth();

    } else {
      return Homepage();

    }
    
  }

}