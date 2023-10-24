// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:highschoolhub/home/createPostScreen.dart';
import 'package:highschoolhub/models/class.dart';
import 'package:highschoolhub/models/club.dart';
import 'package:highschoolhub/models/filter.dart';
import 'package:highschoolhub/models/school.dart';
import 'package:highschoolhub/models/user.dart';
import 'package:highschoolhub/models/reply.dart';

class Location {
  bool isVirtual = false;
  String address;
  String state;
  double lat;
  double lon;
  Location({this.isVirtual = true, this.address = "", this.state = "", this.lat = 0, this.lon = 0});
  void locationFromJson(Map data) {
    print(data);
    address = data["description"];

    state = data["terms"][data["terms"].length - 2]["value"];
  }

  Map toJson() {
    return {"isVirtual": isVirtual, "address": address, "state": state, "lat" : lat, "lon" : lon, };
  }

  void fromJson(Map data) {
    isVirtual = data["isVirtual"];
    address = data["address"];
    state = data["state"];
    lat = data["lat"];
    lon = data["lon"];
  }
}

class PublicPost {
  int id = 0;
  String postTitle;
  String postDescription;
  AppUser? author = AppUser();
  List likes = [];
  List celebrate = [];
  List<commentThread> comments = [];
  PostType type;
  String imageAddress;
  List<School> taggedSchools = [];
  List<AppUser> taggedPeople = [];
  List<schoolClassDatabase> taggedClasses = [];
  List<topicSubjects> volunteerTopics = [];
  List<topicSubjects> tournamentTopics = [];
  List<topicSubjects> collaborationTopic = [];
  List<topicSubjects> otherTopic = [];
  Location volunteerLocation = Location();
  Location tournamentLocation = Location();
  String volunteerWebsite = "";
  String tournamentWebsite = "";
  Range? grades = Range(1, 12);
  DateTime DatePosted = DateTime.now();
  Range tournamentGradeLimit = Range(1, 12);
  // volunteer variables
  TimeOfDay volunteerFromTime = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay volunteerToTime = TimeOfDay(hour: 0, minute: 0);
  DateTime? volunteerDate;
  DateTime? tournamentDate;
  double gScore = 0;
  double getGScore(String query) {
    gScore = 0;
    // compare author
    gScore += author!.getCorpusRatingFromQuery(query) * 0.5;
    // compare title,
    if (postTitle.toLowerCase().contains(query.toLowerCase())) {
      gScore += query.length * 2;
    }
    // compare description,
    if (postDescription.toLowerCase().contains(query.toLowerCase())) {
      gScore += query.length * 2;
    }
    // compare post type
    if(type.toString().toLowerCase().contains(query.toLowerCase())){
      gScore += query.length;
    }
    // compare topic
    if(type == PostType.Tournament){
      for(topicSubjects t in tournamentTopics){
        if(t.clubTypeString.toLowerCase().contains(query.toLowerCase())){
          gScore += t.clubTypeString.length;
        }else if(t.clubType.toString().toLowerCase().contains(query.toLowerCase())){
          gScore += query.length;
        }
      }
    }else if(type == PostType.Collaborate){
      for (topicSubjects t in collaborationTopic) {
        if (t.clubTypeString.toLowerCase().contains(query.toLowerCase())) {
          gScore += t.clubTypeString.length;
        } else if (t.clubType
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase())) {
          gScore += query.length;
        }
      }
    }else if (type == PostType.Volounteer) {
      for (topicSubjects t in volunteerTopics) {
        if (t.clubTypeString.toLowerCase().contains(query.toLowerCase())) {
          gScore += t.clubTypeString.length;
        } else if (t.clubType
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase())) {
          gScore += query.length;
        }
      }
    }else{
      for (topicSubjects t in otherTopic) {
        if (t.clubTypeString.toLowerCase().contains(query.toLowerCase())) {
          gScore += t.clubTypeString.length;
        } else if (t.clubType
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase())) {
          gScore += query.length;
        }
      }
    }
    // compare location
    if(type == PostType.Volounteer){
      
    }
    // compare tagged schools
    // compare tagged classes
    return gScore;
  }

  List<topicSubjects> getTypeList() {
    if (type == PostType.Tournament)
      return tournamentTopics;
    else if (type == PostType.Volounteer)
      return volunteerTopics;
    else if (type == PostType.Collaborate) return collaborationTopic;
    return otherTopic;
  }

  bool volunteerTopicsContains(topicSubjects data) {
    for (topicSubjects databaseValues in volunteerTopics) {
      if ((databaseValues.clubType == data.clubType &&
              databaseValues.clubType != ClubType.None) ||
          (databaseValues.clubTypeString == data.clubTypeString &&
              databaseValues.clubTypeString != "none")) return true;
    }
    return false;
  }

  bool removeVolunteerTopics(topicSubjects data) {
    for (topicSubjects databaseValues in volunteerTopics) {
      if ((databaseValues.clubType == data.clubType &&
              databaseValues.clubType != ClubType.None) ||
          (databaseValues.clubTypeString == data.clubTypeString &&
              databaseValues.clubTypeString != "none")) {
        volunteerTopics.remove(databaseValues);
        break;
      }
    }
    return false;
  }

  bool collaborationTopicsContains(topicSubjects data) {
    for (topicSubjects databaseValues in collaborationTopic) {
      if ((databaseValues.clubType == data.clubType &&
              databaseValues.clubType != ClubType.None) ||
          (databaseValues.clubTypeString == data.clubTypeString &&
              databaseValues.clubTypeString != "none")) return true;
    }
    return false;
  }

  bool removeVolunteerTopicsCollaboration(topicSubjects data) {
    for (topicSubjects databaseValues in collaborationTopic) {
      if ((databaseValues.clubType == data.clubType &&
              databaseValues.clubType != ClubType.None) ||
          (databaseValues.clubTypeString == data.clubTypeString &&
              databaseValues.clubTypeString != "none")) {
        tournamentTopics.remove(databaseValues);
        break;
      }
    }
    return false;
  }

  bool volunteerTopicsContainsTournament(topicSubjects data) {
    for (topicSubjects databaseValues in tournamentTopics) {
      if ((databaseValues.clubType == data.clubType &&
              databaseValues.clubType != ClubType.None) ||
          (databaseValues.clubTypeString == data.clubTypeString &&
              databaseValues.clubTypeString != "none")) return true;
    }
    return false;
  }

  bool removeVolunteerTopicsTournament(topicSubjects data) {
    for (topicSubjects databaseValues in tournamentTopics) {
      if ((databaseValues.clubType == data.clubType &&
              databaseValues.clubType != ClubType.None) ||
          (databaseValues.clubTypeString == data.clubTypeString &&
              databaseValues.clubTypeString != "none")) {
        tournamentTopics.remove(databaseValues);
        break;
      }
    }
    return false;
  }

  bool generalTopicContains(topicSubjects data) {
    for (topicSubjects databaseValues in otherTopic) {
      if ((databaseValues.clubType == data.clubType &&
              databaseValues.clubType != ClubType.None) ||
          (databaseValues.clubTypeString == data.clubTypeString &&
              databaseValues.clubTypeString != "none")) return true;
    }
    return false;
  }

  bool removeotherTopic(topicSubjects data) {
    for (topicSubjects databaseValues in otherTopic) {
      if ((databaseValues.clubType == data.clubType &&
              databaseValues.clubType != ClubType.None) ||
          (databaseValues.clubTypeString == data.clubTypeString &&
              databaseValues.clubTypeString != "none")) {
        otherTopic.remove(databaseValues);
        break;
      }
    }
    return false;
  }

  PublicPost(
      {this.postTitle = "",
      this.postDescription = "",
      this.type = PostType.Other,
      this.imageAddress = "",
      this.author});
  Map toJson() {
    List<Map> taggedSchoolsTemp = [];
    for (School tempSchool in taggedSchools)
      taggedSchoolsTemp.add(tempSchool.getJson());

    List<Map> taggedPeopleTemp = [];
    for (AppUser tempPeople in taggedPeople)
      taggedPeopleTemp.add(tempPeople.toJson());

    List<Map> taggedClassesTemp = [];
    for (schoolClassDatabase tempClasses in taggedClasses)
      taggedClassesTemp.add(tempClasses.toJson());

    List<Map> volunteerTopicsTemp = [];
    for (topicSubjects tempVolunteerTopics in volunteerTopics)
      volunteerTopicsTemp.add(tempVolunteerTopics.toJson());

    List<Map> tournamentTopicsTemp = [];
    for (topicSubjects tempTournamentTopics in tournamentTopics)
      tournamentTopicsTemp.add(tempTournamentTopics.toJson());

    List<Map> collaborationTopicsTemp = [];
    for (topicSubjects tempTournamentTopics in collaborationTopic)
      collaborationTopicsTemp.add(tempTournamentTopics.toJson());

    List<Map> otherTopicsTemp = [];
    for (topicSubjects tempTournamentTopics in otherTopic)
      collaborationTopicsTemp.add(tempTournamentTopics.toJson());
    List<Map> tempCommentsList = [];
    for (commentThread ct in comments) tempCommentsList.add(ct.toJson());
    return {
      "Likes": likes,
      "Celebrate": celebrate,
      "Comments": tempCommentsList,
      "postTitle": this.postTitle,
      "postDescription": this.postDescription,
      "DatePosted": DatePosted.toString(),
      "type": this.type.toString(),
      "imageAddress": this.imageAddress,
      "volunteerLocation": this.volunteerLocation.toJson(),
      "tournamentLocation": this.tournamentLocation.toJson(),
      "grades": {"low": grades!.lowerBound, "upper": grades!.upperBound},
      "tournamentGradeLimit": {
        "low": tournamentGradeLimit!.lowerBound,
        "upper": tournamentGradeLimit!.upperBound
      },
      "volunteerFromTime": volunteerFromTime.toString(),
      "volunteerToTime": volunteerToTime.toString(),
      "volunteerDate": volunteerDate.toString(),
      "tournamentDate": tournamentDate.toString(),
      "taggedSchools": taggedSchoolsTemp,
      "taggedPeople": taggedPeopleTemp,
      "taggedClasses": taggedClassesTemp,
      "volunteerTopics": volunteerTopicsTemp,
      "tournamentTopics": tournamentTopicsTemp,
      "collaborationTopics": collaborationTopicsTemp,
      "author": author!.toJson(),
      "volunteerWebsite": volunteerWebsite,
      "tournamentWebsite": tournamentWebsite,
      "otherTopics": otherTopicsTemp
    };
  }

  TimeOfDay stringToTimeOfDay(String data) {
    TimeOfDay answer = TimeOfDay(
        hour:
            int.parse(data.substring(data.indexOf("(") + 1, data.indexOf(":"))),
        minute: int.parse(
            data.substring(data.indexOf(":") + 1, data.indexOf(")"))));
    return answer;
  }

  void fromJson(Map data) {
    likes = data["Likes"];
    tournamentWebsite = data["tournamentWebsite"];
    volunteerWebsite = data["volunteerWebsite"];
    print("this is it");
    print(data["tournnamentDate"]);
    print(data["tournamentDate"] != null);
    type = PostTypeFromJson(data["type"]);
    if (type == PostType.Tournament)
      tournamentDate = DateTime.parse(data["tournamentDate"]);
    id = data["id"];
    celebrate = data["Celebrate"];
    List tempComments = data["Comments"]; //fix thids
    for (Map tempData in tempComments) {
      commentThread tempComment = commentThread();
      tempComment.fromJson(tempData);
      comments.add(tempComment);
    }
    postTitle = data["postTitle"];
    postDescription = data["postDescription"];

    author = AppUser();
    author!.fromJson(data["author"]);
    if (type == PostType.Volounteer) {
      volunteerFromTime = stringToTimeOfDay(data["volunteerFromTime"]);
      volunteerToTime = stringToTimeOfDay(data["volunteerToTime"]);
      volunteerDate = DateTime.parse(data["volunteerDate"]);
      volunteerLocation = Location();
      volunteerLocation.fromJson(data["volunteerLocation"]);
    } else if (type == PostType.Tournament) {
      tournamentLocation = Location();
      tournamentLocation.fromJson(data["tournamentLocation"]);
      tournamentGradeLimit = Range(data["tournamentGradeLimit"]["low"],
          data["tournamentGradeLimit"]["upper"]);
    }
    imageAddress = data["imageAddress"];
    DatePosted = DateTime.parse(data["DatePosted"]);
    grades = Range(data["grades"]["low"], data["grades"]["upper"]);
    taggedSchools = [];
    for (Map indData in data["taggedSchools"]) {
      School temp = School();
      temp.fromJson(indData);
      taggedSchools.add(temp);
    }
    comments = [];
    for (Map indData in data["Comments"]) {
      commentThread temp = commentThread();
      temp.fromJson(indData);
      comments.add(temp);
    }
    taggedPeople = [];
    for (Map indData in data["taggedPeople"]) {
      AppUser temp = AppUser();
      temp.fromJson(indData);
      taggedPeople.add(temp);
    }
    taggedClasses = [];
    for (Map indData in data["taggedClasses"]) {
      schoolClassDatabase temp = schoolClassDatabase();
      temp.fromJson(indData);
      taggedClasses.add(temp);
    }
    otherTopic = [];
    for (Map indData in data["otherTopics"]) {
      topicSubjects temp = topicSubjects();
      temp.formJson(indData);
      otherTopic.add(temp);
    }
    volunteerTopics = [];
    for (Map indData in data["volunteerTopics"]) {
      topicSubjects temp = topicSubjects();
      temp.formJson(indData);
      volunteerTopics.add(temp);
    }
    tournamentTopics = [];
    for (Map indData in data["tournamentTopics"]) {
      topicSubjects temp = topicSubjects();
      temp.formJson(indData);
      tournamentTopics.add(temp);
    }
    collaborationTopic = [];
    for (Map indData in data["collaborationTopics"]) {
      topicSubjects temp = topicSubjects();
      temp.formJson(indData);
      collaborationTopic.add(temp);
    }
  }
}
