import 'package:weaversmvp/modeling/daddy.dart';
import 'package:weaversmvp/pages/homepage/profiledisplay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Create the diet list class for listing the properties for diet
class DietList extends StatefulWidget {
  @override
  _DietListState createState() => _DietListState();
}

//Create class for managing diet list states
class _DietListState extends State<DietList> {
  @override
  Widget build(BuildContext context) {

    final diets = Provider.of<List<DietDaddy>>(context);

    return ListView.builder(
      itemCount: diets.length,
      itemBuilder: (context, index) {
        return ProfileDisplay(profileInfo: diets[index]);
      },
    );
  }
}