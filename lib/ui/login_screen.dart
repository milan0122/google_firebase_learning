import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/Utils/utils.dart';
import 'package:firebase_project/ui/forgot_password.dart';
import 'package:firebase_project/ui/login_phone.dart';
import 'package:firebase_project/ui/post/post_screen.dart';
import 'package:firebase_project/ui/signup_screen.dart';
import 'package:firebase_project/widgets/round_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
   bool loading = false;
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final  passwordController = TextEditingController();
  @override
  void dispose(){
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  void login(){
    _auth.signInWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString()
    ).then((value){
      setState(() {
        loading =false;
      });
      //Utilis.toastMessage(value.user!.email.toString());
      Navigator.push(context, MaterialPageRoute(builder: (_)=>PostScreen()));
    }).onError((error,stackTrace){
      setState(() {
        loading =false;
      });
      debugPrint(error.toString());
      Utils.toastMessage(error.toString());
    });
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Fltutter Firebase'),
          automaticallyImplyLeading: false,
          centerTitle:true,
        ),
        body:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
                child:Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                            hintText: 'Email',
                            labelText: 'Email',
                            helperText:'enter email e.g milan@gmail.com' ,
                            prefixIcon: Icon(Icons.mail)
                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Please Enter your email';
                          }
                          else{
                            return null;
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: passwordController,
                        obscuringCharacter: '*',
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline)
                        ),
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Please Enter your Password';
                            }
                            else{
                              return null;
                            }
                          }
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>ForgotPasswordScreen()));

                      },
                          child: Text('Forgot Password?')),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                  ],
                )
            ),
            RoundButton(title:'Login',
                loading: loading,
                onTap: (){
              if(_formKey.currentState!.validate()){
                setState(() {
                  loading =true;
                });
                login();
              }

            }
            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an Account?"),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>SignupScreen()));
                }, child: Text('SignUp'))
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>LoginPhone()));
              },
              child: Container(
                height: 50,
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(45),
                  border: Border.all(
                    color: Colors.black,
                    width: 1.5

                  )
                ),
                child: Center(child: Text('Login with Phone')),
              ),
            )



          ],
        ),

      ),
    );
  }
}
