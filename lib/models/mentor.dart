
import 'package:highschoolhub/models/class.dart';
import 'package:highschoolhub/models/club.dart';
import 'package:highschoolhub/models/school.dart';
import 'package:highschoolhub/models/skills.dart';
import 'package:highschoolhub/pages/mentor/createMentorPostScreen.dart';

enum MentorShipType { Classes, Skills, Other, none }

MentorShipType stringToMentor(String mentorShipTypeString){
  if("MentorShipType.Classes" == mentorShipTypeString) return MentorShipType.Classes;
  if("MentorShipType.Skills" == mentorShipTypeString) return MentorShipType.Skills;
  if("MentorShipType.Other" == mentorShipTypeString) return MentorShipType.Other;
  return MentorShipType.none;
}


enum MentorShipMeetLocation { Virtual, Both, Live, none }
MentorShipMeetLocation stringToMentorShipMeetLocation(String mentorShipLocationString){
  if("MentorShipMeetLocation.Virtual" == mentorShipLocationString) return MentorShipMeetLocation.Virtual;
  if("MentorShipMeetLocation.Live" == mentorShipLocationString) return MentorShipMeetLocation.Live;
  if("MentorShipMeetLocation.Both" == mentorShipLocationString) return MentorShipMeetLocation.Both;
  return MentorShipMeetLocation.none;
}

class Mentor{
  String userEmail;
  MentorShipType type;
  MentorShipMeetLocation location;
  ClubType mentorSubject;
  int rating = 0;
  int numberOfRating = 0;
  String mentorSubjectClass;
  int id = 0;
  int experience = 1;
  List<School> courseTakenAt = [];
  List<schoolClassDatabase> mentoringClass = [];
  List<Skill> mentoringSkill = [];
  String other = "";
  String description = "";
  double gScore = 0;
  Mentor({this.userEmail = "", this.type = MentorShipType.none, this.experience = 1, this.location = MentorShipMeetLocation.none, this.mentorSubject = ClubType.None, this.mentorSubjectClass = "", this.description = ""});
  bool allFieldFilledOut(){
    if(location == MentorShipMeetLocation.none) return false;
    if(type == MentorShipType.Classes){
      if(mentoringClass.isEmpty) return false;
      if(courseTakenAt.isEmpty) return false;

    }
    if(type == MentorShipType.Skills){
      if(mentoringSkill.isEmpty) return false;

    }
    if(type == MentorShipType.Other){
      if(other == "") return false;
    }
    return true;
  }
  void addSchool(School s){
    courseTakenAt = [s];
  }
  void addClass(schoolClassDatabase c){
    mentoringClass = [c];
  }
  void addSkill(Skill s){
    mentoringSkill = [s];
  }
  int countOcurunce(String wholeString, String subString){
    int occurrences = 0;
    for(int i = 0; i < wholeString.length - subString.length; i++){
      if(wholeString.substring(i, i + subString.length) == subString) occurrences ++;
    }
    return occurrences;
  }
  double getSRating(String query){
    /*
      To Get GSCORE : 
        - Look at the title - DONE
        - Look at the description - DONE
        - Search for word in the subjects - DONE
    */
    double tempGScore = 0;
    tempGScore += countOcurunce(description, query);
    if(type == MentorShipType.Classes){
      if(mentoringClass[0].className.toLowerCase().contains(query)) tempGScore += 3;
      if(mentorSubjectClass.toLowerCase().contains(query)) tempGScore += 2;
    }else if(type == MentorShipType.Skills){
      if(mentoringSkill[0].className.toLowerCase().contains(query)) tempGScore += 3;
      if(mentorSubject.toString().toLowerCase().contains(query)) tempGScore += 2;
    }else{
      if(other.toLowerCase().contains(query)) tempGScore += 3;
      if(mentorSubject.toString().toLowerCase().contains(query)) tempGScore += 2;
    }
    return tempGScore; 
  }
  double getGScore(String query){
    List<String> subPrompts = [];
    for(int i = 0; i < query.length; i++){
      subPrompts.add(query.substring(0, i) + query.substring(i + 1));
    }
    gScore = 0;
    for(String tempPrompt in subPrompts){
      gScore += getSRating(tempPrompt) * 0.8;
    }
    return gScore;
  }
  String getMentorTopicName(){
    if(type == MentorShipType.Classes) return mentoringClass[0].className;
    if(type == MentorShipType.Skills) return mentoringSkill[0].className;
    if(type == MentorShipType.Other) return other;
    return "";
  }
  String getExperienceToString(){
    String prefix = "Years";
    if(experience == 0){
      return "<1 Year";
    }
    if(experience == 6){
      return "5+ Years";
    }
    return experience.toString() + " " + prefix;
  }
  Map toJson(){
    if(type == MentorShipType.Skills){
      mentorSubject = stringToEnum(mentoringSkill[0].types![0].toReadableString());
      print("convert");
      print(mentorSubject);
    }
    if(type == MentorShipType.Classes){
      mentorSubjectClass = mentoringClass[0].fieldOfStudy;
      
    }
    if(type == MentorShipType.Skills){
      mentorSubject = mentoringSkill[0].types![0];
    }
    Map? courseTakenAtJsonData;
    Map? mentoringClassJson;
    Map? mentoringSkillJson;
    if(courseTakenAt.isNotEmpty) courseTakenAtJsonData = courseTakenAt[0].getJson();
    if(mentoringClass.isNotEmpty) mentoringClassJson = mentoringClass[0].toJson();
    if(mentoringSkill.isNotEmpty) mentoringSkillJson = mentoringSkill[0].toJSON();
    return {
      "UserEmail": userEmail, 
      "Type": type.toString(), 
      "Location": location.toString(), 
      "MentorSubject": mentorSubject.toReadableString(), 
      "Experience" : experience, 
      "CourseTakingAt" : courseTakenAtJsonData, 
      "MentoringClass" : mentoringClassJson, 
      "MentoringSkill" : mentoringSkillJson, 
      "mentorSubjectClass" : mentorSubjectClass,
      "other" : other, 
      "Description" : description,
      "Rating" : rating, 
      "NumberOfRating" : numberOfRating
    };
  }
  String getIconImageAddress(){
    if(type == MentorShipType.Skills || type == MentorShipType.Other) return "assets/images/clubIcons/" + mentorSubject.toString().substring(9) + ".png";
    return "assets/images/classImage/" + mentorSubjectClass + ".png";
  }
  void parseJson(Map data){
    userEmail = data["UserEmail"];
    experience = data["Experience"];
    mentorSubjectClass = data["mentorSubjectClass"];
    other = data["other"];
    description = data["Description"];
    type = stringToMentor(data["Type"]);
    location = stringToMentorShipMeetLocation(data["Location"]);
    mentorSubject = stringToEnum(data["MentorSubject"]);
    rating = data["Rating"];
    numberOfRating = data["NumberOfRating"];
    if(data["CourseTakingAt"] != null){
      School tempSchool = School();
      tempSchool.fromJson(data["CourseTakingAt"]);
      courseTakenAt = [tempSchool];
    }
    if(data["MentoringClass"] != null){
      schoolClassDatabase tempClass = schoolClassDatabase();
      tempClass.fromJson(data["MentoringClass"]);
      mentoringClass = [tempClass];
    }
    if(data["MentoringSkill"] != null){
      Skill tempSkill = Skill();
      tempSkill.fromJSON(data["MentoringSkill"]);
      mentoringSkill = [tempSkill];
    }
  }
}
/*
 currentMentor.id = data["id"];
                                          currentUser.mentorposts.add(currentMentor);
                                          List<Map> mentorJsonList = [];
                                          for(Mentor m in currentUser.mentorposts){
                                            mentorJsonList.add(m.toJson());
                                          }
                                          await supaBase.from("user_auth_table").update({
                                            "MentorPosts" : currentUser.mentorposts.map((e) => e.toJson()).toList()
                                          }).eq("email", currentUser.email);
                                          print("done");
*/
class mentorDatabase{
  String email;
  Mentor? topic;
  int myRating = 0;
  mentorDatabase({this.email = "", this.topic}){
    topic ??= Mentor();
  }
  void fromJson(Map data){
    email = data["email"];
    topic = Mentor();
    topic!.parseJson(data["topic"]);
    if(data.keys.contains("myRating") == false){
      myRating = -1;
    }else{
      myRating = data["myRating"];
    }
    
  }
  Map toJson(){
    return {
      "email" : email, 
      "topic" : topic!.toJson(), 
      "myRating" : myRating
    };
  }
}