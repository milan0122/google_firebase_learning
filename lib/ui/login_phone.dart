import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/Utils/utils.dart';
import 'package:firebase_project/ui/verfiy_code.dart';
import 'package:firebase_project/widgets/round_button.dart';
import 'package:flutter/material.dart';

class LoginPhone extends StatefulWidget {
  const LoginPhone({super.key});

  @override
  State<LoginPhone> createState() => _LoginPhoneState();
}

class _LoginPhoneState extends State<LoginPhone> {
  bool loading = false;
  final _auth = FirebaseAuth.instance;
  final phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login With phone'),),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            TextFormField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: '+977 9822823371',
                label: Text('Phone Number', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)

              ),
            ),
            SizedBox(height: 20,),
            RoundButton(title: 'Send Code',
                loading:loading,
                onTap: (){
              setState(() {
                loading = true;
              });
              _auth.verifyPhoneNumber(
                phoneNumber: phoneNumberController.text,
                  verificationCompleted: (_){
                    setState(() {
                      loading = false;
                    });
                  },
                  verificationFailed: (e){
                  setState(() {
                    loading = false;
                  });
                  Utils.toastMessage(e.toString());
                  },
                  codeSent: (String verificationId, int? token){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>VerifyCodeScreen(verificationId: verificationId,)));
                  setState(() {
                    loading = false;
                  });
                  },
                  codeAutoRetrievalTimeout: (e){
                    setState(() {
                      loading = false;
                    });
                  Utils.toastMessage(e.toString());
                  }
              );
            })
          ],
        ),
      ),
    );
  }
}
