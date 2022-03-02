import 'package:flutter/material.dart';


class Dialogs{

  static Future<void> showLoading(BuildContext context) async{
      return showDialog(context: context,
       builder: (BuildContext context){
            return AlertDialog(
              content: Row(children: const [
                Expanded(child: SizedBox(height: 60, width: 60, child: CircularProgressIndicator(),)),
                Expanded(child: Text("Please wait..."))
              ],),
            );
      });
}
}