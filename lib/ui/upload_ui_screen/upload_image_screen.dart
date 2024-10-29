import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_project/Utils/utils.dart';
import 'package:firebase_project/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? _image;
  final picker = ImagePicker();
  bool loading = false;
  //reference for storage
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  DatabaseReference dfRef = FirebaseDatabase.instance.ref('Post');
  Future getImageGallery()async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
    if(pickedFile!=null){
      setState(() {
        _image = File(pickedFile.path);
      });
    }
    else{
      Utils.toastMessage('No image picked');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: InkWell(
              onTap: (){
                getImageGallery();
              },
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black54
                  )
                ),
                child: _image!=null? Image.file(_image!.absolute,fit: BoxFit.cover,) : Center(child: Icon(Icons.image)),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          RoundButton(title: 'Upload Image',
              loading: loading,
              onTap: (){
            setState(() {
              loading=true;
            });
            firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/Gallery'+'img1');
            firebase_storage.UploadTask upload = ref.putFile(_image!.absolute);
             Future.value(upload).then((value)async{
              var newUrl = await ref.getDownloadURL();
              dfRef.child('2').set({
                'id':2,
                'image_url':newUrl.toString()
              }).then((value){
                setState(() {
                  loading=false;
                });
                Utils.toastMessage('Uploaded successfully');
              }).onError((error,StackTrace){
                setState(() {
                  loading=false;
                });
                Utils.toastMessage(error.toString());
              });
            });


          })

        ],
      ),
    );
  }
}
