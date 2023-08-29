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

import 'package:supabase_flutter/supabase_flutter.dart';

enum Grade { Sophmore, Junior, Senior, Freshman, None }

String currentGradeToString(Grade currentGrade) {
  if (currentGrade == Grade.Sophmore) {
    return "Sophmore";
  } else if (currentGrade == Grade.Junior) {
    return "Junior";
  } else if (currentGrade == Grade.Senior) {
    return "Senior";
  } else if (currentGrade == Grade.Freshman) {
    return "Freshman";
  }
  return "None";
}

int currentGradeToInt(Grade currentGrade) {
  if (currentGrade == Grade.Sophmore) {
    return 10;
  } else if (currentGrade == Grade.Junior) {
    return 11;
  } else if (currentGrade == Grade.Senior) {
    return 12;
  } else if (currentGrade == Grade.Freshman) {
    return 9;
  }
  return -1;
}

Grade currentGradeFromString(String gradeName) {
  if (gradeName == "Junior") {
    return Grade.Junior;
  } else if (gradeName == "Senior") {
    return Grade.Senior;
  } else if (gradeName == "Freshman") {
    return Grade.Freshman;
  } else if (gradeName == "Sophmore") {
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
  bool newImageChosen = false;
  bool imageAlreadyThere = false;
  var image;
  List network;
  List requestsSent; 
  List requestsReceived; 
  List requestsRejected;
  DateOfBirth dateOfBirth = DateOfBirth(0, 0, Months.None);
  USStates userState = USStates.None;
  Grade currentGrade;
  int rating = 0;
  fa.User? userData;
  void setAlData(String email, School school, String image,
      DateOfBirth dateOfBirth, List<clubAppData> clubs, List<Skill> skills) {
    this.email = email;
    this.schools = schools;
    this.image = image;
    this.dateOfBirth = dateOfBirth;
    this.skills = skills;
    this.clubs = clubs;
  }
  void getRatingByQuery(String query){
    String querySublist = "";
    rating = 0;
    for(int i = 0; i < query.length; i++){
      querySublist = querySublist + query.substring(i, i + 1);
      rating = rating + ()
    }
  }
  AppUser(
      {this.email = "",
      this.image = "",
      this.schools = const [],
      this.userData,
      this.currentGrade = Grade.None,
      this.skills = const [],
      this.clubs = const [], 
      this.requestsSent = const [],
      this.requestsReceived = const [],
      this.requestsRejected = const [],
      this.network = const []}) {
    if (this.skills.isEmpty) this.skills = [];
    if (this.clubs.isEmpty) this.clubs = [];
    if (this.network.isEmpty) this.network = [];
    if (this.requestsSent.isEmpty) this.requestsSent = [];
    if (this.requestsReceived.isEmpty) this.requestsReceived = [];
    if (this.requestsRejected.isEmpty) this.requestsRejected = [];
  }
  //! Friend Request Functions
  Future<int> updateNetworkParameters () async {
    Map dataBaseData = await supaBase.from("user_auth_table").select().eq('email', email).single();
    network = dataBaseData["network"];
    requestsSent  = dataBaseData["requestsSent"];
    requestsReceived  = dataBaseData["requestsReceived"];
    requestsRejected = dataBaseData["requestsRejected"];
    return 1;
  }
  Future<int> updateNetworkParametersInDatabase() async {
    await supaBase.from("user_auth_table").update({
      "network" : network, 
      "requestsSent" : requestsSent, 
      "requestsReceived" : requestsReceived, 
      "requestsRejected" : requestsRejected
    }).eq('email', email);
    return 1;
  }
  Future<int> acceptFriendRequest(String friendEmail) async {
    requestsReceived.remove(friendEmail);
    network.add(friendEmail);
    updateNetworkParametersInDatabase();
    AppUser tempUser = AppUser();
    await tempUser.getDataFromDatabase(friendEmail);
    tempUser.requestsSent.remove(email);
    tempUser.network.add(email);
    tempUser.updateNetworkParametersInDatabase();
    return -1;
  }
  Future<int> declineFriendRequest(String friendEmail) async {
    requestsReceived.remove(friendEmail);
    updateNetworkParametersInDatabase();
    AppUser tempUser = AppUser();
    await tempUser.getDataFromDatabase(friendEmail);
    tempUser.requestsSent.remove(email);
    tempUser.requestsRejected.add(email);
    tempUser.updateNetworkParametersInDatabase();
    return -1;
  }
  Future<int> addFriendRequest(String friendEmail) async {
    requestsSent.add(friendEmail);
    updateNetworkParametersInDatabase();
    AppUser tempUser = AppUser();
    await tempUser.getDataFromDatabase(friendEmail);
    tempUser.requestsReceived.add(email);
    tempUser.updateNetworkParametersInDatabase();
    return -1;
  }
  Future<int> removeFriendRequest(String friendEmail) async {
    requestsSent.remove(friendEmail);
    updateNetworkParametersInDatabase();
    AppUser tempUser = AppUser();
    await tempUser.getDataFromDatabase(friendEmail);
    tempUser.requestsReceived.remove(email);
    tempUser.updateNetworkParametersInDatabase();
    return -1;
  }
  String _generateRandomString() {
    final random = Random.secure();
    return base64Url.encode(List<int>.generate(16, (_) => random.nextInt(256)));
  }

  void addClass(schoolClassDatabase takenClassInfo) {
    if (currentGrade != Grade.None)
      classes.add(
          schoolClassStudent(classInfo: takenClassInfo, taken: currentGrade));
    else
      classes.add(schoolClassStudent(classInfo: takenClassInfo));
  }

  void removeClass(schoolClassStudent takenClassInfo) {
    classes.remove(takenClassInfo);
  }

  void changeGrade(Grade newGrade) {
    currentGrade = newGrade;
    for (schoolClassStudent sClass in classes) {
      sClass.taken = currentGrade;
    }
  }

  Future<int> setSchoolData() async {
    print("started");
    int currentGrade = -1;
    for (School school in schools) {
      school.attendedGrades.sort();
      int tempGrade = school.attendedGrades[school.attendedGrades.length - 1];
      if (tempGrade > currentGrade) {
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
    return 1;
  }
  School getCurrentSchool() {
    setCurrentSchool();
    for(School s in schools){
      if(s.currentSchool){
        return s;
      }
    }
    return schools[0];
  }
  void setCurrentSchool() {
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

  Future<int> setGeneralData({bool imageAlso = true}) async {
    print("setting data");
    io.File? imageFile;
    if (image.runtimeType != String && imageAlso) {
      imageFile = image;
      print("uploading");
      print(imageFile.runtimeType);
      await supaBase.storage.from('User-Profile').upload(
            "public/$email.png",
            imageFile!,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
      image = supaBase.storage
          .from('User-Profile')
          .getPublicUrl('$email.png')
          .replaceAll("User-Profile/", "User-Profile/public/") ;
      
      print(image);
      print("done uploading");
      
    }
    int currentSchoolIndex = -1;
    int highestGrade = 0;
    for (int i = 0; i < schools.length; i++) {
      schools[i].attendedGrades.sort();
      print(schools[i].attendedGrades);
      if (schools[i].attendedGrades[schools[i].attendedGrades.length - 1] > highestGrade) {
        highestGrade = schools[i].attendedGrades[schools[i].attendedGrades.length - 1];
        currentSchoolIndex = i;
      }
    }
    if(currentSchoolIndex != -1)schools[currentSchoolIndex].currentSchool = true;
    List<Map> schoolList = [];
    for (School school in schools) {
      schoolList.add(school.getJson());
    }
    print("here");
    List<Map> tempClassList = [];
    List<Map> tempSkillList = [];
    List<Map> tempClubList = [];
    for (Skill s in skills) {
      tempSkillList.add(s.toJSON());
    }
    for (clubAppData s in clubs) {
      tempClubList.add(s.toJson());
    }
    for (schoolClassStudent s in classes) {
      tempClassList.add(s.toJson());
    }
    await supaBase.from("user_auth_table").insert({
      "email": email,
      "schools": schoolList,
      "image": image,
      "state": stateToString(userState),
      "first_name": firstName,
      "last_name": lastName,
      "grade": currentGradeToString(currentGrade),
      "skills": tempSkillList,
      "classes": tempClassList,
      "clubs": tempClubList,
      "dateOfBirth": {
        "Month": monthToString(dateOfBirth.month),
        "Year": dateOfBirth.year,
        "Day": dateOfBirth.day,
      }, 
      "network" : network,
      "requestsSent" : requestsSent, 
      "requestsReceived" : requestsReceived, 
      "requestsRejected" : requestsRejected
    });
    await setSchoolData();
    return 1;
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

  Future<int> signOut() async {
    GoogleSignIn().signOut();
    return 1;
  }
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

  Future<int> updateData({bool imageAlso = true}) async {
    // delete school data
    for(School s in schools){
      try{
        await supaBase.from(s.name.replaceAll(" ", "")).delete().eq("student_gmail", email);
      }on Exception catch (e){}
    }
    await supaBase.from("user_auth_table").delete().eq("email", email);
    print("deleting");
    print("public/$email.png");
    final response = await supaBase.storage.from('User-Profile').remove(["public/$email.png"]);
    await setGeneralData(imageAlso : imageAlso);

    return 1;
  }

  Future<bool> getDataFromDatabase(String gmail) async {
    email = gmail;
    bool userFound = await findUserInDatabase();
    if(userFound){
      imageAlreadyThere = true;
      /*
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
      */
      Map dataBaseData = await supaBase.from("user_auth_table").select().eq('email', gmail).single();
      print(dataBaseData);
      email = dataBaseData["email"];
      schools = [];
      for(Map data in dataBaseData["schools"]){
        School tempSchool = School();
        tempSchool.fromJson(data);
        schools.add(tempSchool);
      }
      classes = [];
      for(Map data in dataBaseData["classes"]){
        schoolClassStudent tempClass = schoolClassStudent();
        tempClass.fromJson(data);
        classes.add(tempClass);
      }
      clubs = [];
      for(Map data in dataBaseData["clubs"]){
        clubAppData tempClub = clubAppData();
        tempClub.fromJson(data);
        clubs.add(tempClub);
      }
      skills = [];
      for(Map data in dataBaseData["skills"]){
        Skill tempSkill = Skill();
        tempSkill.fromJSON(data);
        skills.add(tempSkill);
      }
      firstName = dataBaseData["first_name"];
      lastName = dataBaseData["last_name"];
      image = dataBaseData["image"];
      if ( dataBaseData["network"] == []) network = dataBaseData["network"];
      else network = [];
      dateOfBirth = DateOfBirth(dataBaseData["dateOfBirth"]["Day"], dataBaseData["dateOfBirth"]["Year"], stringToMonth( dataBaseData["dateOfBirth"]["Month"][0]));
      userState = stringToState(dataBaseData["state"]);
      currentGrade = currentGradeFromString(dataBaseData["grade"]);
      if (dataBaseData["network"] != [])network = dataBaseData["network"]; else network = [];
      if (dataBaseData["requestsSent"] != [])requestsSent = dataBaseData["requestsSent"]; else requestsSent = [];
      if (dataBaseData["requestsReceived"] != [])requestsReceived = dataBaseData["requestsReceived"]; else requestsReceived = [];
      if (dataBaseData["requestsRejected"] != [])requestsRejected = dataBaseData["requestsRejected"]; else requestsRejected = [];
      requestsSent = dataBaseData["requestsSent"];
      requestsReceived = dataBaseData["requestsReceived"];
      requestsRejected = dataBaseData["requestsRejected"];
      return true;
    }else{
      return false;
    }
  }
}

class DateOfBirth {
  int day;
  int year;
  Months month;
  DateOfBirth(this.day, this.year, this.month);
}
