import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
class Utilis{


  static toastMessage(String message){
   Fluttertoast.showToast(
       msg: message,
     toastLength: Toast.LENGTH_SHORT,
     gravity: ToastGravity.BOTTOM,
     textColor: Colors.red,
     timeInSecForIosWeb: 1,
     fontSize: 16


   );
}
}