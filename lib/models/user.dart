// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:flutter/material.dart';
import 'package:highschoolhub/models/class.dart';
import 'package:highschoolhub/models/club.dart';
import 'package:highschoolhub/models/school.dart';
import 'package:highschoolhub/main.dart';
import 'package:highschoolhub/models/skills.dart';
import 'package:highschoolhub/pages/SignUpScreen/AccountInfo.dart';
import 'package:supabase/supabase.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_downloader/image_downloader.dart';
import 'dart:io' as io;

enum Grade{
  Sophmore, 
  Junior,
  Senior, 
  Freshman, 
  None
}

String currentGradeToString(Grade currentGrade){
  if(currentGrade == Grade.Sophmore){
    return "Sophmore";
  }else if(currentGrade == Grade.Junior){
    return "Junior";
  }else if(currentGrade == Grade.Senior){
    return "Senior";
  }else if(currentGrade == Grade.Freshman){
    return "Freshman";
  }
  return "None";
}

int currentGradeToInt(Grade currentGrade){
  if(currentGrade == Grade.Sophmore){
    return 10;
  }else if(currentGrade == Grade.Junior){
    return 11;
  }else if(currentGrade == Grade.Senior){
    return 12;
  }else if(currentGrade == Grade.Freshman){
    return 9;
  }
  return -1;
}

Grade currentGradeFromString(String gradeName){
  if(gradeName == "Junior"){
    return Grade.Junior;
  }else if(gradeName == "Senior"){
    return Grade.Senior;
  }else if(gradeName == "Freshman"){
    return Grade.Freshman;
  }else if(gradeName == "Sophmore"){
    return Grade.Sophmore;
  }
  return Grade.None;
}

class AppUser {
  String email;
  List<School> schools = [];
  List<schoolClassStudent> classes = [];
  List<clubAppData> clubs = [];
  List<Skill> skills = [];
  String firstName = "";
  String lastName = "";
  var image;
  DateOfBirth dateOfBirth = DateOfBirth(0, 0, Months.None);
  USStates userState = USStates.None;
  Grade currentGrade;
  fa.User? userData;
  void setAlData(
      String email, School school, String image, DateOfBirth dateOfBirth, List<clubAppData> clubs, List<Skill> skills) {
    this.email = email;
    this.schools = schools;
    this.image = image;
    this.dateOfBirth = dateOfBirth;
    this.skills = skills;
    this.clubs = clubs;
  }

  AppUser(
      {this.email = "",
      this.image = "",
      this.schools = const [],
      this.userData, 
      this.currentGrade = Grade.None,
      this.skills = const [], 
      this.clubs = const []}){
        if(this.skills.isEmpty) this.skills = [];
        if(this.clubs.isEmpty) this.clubs = [];
      }
  String _generateRandomString() {
    final random = Random.secure();
    return base64Url.encode(List<int>.generate(16, (_) => random.nextInt(256)));
  }
  void addClass(schoolClassDatabase takenClassInfo){
    if(currentGrade != Grade.None) classes.add(schoolClassStudent(classInfo: takenClassInfo, taken: currentGrade));
    else classes.add(schoolClassStudent(classInfo: takenClassInfo));
  }
  void removeClass(schoolClassStudent takenClassInfo){
    classes.remove(takenClassInfo);
  }
  void changeGrade(Grade newGrade){
    currentGrade = newGrade;
    for(schoolClassStudent sClass in classes){
      sClass.taken = currentGrade;
    }
  }
  void setSchoolData() async {
    print("started");
    int currentGrade = -1;
    for (School school in schools) {
      school.attendedGrades.sort();
      int tempGrade = school.attendedGrades[school.attendedGrades.length - 1];
      if(tempGrade > currentGrade){
        currentGrade = tempGrade;
      }
    }
    DateTime currentTime = DateTime.now();
    int currentAcademicYear = currentTime.year;
    if (currentTime.month <= DateTime.may) {
      currentAcademicYear = currentTime.year - 1;
    }
    print(currentAcademicYear);
    print(currentGrade);
    for (School school in schools) {
      print(school);
      for (int grade in school.attendedGrades) {
        print(grade);
        Map insertionMap = {
          "Student_Gmail": email,
          "Grade": grade,
          "Year": currentAcademicYear - (currentGrade - grade), 
        };
        try {
          print("here ");
          print(email);
          final insertQuery = '''
      INSERT INTO ${school.getDatabaseName()} (Student_Gmail, Grade, Year)
      VALUES (@email, @grade, @year)
    ''';

    // Execute the prepared statement with the provided parameters.
    await databaseConnection.execute(insertQuery, substitutionValues: {
      'email': email,
      'grade': grade,
      'year': currentAcademicYear - (currentGrade - grade),
    });
        } on Exception catch (e) {
          print(e);
          await databaseConnection.execute('''      
            CREATE TABLE ${school.getDatabaseName()} (
              Student_Gmail text,  
              Grade int, 
              Year int,
              id SERIAL PRIMARY KEY
            )
          ''');
          print("created");
          final insertQuery = '''
      INSERT INTO ${school.getDatabaseName()} (Student_Gmail, Grade, Year)
      VALUES (@email, @grade, @year)
    ''';

    // Execute the prepared statement with the provided parameters.
    await databaseConnection.execute(insertQuery, substitutionValues: {
      'email': email,
      'grade': grade,
      'year': currentAcademicYear - (currentGrade - grade),
    });
        }
      }
    }
  }

  void setCurrentSchool(){
      int currentSchoolIndex = -1;
      int highestGrade = 0;
      for (int i = 0; i < schools.length; i++) {
        schools[i].attendedGrades.sort();
        if (schools[i].attendedGrades[schools.length - 1] > highestGrade) {
          highestGrade = schools[i].attendedGrades[schools.length - 1];
          currentSchoolIndex = i;
        }
      }
      schools[currentSchoolIndex].currentSchool = true;
  }

  void setGeneralData() async {
    print("setting data");
    io.File? imageFile;
    if (image.runtimeType != String) {
      imageFile = image;
      print("uploading");
      await supaBase.storage.from('User-Profile').upload(
            "public/$email.png",
            imageFile!,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
      image = supaBase.storage
          .from('User-Profile')
          .getPublicUrl('$email.png')
          .replaceAll("User-Profile/", "User-Profile/public/");
    }
    int currentSchoolIndex = -1;
    int highestGrade = 0;
    for (int i = 0; i < schools.length; i++) {
      schools[i].attendedGrades.sort();
      if (schools[i].attendedGrades[schools.length - 1] > highestGrade) {
        highestGrade = schools[i].attendedGrades[schools.length - 1];
        currentSchoolIndex = i;
      }
    }
    schools[currentSchoolIndex].currentSchool = true;
    List<Map> schoolList = [];
    for (School school in schools) {
      schoolList.add(school.getJson());
    }
    print("here");
    await supaBase.from("user_auth_table").insert({
      "email": email,
      "schools": schoolList,
      "image": image,
      "state": stateToString(userState),
      "first_name": firstName,
      "last_name": lastName,
      "dateOfBirth": {
        "Month": monthToString(dateOfBirth.month),
        "Year": dateOfBirth.year,
        "Day": dateOfBirth.day,
      }
    });
    print("done");
  }

  Future<int> authenticationUser() async {
    /**
     * Legend 
     * 1 = Succesful
     * 2 = Not Signed Up
     * -1 = failed
     */
    final GoogleSignInAccount? temp = await GoogleSignIn().signIn();
    print(temp);
    if (temp != null) {
      final GoogleSignInAuthentication gAuth = await temp!.authentication;
      final credential = fa.GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken, idToken: gAuth.idToken);
      userData =
          (await fa.FirebaseAuth.instance.signInWithCredential(credential))
              .user!;
      print("user data has been completed : ");
      print(userData);
      email = userData!.email!;
      if (await findUserInDatabase()) return 1;
      return 2;
    }

    return -1;
  }

  void signOut() {}
  Future<bool> findUserInDatabase() async {
    final userData = await supaBase.from('user_auth_table').select("email");
    for (int i = 0; i < userData.length; i++) {
      if (userData[i]["email"] == email) return true;
    }
    return false;
  }

  void addSchool(School school) {
    schools.add(school);
  }

  void removeSchool(String schoolName) {
    for (School school in schools) {
      if (school.name == schoolName) {
        schools.remove(school);
        break;
      }
    }
  }

  School getSchool(String schoolName) {
    for (School school in schools) {
      if (school.name == schoolName) {
        return school;
      }
    }
    return schools[0];
  }
}

class DateOfBirth {
  int day;
  int year;
  Months month;
  DateOfBirth(this.day, this.year, this.month);
}
