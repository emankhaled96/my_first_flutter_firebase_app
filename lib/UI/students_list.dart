
import 'dart:async';
import 'dart:core';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_project/UI/student_info.dart';
import 'package:firebase_project/model/student.dart';
import 'package:flutter/material.dart';
import 'package:firebase_project/UI/student_details.dart';

class StudentList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new StudentListState();
  }

}

final DatabaseReference studentRef = FirebaseDatabase.instance.ref('Students');
class StudentListState extends State<StudentList>{

   late List<Student> studItems ;
   late StreamSubscription<DatabaseEvent> _onStudentAddedSubscription;
 late StreamSubscription<DatabaseEvent> _onStudentChangedSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    studItems =[];
    _onStudentAddedSubscription = studentRef.onChildAdded.listen(_onStudentAdded) ;

    _onStudentChangedSubscription = studentRef.onChildChanged.listen(_onStudentChanged) ;

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _onStudentAddedSubscription.cancel();
    _onStudentChangedSubscription.cancel();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Student DB',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Students Information',),
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
        body: Center(
          child: ListView.builder(
            itemCount: studItems.length,
              padding: EdgeInsets.only(top: 12.0),
              itemBuilder: (BuildContext context ,int position ){
              return Column(
                children: [
                  Divider(height: 6.0,),
                  Card(
                    child: Row(
                      children: [
                        new Expanded(child:ListTile(
                          title: Text('${studItems[position].name}',
                            style: TextStyle(color: Colors.red,
                                fontSize: 22.0),),
                          subtitle: Text('${studItems[position].age } /${studItems[position].city } /${studItems[position].department }  ',
                            style: TextStyle(color: Colors.black,
                                fontSize: 18.0),),
                          leading: Column(
                            children: [

                              '${studItems[position].image}' == ''?
                              CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                radius: 20.0,
                                child: Text('${position + 1}',
                                  style: TextStyle(color: Colors.white,
                                      fontSize: 18.0),
                                ),
                              ):
                              Image.network('${studItems[position].image}',height: 30.0,width: 30.0,)

                            ],
                          ),
                          onTap: ()=> _navigateToStudent(context , studItems[position],position),
                        ),
                        ),
                        IconButton(onPressed:()=> _editStudent(context , studItems[position],position),
                            icon: Icon(Icons.edit , color: Colors.blueAccent,)),
                        IconButton(onPressed:()=> _deleteStudent(context , studItems[position],position), icon: Icon(Icons.delete ,color: Colors.red,))

                      ],
                    ),
                  ),


                ],
              );
              }),
        ),
        floatingActionButton: FloatingActionButton(child: Icon(Icons.add),
        onPressed: ()=>_createNewStudent(context),),
      ),
    );
  }

  void _onStudentChanged(DatabaseEvent event){
    var oldStudentValue = studItems.singleWhere((student) => student.id == event.snapshot.key );

    print('oldStudentValue : ${oldStudentValue}');

    setState(() {

      studItems[studItems.indexOf(oldStudentValue)] = new Student.fromSnapshot(event.snapshot);


    });
  }
  void _onStudentAdded(DatabaseEvent event){
    //studItems.clear();
  setState(() {

    studItems.add(new Student.fromSnapshot(event.snapshot));

  });

  }


  void _editStudent(BuildContext context, Student studItem, int position) async {
  
    await Navigator.push(context, 
    MaterialPageRoute(builder: (context) => StudentDetails(studItem)));
  }


   void _navigateToStudent(BuildContext context, Student studItem, int position) async {

     await Navigator.push(context,
         MaterialPageRoute(builder: (context) => StudentInfo(studItem)));
   }

  void _deleteStudent(BuildContext context, Student studItem, int position) async {

    await studentRef.child(studItem.id.toString()).remove().then((_) {
      setState(() {
        studItems.removeAt(position);
      });
    });

  }
  void _createNewStudent(BuildContext context)async{

    await Navigator.push(context,
      MaterialPageRoute(builder:
        (context)=>StudentDetails(Student(null, '', '', '', '',''))),
    );

  }
}
