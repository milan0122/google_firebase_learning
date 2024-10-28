import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_project/Utilis/utilis.dart';
import 'package:firebase_project/ui/login_screen.dart';
import 'package:firebase_project/ui/post/add_post.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _auth = FirebaseAuth.instance;
  //taking reference to fetch data
  final ref = FirebaseDatabase.instance.ref('Post');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(onPressed: (){
            _auth.signOut().then((value){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>LoginScreen()));
            }).onError((error,StackTrace){
              Utilis.toastMessage(error.toString());
            });
          },
              icon:Icon(Icons.login_rounded))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
                query: ref,
                itemBuilder: (context, snapshot,animation,index){
                  return ListTile(
                    title: Text('id: ' + snapshot.child('id').value.toString()),
                    subtitle: Text('Name: ' + snapshot.child('title').value.toString()),

                    // title: Text('id: ' + snapshot.child('comment').child('id').value.toString()),
                    // subtitle: Text('Name: ' + snapshot.child('comment').child('title').value.toString()),
                  );
                }
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=>AddPostScreen()));
          },
        child: Icon(Icons.add),
      ),
    );
  }
}
