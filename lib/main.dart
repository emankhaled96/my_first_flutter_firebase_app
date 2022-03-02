import 'package:firebase_project/UI/students_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
  runApp(
    MaterialApp(
      home: new StudentList(),
    )
  );
}

