import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/Utils/utils.dart';
import 'package:firebase_project/ui/login_screen.dart';
import 'package:firebase_project/widgets/round_button.dart';
import 'package:flutter/material.dart';
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
   bool loading = false;
  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Email'),
              ),
            ),
          ),
          SizedBox(height: 40,),
          RoundButton(title:'Reset Password',
              loading: loading,
              onTap: (){
            setState(() {
              loading=true;
            });

            auth.sendPasswordResetEmail(email: emailController.text.toString()
            ).then((value){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>LoginScreen()));
              setState(() {
                loading=false;
              });
              Utils.toastMessage('We have sent you email to recover password, please check email');
            }).onError((error,StackTrace){
              setState(() {
                loading=false;
              });
              Utils.toastMessage(error.toString());
            });
          })
        ],
      ),
    );
  }
}
