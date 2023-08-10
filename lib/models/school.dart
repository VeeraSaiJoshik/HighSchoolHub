import 'package:fl_geocoder/fl_geocoder.dart';
import 'package:flutter/material.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/models/location.dart';
class School{
  SchoolLocation address = SchoolLocation();
  String name;
  String image;
  bool currentSchool = false;
  List grades = [];
  List attendedGrades = [];
  School({this.name = "", this.image = "",});
  String getDatabaseName(){
    return name.replaceAll(" ", "");
  }
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
  void fromJson(Map json){
    address.fromJson(json["address"]); 
    name = json["name"];
    image = json["image"];
    currentSchool = json["currentSchool"];
    attendedGrades = json["attendedGrades"];
    grades = json["grades"];
  }
}