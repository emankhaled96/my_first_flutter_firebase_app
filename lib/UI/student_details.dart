
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_project/model/student.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';


class StudentDetails extends StatefulWidget{
  final Student student;
  StudentDetails(this.student);
  @override
  State<StatefulWidget> createState() {
    return new StudentDetailsState();
  }

}
final DatabaseReference studentRef = FirebaseDatabase.instance.ref('Students');

class StudentDetailsState extends State<StudentDetails>{
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _cityController;
  late TextEditingController _departmentController;

   File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedimg = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedimg != null) {
        _image = File(pickedimg.path);
      } else {
        print('No Image Selected');
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = new TextEditingController(text: widget.student.name);
    _ageController = new TextEditingController(text: widget.student.age);
    _cityController = new TextEditingController(text: widget.student.city);
    _departmentController = new TextEditingController(text: widget.student.department);




  }



  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text('Student Info'),
       backgroundColor: Colors.deepOrange,

     ),
     body: new Container(
       margin: EdgeInsets.only(top: 15.0),
       alignment: Alignment.center,
       child: Column(
         children: [
           TextField(
             style: TextStyle(fontSize: 16.0,color: Colors.orangeAccent),
             controller: _nameController,
             decoration: InputDecoration(
               icon: Icon(Icons.person),
               labelText: 'Name'
             ),
           ),
           Padding(padding: EdgeInsets.only(top: 8.0)),
           TextField(
             style: TextStyle(fontSize: 16.0,color: Colors.orangeAccent),
             controller: _ageController,
             decoration: InputDecoration(
                 icon: Icon(Icons.calendar_today),
                 labelText: 'Age'
             ),
           ),
           Padding(padding: EdgeInsets.only(top: 8.0)),
           TextField(
             style: TextStyle(fontSize: 16.0,color: Colors.orangeAccent),
             controller: _cityController,
             decoration: InputDecoration(
                 icon: Icon(Icons.location_city),
                 labelText: 'City'
             ),
           ),
           Padding(padding: EdgeInsets.only(top: 8.0)),
           TextField(
             style: TextStyle(fontSize: 16.0,color: Colors.orangeAccent),
             controller: _departmentController,
             decoration: InputDecoration(
                 icon: Icon(Icons.home),
                 labelText: 'Department'
             ),
           ),
           Padding(padding: EdgeInsets.only(top: 8.0)),
       Container(
         child: Center(
           child:_image != null ? Image.file(_image!,height: 20.0,) : Text('no Image')
           ,
         ),
       ),
        FlatButton(
            onPressed: () async {
              if(widget.student.id!=null){
                studentRef.child(widget.student.id.toString()).set({
                  'name':_nameController.text,
                  'age':_ageController.text,
                  'city':_cityController.text,
                  'department':_departmentController.text
                }).then((_) => {
                  Navigator.pop(context)
                });
              }else{

                var now = formatDate(new DateTime.now(), [yyyy ,'-','mm','-',dd]);
                var fullImageName = 'image/${_nameController.text}-$now'+'.jpg';

                final FirebaseStorage storage = FirebaseStorage.instance;
                final Reference = storage.ref().child(fullImageName);

                final  task = Reference.putFile(_image!);
               String url = (await Reference.getDownloadURL()).toString();

                var part1 = 'https://firebasestorage.googleapis.com/v0/b/twitter-2dbd5.appspot.com/o/';

                var fullImagePath = url;

                studentRef.push().set({
                  'name':_nameController.text,
                  'age':_ageController.text,
                  'city':_cityController.text,
                  'department':_departmentController.text,
                  'image' : fullImagePath
                }).then((_) => {
                  Navigator.pop(context)
                });
              }
            },
            child: (widget.student.id != null ?Text('Update') : Text('Add'))
        )
         ],
       ),
     ),
     floatingActionButton: FloatingActionButton(
       onPressed: () => getImage(),
       child: Icon(Icons.camera_alt),
     ),
   );
  }
  
}