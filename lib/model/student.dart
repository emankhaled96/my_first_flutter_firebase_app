import 'package:firebase_database/firebase_database.dart';

class Student{
   String? _id ;
   String _name = '';
   String _age = '';
   String _city = '';
   String _department = '';
   String _image='';

  Student( this._id,this._name, this._age, this._city, this._department,this._image);


  Student.map(dynamic obj){
    this._id = obj['id'];
    this._name = obj['name'];
    this._age = obj['age'];
    this._city = obj['city'];
    this._department = obj['department'];
    this._image = obj['image'];

  }
  String get department => _department;

  String get city => _city;

  String get age => _age;

  String get name => _name;

  String? get id => _id;

   String get image => _image;

  Student.fromSnapshot(DataSnapshot snapshot){
    _id = snapshot.key.toString();
    _name = snapshot.child('name').value.toString();
    _age = snapshot.child('age').value.toString();
    _city = snapshot.child('city').value.toString();
    _department = snapshot.child('department').value.toString();

    _image = snapshot.child('image').value.toString();
  }
}