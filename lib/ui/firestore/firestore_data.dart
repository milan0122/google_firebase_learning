import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_project/Utils/utils.dart';
import 'package:firebase_project/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreData extends StatefulWidget {
  const FireStoreData({super.key});

  @override
  State<FireStoreData> createState() => _FireStoreDataState();
}

class _FireStoreDataState extends State<FireStoreData> {
  //create collection
  final postController = TextEditingController();
  final nameController = TextEditingController();
  final dfRef = FirebaseDatabase.instance.ref('Post');
  bool loading = false;

  //creating collection in firestore
  final fireStore = FirebaseFirestore.instance.collection('Users');
  @override
  void dispose(){
    super.dispose();
    postController.dispose();
    nameController.dispose();


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add FireStore Data'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                  hintText: "Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)
                  )
              ),
            ),
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
                fireStore.doc(id).set({
                  'id':id,
                  'name':nameController.text.toString(),
                  'thoughts':postController.text.toString()

                }).then((value){
                  setState(() {
                    loading=false;
                  });
                  Utils.toastMessage("sucessfully added");
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
