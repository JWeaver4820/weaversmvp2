import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weaversmvp/utils/page_transition.dart';

extension BuildContextExt on BuildContext{

  void showMessage(String msg){
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(msg)));
  }
  
  void startNewTaskPage({required Widget child}){
                        // UserManager.saveUser(user);
                           Navigator.of(this).pushAndRemoveUntil(PageTransition(widget: child), (se) => false);
  }
}

extension WidgetExt on Widget{

}