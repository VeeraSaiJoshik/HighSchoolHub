// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:flutter/material.dart';
import 'package:highschoolhub/models/class.dart';
import 'package:highschoolhub/models/club.dart';
import 'package:highschoolhub/models/filter.dart';
import 'package:highschoolhub/models/mentor.dart';
import 'package:highschoolhub/models/school.dart';
import 'package:highschoolhub/main.dart';
import 'package:highschoolhub/models/skills.dart';
import 'package:highschoolhub/pages/AuthenticationPage.dart';
import 'package:highschoolhub/pages/SignUpScreen/AccountInfo.dart';
import 'package:supabase/supabase.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_downloader/image_downloader.dart';
import 'dart:io' as io;

import 'package:supabase_flutter/supabase_flutter.dart';

enum Grade { Freshman, Sophmore, Junior, Senior, None }

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
  Filter searchFilterSearchCommunity = Filter();
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
  List<AppUser> requestsSent;
  List<AppUser> requestsReceived;
  List<AppUser> requestsRejected;
  List<AppUser> network;
  List<Mentor> mentorposts;
  List<mentorDatabase> mentors;
  List<mentorDatabase> mentees;
  List<mentorDatabase> mentorRequestsSent;
  List<mentorDatabase> mentorRequestsRecieved;
  DateOfBirth dateOfBirth = DateOfBirth(0, 0, Months.None);
  USStates userState = USStates.None;
  Grade currentGrade;
  int rating = 0;
  double gScore = 0;
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

  int getRatingByQuery(String query) {
    String querySublist = "";
    rating = 0;
    for (int i = 0; i < query.length; i++) {
      querySublist = querySublist + query.substring(i, i + 1);
      rating = rating;
    }
    return rating;
  }
  bool userEmailInMyNetwork(String email){
    for(AppUser user in network){
      if(user.email == email) return true;
    }
    return false;
  }
  bool userEmailInMyRequestSents(String query){
    for(AppUser user in requestsSent){
      if(user.email == query) return true;
    }
    return false;
  }
  bool userEmailInMyRequestsRecieved(String query){
    for(AppUser user in requestsReceived){
      if(user.email == query) return true;
    }
    return false;
  }
  bool userEmailInMyConnectionList(String query){
    return userEmailInMyRequestSents(query) && userEmailInMyNetwork(query) && userEmailInMyRequestsRecieved(query);
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
      this.network = const [],
      this.mentorposts = const [],
      this.mentors = const [],
      this.mentees = const [],
      this.mentorRequestsSent = const [],
      this.mentorRequestsRecieved = const []}) {
    if (this.skills.isEmpty) this.skills = [];
    if (this.clubs.isEmpty) this.clubs = [];
    if (this.network.isEmpty) this.network = [];
    if (this.requestsSent.isEmpty) this.requestsSent = [];
    if (this.requestsReceived.isEmpty) this.requestsReceived = [];
    if (this.requestsRejected.isEmpty) this.requestsRejected = [];
    if (this.mentorposts.isEmpty) this.mentorposts = [];
    if (this.mentors.isEmpty) this.mentors = [];
    if (this.mentees.isEmpty) this.mentees = [];
    if (this.mentorRequestsSent.isEmpty) this.mentorRequestsSent = [];
    if (this.mentorRequestsRecieved.isEmpty) this.mentorRequestsRecieved = [];
  }
  Map toJson() {
    List<Map> mentorsTemp = [];
    List<Map> menteesTemp = [];
    List<Map> mentorRequestsSentTemp = [];
    List<Map> mentorRequestsRecievedTemp = [];
    for (mentorDatabase m in mentors) {
      mentorsTemp.add(m.toJson());
    }
    for (mentorDatabase m in mentees) {
      menteesTemp.add(m.toJson());
    }
    for (mentorDatabase m in mentorRequestsSent) {
      mentorRequestsSentTemp.add(m.toJson());
    }
    for (mentorDatabase m in mentorRequestsRecieved) {
      mentorRequestsRecievedTemp.add(m.toJson());
    }
    int currentSchoolIndex = -1;
    int highestGrade = 0;
    for (int i = 0; i < schools.length; i++) {
      schools[i].attendedGrades.sort();
      print(schools[i].attendedGrades);
      if (schools[i].attendedGrades[schools[i].attendedGrades.length - 1] >
          highestGrade) {
        highestGrade =
            schools[i].attendedGrades[schools[i].attendedGrades.length - 1];
        currentSchoolIndex = i;
      }
    }
    if (currentSchoolIndex != -1)
      schools[currentSchoolIndex].currentSchool = true;
    List<Map> schoolList = [];
    for (School school in schools) {
      schoolList.add(school.getJson());
    }
    print("here");
    List<Map> tempClassList = [];
    List<Map> tempSkillList = [];
    List<Map> tempClubList = [];
    List<Map> mentorPostsList = [];
    for (Mentor m in mentorposts) {
      mentorPostsList.add(m.toJson());
    }
    for (Skill s in skills) {
      tempSkillList.add(s.toJSON());
    }
    for (clubAppData s in clubs) {
      tempClubList.add(s.toJson());
    }
    for (schoolClassStudent s in classes) {
      tempClassList.add(s.toJson());
    }
    return {
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
      "network": network,
      "requestsSent": requestsSent,
      "requestsReceived": requestsReceived,
      "requestsRejected": requestsRejected,
      "MentorPosts": mentorPostsList,
      "mentors": mentorsTemp,
      "mentees": menteesTemp,
      "mentorRequestsSent": mentorRequestsSentTemp,
      "mentorRequestsRecieved": mentorRequestsRecievedTemp
    };
  }

  void fromJson(Map dataBaseData) {
    email = dataBaseData["email"];
    mentorposts = [];
    print("this is where the error at");
    mentors = [];
    mentorRequestsRecieved = [];
    mentorRequestsSent = [];
    mentees = [];
    if (dataBaseData["mentors"] != null)
      for (Map data in dataBaseData["mentors"]) {
        mentorDatabase tempmentor = mentorDatabase();
        tempmentor.fromJson(data);
        mentors.add(tempmentor);
      }
    if (dataBaseData["mentees"] != null)
      for (Map data in dataBaseData["mentees"]) {
        mentorDatabase tempmentor = mentorDatabase();
        tempmentor.fromJson(data);
        mentees.add(tempmentor);
      }
    if (dataBaseData["mentorRequestsSent"] != null)
      for (Map data in dataBaseData["mentorRequestsSent"]) {
        mentorDatabase tempmentor = mentorDatabase();
        tempmentor.fromJson(data);
        mentorRequestsSent.add(tempmentor);
      }
    if (dataBaseData["mentorRequestsRecieved"] != null)
      for (Map data in dataBaseData["mentorRequestsRecieved"]) {
        mentorDatabase tempmentor = mentorDatabase();
        tempmentor.fromJson(data);
        mentorRequestsRecieved.add(tempmentor);
      }
    if (dataBaseData["MentorPosts"] != null)
      for (Map data in dataBaseData["MentorPosts"]) {
        Mentor tempmentor = Mentor();
        print(data);
        tempmentor.parseJson(data);
        mentorposts.add(tempmentor);
      }
    schools = [];
    for (Map data in dataBaseData["schools"]) {
      School tempSchool = School();
      tempSchool.fromJson(data);
      schools.add(tempSchool);
    }
    classes = [];
    for (Map data in dataBaseData["classes"]) {
      schoolClassStudent tempClass = schoolClassStudent();
      tempClass.fromJson(data);
      classes.add(tempClass);
    }
    clubs = [];
    for (Map data in dataBaseData["clubs"]) {
      clubAppData tempClub = clubAppData();
      tempClub.fromJson(data);
      clubs.add(tempClub);
    }
    skills = [];
    for (Map data in dataBaseData["skills"]) {
      Skill tempSkill = Skill();
      tempSkill.fromJSON(data);
      skills.add(tempSkill);
    }
    firstName = dataBaseData["first_name"];
    lastName = dataBaseData["last_name"];
    image = dataBaseData["image"];
    dateOfBirth = DateOfBirth(
        dataBaseData["dateOfBirth"]["Day"],
        dataBaseData["dateOfBirth"]["Year"],
        stringToMonth(dataBaseData["dateOfBirth"]["Month"][0]));
    userState = stringToState(dataBaseData["state"]);
    currentGrade = currentGradeFromString(dataBaseData["grade"]);
  }

  void addMentorPost(Mentor m) {
    if (mentorposts.isEmpty) {
      mentorposts = [];
    }
    mentorposts.add(m);
  }

  //! Friend Request Functions
  Future<int> updateNetworkParameters() async {
    print("Updating");
    Map dataBaseData = await supaBase
        .from("user_auth_table")
        .select()
        .eq('email', email)
        .single();
    network = [];
    requestsSent = [];
    requestsReceived = [];
    requestsRejected = [];
    print(dataBaseData["network"]);
    for (Map u in dataBaseData["network"]) {
      print("I am here");
      AppUser t = AppUser();
      t.fromJson(u);
      network.add(t);
    }
    for (Map u in dataBaseData["requestsSent"]) {
      print(u);
      AppUser t = AppUser();
      t.fromJson(u);
      requestsSent.add(t);
    }
    for (Map u in dataBaseData["requestsReceived"]) {
      AppUser t = AppUser();
      t.fromJson(u);
      requestsReceived.add(t);
    }
    for (Map u in dataBaseData["requestsRejected"]) {
      AppUser t = AppUser();
      t.fromJson(u);
      requestsRejected.add(t);
    }
    return 1;
  }

  bool findEmailInUserList(String email, List usersList) {
    print("this is the list");
    print(usersList);
    if (usersList.isEmpty) return false;
    for (AppUser user2 in usersList) {
      if (user2.email == email) return true;
    }
    return false;
  }

  Future<int> updateNetworkParametersInDatabase() async {
    Map finalData = {};
    finalData["network"] = [];
    finalData["requestsSent"] = [];
    finalData["requestsRejected"] = [];
    finalData["requestsReceived"] = [];
    for (AppUser t in network) {
      finalData["network"].add(t.toJson());
    }
    for (AppUser t in requestsSent) {
      finalData["requestsSent"].add(t.toJson());
    }
    for (AppUser t in requestsReceived) {
      finalData["requestsReceived"].add(t.toJson());
    }
    for (AppUser t in requestsRejected) {
      finalData["requestsRejected"].add(t.toJson());
    }
    print(finalData);
    await supaBase.from("user_auth_table").update(finalData).eq('email', email);
    return 1;
  }

  double getCorpusRatingFromQueryAndText(String query, String text) {
    double score = 0;
    String currentQuery = "";
    for (String char in query.split('')) {
      currentQuery = currentQuery + char.toLowerCase();
      if (text.toLowerCase().indexOf(currentQuery) != -1 &&
          currentQuery.length > 1) {
        score += (1 / (text.toLowerCase().indexOf(currentQuery) + 1)) *
            currentQuery.length *
            1000;
      }
    }
    return score;
  }

  double getCorpusRatingFromQuery(String query) {
    double score = 0;
    String currentQuery = "";
    gScore = 0;
    if (getCorpusRatingFromQueryAndText(query, firstName) > gScore)
      gScore = getCorpusRatingFromQueryAndText(query, firstName);
    if (getCorpusRatingFromQueryAndText(query, lastName) > gScore)
      gScore = getCorpusRatingFromQueryAndText(query, lastName);
    if (getCorpusRatingFromQueryAndText(query, firstName + lastName) > gScore)
      gScore = getCorpusRatingFromQueryAndText(query, firstName + lastName);
    if (getCorpusRatingFromQueryAndText(query, lastName + firstName) > gScore)
      gScore = getCorpusRatingFromQueryAndText(query, lastName + firstName);
    return score;
  }

  List removeEmailElement(List data, String email) {
    print(data.runtimeType);
    print(data);
    if (data.runtimeType != List<AppUser>) {
      for (Map dataString in data) {
        if (dataString["email"] == email) {
          data.remove(dataString);
          return data;
        }
      }
    } else {
      for (AppUser dataString in data) {
        if (dataString.email == email) {
          data.remove(dataString);
          return data;
        }
      }
    }
    return data;
  }

  Future<int> acceptFriendRequest(String friendEmail) async {
    // other side
    Map dataBaseData = await supaBase
        .from("user_auth_table")
        .select()
        .eq('email', friendEmail)
        .single();
    dataBaseData["network"].add(toJson());
    dataBaseData["requestsSent"] =
        removeEmailElement(dataBaseData["requestsSent"], email);
    await supaBase
        .from("user_auth_table")
        .update(dataBaseData)
        .eq('email', friendEmail);
    // current side
    AppUser tempUser = AppUser();
    tempUser.fromJson(dataBaseData);
    network.add(tempUser);
    requestsReceived =
        removeEmailElement(requestsReceived, friendEmail) as List<AppUser>;
    await updateNetworkParametersInDatabase();
    return -1;
  }

  Future<int> declineFriendRequest(String friendEmail) async {
    // other side
    Map dataBaseData = await supaBase
        .from("user_auth_table")
        .select()
        .eq('email', friendEmail)
        .single();
    dataBaseData["requestsRejected"].add(toJson());
    dataBaseData["requestsSent"] =
        removeEmailElement(dataBaseData["requestsSent"], email);
    await supaBase
        .from("user_auth_table")
        .update(dataBaseData)
        .eq('email', friendEmail);
    // current side
    requestsReceived =
        removeEmailElement(requestsReceived, friendEmail) as List<AppUser>;
    print(requestsReceived);
    await updateNetworkParametersInDatabase();
    return -1;
  }

  Future<int> addFriendRequest(String friendEmail) async {
    Map dataBaseData = await supaBase
        .from("user_auth_table")
        .select()
        .eq('email', friendEmail)
        .single();
    dataBaseData["requestsReceived"].add(toJson());
    await supaBase
        .from("user_auth_table")
        .update(dataBaseData)
        .eq('email', friendEmail);
    // current side
    AppUser tempUser = AppUser();
    tempUser.fromJson(dataBaseData);
    requestsSent.add(tempUser);
    await updateNetworkParametersInDatabase();
    return -1;
  }

  Future<int> removeFriendRequest(String friendEmail) async {
    Map dataBaseData = await supaBase
        .from("user_auth_table")
        .select()
        .eq('email', friendEmail)
        .single();
    dataBaseData["requestsReceived"] =
        removeEmailElement(dataBaseData["requestsReceived"], email);
    await supaBase
        .from("user_auth_table")
        .update(dataBaseData)
        .eq('email', friendEmail);
    // current side
    requestsSent = removeEmailElement(requestsSent, email) as List<AppUser>;
    await updateNetworkParametersInDatabase();
    return -1;
  }

  // Mentorship Functions
  bool mentorContainedinMentorList(Mentor m, List<mentorDatabase> data) {
    for (mentorDatabase mTemp in data) {
      if (mTemp.topic!.description == m.description) return true;
    }
    return false;
  }

  Future<int> updateMentorshipParametersInDatabase() async {
    Map finalData = {};
    finalData["mentors"] = [];
    finalData["mentees"] = [];
    finalData["mentorRequestsRecieved"] = [];
    finalData["mentorRequestsSent"] = [];
    for (mentorDatabase t in mentors) {
      finalData["mentors"].add(t.toJson());
    }
    for (mentorDatabase t in mentees) {
      finalData["mentees"].add(t.toJson());
    }
    for (mentorDatabase t in mentorRequestsRecieved) {
      finalData["mentorRequestsRecieved"].add(t.toJson());
    }
    for (mentorDatabase t in mentorRequestsSent) {
      finalData["mentorRequestsSent"].add(t.toJson());
    }
    print(finalData);
    await supaBase.from("user_auth_table").update(finalData).eq('email', email);
    return 1;
  }

  Future<int> updateMentorshipParameters() async {
    print("Updating");
    Map dataBaseData = await supaBase
        .from("user_auth_table")
        .select()
        .eq('email', email)
        .single();
    mentors = [];
    mentees = [];
    mentorRequestsRecieved = [];
    mentorRequestsSent = [];
    print("updating the data");
    print(dataBaseData["mentees"]);
    for (Map u in dataBaseData["mentors"]) {
      mentorDatabase t = mentorDatabase();
      t.fromJson(u);
      mentors.add(t);
    } //mentorRequestsRecieved
    for (Map u in dataBaseData["mentees"]) {
      print("this is mentee number one");
      mentorDatabase t = mentorDatabase();
      t.fromJson(u);
      mentees.add(t);
    }
    print(mentees);
    for (Map u in dataBaseData["mentorRequestsRecieved"]) {
      mentorDatabase t = mentorDatabase();
      t.fromJson(u);
      mentorRequestsRecieved.add(t);
    }
    for (Map u in dataBaseData["mentorRequestsSent"]) {
      mentorDatabase t = mentorDatabase();
      t.fromJson(u);
      mentorRequestsSent.add(t);
    }
    return 1;
  }

  Future<int> addMentorRequest(Mentor mentorPost) async {
    // add it to my side
    mentorDatabase temp =
        mentorDatabase(email: mentorPost.userEmail, topic: mentorPost);
    mentorRequestsSent.add(temp);
    await updateMentorshipParametersInDatabase();
    // add it ot there side
    temp = mentorDatabase(email: currentUser.email, topic: mentorPost);
    AppUser oppositeUser = AppUser();
    await oppositeUser.getDataFromDatabase(mentorPost.userEmail);
    oppositeUser.mentorRequestsRecieved.add(temp);
    print("these are the mentors2");
    print(oppositeUser.mentees);
    await oppositeUser.updateMentorshipParametersInDatabase();
    return 1;
  }

  Future<int> acceptMenteeRequest(Mentor mentorPost, String emailFrom) async {
    // add it to my side
    mentorDatabase temp =
        mentorDatabase(email: emailFrom, topic: mentorPost);
    for (mentorDatabase m in mentorRequestsRecieved) {
      if (m.email == emailFrom &&
          m.topic!.description == mentorPost.description){
        mentorRequestsRecieved.remove(m);
        break;
      };
    }
    mentees.add(temp);
    await updateMentorshipParametersInDatabase();
    // add it ot there side
    temp = mentorDatabase(email: currentUser.email, topic: mentorPost);
    AppUser oppositeUser = AppUser();
    oppositeUser.getDataFromDatabase(emailFrom);
    for (mentorDatabase m in oppositeUser.mentorRequestsSent) {
      if (m.email == mentorPost.userEmail &&
          m.topic!.description == mentorPost.description)
        oppositeUser.mentorRequestsSent.remove(m);
    }
    oppositeUser.mentors.add(temp);
    await oppositeUser.updateMentorshipParametersInDatabase();
    return 1;
  }

  Future<int> rejectMenteeRequest(Mentor mentorPost, String emailFrom) async {
    // add it to my side
    mentorDatabase temp =
        mentorDatabase(email: emailFrom, topic: mentorPost);
    for (mentorDatabase m in mentorRequestsRecieved) {
      if (m.email == emailFrom &&
          m.topic!.description == mentorPost.description)
        mentorRequestsRecieved.remove(m);
    }
    await updateMentorshipParametersInDatabase();
    // add it ot there side
    temp = mentorDatabase(email: currentUser.email, topic: mentorPost);
    AppUser oppositeUser = AppUser();
    oppositeUser.getDataFromDatabase(mentorPost.userEmail);
    for (mentorDatabase m in oppositeUser.mentorRequestsSent) {
      if (m.email == mentorPost.userEmail &&
          m.topic!.description == mentorPost.description)
        oppositeUser.mentorRequestsSent.remove(m);
    }
    await oppositeUser.updateMentorshipParametersInDatabase();
    return 1;
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
      List<int> gradeList = [];
      List<int> yearList = [];
      for (int grade in school.attendedGrades) {
        gradeList.add(grade);
        yearList.add(currentAcademicYear - (currentGrade - grade));
      }
      Map insertionMap = {
        "Student_Gmail": email,
        "Grade": gradeList,
        "Year": yearList,
      };
      try {
        print("here ");
        print(school.getDatabaseName());

        // Execute the prepared statement with the provided parameters.

        await supaBase.from(school.getDatabaseName()).insert({
          'student_gmail': email,
          'grade': gradeList,
          'year': yearList,
        });
      } on Exception catch (e) {
        print(e);
        await databaseConnection.execute('''      
            CREATE TABLE ${school.getDatabaseName()} (
              Student_Gmail text,  
              Grade int[], 
              Year int[],
              id SERIAL PRIMARY KEY
            )
          ''');
        print("created");

        // Execute the prepared statement with the provided parameters.
        await supaBase.from(school.getDatabaseName()).insert({
          'student_gmail': email,
          'grade': gradeList,
          'year': yearList,
        });
      }
    }
    return 1;
  }

  School getCurrentSchool() {
    setCurrentSchool();
    for (School s in schools) {
      if (s.currentSchool) {
        return s;
      }
    }
    School tempSchool = School();
    return tempSchool;
  }

  void setCurrentSchool() {
    int currentSchoolIndex = -1;
    int highestGrade = 0;
    for (int i = 0; i < schools.length; i++) {
      schools[i].attendedGrades.sort();
      if (schools[i].attendedGrades.length != 0 &&
          schools[i].attendedGrades[schools[i].attendedGrades.length - 1] >
              highestGrade) {
        highestGrade =
            schools[i].attendedGrades[schools[i].attendedGrades.length - 1];
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
          .replaceAll("User-Profile/", "User-Profile/public/");

      print(image);
      print("done uploading");
    }
    int currentSchoolIndex = -1;
    int highestGrade = 0;
    for (int i = 0; i < schools.length; i++) {
      schools[i].attendedGrades.sort();
      print(schools[i].attendedGrades);
      if (schools[i].attendedGrades[schools[i].attendedGrades.length - 1] >
          highestGrade) {
        highestGrade =
            schools[i].attendedGrades[schools[i].attendedGrades.length - 1];
        currentSchoolIndex = i;
      }
    }
    if (currentSchoolIndex != -1)
      schools[currentSchoolIndex].currentSchool = true;
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
    await updateNetworkParametersInDatabase();
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
    for (School s in schools) {
      try {
        await supaBase
            .from(s.name.replaceAll(" ", ""))
            .delete()
            .eq("student_gmail", email);
      } on Exception catch (e) {}
    }
    await supaBase.from("user_auth_table").delete().eq("email", email);
    print("deleting");
    print("public/$email.png");
    final response = await supaBase.storage
        .from('User-Profile')
        .remove(["public/$email.png"]);
    await setGeneralData(imageAlso: imageAlso);

    return 1;
  }

  Future<bool> getDataFromDatabase(String gmail) async {
    email = gmail;
    bool userFound = await findUserInDatabase();

    if (userFound) {
      imageAlreadyThere = true;
      Map dataBaseData = await supaBase
          .from("user_auth_table")
          .select()
          .eq('email', gmail)
          .single();
      await updateNetworkParameters();
      print("hello there mother");
      print(dataBaseData);
      email = dataBaseData["email"];
      mentors = [];
      mentorRequestsRecieved = [];
      mentorRequestsSent = [];
      mentees = [];
      print(dataBaseData["mentors"]);
      print(dataBaseData["mentees"]);
      print(dataBaseData["mentorRequestsSent"]);
      print(dataBaseData["mentorRequestsRecieved"]);
      if (dataBaseData["mentors"] != null)
        for (Map data in dataBaseData["mentors"]) {
          mentorDatabase tempmentor = mentorDatabase();
          tempmentor.fromJson(data);
          mentors.add(tempmentor);
        }
      if (dataBaseData["mentees"] != null)
        for (Map data in dataBaseData["mentees"]) {
          mentorDatabase tempmentor = mentorDatabase();
          tempmentor.fromJson(data);
          mentees.add(tempmentor);
        }
      if (dataBaseData["mentorRequestsSent"] != null)
        for (Map data in dataBaseData["mentorRequestsSent"]) {
          mentorDatabase tempmentor = mentorDatabase();
          tempmentor.fromJson(data);
          mentorRequestsSent.add(tempmentor);
        }
      if (dataBaseData["mentorRequestsRecieved"] != null)
        for (Map data in dataBaseData["mentorRequestsRecieved"]) {
          mentorDatabase tempmentor = mentorDatabase();
          tempmentor.fromJson(data);
          mentorRequestsRecieved.add(tempmentor);
        }
      if (dataBaseData["MentorPosts"] != null)
        for (Map data in dataBaseData["MentorPosts"]) {
          Mentor tempmentor = Mentor();
          print(data);
          tempmentor.parseJson(data);
          mentorposts.add(tempmentor);
        }
      schools = [];
      for (Map data in dataBaseData["schools"]) {
        School tempSchool = School();
        tempSchool.fromJson(data);
        schools.add(tempSchool);
      }
      classes = [];
      for (Map data in dataBaseData["classes"]) {
        schoolClassStudent tempClass = schoolClassStudent();
        tempClass.fromJson(data);
        classes.add(tempClass);
      }
      clubs = [];
      for (Map data in dataBaseData["clubs"]) {
        clubAppData tempClub = clubAppData();
        tempClub.fromJson(data);
        clubs.add(tempClub);
      }
      skills = [];
      for (Map data in dataBaseData["skills"]) {
        Skill tempSkill = Skill();
        tempSkill.fromJSON(data);
        skills.add(tempSkill);
      }
      firstName = dataBaseData["first_name"];
      lastName = dataBaseData["last_name"];
      image = dataBaseData["image"];
      dateOfBirth = DateOfBirth(
          dataBaseData["dateOfBirth"]["Day"],
          dataBaseData["dateOfBirth"]["Year"],
          stringToMonth(dataBaseData["dateOfBirth"]["Month"][0]));
      userState = stringToState(dataBaseData["state"]);
      currentGrade = currentGradeFromString(dataBaseData["grade"]);
      return true;
    } else {
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
