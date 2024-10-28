import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/Utilis/utilis.dart';
import 'package:firebase_project/ui/post/post_screen.dart';
import 'package:firebase_project/widgets/round_button.dart';
import 'package:flutter/material.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
  const VerifyCodeScreen({super.key,required this.verificationId});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  @override
  bool loading = false;
  final _auth = FirebaseAuth.instance;
  final verifyCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('6 Digits Code')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            TextFormField(
              controller: verifyCodeController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: '6-digit-codes'
              ),
            ),
            SizedBox(height: 20,),
            RoundButton(title: 'verify',
                loading: loading,
                onTap: () async{
              setState(() {
                loading= true;
              });
              final credentials = PhoneAuthProvider.credential(
                  verificationId: widget.verificationId,
                  smsCode: verifyCodeController.text.toString());
              try{
                await _auth.signInWithCredential(credentials);
                Navigator.push(context, MaterialPageRoute(builder: (_)=>PostScreen()));
                
              }
              catch(e){
                setState(() {
                  loading = false;
                });
                Utilis.toastMessage(e.toString());
                //debugPrint(e.toString());
              }
            })

          ],
        ),
      ),
    );
  }
}
