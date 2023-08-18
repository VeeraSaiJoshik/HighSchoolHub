import 'package:flutter/material.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/models/school.dart';
import 'package:highschoolhub/models/user.dart';

class schoolClassDatabase{
  String className;
  List schoolAssociatedWith;
  String fieldOfStudy;
  double gScore = -1;
  List<String> subjects = [
    "Buisness",//g
    "Computers",// b
    "English", 
    "Language", 
    "Math", //g
    "Music", //b
    "Sports", 
    "Science", 
    "Social_Studies", 
    "Art", //g
    "Electives", // b
  ];
  void addSchool(School addingSchool){
    bool flag = false;
    for(School s in schoolAssociatedWith){
      if(s.name == addingSchool.name){
        flag = true;
      }
    }
    if(flag == false){
      schoolAssociatedWith.add(addingSchool);
    }
  }
  double getCorpusRatingFromQuery(String query) {
    double score = 0;
    String currentQuery = "";
    int i = 0;
    for(String char in query.split('')){
      currentQuery = currentQuery + char.toLowerCase();
      if(className.toLowerCase().indexOf(currentQuery) != -1){
        score += (1/(className.toLowerCase().indexOf(currentQuery) + 1)) * currentQuery.length* 1000;  
      }
    }
    gScore = score;
    return score;
  }
  String getImageAddy(){
    return "assets/images/classImage/" + fieldOfStudy + ".png";
  }
  void fromJson(Map data){
    className = data["ClassName"];
    schoolAssociatedWith = [];
    for(Map schoolD in data["Schools"]){
      School tempVal = School();
      tempVal.fromJson(schoolD);
      schoolAssociatedWith.add(
        tempVal
      );
    }
    fieldOfStudy = data["FieldOfStudy"];
  }
  Map toJson(){
    List uploadableSchoolList = [];
    for(School s in schoolAssociatedWith){
      uploadableSchoolList.add(s.getJson());
    }
    return {
      "ClassName" : className, 
      "Schools" : uploadableSchoolList, 
      "FieldOfStudy" : fieldOfStudy
    };
  }
  Color getColor(){
    int colorVal = subjects.indexOf(fieldOfStudy)%4;
    List<Color> colors = [mainColor, blue, puprle, orange];
    return colors[colorVal];
  }
  Color getDColor(){
    int colorVal = subjects.indexOf(fieldOfStudy)%4;
    List<Color> colors = [darkGreen, darkblue, darkPurple, darkOrange];
    return colors[colorVal];
  }
  schoolClassDatabase({this.className = "", this.schoolAssociatedWith = const [], this.fieldOfStudy = ""});
}

class schoolClassStudent{
  schoolClassDatabase? classInfo = schoolClassDatabase();
  School? classTakenAt = School();
  Grade? taken = Grade.None;
  String? classId = "";
  schoolClassStudent({this.classInfo, this.classTakenAt, this.taken}){
    classId = DateTime.now().toString();
  }
  Map toJson(){
    return {
      "classInfo" : classInfo!.toJson(), 
      "taken" : currentGradeToString(taken!), 
      "associatedSchool" : classTakenAt!.getJson(),
      "classId" : classId
    };
  }
  void fromJson(Map json){
    classInfo = schoolClassDatabase();
   classTakenAt = School();
   taken = Grade.None;
   classId = "";
    classInfo!.fromJson(json["classInfo"]);
    taken = currentGradeFromString(json["taken"]);
    classId = json["classId"];
    classTakenAt!.fromJson(json["associatedSchool"]);
  }
}