import 'package:firebase_project/ui/splash_services.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashScreen = SplashServices();
  @override
  void initState(){
    super.initState();
    splashScreen.isLogin(context);
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue,Colors.blueGrey,Colors.purpleAccent],
              begin: Alignment.topLeft,
              end:Alignment.bottomRight,
            )
        ),
        child: Center(
          child: Text('Firebase Learning',style: TextStyle(fontSize: 24),),
        ),
      )



    );
  }
}
