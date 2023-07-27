import 'package:fl_geocoder/fl_geocoder.dart';
import 'package:flutter/material.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/models/location.dart';
class School{
  SchoolLocation address = SchoolLocation();
  String name;
  String image;
  bool currentSchool = false;
  List<int> grades = [];
  List<int> attendedGrades = [];
  School({this.name = "", this.image = "",});
  Map getJson(){
    return {
      "address" : this.address.toJson(), 
      "name" : this.name,
      "image" : this.image, 
      "currentSchool" : this.currentSchool, 
      "grades" : this.grades, 
      "attendedGrades" : this.attendedGrades, 
    };
  }
}