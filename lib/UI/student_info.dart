
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_project/model/student.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StudentInfo extends StatefulWidget{
  final Student student;
  StudentInfo(this.student);
  @override
  State<StatefulWidget> createState() {
    return new StudentInfoState();
  }

}
final DatabaseReference studentRef = FirebaseDatabase.instance.ref('Students');

class StudentInfoState extends State<StudentInfo>{

String image = '';
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    image = widget.student.image;
    print('Image : $image'  );
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text('Student Information'),
       backgroundColor: Colors.purpleAccent,

     ),
     body: new Container(
       margin: EdgeInsets.only(top: 15.0),
       alignment: Alignment.center,
       child: Column(
         children: [
           Container(child: Center(
             child:image != null ? Image.network(image+'?alt=media',
             height: 200.0,) : Text('no Image')
             ,
           ),
           ),

           Padding(padding: EdgeInsets.only(top: 15.0)),

           Text('Name: ${widget.student.name}'
             ,style: TextStyle(fontSize: 22.0,color: Colors.purpleAccent),

           ),
           Padding(padding: EdgeInsets.only(top: 8.0)),

           Text('Age: ${widget.student.age}'
             ,style: TextStyle(fontSize: 18.0,color: Colors.purpleAccent),

           ),
           Padding(padding: EdgeInsets.only(top: 8.0)),
           Text('City: ${widget.student.city}'
             ,style: TextStyle(fontSize: 18.0,color: Colors.purpleAccent),

           ),
           Padding(padding: EdgeInsets.only(top: 8.0)),
           Text('Department: ${widget.student.department}'
             ,style: TextStyle(fontSize: 18.0,color: Colors.purpleAccent),

           ),
           Padding(padding: EdgeInsets.only(top: 8.0)),


         ],
       ),
     ),
   );
  }
  
}