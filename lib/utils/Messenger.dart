import 'package:flutter/material.dart';

class Messenger{
  static snackBar(BuildContext context, String msg){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg))
    );
  }
}