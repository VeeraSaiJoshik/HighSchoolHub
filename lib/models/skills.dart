import 'package:flutter/material.dart';
import 'club.dart';

class Skill {
  String className = "";
  List<ClubType>? types = [];
  double gScore = 0;
  Skill({this.className = "", this.types, this.gScore = 0}){
    types ??= [];
  }
  //! JSON FUNCTIONS
  void fromJSON(Map data){
    className = data["name"];
    types = [];
    for(var t in data["types"]){
      types!.add(stringToEnum(t));
    }
  }
  Map toJSON(){
    List tempList = [];
    for(ClubType t in types!){
      tempList.add(t.toReadableString());
    }
    return {
      "name" : className,
      "types" : tempList
    };
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
}
