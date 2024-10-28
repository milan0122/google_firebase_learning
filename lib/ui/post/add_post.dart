import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_project/Utilis/utilis.dart';
import 'package:firebase_project/widgets/round_button.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  //create collection
  final postController = TextEditingController();
  final dfRef = FirebaseDatabase.instance.ref('Post');
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Data'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: postController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "What is in your mind?",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8)
                )
              ),
            ),
          ),
            SizedBox(
              height: 30,
          ),
          RoundButton(title: 'Add',
              loading:loading,onTap:(){
            setState(() {
              loading=true;
            });
           dfRef.child(DateTime.now().millisecondsSinceEpoch.toString()).set({
             // if you want to add nested child
             //dfRef.child(DateTime.now().millisecondsSinceEpoch.toString()).child('comment').set({
              'title':postController.text.toString(),
              'id': DateTime.now().millisecondsSinceEpoch.toString()


            }).then((value){
              setState(() {
                loading=false;
              });
              Utilis.toastMessage('Post added');
            }).onError((error,stackTrace){
              setState(() {
                loading=false;
              });
              Utilis.toastMessage(error.toString());
            });
          })
        ],
      ),
    );

  }
}
