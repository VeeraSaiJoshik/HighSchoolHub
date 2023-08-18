import 'package:flutter/material.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/models/school.dart';

enum ClubType {
  Art,
  Sports,
  Service,
  Science,
  Technology,
  Speech,
  Culture,
  Math,
  Music,
  Media,
  Buisness,
  Academics,
  Engineering,
  None
}

ClubType stringToEnum(String str) {
  if (str == "ClubType.Art") {
    return ClubType.Art;
  } else if (str == "ClubType.Sports") {
    return ClubType.Sports;
  } else if (str == "ClubType.Service") {
    return ClubType.Service;
  } else if (str == "ClubType.Science") {
    return ClubType.Science;
  } else if (str == "ClubType.Technology") {
    return ClubType.Technology;
  } else if (str == "ClubType.Speech") {
    return ClubType.Speech;
  } else if (str == "ClubType.Culture") {
    return ClubType.Culture;
  } else if (str == "ClubType.Math") {
    return ClubType.Math;
  } else if (str == "ClubType.Music") {
    return ClubType.Music;
  } else if (str == "ClubType.Media") {
    return ClubType.Media;
  } else if (str == "ClubType.Buisness") {
    return ClubType.Buisness;
  } else if (str == "ClubType.Engineering") {
    return ClubType.Engineering;
  } else if (str == "ClubType.Academics") {
    return ClubType.Academics;
  }
  return ClubType.None;
}

extension ParseToString on ClubType {
  String toReadableString() {
    return this.toString().replaceAll("_", " ");
  }
}

class club {
  String className = "";
  List<School> schoolsAssociatedWith = [];
  List<clubImage> images = [];
  ClubType type = ClubType.None;
  double gScore = -1;
  //! Input Function
  club(
      {this.className = "",
      this.schoolsAssociatedWith = const [],
      this.images = const [],
      this.type = ClubType.None});
  //! Methods
  Color getClubTypeColor() {
    ClubType t = type;
    if (t == ClubType.Academics ||
        t == ClubType.Science ||
        t == ClubType.Math ||
        t == ClubType.Technology) {
      return blue;
    } else if (t == ClubType.Sports ||
        t == ClubType.Service ||
        t == ClubType.Culture) {
      return puprle;
    } else if (t == ClubType.Engineering ||
        t == ClubType.Speech ||
        t == ClubType.Buisness) {
      return orange;
    }
    return mainColor;
  }

  Color getClubTypeColorDark() {
    ClubType t = type;
    if (t == ClubType.Academics ||
        t == ClubType.Science ||
        t == ClubType.Math ||
        t == ClubType.Technology) {
      return darkblue;
    } else if (t == ClubType.Sports ||
        t == ClubType.Service ||
        t == ClubType.Culture) {
      return darkPurple;
    } else if (t == ClubType.Engineering ||
        t == ClubType.Speech ||
        t == ClubType.Buisness) {
      return darkOrange;
    }
    return darkGreen;
  }

  bool schoolContained(String schoolName) {
    for (School s in schoolsAssociatedWith) {
      if (s.name == schoolName) return true;
    }
    return false;
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

  void fromJson(Map jsonData) {
    className = jsonData["className"];
    schoolsAssociatedWith = [];
    for (Map data in jsonData["schoolsAssociatedWith"]) {
      School temp = School();
      temp.fromJson(data);
      schoolsAssociatedWith.add(temp);
    }
    images = [];
    for (Map data in jsonData["images"]) {
      clubImage temp = clubImage("", "");
      temp.fromJson(data);
      images.add(temp);
    }
    type = stringToEnum(jsonData["type"]);
  }

  Map toJson() {
    List<Map> tempString = [];
    List<Map> tempImage = [];
    for (School s in schoolsAssociatedWith) {
      tempString.add(s.getJson());
    }
    for (clubImage s in images) {
      tempImage.add(s.toJson());
    }
    return {
      "className": className,
      "images": tempImage,
      "type": type.toReadableString(),
      "schoolsAssociatedWith": tempString
    };
  }

  Widget getImage(String schoolName, {Color? finalColor}) {
    
    for (clubImage img in images) {
      if (img.schoolName == schoolName) {
        return Image.network(img.imageAddress);
      }
    }
    return ImageIcon(
      AssetImage("assets/images/clubIcons/" +
          type.toReadableString().substring(9) +
          ".png"),
      color: finalColor,
    );
  }
}

class clubImage {
  String imageAddress = "";
  String schoolName = "";
  clubImage(this.imageAddress, this.schoolName);
  void fromJson(Map data) {
    imageAddress = data["imageAddress"];
    schoolName = data["schoolName"];
  }

  Map toJson() {
    return {"imageAddress": imageAddress, "schoolName": schoolName};
  }
}

class clubAppData {
  club clubData = club();
  String schoolAt = "";
  //! METHODS
  void fromJson(Map data){
    clubData.fromJson(data["clubData"]);
    schoolAt = data["schoolAt"];
  }
  Map toJson(){
    return {
      "clubData":clubData.toJson(), 
      "schoolAt":schoolAt
    };
  }
  void setClubData(club data) {
    clubData = data;
  }
  String getSchoolImage(List<School> schoolList){
    for(School s in schoolList){
      if(s.name == schoolAt){
        return s.image;
      }
    }
    return "";
  }
  Widget getImage({Color? finalColor}) {
    print(finalColor);
    return clubData.getImage(schoolAt, finalColor: finalColor);
  }
}
