import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_project/Utilis/utilis.dart';
import 'package:firebase_project/ui/firestore/firestore_data.dart';
import 'package:firebase_project/ui/login_screen.dart';
import 'package:firebase_project/ui/post/add_post.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreListScreen extends StatefulWidget {
  const FireStoreListScreen({super.key});

  @override
  State<FireStoreListScreen> createState() => _FireStoreListScreenState();
}

class _FireStoreListScreenState extends State<FireStoreListScreen> {
  final _auth = FirebaseAuth.instance;
  final searchFilter = TextEditingController();
  final editController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('Users').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('Users');
  
  //taking reference to fetch data

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FireStore'),
        actions: [
          IconButton(
              onPressed: () {
                _auth.signOut().then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => LoginScreen()));
                }).onError((error, StackTrace) {
                  Utilis.toastMessage(error.toString());
                });
              },
              icon: const Icon(Icons.login_rounded))
        ],
      ),
      body: Column(
        children: [
          //
          Padding(
            padding: const EdgeInsets.all(5),
            child: TextFormField(
              controller: searchFilter,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search....',
              ),
              onChanged: (String val){
                setState(() {

                });
              },

            ),
          ),
           SizedBox(
            height: 10,
          ),

         StreamBuilder(stream: fireStore,
             builder:(context, AsyncSnapshot<QuerySnapshot>snapshot){
           if(snapshot.connectionState==ConnectionState.waiting){
             return CircularProgressIndicator();
           }
           else if(snapshot.hasError){
             return Center(child: Text('Something Went wrong !!!'),);
           }
           else{
             return Expanded(child: ListView.builder(
                 itemCount: snapshot.data!.docs.length,
                 itemBuilder: (context,index){
                   final id  = snapshot.data!.docs[index]['id'].toString();
                   final name= snapshot.data!.docs[index]['name'].toString();
                   final thoughts = snapshot.data!.docs[index]['thoughts'].toString();
                   if(searchFilter.text.isEmpty) {
                     return ListTile(
                       title: Text(
                           name),
                       subtitle: Text(
                          thoughts,),
                       trailing: PopupMenuButton(
                         icon: Icon(Icons.more_vert),
                           itemBuilder: (context)=>[
                         PopupMenuItem(
                             child: ListTile(
                               onTap: (){
                                 Navigator.pop(context);
                                 showMyDialog(thoughts, id);
                               },
                               leading: Icon(Icons.edit),
                               title: Text('Edit'),
                             )),
                         PopupMenuItem(
                             child: ListTile(
                               onTap: (){
                                 ref.doc(snapshot.data!.docs[index]['id'].toString()).delete();
                                 Navigator.pop(context);

                               },
                               leading: Icon(Icons.delete),
                               title: Text('delete'),
                             )),


                       ]
                       ),
                     );
                   }
                   else if(name.toLowerCase().contains(searchFilter.text.toLowerCase())){
                     return ListTile(
                         title: Text(
                             name),
                         subtitle: Text(
                           thoughts,)
                     );
                   }
                   else{
                     return Container();
                   }
                 }));
           }

             }),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => FireStoreData()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
//function to update
  Future<void> showMyDialog(String title,String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update your thoughts'),
            content: Container(
              child: TextField(
                controller: editController,
                decoration: InputDecoration(),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                    ref.doc(id).update({
                      'thoughts':editController.text.toString()
                    }).then((value){
                      Utilis.toastMessage("Update successfully");
                    }).onError((error, StackTrace){
                      Utilis.toastMessage(error.toString());
                    });
          },
                  child: Text('Update '))
            ],
          );
        });
  }
}

