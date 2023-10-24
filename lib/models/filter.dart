import 'package:highschoolhub/main.dart';
import 'package:highschoolhub/models/class.dart';
import 'package:highschoolhub/models/club.dart';
import 'package:highschoolhub/models/mentor.dart';
import 'package:highschoolhub/models/school.dart';
import 'package:highschoolhub/models/skills.dart';
import 'package:highschoolhub/models/user.dart';
import 'package:highschoolhub/pages/AuthenticationPage.dart';
import 'package:highschoolhub/pages/SignUpScreen/AccountInfo.dart';
import 'dart:math' show asin, cos, pow, sin, sqrt;

double getDistance(double lat1, double lon1, double lat2, double lon2) {
  const r = 3958.8; // Earth radius in kilometers

  final dLat = _toRadians(lat2 - lat1);
  final dLon = _toRadians(lon2 - lon1);
  final lat1Radians = _toRadians(lat1);
  final lat2Radians = _toRadians(lat2);

  final a = _haversin(dLat) + cos(lat1Radians) * cos(lat2Radians) * _haversin(dLon);
  final c = 2 * asin(sqrt(a));

  return r * c;
}

double _toRadians(double degrees) => degrees * (3.14159268) / 180;

double _haversin(double radians) => pow(sin(radians / 2), 2).toDouble();

enum filterTypeSchool { certainSchool, State, ZipCode, Distance, None }
class topicSubjects {
  ClubType clubType;
  String clubTypeString;
  String image;
  Map toJson(){
    return {
      "clubType" : clubType.name, 
      "clubTypeString" : clubTypeString, 
      "image" : image
    };
  }
  void formJson(Map data){
    print(data["clubType"]);
    for(ClubType c in ClubType.values){
      if(c.name == data["clubType"]){
        clubType = c;
        break;
      }
    }
    clubTypeString = data["clubTypeString"];
    image = data["image"];
  }
  topicSubjects({this.clubType  = ClubType.None, this.clubTypeString = "", this.image= ""});
}
class MentorFilter {
  int experience = 0;
  List<topicSubjects> topicSubjectsList = [
    topicSubjects(
        clubType : ClubType.Academics, clubTypeString : "none", image: "assets/images/clubIcons/Academics.png"),
    topicSubjects(
        clubType: ClubType.Art, clubTypeString: "Art", image: "assets/images/clubIcons/Art.png"),
    topicSubjects(
        clubType: ClubType.Buisness, clubTypeString: "Buisness", image: "assets/images/clubIcons/Buisness.png"),
    topicSubjects(
        clubType: ClubType.Culture, clubTypeString: "none", image: "assets/images/clubIcons/Culture.png"),
    topicSubjects(
        clubType: ClubType.Engineering, clubTypeString: "none", image: "assets/images/clubIcons/Engineering.png"),
    topicSubjects(
        clubType: ClubType.Math, clubTypeString: "Math", image: "assets/images/clubIcons/Math.png"),
    topicSubjects(
        clubType: ClubType.Media, clubTypeString: "none", image: "assets/images/clubIcons/Media.png"),
    topicSubjects(
        clubType: ClubType.Music, clubTypeString: "Music", image: "assets/images/clubIcons/Music.png"),
    topicSubjects(
        clubType: ClubType.Science, clubTypeString: "Science", image: "assets/images/clubIcons/Science.png"),
    topicSubjects(
        clubType: ClubType.Service, clubTypeString: "none", image: "assets/images/clubIcons/Service.png"),
    topicSubjects(
        clubType: ClubType.Speech, clubTypeString: "none", image: "assets/images/clubIcons/Speech.png"),
    topicSubjects(
        clubType: ClubType.Sports,
        clubTypeString:  "Sports", image: "assets/images/clubIcons/Sports.png"),
    topicSubjects(
        clubType: ClubType.Technology, clubTypeString: "Computers", image: "assets/images/clubIcons/Technology.png"),
    topicSubjects(
        clubType: ClubType.None, clubTypeString: "Electives", image: "assets/images/classImage/Electives.png"),
    topicSubjects(
       clubType:  ClubType.None, clubTypeString: "English", image: "assets/images/classImage/English.png"),
    topicSubjects(
        clubType: ClubType.None, clubTypeString: "Language", image: "assets/images/classImage/Language.png"),
    topicSubjects(
        clubType: ClubType.None, clubTypeString: "Social_Studies", image: "assets/images/classImage/Social_Studies.png"),
  ];
  List<MentorShipType> mentorShipType = MentorShipType.values;
  List<MentorShipMeetLocation> meetingTypes = MentorShipMeetLocation.values;
  List<Grade> grades = Grade.values;
  List<USStates> stateList = USStates.values;
  List<School> filterSchools = [];
  int stars = 0;
  bool fitsFilter(Mentor mentor){
    if(mentorShipType.contains(mentor.type) == false){
      return false;
    }
    bool flag = false;
    for(topicSubjects ts in topicSubjectsList){
      if(ts.clubType == mentor.mentorSubject || ts.clubTypeString == mentor.mentorSubjectClass){
        flag = true;
      }
    }
    if(flag == false) return false;
    if(meetingTypes.contains(mentor.location) == false) return false;
    if(grades.contains(allUsers[mentor.userEmail]!.currentGrade) == false) return false;
    if(stateList.contains(allUsers[mentor.userEmail]!.userState) == false) return false;
    if(mentor.rating < stars) return false;
    flag = false;
    for(School s in filterSchools){
      if(s.name == allUsers[mentor.userEmail]!.getCurrentSchool().name){
        flag = true;
        break;
      }
    }
    if(flag == false && filterSchools.isNotEmpty) return false;
    return true;
  }
  int addSchool(School tempSchool){
    
    for(School temp in filterSchools){
      if(temp.name == tempSchool.name){
        filterSchools.remove(temp);
        return 1;
      }
    }
    filterSchools.add(tempSchool);
    return 1;
  }
  void addStateList(USStates usState){
    bool flag = stateList.remove(usState);
    if(!flag) stateList.add(usState);
  }
  String experienceToYears(){
    if(experience == 0){
      return "<1";
    }
    return experience.toString() + "+";
  }
  void addGrades(Grade g){
    bool flag = grades.remove(g);
    if(flag == false) grades.add(g);
  }
  int addTopicSubjectsList(topicSubjects t){
    for(topicSubjects ts in topicSubjectsList){
      if(ts.image == t.image){
        topicSubjectsList.remove(ts);
        return 1;
      }
    }
    topicSubjectsList.add(t);
    return 1;
  }
  bool containsTopic(topicSubjects t){
    for(topicSubjects temp in topicSubjectsList){
      if(temp.image == t.image) return true;
    }
    return false;
  }
  int addMentorShipType(MentorShipType mst){
    bool flag = mentorShipType.remove(mst);
    if(flag == false ) mentorShipType.add(mst);
    return 1;
  }
  int addMeetingTypes(MentorShipMeetLocation msml){
    bool flag = meetingTypes.remove(msml);
    if(flag == false ) meetingTypes.add(msml);
    return 1;
  }


}
class SchoolFilter {
  List<School> schools = [];
  List<USStates> currentState = [];
  int distance = 0;
  List<String> zipcode = [];
  filterTypeSchool type = filterTypeSchool.None;
  bool doesSchoolFitFilter(School school) {
    print(type);
    if(type == filterTypeSchool.certainSchool){
      if(schools.length == 0 ) return true;
      for(School s1 in schools){
        if(school.name == s1.name){
          return true;
        }
      }
      return false;
    }else if(type == filterTypeSchool.State){
      if(currentState.length == 0 ) return true;
      for(USStates usState in currentState){
        if(stringToState(school.address.stateLongName) == usState){
          print("state was true son");
          return true;
        }
      }
      return false;
    }else if(type == filterTypeSchool.ZipCode){
      if(zipcode.length == 0 ) return true;
      for(String code in zipcode){
        if(school.address.zipCode == code){
          return true;
        }
      }
      return false;
    }else if(type == filterTypeSchool.Distance){
      if(getDistance(school.address.lat, school.address.lon, currentUser.getCurrentSchool().address.lat, currentUser.getCurrentSchool().address.lon) <= distance ){
        return true;
      }
      return false;
    }
    return true;
  }
  bool stateAdded(USStates s){
    for(USStates s2 in currentState){
      if(s2.name == s.name){
        return true;
      }
    }
    return false;
  }
  void addSchool(School s){
    bool flag = true;
    for(School s1 in schools){
      if(s1.name == s.name){
        flag = false;
        schools.remove(s1);
        break;
      }
    }
    if(flag) schools.add(s);
  }
  void addZipCode(String zc){
    if(zipcode.contains(zc)){
      zipcode.remove(zc);
    }else{
      zipcode.add(zc);
    }
  }
  void addState(USStates s){
    if(currentState.contains(s)){
      currentState.remove(s);
    }else{
      currentState.add(s);
    }
  }
}

class Filter {
  SchoolFilter filter = SchoolFilter();
  List<club> clubs = [];
  List<Skill> skills = [];
  List<Grade> grades = [];
  List<schoolClassDatabase> classes = [];
  SchoolFilter schools = SchoolFilter();
  void addGrade(Grade g) {
    if (grades.contains(g)) {
      grades.remove(g);
    } else {
      grades.add(g);
    }
  }

  void addClass(schoolClassDatabase classDatabase) {
    bool flag = true;
    for (schoolClassDatabase c in classes) {
      if (c.className == classDatabase.className) {
        classes.remove(c);
        flag = false;
        break;
      }
    }
    if (flag) {
      classes.add(classDatabase);
    }
  }

  void addClub(club c1) {
    bool flag = true;
    for (club c in clubs) {
      if (c1.className == c.className) {
        clubs.remove(c);
        flag = false;
        break;
      }
    }
    if (flag) {
      clubs.add(c1);
    }
  }

  void addSkill(Skill s) {
    bool flag = true;
    for (Skill skill in skills) {
      if (skill.className == s.className) {
        skills.remove(skill);
        flag = false;
        break;
      }
    }
    if (flag) skills.add(s);
  }

  void addSchool() {}

  bool userPassesFilter(AppUser user) {
    //check clubs
    bool flag = false;
    for(club filterClub in clubs){
      
      flag = true;
      for(clubAppData c in user.clubs){
        if(c.clubData.className == filterClub.className){
          flag = false;
        }
      }
      if(flag) return false;
    }
    print("passed clubs check");
    //check skills
    flag = false;
    for(Skill filterSkill in skills){
      flag = true;
      for(Skill s in user.skills){
        if(s.className == filterSkill.className){
          flag = false;
        }
      }
      if(flag) return false;
    }
    print("passed skill check");
    //check grades
    print(user.currentGrade);
    if(grades.contains(user.currentGrade) == false) {
      return false;
    }
    print("passed grades check");
    //check school
    flag = true;
    for(School s in user.schools){
      print(schools.doesSchoolFitFilter(s));
      if(schools.doesSchoolFitFilter(s)){
        flag = false;
        break;
      }
    }
    if(flag){
      print("failed school check");
      return false;
    }
    print("passed school check");
    //check classes
    flag = false;
    for(schoolClassDatabase schoolClass in classes){
      flag = true;
      for(schoolClassStudent c in user.classes){
        if(c.classInfo!.className == schoolClass.className){
          flag = false;
        }
      }

      if(flag) return false;
    }
    print("passed classes check");
    return true;
  }
}
class postFilter{
  postFilter();
  Map toJson(){
    return {

    };
  }
  void fromJson(Map data){
  }
}