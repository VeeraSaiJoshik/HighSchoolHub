import 'package:highschoolhub/main.dart';
import 'package:highschoolhub/models/club.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:highschoolhub/models/school.dart';
import 'package:highschoolhub/models/skills.dart';

void upploadClubData() async {
  List<Map> testSchoolDat = [
    {
      "address": {
        "address_components": [
          {
            "long_name": "2600",
            "short_name": "2600",
            "types": ["street_number"]
          },
          {
            "long_name": "Southeast J Street",
            "short_name": "SE J St",
            "types": ["route"]
          },
          {
            "long_name": "Bentonville",
            "short_name": "Bentonville",
            "types": ["locality", "political"]
          },
          {
            "long_name": "Benton County",
            "short_name": "Benton County",
            "types": ["administrative_area_level_2", "political"]
          },
          {
            "long_name": "Arkansas",
            "short_name": "AR",
            "types": ["administrative_area_level_1", "political"]
          },
          {
            "long_name": "United States",
            "short_name": "US",
            "types": ["country", "political"]
          },
          {
            "long_name": "72712",
            "short_name": "72712",
            "types": ["postal_code"]
          },
          {
            "long_name": "3767",
            "short_name": "3767",
            "types": ["postal_code_suffix"]
          }
        ],
        "formatted_address": "2600 SE J St, Bentonville, AR 72712, USA",
        "geometry": {
          "bounds": {
            "northeast": {"lat": 36.3445678, "lng": -94.1977534},
            "southwest": {"lat": 36.3442806, "lng": -94.1984449}
          },
          "location": {"lat": 36.3444022, "lng": -94.19814889999999},
          "location_type": "ROOFTOP",
          "viewport": {
            "northeast": {"lat": 36.34577318029149, "lng": -94.19673296970849},
            "southwest": {"lat": 36.3430752197085, "lng": -94.1994309302915}
          }
        },
        "partial_match": true,
        "place_id": "ChIJFyty2mYQyYcRpKvVpzdU9Hc",
        "types": ["premise"]
      },
      "name": "Haas Hall Bentonville",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTRgJ40v7JQcveWuygaT1XYPim0RGwMwW_81OOgb9-YNPhy1hl-sPz3VGKGgEM&s",
      "currentSchool": true,
      "grades": [7, 8, 9, 10, 11, 12],
      "attendedGrades": [7, 8, 9, 10]
    }, 
    {
      "address": {
        "address_components": [
          {
            "long_name": "2600",
            "short_name": "2600",
            "types": ["street_number"]
          },
          {
            "long_name": "Southeast J Street",
            "short_name": "SE J St",
            "types": ["route"]
          },
          {
            "long_name": "Bentonville",
            "short_name": "Bentonville",
            "types": ["locality", "political"]
          },
          {
            "long_name": "Benton County",
            "short_name": "Benton County",
            "types": ["administrative_area_level_2", "political"]
          },
          {
            "long_name": "Arkansas",
            "short_name": "AR",
            "types": ["administrative_area_level_1", "political"]
          },
          {
            "long_name": "United States",
            "short_name": "US",
            "types": ["country", "political"]
          },
          {
            "long_name": "72712",
            "short_name": "72712",
            "types": ["postal_code"]
          },
          {
            "long_name": "3767",
            "short_name": "3767",
            "types": ["postal_code_suffix"]
          }
        ],
        "formatted_address": "2600 SE J St, Bentonville, AR 72712, USA",
        "geometry": {
          "bounds": {
            "northeast": {"lat": 36.3445678, "lng": -94.1977534},
            "southwest": {"lat": 36.3442806, "lng": -94.1984449}
          },
          "location": {"lat": 36.3444022, "lng": -94.19814889999999},
          "location_type": "ROOFTOP",
          "viewport": {
            "northeast": {"lat": 36.34577318029149, "lng": -94.19673296970849},
            "southwest": {"lat": 36.3430752197085, "lng": -94.1994309302915}
          }
        },
        "partial_match": true,
        "place_id": "ChIJFyty2mYQyYcRpKvVpzdU9Hc",
        "types": ["premise"]
      },
      "name": "Bentonville West High School",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTRgJ40v7JQcveWuygaT1XYPim0RGwMwW_81OOgb9-YNPhy1hl-sPz3VGKGgEM&s",
      "currentSchool": true,
      "grades": [7, 8, 9, 10, 11, 12],
      "attendedGrades": [7, 8, 9, 10]
    }, 
    {
      "address": {
        "address_components": [
          {
            "long_name": "2600",
            "short_name": "2600",
            "types": ["street_number"]
          },
          {
            "long_name": "Southeast J Street",
            "short_name": "SE J St",
            "types": ["route"]
          },
          {
            "long_name": "Bentonville",
            "short_name": "Bentonville",
            "types": ["locality", "political"]
          },
          {
            "long_name": "Benton County",
            "short_name": "Benton County",
            "types": ["administrative_area_level_2", "political"]
          },
          {
            "long_name": "Arkansas",
            "short_name": "AR",
            "types": ["administrative_area_level_1", "political"]
          },
          {
            "long_name": "United States",
            "short_name": "US",
            "types": ["country", "political"]
          },
          {
            "long_name": "72712",
            "short_name": "72712",
            "types": ["postal_code"]
          },
          {
            "long_name": "3767",
            "short_name": "3767",
            "types": ["postal_code_suffix"]
          }
        ],
        "formatted_address": "2600 SE J St, Bentonville, AR 72712, USA",
        "geometry": {
          "bounds": {
            "northeast": {"lat": 36.3445678, "lng": -94.1977534},
            "southwest": {"lat": 36.3442806, "lng": -94.1984449}
          },
          "location": {"lat": 36.3444022, "lng": -94.19814889999999},
          "location_type": "ROOFTOP",
          "viewport": {
            "northeast": {"lat": 36.34577318029149, "lng": -94.19673296970849},
            "southwest": {"lat": 36.3430752197085, "lng": -94.1994309302915}
          }
        },
        "partial_match": true,
        "place_id": "ChIJFyty2mYQyYcRpKvVpzdU9Hc",
        "types": ["premise"]
      },
      "name": "Founders Classical Academy At Bentonville",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTRgJ40v7JQcveWuygaT1XYPim0RGwMwW_81OOgb9-YNPhy1hl-sPz3VGKGgEM&s",
      "currentSchool": true,
      "grades": [7, 8, 9, 10, 11, 12],
      "attendedGrades": [7, 8, 9, 10]
    }
  ];
  List<School> dummySchoolData = [];
  for(Map dummyData in testSchoolDat){
    School temp = School();
    temp.fromJson(dummyData);
    dummySchoolData.add(temp);
  }
  List<String> files = [
    "academics",
    "art",
    "buisness",
    "culture",
    "engeneering",
    "math",
    "music",
    "media",
    "science",
    "service",
    "speech",
    "sports",
    "tech"
  ];
  List<ClubType> typesList = [
    ClubType.Academics,
    ClubType.Art,
    ClubType.Buisness,
    ClubType.Culture,
    ClubType.Engineering,
    ClubType.Math,
    ClubType.Media,
    ClubType.Music,
    ClubType.Science,
    ClubType.Service,
    ClubType.Speech,
    ClubType.Sports,
    ClubType.Technology
  ];
  List<Skill> skillList = [];
  for(int i = 0; i < files.length; i++) {
    String file = files[i];
    var contents = await rootBundle.loadString("python/skills/" + file + ".txt");
    for(String c in contents.split("\n")){
      String skillName = c.trimLeft().trimRight();
      bool flag = false;
      for(Skill s in skillList){
        if(s.className == skillName){
          flag = true;
          s.types!.add(typesList[i]);
          break;
        }
      }
      if(flag == false){
        print(skillName);
        Skill s = Skill();
        s.className = skillName;
        s.types = [typesList[i]];
        skillList.add(s);
      }
    }
  }
  int total = skillList.length;
  int index = 1;
  for(Skill s in skillList){
    await supaBase.from("Skills").insert(s.toJSON());
    print(index.toString() + "/" + total.toString());
    index += 1;
  }
}
