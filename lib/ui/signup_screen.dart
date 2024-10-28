import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/ui/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_project/Utilis/utilis.dart';
import 'package:firebase_project/widgets/round_button.dart';
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final  passwordController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void dispose(){
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  void signup(){
    if(_formKey.currentState!.validate()){
      setState(() {
        loading = true;
      });
      _auth.createUserWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString(),

      ).then((value){
        setState(() {
          loading=false;
        });

      }).onError((error,stackTrace){
        Utilis.toastMessage(error.toString());
        setState(() {
          loading = false;
        });
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fltutter Firebase'),
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
                  SizedBox(
                    height: 20,
                  ),

                ],
              )
          ),
          RoundButton(
              title:'Signup',
              loading: loading,
              onTap: (){
                signup();


          }
          ),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an Account?"),
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>LoginScreen()));
              }, child: Text('LogIn'))
            ],
          )



        ],
      ),

    );
  }
}
