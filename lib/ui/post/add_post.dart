import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_project/Utils/utils.dart';
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
        title: Text('Insert Operation'),
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
            String id = DateTime.now().millisecondsSinceEpoch.toString();
           dfRef.child(id).set({
             // if you want to add nested child
             //dfRef.child(DateTime.now().millisecondsSinceEpoch.toString()).child('comment').set({
             'id': id,
              'title':postController.text.toString(),



            }).then((value){
              setState(() {
                loading=false;
              });
              Utils.toastMessage('Post added');
            }).onError((error,stackTrace){
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
