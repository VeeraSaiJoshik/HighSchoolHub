import 'package:flutter/material.dart';

enum SkillType {
  Computer_Science, 
  Mathematics,
  Science, 
  None
}

SkillType stringToEnum(String str){
  if(str == "Computer_Science"){
    return SkillType.Computer_Science;
  }else if(str == "Mathematics"){
    return SkillType.Mathematics;
  }else if(str == "Science"){
    return SkillType.Science;
  }
  return SkillType.None;
}

extension ParseToString on SkillType {
  String toReadableString(){
    return this.toString().replaceAll("_", " ");
  }
}

class Skill {
  String name = "";
  SkillType type = SkillType.None;
  Skill(this.name, this.type);
  //! JSON FUNCTIONS
  void fromJSON(Map data){
    name = data["name"];
    type = stringToEnum(data["type"]);
  }
  Map toJSON(){
    return {
      "name" : name,
      "type" : type.toReadableString()
    };
  }
  //! Methods
  Widget getImage(){
    return Image.asset(
      "Assets/skillsImage/" + type.toReadableString() + ".png"
    );
  }
}
