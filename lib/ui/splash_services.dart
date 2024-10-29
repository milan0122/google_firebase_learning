import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/ui/firestore/firestore_list_screen.dart';
import 'package:firebase_project/ui/login_screen.dart';
import 'package:firebase_project/ui/upload_ui_screen/upload_image_screen.dart';
import 'package:flutter/material.dart';

class SplashServices{
  void isLogin(BuildContext context){


    final auth = FirebaseAuth.instance;
    final user = auth .currentUser;

    if(user !=null){
      Future.delayed(const Duration(seconds: 2),(){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>UploadImageScreen()));
      });

    }
    else{
      Future.delayed(const Duration(seconds: 2),(){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>LoginScreen()));
      });
    }


  }
}