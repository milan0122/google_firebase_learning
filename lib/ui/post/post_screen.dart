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
  final searchFilter = TextEditingController();
  final editController = TextEditingController();
  //taking reference to fetch data
  final ref = FirebaseDatabase.instance.ref('Post');
  @override
  void initState() {
    super.initState();
    ref.onValue.listen((event) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetching data using FirebaseAnimateList'),
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
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: searchFilter,
              decoration: const InputDecoration(
                hintText: 'Search..',
                border: OutlineInputBorder(),
              ),
              onChanged: (String value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
                query: ref,
                defaultChild: const Text('Loading..'),
                itemBuilder: (context, snapshot, animation, index) {
                  final title = snapshot.child('title').value.toString();
                  final id = snapshot.child('id').value.toString();
                  if (searchFilter.text.isEmpty) {
                    return ListTile(
                      title: Text('id: ${snapshot.child('id').value}'),
                      subtitle: Text('Name: ${snapshot.child('title').value}'),
                      trailing: PopupMenuButton(

                          icon:  Icon(Icons.more_vert_outlined),
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                        showMyDialog(title,id);
                                      },
                                      leading: Icon(Icons.edit),
                                      title: Text('Edit'),
                                    )),
                                PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      onTap: (){
                                        ref.child(snapshot.child('id').value.toString()).remove();
                                        Navigator.pop(context);
                                      },
                                      leading: Icon(Icons.delete),
                                      title: Text('Delete'),
                                    ))
                              ]),

                      // title: Text('id: ' + snapshot.child('comment').child('id').value.toString()),
                      // subtitle: Text('Name: ' + snapshot.child('comment').child('title').value.toString()),
                    );
                  } else if (title
                      .toLowerCase()
                      .contains(searchFilter.text.toLowerCase())) {
                    return ListTile(
                        title: Text('id: ${snapshot.child('id').value}'),
                        subtitle:
                            Text('Name: ${snapshot.child('title').value}'));
                  } else {
                    return Container();
                  }
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddPostScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
//fucntion for delete
  Future<void> showMyDialog(String title,String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit'),
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
                  onPressed: () {
                    Navigator.pop(context);
                    ref.child(id).update({
                      'title':editController.text.toLowerCase()
                    }).then((value){
                      Utilis.toastMessage('Post updated');
                    }).onError((error,StackTrace){
                      Utilis.toastMessage(error.toString());
                    });
                  },
                  child: Text('Update'))
            ],
          );
        });
  }
}

// Center(child: Text('Fetching data using StreamBuilder',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20))),
// Expanded(
//   child:StreamBuilder
//     (
//     stream: ref.onValue,
//     builder: (context,AsyncSnapshot<DatabaseEvent>snapshot){
//       if(snapshot.connectionState==ConnectionState.waiting){
//         return CircularProgressIndicator(color: Colors.black54,);
//       }
//       else if (!snapshot.hasData || snapshot.data!.snapshot.value==null){
//         return Center(child: Text("No data available"));
//
//       }
//       else{
//         Map<dynamic,dynamic> map = snapshot.data!.snapshot.value as Map<dynamic,dynamic>;
//         List<dynamic> list = map.values.toList();
//
//         return ListView.builder(
//             itemCount: snapshot.data!.snapshot.children.length,
//             itemBuilder: (context,index){
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ListTile(
//                   title: Text(list[index]['id'],),
//                   subtitle: Text(list[index]['title']),
//                 ),
//               );
//             });
//
//       }
//
//
//
//   }, )
// ),
