import 'package:fl_geocoder/fl_geocoder.dart';
import 'package:flutter/material.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/models/location.dart';
import 'package:highschoolhub/models/user.dart';
class School{
  SchoolLocation address = SchoolLocation();
  String name;
  String image;
  bool currentSchool = false;
  List grades = [];
  List attendedGrades = [];
  School({this.name = "", this.image = "",});
  String getDatabaseName(){
    return name.replaceAll(" ", "").toLowerCase();
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

class academicYear{
  int year;
  int grade;
  bool sameGrade = false;
  School school;
  academicYear(this.year, this.grade, this.school);
}

class schoolCalculationNode{
  List<academicYear> years = [];
  AppUser user;
  double rating = 0;
  schoolCalculationNode(this.user);
  void addYears(schoolUserList sList, School s ){
    for(int i = 0; i < sList.year.length; i++){
      academicYear tempYear = academicYear(sList.year[i], sList.grade[i], s);
      
      years.add(tempYear);
    }
  }
  int abs(int num){
    if(num < 0)return -1 * num;
    return num;
  }
  double getRating(List<academicYear> currentUserYears){
    rating = 0;
    int multiplier = 1;
    for(academicYear year in years){
      for(academicYear currentUserYear in currentUserYears){
        if(year.year == currentUserYear.year && year.school.name == currentUserYear.school.name){
          rating = rating + currentUserYear.year * 1000/(abs(currentUserYear.grade - year.grade) + 1);
          print(rating);
        }
      }
    }
    return rating;
  }
}
class schoolUserList{
  String studentGmail;
  List year;
  List grade;
  schoolUserList({this.studentGmail = "", this.year= const[], this.grade = const[]});
}
/*
flutter: 2023000.0
flutter: Name : Bobby Holland Score: 2023000.0
flutter: 4046000.0
flutter: Name : Cristiano Ronaldo Score: 4046000.0
flutter: 4044000.0
flutter: Name : Joshik Unnam Score: 4044000.0
*/