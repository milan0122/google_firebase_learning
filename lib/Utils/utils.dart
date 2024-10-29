import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
class Utils{


  static toastMessage(String message){
   Fluttertoast.showToast(
       msg: message,
     toastLength: Toast.LENGTH_SHORT,
     gravity: ToastGravity.BOTTOM,
     timeInSecForIosWeb: 1,
     fontSize: 16


   );
}
}