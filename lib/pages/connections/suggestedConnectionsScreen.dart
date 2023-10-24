import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/main.dart';
import 'package:highschoolhub/models/class.dart';
import 'package:highschoolhub/models/club.dart';
import 'package:highschoolhub/models/filter.dart';
import 'package:highschoolhub/models/school.dart';
import 'package:highschoolhub/models/skills.dart';
import 'package:highschoolhub/pages/AuthenticationPage.dart';
import 'package:highschoolhub/pages/connections/viewAllClassesConnectionsScreen.dart';
import 'package:highschoolhub/pages/connections/viewAllClubConnectionsScreen.dart';
import 'package:highschoolhub/pages/connections/viewAllSchoolConnectionsScreen.dart';
import 'package:highschoolhub/pages/connections/viewAllSkillsConnectionsScreen.dart';

import '../../models/user.dart';

class generalConnections {
  double rating;
  AppUser user;
  generalConnections(this.user, this.rating);
}
class schoolClassConnections {
  AppUser user;
  List<schoolClassStudent> classes = [];
  double rating = 0;
  int classesInCommon = 0;
  schoolClassConnections(this.user) {
    classes.addAll(user.classes);
  }
  double getRating(List<schoolClassStudent> curClasses) {
    classesInCommon = 0;
    rating = 0;
    for (schoolClassStudent curClass in classes) {
      for (schoolClassStudent currentStudentClass in curClasses) {
        if (curClass.classInfo!.className ==
            currentStudentClass.classInfo!.className) {
          classesInCommon++;
          rating = rating + 1;
          if (curClass.classTakenAt!.name ==
              currentStudentClass.classTakenAt!.name) {
            rating = rating + 2;
          }
          break;
        }
      }
    }
    return rating;
  }
  double getRatingRaw(List<schoolClassStudent> curClasses) {
    classesInCommon = 0;
    rating = 0;
    for (schoolClassStudent curClass in classes) {
      for (schoolClassStudent currentStudentClass in curClasses) {
        if (curClass.classInfo!.className ==
            currentStudentClass.classInfo!.className) {
          classesInCommon++;
          rating = rating + 1;
          break;
        }
      }
    }
    return rating;
  }
}

class schoolClubConnections {
  AppUser user;
  List<clubAppData> clubs = [];
  double rating = 0;
  int classesInCommon = 0;
  schoolClubConnections(this.user) {
    clubs.addAll(user.clubs);
  }
  double getRating(List<clubAppData> curClubs) {
    classesInCommon = 0;
    rating = 0;
    for (clubAppData curClass in clubs) {
      for (clubAppData currentStudentClass in curClubs) {
        if (curClass.clubData!.className ==
            currentStudentClass.clubData!.className) {
          classesInCommon++;
          rating = rating + 1;
          if (curClass.schoolAt == currentStudentClass.schoolAt) {
            rating = rating + 2;
          }
          break;
        }
      }
    }
    return rating;
  }
  double getRatingRaw(List<clubAppData> curClubs) {
    classesInCommon = 0;
    rating = 0;
    for (clubAppData curClass in clubs) {
      for (clubAppData currentStudentClass in curClubs) {
        if (curClass.clubData!.className ==
            currentStudentClass.clubData!.className) {
          classesInCommon++;
          rating = rating + 1;
          break;
        }
      }
    }
    return rating;
  }
}

class schoolSkillConnections {
  AppUser user;
  List<Skill> skills = [];
  double rating = 0;
  int skillsInCommon = 0;
  schoolSkillConnections(this.user) {
    skills.addAll(user.skills);
  }
  double getRating(List<Skill> curSkills) {
    skillsInCommon = 0;
    rating = 0;
    for (Skill curSkill in skills) {
      for (Skill currentStudentSkill in curSkills) {
        if (curSkill.className == currentStudentSkill.className) {
          skillsInCommon++;
          rating = rating + 1;
          break;
        }
      }
    }
    return rating;
  }
}

class SuggestedConnectionsScreen extends StatefulWidget {
  const SuggestedConnectionsScreen({super.key});

  @override
  State<SuggestedConnectionsScreen> createState() =>
      _SuggestedConnectionsScreenState();
}

class _SuggestedConnectionsScreenState
    extends State<SuggestedConnectionsScreen> {
  List<schoolCalculationNode> connectionsThroughSchool = [];
  List<schoolClassConnections> connectionsThroughClasses = [];
  List<schoolSkillConnections> connectionsThroughSkills = [];
  List<schoolClubConnections> connectionsThroughClubs = [];
  List<generalConnections> studentsLikeYou = [];
  List<academicYear> schoolYears = [];
  void findSimilarConnections() {
    double similarConnections = 0;
    for (String randomUserEmail in allUsers.keys) {
      AppUser userEmail = allUsers[randomUserEmail]!;
      print(allUsers[randomUserEmail]!.network);
      double score = 0;
      print("Score");
      // Calculate Mutual Connections
      similarConnections = 0;
      for (AppUser tempUser in currentUser.network) {
        for (AppUser randomUserTempUser in userEmail.network) {
          print(tempUser.email + " " + randomUserTempUser.email);
          if (randomUserTempUser.email == tempUser.email) {
            similarConnections++;
          }
        }
      }
      score = (similarConnections / currentUser.network.length) * 2;
      // calculate similar classes
      schoolClassConnections tempClass =
          schoolClassConnections(allUsers[randomUserEmail]!);
      score = score + (tempClass.getRatingRaw(currentUser.classes)/currentUser.classes.length) * 2;
      // calculate similar clubs
      print(tempClass.getRatingRaw(currentUser.classes)/currentUser.classes.length);
      print(tempClass.getRatingRaw(currentUser.classes));
      print(score);
      schoolClubConnections tempClub = schoolClubConnections(allUsers[randomUserEmail]!);
      score = score + (tempClub.getRatingRaw(currentUser.clubs)/currentUser.clubs.length) * 2;
      print(tempClub.getRatingRaw(currentUser.clubs)/currentUser.clubs.length);
      print(tempClub.getRatingRaw(currentUser.clubs));
      print(score);
      // calculate similar skills
      schoolSkillConnections tempSkill = schoolSkillConnections(allUsers[randomUserEmail]!);
      score = score + (tempSkill.getRating(currentUser.skills)/currentUser.skills.length) * 2;
      print(tempSkill.getRating(currentUser.skills)/currentUser.skills.length);
      print(tempSkill.getRating(currentUser.skills));
      print(score);
      // calculate distance from current school
      if(userEmail.getCurrentSchool().name == currentUser.getCurrentSchool().name){
        score = score + 1;
      }else{
        double distance = 1/(getDistance(userEmail.getCurrentSchool().address.lat, userEmail.getCurrentSchool().address.lon, currentUser.getCurrentSchool().address.lat, currentUser.getCurrentSchool().address.lon)/2).toInt();
        if(distance < 1){
          distance = 1;
        }
        score = score + distance;
      }
      bool flag = true;
      for(AppUser tempsUser in currentUser.network){
        if(tempsUser.email == userEmail.email){
          flag = false;
          break;
        }
      }
      if(flag == false){
        for(AppUser tempsUser in currentUser.requestsSent){
          if(tempsUser.email == userEmail.email){
            flag = false;
            break;
          }
        }
      }
      if(score >= 5 && userEmail.email != currentUser.email && flag)studentsLikeYou.add(generalConnections(userEmail, score));
      
      print(score);
    }
    studentsLikeYou.sort((e, b){
      return e.rating.compareTo(b.rating);
    });
    studentsLikeYou = studentsLikeYou.reversed.toList();
  }

  void findSimilarClassesConnections() {
    List<schoolClassConnections> possibleClassConnections = [];
    for (String email in allUsers.keys) {
      schoolClassConnections tempClass =
          schoolClassConnections(allUsers[email]!);
      tempClass.getRating(currentUser.classes);
      possibleClassConnections.add(tempClass);
    }
    possibleClassConnections.sort((a, b) {
      return a.rating.compareTo(b.rating);
    });
    for (schoolClassConnections possibleConnection
        in possibleClassConnections) {
      bool flag = false;
      // check if it is network
      for (AppUser tempUser in currentUser.network) {
        if (tempUser.email == possibleConnection.user.email) {
          flag = true;
          break;
        }
      }

      // check if it is in network received,
      if (flag) {
        for (AppUser tempUser in currentUser.requestsReceived) {
          if (tempUser.email == possibleConnection.user.email) {
            flag = true;
            break;
          }
        }
      }
      if(possibleConnection.user.email == currentUser.email) flag = true;
      if (flag == false && possibleConnection.rating != 0)
        connectionsThroughClasses.insert(0, possibleConnection);
    }
  }

  void findSimilarClubsConnections() {
    List<schoolClubConnections> possibleClubConnections = [];
    for (String email in allUsers.keys) {
      schoolClubConnections tempClass = schoolClubConnections(allUsers[email]!);
      tempClass.getRating(currentUser.clubs);
      possibleClubConnections.add(tempClass);
    }
    possibleClubConnections.sort((a, b) {
      return a.rating.compareTo(b.rating);
    });
    for (schoolClubConnections possibleConnection in possibleClubConnections) {
      bool flag = false;
      // check if it is network
      for (AppUser tempUser in currentUser.network) {
        if (tempUser.email == possibleConnection.user.email) {
          flag = true;
          break;
        }
      }

      // check if it is in network received,
      if (flag) {
        for (AppUser tempUser in currentUser.requestsReceived) {
          if (tempUser.email == possibleConnection.user.email) {
            flag = true;
            break;
          }
        }
      }
      if(possibleConnection.user.email == currentUser.email) flag = true;
      if (flag == false && possibleConnection.rating != 0)
        connectionsThroughClubs.insert(0, possibleConnection);
    }
  }

  void findSimilarSkillsConnections() {
    List<schoolSkillConnections> possibleSkillConnections = [];
    for (String email in allUsers.keys) {
      schoolSkillConnections tempClass =
          schoolSkillConnections(allUsers[email]!);
      tempClass.getRating(currentUser.skills);
      possibleSkillConnections.add(tempClass);
    }
    possibleSkillConnections.sort((a, b) {
      return a.rating.compareTo(b.rating);
    });
    for (schoolSkillConnections possibleConnection
        in possibleSkillConnections) {
      bool flag = false;
      // check if it is network
      for (AppUser tempUser in currentUser.network) {
        if (tempUser.email == possibleConnection.user.email) {
          flag = true;
          break;
        }
      }

      // check if it is in network received,
      if (flag) {
        for (AppUser tempUser in currentUser.requestsReceived) {
          if (tempUser.email == possibleConnection.user.email) {
            flag = true;
            break;
          }
        }
      }
      if(possibleConnection.user.email == currentUser.email) flag = true;
      if (flag == false && possibleConnection.rating != 0)
        connectionsThroughSkills.insert(0, possibleConnection);
    }
  }

  void findSimilarOverallConnections() {}
  void findSchoolBasedConnections() {
    List<schoolCalculationNode> possibleSchoolConnections = [];
    List<String> possibleSchoolConnectionsEmail = [];
    List<academicYear> schoolYears = [];
    /* 
    get the academic school years of current user
      - get all the schools they have attended
      - creat a school calculation node and add all the years
    */
    for (School s in currentUser.schools) {
      List years = schoolData[s.getDatabaseName()]![currentUser.email]!.year;
      List grades = schoolData[s.getDatabaseName()]![currentUser.email]!.grade;
      for (int i = 0; i < years.length; i++) {
        schoolYears.add(academicYear(years[i], grades[i], s));
      }
    }
    for (School s in currentUser.schools) {
      List years = schoolData[s.getDatabaseName()]![currentUser.email]!.year;
      for (String key in schoolData[s.getDatabaseName()]!.keys) {
        for (int year in years) {
          if (schoolData[s.getDatabaseName()]![key]!.year.contains(year)) {
            print(schoolData[s.getDatabaseName()]![key]!.studentGmail);
            if (possibleSchoolConnectionsEmail.contains(
                        schoolData[s.getDatabaseName()]![key]!.studentGmail) ==
                    false &&
                schoolData[s.getDatabaseName()]![key]!.studentGmail !=
                    currentUser.email) {
              print("I got in");
              schoolCalculationNode temp = schoolCalculationNode(allUsers[
                  schoolData[s.getDatabaseName()]![key]!.studentGmail]!);
              temp.addYears(schoolData[s.getDatabaseName()]![key]!, s);
              possibleSchoolConnections.add(temp);
              possibleSchoolConnectionsEmail
                  .add(schoolData[s.getDatabaseName()]![key]!.studentGmail);
            } else if (possibleSchoolConnectionsEmail.contains(
                    schoolData[s.getDatabaseName()]![key]!.studentGmail) ==
                false) {
              for (schoolCalculationNode node in possibleSchoolConnections) {
                if (node.user.email ==
                    schoolData[s.getDatabaseName()]![key]!.studentGmail) {
                  node.addYears(schoolData[s.getDatabaseName()]![key]!, s);
                  break;
                }
              }
            }
          }
        }
      }
    }
    for (schoolCalculationNode node in possibleSchoolConnections) {
      node.getRating(schoolYears);
      print("Name : " +
          node.user.firstName +
          " " +
          node.user.lastName +
          " Email : " +
          node.user.email +
          " Score: " +
          node.rating.toString());
    }
    possibleSchoolConnections.sort((a, b) => a.rating.compareTo(b.rating));
    for (schoolCalculationNode node in possibleSchoolConnections) {
      bool flag = false;
      // check if it is network
      for (AppUser tempUser in currentUser.network) {
        if (tempUser.email == node.user.email) {
          flag = true;
          break;
        }
      }

      // check if it is in network received,
      if (flag) {
        for (AppUser tempUser in currentUser.requestsReceived) {
          if (tempUser.email == node.user.email) {
            flag = true;
            break;
          }
        }
      }
      if(node.user.email == currentUser.email) flag = true;
      if (flag == false && node.rating != 0)
        connectionsThroughSchool.insert(0, node);
    }
    // assign each user a ranking based on how recent there interaction was, whether they were in the same grade, or how far away there grade was.
  }

  void initState() {
    findSchoolBasedConnections();
    findSimilarClassesConnections();
    findSimilarClubsConnections();
    findSimilarConnections();
    findSimilarSkillsConnections();
    super.initState();
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
      height: height,
      width: width,
      color: backgroundColor,
      child: Stack(
        children: [
          Opacity(
            opacity: 0.35,
            child: SizedBox(
              height: height,
              width: width,
              child: Image.asset(
                "assets/images/backdrop.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
              top: true,
              child: Container(
                height: height,
                width: width,
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.008,
                    ),
                    Container(
                      width: width * 0.92,
                      height: height * 0.07,
                      child: Row(
                        children: [
                          Container(
                            width: height * 0.01,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              height: height * 0.063,
                              width: height * 0.063,
                              decoration: BoxDecoration(
                                  color: red,
                                  border: Border.all(
                                      color: darkRed, width: width * 0.012),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              padding: EdgeInsets.all(width * 0.018),
                              child: ImageIcon(
                                AssetImage("assets/images/backArrow2.png"),
                                color: backgroundColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.085,
                          ),
                          Container(
                              height: height * 0.067,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  "Suggested",
                                  style: GoogleFonts.fredoka(
                                    color: mainColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Expanded(
                      child: Container(
                        width: width * 0.935,
                        height: height,
                        child: ListView(padding: EdgeInsets.zero, children: [
                          //! People like you
                          Container(
                            width: width * 0.8,
                            height: height * 0.4,
                            padding: EdgeInsets.only(bottom: height * 0.01),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(90, 224, 224, 224),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: width * 0.04,
                                    ),
                                    Container(
                                      height: height * 0.034,
                                      child: FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: ImageIcon(
                                            AssetImage(
                                                "assets/images//suggestedConnectionsImages/user.png"),
                                            color: blue,
                                          )),
                                    ),
                                    SizedBox(
                                      width: width * 0.015,
                                    ),
                                    Container(
                                      height: height * 0.045,
                                      margin: EdgeInsets.only(
                                          top: width * 0.024,
                                          bottom: height * 0.005),
                                      child: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Text(
                                          "Similar Interests",
                                          style: GoogleFonts.fredoka(
                                              color: blue,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Container())
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.005,
                                ),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.zero,
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: height * 0.01),
                                      alignment: Alignment.center,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(13),
                                        child: ListView(
                                          padding: EdgeInsets.zero,
                                          children: [
                                            ...studentsLikeYou
                                                .map((e) {
                                              if (studentsLikeYou
                                                      .indexOf(e) >=
                                                  10) return Container();
                                              AppUser recommendedUser = e.user;
                                              return InkWell(
                                                onTap: () async {},
                                                child: Container(
                                                  width: width * 0.93,
                                                  height: height * 0.1,
                                                  margin: EdgeInsets.only(
                                                    bottom: height * 0.01,
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: blue,
                                                      border: Border.all(
                                                          color: darkblue,
                                                          width: width * 0.015),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15))),
                                                  child: Stack(
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width: width * 0.02,
                                                          ),
                                                          Container(
                                                            height:
                                                                height * 0.07,
                                                            width:
                                                                height * 0.07,
                                                            margin: EdgeInsets
                                                                .only(
                                                                    top: width *
                                                                        0.02,
                                                                    bottom:
                                                                        width *
                                                                            0.02),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color:
                                                                        darkblue,
                                                                    width: width *
                                                                        0.01),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              5)),
                                                              child:
                                                                  Image.network(
                                                                recommendedUser
                                                                    .image,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                width * 0.025,
                                                          ),
                                                          Column(
                                                            children: [
                                                              SizedBox(
                                                                height: height *
                                                                    0.008,
                                                              ),
                                                              Container(
                                                                  height:
                                                                      height *
                                                                          0.045,
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .fitHeight,
                                                                    child: Text(
                                                                      recommendedUser
                                                                              .firstName +
                                                                          " " +
                                                                          recommendedUser
                                                                              .lastName,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: GoogleFonts.fredoka(
                                                                          color:
                                                                              backgroundColor,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                  )),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Positioned(
                                                        bottom: height * 0.01,
                                                        left: width * 0.2,
                                                        child: Container(
                                                          height:
                                                              height * 0.029,
                                                          width: width * 0.55,
                                                          child: Text(
                                                            (e.rating/9 * 100).toInt().toString() + "% matched",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: GoogleFonts.fredoka(
                                                                fontSize: 18,
                                                                color:
                                                                    backgroundColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: height * 0.016,
                                                        right: width * 0.02,
                                                        child: currentUser.findEmailInUserList(
                                                                    recommendedUser
                                                                        .email,
                                                                    currentUser
                                                                        .requestsSent) ||
                                                                currentUser.findEmailInUserList(
                                                                    recommendedUser
                                                                        .email,
                                                                    currentUser
                                                                        .network)
                                                            ? Container()
                                                            : InkWell(
                                                                onTap:
                                                                    () async {
                                                                  await currentUser
                                                                      .addFriendRequest(
                                                                          recommendedUser
                                                                              .email);
                                                                  setState(
                                                                      () {});
                                                                },
                                                                child:
                                                                    Container(
                                                                  child:
                                                                      ImageIcon(
                                                                    AssetImage(
                                                                      "assets/images/add-user.png",
                                                                    ),
                                                                    color:
                                                                        backgroundColor,
                                                                    size:
                                                                        height *
                                                                            0.03,
                                                                  ),
                                                                ),
                                                              ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                            InkWell(
                                                onTap: () async {
                                                  var delay = await Navigator
                                                          .of(context)
                                                      .push(MaterialPageRoute(
                                                          builder: (builder) {
                                                    return AllSchoolConnectionScreen(
                                                        connectionsThroughSchool);
                                                  }));
                                                },
                                                child: Container(
                                                  width: width * 0.93,
                                                  height: height * 0.08,
                                                  margin: EdgeInsets.only(
                                                    bottom: height * 0.01,
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: blue,
                                                      border: Border.all(
                                                          color: darkblue,
                                                          width: width * 0.015),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15))),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        height: height * 0.04,
                                                        child: FittedBox(
                                                          fit: BoxFit.fitHeight,
                                                          child: ImageIcon(
                                                            AssetImage(
                                                                "assets/images/more.png"),
                                                            color:
                                                                backgroundColor,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: width * 0.015,
                                                      ),
                                                      Container(
                                                          height:
                                                              height * 0.048,
                                                          child: FittedBox(
                                                            fit: BoxFit
                                                                .fitHeight,
                                                            child: Text(
                                                              "View More",
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: GoogleFonts.fredoka(
                                                                  color:
                                                                      backgroundColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          //! Skills
                          Container(
                            width: width * 0.8,
                            height: height * 0.4,
                            padding: EdgeInsets.only(bottom: height * 0.01),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(90, 224, 224, 224),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: width * 0.04,
                                    ),
                                    Container(
                                      height: height * 0.034,
                                      child: FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: ImageIcon(
                                            AssetImage(
                                                "assets/images//suggestedConnectionsImages/school.png"),
                                            color: puprle,
                                          )),
                                    ),
                                    SizedBox(
                                      width: width * 0.015,
                                    ),
                                    Container(
                                      height: height * 0.045,
                                      margin: EdgeInsets.only(
                                          top: width * 0.024,
                                          bottom: height * 0.005),
                                      child: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Text(
                                          "Similar Schools",
                                          style: GoogleFonts.fredoka(
                                              color: puprle,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Container())
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.005,
                                ),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.zero,
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: height * 0.01),
                                      alignment: Alignment.center,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(13),
                                        child: ListView(
                                          padding: EdgeInsets.zero,
                                          children: [
                                            ...connectionsThroughSchool
                                                .map((e) {
                                              if (connectionsThroughSchool
                                                      .indexOf(e) >=
                                                  10) return Container();
                                              AppUser recommendedUser = e.user;
                                              String bottomText = "";
                                              if (e.years[e.years.length - 1]
                                                      .school.name ==
                                                  e.user
                                                      .getCurrentSchool()
                                                      .name) {
                                                bottomText = "Studying at ";
                                              } else {
                                                bottomText = "Studied at ";
                                              }
                                              bottomText = bottomText +
                                                  e.years[e.years.length - 1]
                                                      .school.name;
                                              return InkWell(
                                                onTap: () async {},
                                                child: Container(
                                                  width: width * 0.93,
                                                  height: height * 0.1,
                                                  margin: EdgeInsets.only(
                                                    bottom: height * 0.01,
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: puprle,
                                                      border: Border.all(
                                                          color: darkPurple,
                                                          width: width * 0.015),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15))),
                                                  child: Stack(
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width: width * 0.02,
                                                          ),
                                                          Container(
                                                            height:
                                                                height * 0.07,
                                                            width:
                                                                height * 0.07,
                                                            margin: EdgeInsets
                                                                .only(
                                                                    top: width *
                                                                        0.02,
                                                                    bottom:
                                                                        width *
                                                                            0.02),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color:
                                                                        darkPurple,
                                                                    width: width *
                                                                        0.01),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              5)),
                                                              child:
                                                                  Image.network(
                                                                recommendedUser
                                                                    .image,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                width * 0.025,
                                                          ),
                                                          Column(
                                                            children: [
                                                              SizedBox(
                                                                height: height *
                                                                    0.008,
                                                              ),
                                                              Container(
                                                                  height:
                                                                      height *
                                                                          0.045,
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .fitHeight,
                                                                    child: Text(
                                                                      recommendedUser
                                                                              .firstName +
                                                                          " " +
                                                                          recommendedUser
                                                                              .lastName,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: GoogleFonts.fredoka(
                                                                          color:
                                                                              backgroundColor,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                  )),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Positioned(
                                                        bottom: height * 0.01,
                                                        left: width * 0.2,
                                                        child: Container(
                                                          height:
                                                              height * 0.029,
                                                          width: width * 0.55,
                                                          child: Text(
                                                            bottomText,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: GoogleFonts.fredoka(
                                                                fontSize: 18,
                                                                color:
                                                                    backgroundColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: height * 0.016,
                                                        right: width * 0.02,
                                                        child: currentUser.findEmailInUserList(
                                                                    recommendedUser
                                                                        .email,
                                                                    currentUser
                                                                        .requestsSent) ||
                                                                currentUser.findEmailInUserList(
                                                                    recommendedUser
                                                                        .email,
                                                                    currentUser
                                                                        .network)
                                                            ? Container()
                                                            : InkWell(
                                                                onTap:
                                                                    () async {
                                                                  await currentUser
                                                                      .addFriendRequest(
                                                                          recommendedUser
                                                                              .email);
                                                                  setState(
                                                                      () {});
                                                                },
                                                                child:
                                                                    Container(
                                                                  child:
                                                                      ImageIcon(
                                                                    AssetImage(
                                                                      "assets/images/add-user.png",
                                                                    ),
                                                                    color:
                                                                        backgroundColor,
                                                                    size:
                                                                        height *
                                                                            0.03,
                                                                  ),
                                                                ),
                                                              ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                            InkWell(
                                                onTap: () async {
                                                  var delay = await Navigator
                                                          .of(context)
                                                      .push(MaterialPageRoute(
                                                          builder: (builder) {
                                                    return AllSchoolConnectionScreen(
                                                        connectionsThroughSchool);
                                                  }));
                                                },
                                                child: Container(
                                                  width: width * 0.93,
                                                  height: height * 0.08,
                                                  margin: EdgeInsets.only(
                                                    bottom: height * 0.01,
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: puprle,
                                                      border: Border.all(
                                                          color: darkPurple,
                                                          width: width * 0.015),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15))),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        height: height * 0.04,
                                                        child: FittedBox(
                                                          fit: BoxFit.fitHeight,
                                                          child: ImageIcon(
                                                            AssetImage(
                                                                "assets/images/more.png"),
                                                            color:
                                                                backgroundColor,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: width * 0.015,
                                                      ),
                                                      Container(
                                                          height:
                                                              height * 0.048,
                                                          child: FittedBox(
                                                            fit: BoxFit
                                                                .fitHeight,
                                                            child: Text(
                                                              "View More",
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: GoogleFonts.fredoka(
                                                                  color:
                                                                      backgroundColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          //! CLASSES
                          Container(
                              width: width * 0.8,
                              height: height * 0.4,
                              padding: EdgeInsets.only(bottom: height * 0.01),
                              margin: EdgeInsets.only(top: height * 0.01),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(90, 224, 224, 224),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: height * 0.005,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width * 0.04,
                                        ),
                                        Container(
                                          height: height * 0.034,
                                          child: FittedBox(
                                              fit: BoxFit.fitHeight,
                                              child: ImageIcon(
                                                AssetImage(
                                                    "assets/images//suggestedConnectionsImages/classes.png"),
                                                color: orange,
                                              )),
                                        ),
                                        SizedBox(
                                          width: width * 0.015,
                                        ),
                                        Container(
                                          height: height * 0.045,
                                          margin: EdgeInsets.only(
                                              top: width * 0.024,
                                              bottom: height * 0.01),
                                          child: FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Text(
                                              "Similar Classes",
                                              style: GoogleFonts.fredoka(
                                                  color: orange,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                        Expanded(child: Container())
                                      ],
                                    ),
                                    SizedBox(
                                      height: height * 0.005,
                                    ),
                                    Expanded(
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.zero,
                                            child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: height * 0.01),
                                                alignment: Alignment.center,
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13),
                                                    child: ListView(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        children: [
                                                          ...connectionsThroughSkills
                                                              .map((e) {
                                                            AppUser
                                                                recommendedUser =
                                                                e.user;
                                                            String bottomText = e
                                                                    .skillsInCommon
                                                                    .toString() +
                                                                " classes in common";
                                                            if (connectionsThroughSkills
                                                                    .indexOf(
                                                                        e) >=
                                                                10)
                                                              return Container();
                                                            return InkWell(
                                                              onTap:
                                                                  () async {},
                                                              child: Container(
                                                                width: width *
                                                                    0.93,
                                                                height: height *
                                                                    0.1,
                                                                margin:
                                                                    EdgeInsets
                                                                        .only(
                                                                  bottom:
                                                                      height *
                                                                          0.01,
                                                                ),
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                        orange,
                                                                    border: Border.all(
                                                                        color:
                                                                            darkOrange,
                                                                        width: width *
                                                                            0.015),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(15))),
                                                                child: Stack(
                                                                  children: [
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              width * 0.02,
                                                                        ),
                                                                        Container(
                                                                          height:
                                                                              height * 0.07,
                                                                          width:
                                                                              height * 0.07,
                                                                          margin: EdgeInsets.only(
                                                                              top: width * 0.02,
                                                                              bottom: width * 0.02),
                                                                          decoration: BoxDecoration(
                                                                              border: Border.all(color: darkOrange, width: width * 0.01),
                                                                              borderRadius: BorderRadius.circular(10)),
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(5)),
                                                                            child:
                                                                                Image.network(
                                                                              recommendedUser.image,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              width * 0.025,
                                                                        ),
                                                                        Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: height * 0.008,
                                                                            ),
                                                                            Container(
                                                                                height: height * 0.045,
                                                                                child: FittedBox(
                                                                                  fit: BoxFit.fitHeight,
                                                                                  child: Text(
                                                                                    recommendedUser.firstName + " " + recommendedUser.lastName,
                                                                                    textAlign: TextAlign.start,
                                                                                    style: GoogleFonts.fredoka(color: backgroundColor, fontWeight: FontWeight.w600),
                                                                                  ),
                                                                                )),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Positioned(
                                                                      bottom:
                                                                          height *
                                                                              0.01,
                                                                      left: width *
                                                                          0.2,
                                                                      child:
                                                                          Container(
                                                                        height: height *
                                                                            0.029,
                                                                        width: width *
                                                                            0.55,
                                                                        child:
                                                                            Text(
                                                                          bottomText,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                          style: GoogleFonts.fredoka(
                                                                              fontSize: 18,
                                                                              color: backgroundColor,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      top: height *
                                                                          0.016,
                                                                      right: width *
                                                                          0.02,
                                                                      child: currentUser.findEmailInUserList(recommendedUser.email, currentUser.requestsSent) ||
                                                                              currentUser.findEmailInUserList(recommendedUser.email, currentUser.network)
                                                                          ? Container()
                                                                          : InkWell(
                                                                              onTap: () async {
                                                                                await currentUser.addFriendRequest(recommendedUser.email);
                                                                                setState(() {});
                                                                              },
                                                                              child: Container(
                                                                                child: ImageIcon(
                                                                                  AssetImage(
                                                                                    "assets/images/add-user.png",
                                                                                  ),
                                                                                  color: backgroundColor,
                                                                                  size: height * 0.03,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                          InkWell(
                                                              onTap: () async {
                                                                var delay = await Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder:
                                                                            (builder) {
                                                                  return AllSchoolClassesConnections(
                                                                      connectionsThroughClasses);
                                                                }));
                                                              },
                                                              child: Container(
                                                                width: width *
                                                                    0.93,
                                                                height: height *
                                                                    0.08,
                                                                margin:
                                                                    EdgeInsets
                                                                        .only(
                                                                  bottom:
                                                                      height *
                                                                          0.01,
                                                                ),
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                        orange,
                                                                    border: Border.all(
                                                                        color:
                                                                            darkOrange,
                                                                        width: width *
                                                                            0.015),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(15))),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      height:
                                                                          height *
                                                                              0.04,
                                                                      child:
                                                                          FittedBox(
                                                                        fit: BoxFit
                                                                            .fitHeight,
                                                                        child:
                                                                            ImageIcon(
                                                                          AssetImage(
                                                                              "assets/images/more.png"),
                                                                          color:
                                                                              backgroundColor,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: width *
                                                                          0.015,
                                                                    ),
                                                                    Container(
                                                                        height: height *
                                                                            0.048,
                                                                        child:
                                                                            FittedBox(
                                                                          fit: BoxFit
                                                                              .fitHeight,
                                                                          child:
                                                                              Text(
                                                                            "View More",
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style:
                                                                                GoogleFonts.fredoka(color: backgroundColor, fontWeight: FontWeight.w700),
                                                                          ),
                                                                        )),
                                                                  ],
                                                                ),
                                                              ))
                                                        ])))))
                                  ])),
                          //! Skills
                          Container(
                              width: width * 0.8,
                              height: height * 0.4,
                              padding: EdgeInsets.only(bottom: height * 0.01),
                              margin: EdgeInsets.only(top: height * 0.01),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(90, 224, 224, 224),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: height * 0.005,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width * 0.04,
                                        ),
                                        Container(
                                          height: height * 0.032,
                                          child: FittedBox(
                                              fit: BoxFit.fitHeight,
                                              child: ImageIcon(
                                                AssetImage(
                                                    "assets/images//suggestedConnectionsImages/skills.png"),
                                                color: mainColor,
                                              )),
                                        ),
                                        SizedBox(
                                          width: width * 0.015,
                                        ),
                                        Container(
                                          height: height * 0.045,
                                          margin: EdgeInsets.only(
                                              top: width * 0.024,
                                              bottom: height * 0.01),
                                          child: FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Text(
                                              "Similar Skills",
                                              style: GoogleFonts.fredoka(
                                                  color: mainColor,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                        Expanded(child: Container())
                                      ],
                                    ),
                                    SizedBox(
                                      height: height * 0.005,
                                    ),
                                    Expanded(
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.zero,
                                            child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: height * 0.01),
                                                alignment: Alignment.center,
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13),
                                                    child: ListView(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        children: [
                                                          ...connectionsThroughSkills
                                                              .map((e) {
                                                            if (connectionsThroughSkills
                                                                    .indexOf(
                                                                        e) >=
                                                                10)
                                                              return Container();
                                                            AppUser
                                                                recommendedUser =
                                                                e.user;
                                                            String bottomText = e
                                                                    .skillsInCommon
                                                                    .toString() +
                                                                " skills in common";
                                                            return InkWell(
                                                              onTap:
                                                                  () async {},
                                                              child: Container(
                                                                width: width *
                                                                    0.93,
                                                                height: height *
                                                                    0.1,
                                                                margin:
                                                                    EdgeInsets
                                                                        .only(
                                                                  bottom:
                                                                      height *
                                                                          0.01,
                                                                ),
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                        mainColor,
                                                                    border: Border.all(
                                                                        color:
                                                                            darkGreen,
                                                                        width: width *
                                                                            0.015),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(15))),
                                                                child: Stack(
                                                                  children: [
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              width * 0.02,
                                                                        ),
                                                                        Container(
                                                                          height:
                                                                              height * 0.07,
                                                                          width:
                                                                              height * 0.07,
                                                                          margin: EdgeInsets.only(
                                                                              top: width * 0.02,
                                                                              bottom: width * 0.02),
                                                                          decoration: BoxDecoration(
                                                                              border: Border.all(color: darkGreen, width: width * 0.01),
                                                                              borderRadius: BorderRadius.circular(10)),
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(5)),
                                                                            child:
                                                                                Image.network(
                                                                              recommendedUser.image,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              width * 0.025,
                                                                        ),
                                                                        Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: height * 0.008,
                                                                            ),
                                                                            Container(
                                                                                height: height * 0.045,
                                                                                child: FittedBox(
                                                                                  fit: BoxFit.fitHeight,
                                                                                  child: Text(
                                                                                    recommendedUser.firstName + " " + recommendedUser.lastName,
                                                                                    textAlign: TextAlign.start,
                                                                                    style: GoogleFonts.fredoka(color: backgroundColor, fontWeight: FontWeight.w600),
                                                                                  ),
                                                                                )),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Positioned(
                                                                      bottom:
                                                                          height *
                                                                              0.01,
                                                                      left: width *
                                                                          0.2,
                                                                      child:
                                                                          Container(
                                                                        height: height *
                                                                            0.029,
                                                                        width: width *
                                                                            0.55,
                                                                        child:
                                                                            Text(
                                                                          bottomText,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                          style: GoogleFonts.fredoka(
                                                                              fontSize: 18,
                                                                              color: backgroundColor,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      top: height *
                                                                          0.016,
                                                                      right: width *
                                                                          0.02,
                                                                      child: currentUser.findEmailInUserList(recommendedUser.email, currentUser.requestsSent) ||
                                                                              currentUser.findEmailInUserList(recommendedUser.email, currentUser.network)
                                                                          ? Container()
                                                                          : InkWell(
                                                                              onTap: () async {
                                                                                await currentUser.addFriendRequest(recommendedUser.email);
                                                                                setState(() {});
                                                                              },
                                                                              child: Container(
                                                                                child: ImageIcon(
                                                                                  AssetImage(
                                                                                    "assets/images/add-user.png",
                                                                                  ),
                                                                                  color: backgroundColor,
                                                                                  size: height * 0.03,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                          InkWell(
                                                              onTap: () async {
                                                                var delay = await Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder:
                                                                            (builder) {
                                                                  return AllSKillConnections(
                                                                      connectionsThroughSkills);
                                                                }));
                                                              },
                                                              child: Container(
                                                                width: width *
                                                                    0.93,
                                                                height: height *
                                                                    0.08,
                                                                margin:
                                                                    EdgeInsets
                                                                        .only(
                                                                  bottom:
                                                                      height *
                                                                          0.01,
                                                                ),
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                        mainColor,
                                                                    border: Border.all(
                                                                        color:
                                                                            darkGreen,
                                                                        width: width *
                                                                            0.015),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(15))),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      height:
                                                                          height *
                                                                              0.04,
                                                                      child:
                                                                          FittedBox(
                                                                        fit: BoxFit
                                                                            .fitHeight,
                                                                        child:
                                                                            ImageIcon(
                                                                          AssetImage(
                                                                              "assets/images/more.png"),
                                                                          color:
                                                                              backgroundColor,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: width *
                                                                          0.015,
                                                                    ),
                                                                    Container(
                                                                        height: height *
                                                                            0.048,
                                                                        child:
                                                                            FittedBox(
                                                                          fit: BoxFit
                                                                              .fitHeight,
                                                                          child:
                                                                              Text(
                                                                            "View More",
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style:
                                                                                GoogleFonts.fredoka(color: backgroundColor, fontWeight: FontWeight.w700),
                                                                          ),
                                                                        )),
                                                                  ],
                                                                ),
                                                              ))
                                                        ])))))
                                  ])),
                          //! Clubs
                          Container(
                              width: width * 0.8,
                              height: height * 0.4,
                              padding: EdgeInsets.only(bottom: height * 0.01),
                              margin: EdgeInsets.only(top: height * 0.01),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(90, 224, 224, 224),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: height * 0.005,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width * 0.04,
                                        ),
                                        Container(
                                          height: height * 0.032,
                                          child: FittedBox(
                                              fit: BoxFit.fitHeight,
                                              child: ImageIcon(
                                                AssetImage(
                                                    "assets/images//suggestedConnectionsImages/clubs.png"),
                                                color: mainColor,
                                              )),
                                        ),
                                        SizedBox(
                                          width: width * 0.015,
                                        ),
                                        Container(
                                          height: height * 0.045,
                                          margin: EdgeInsets.only(
                                              top: width * 0.024,
                                              bottom: height * 0.01),
                                          child: FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Text(
                                              "Similar Clubs",
                                              style: GoogleFonts.fredoka(
                                                  color: mainColor,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                        Expanded(child: Container())
                                      ],
                                    ),
                                    SizedBox(
                                      height: height * 0.005,
                                    ),
                                    Expanded(
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.zero,
                                            child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: height * 0.01),
                                                alignment: Alignment.center,
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13),
                                                    child: ListView(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        children: [
                                                          ...connectionsThroughClubs
                                                              .map((e) {
                                                            if (connectionsThroughClubs
                                                                    .indexOf(
                                                                        e) >=
                                                                10)
                                                              return Container();
                                                            AppUser
                                                                recommendedUser =
                                                                e.user;
                                                            String bottomText = e
                                                                    .classesInCommon
                                                                    .toString() +
                                                                " clubs in common";
                                                            return InkWell(
                                                              onTap:
                                                                  () async {},
                                                              child: Container(
                                                                width: width *
                                                                    0.93,
                                                                height: height *
                                                                    0.1,
                                                                margin:
                                                                    EdgeInsets
                                                                        .only(
                                                                  bottom:
                                                                      height *
                                                                          0.01,
                                                                ),
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                        mainColor,
                                                                    border: Border.all(
                                                                        color:
                                                                            darkGreen,
                                                                        width: width *
                                                                            0.015),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(15))),
                                                                child: Stack(
                                                                  children: [
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              width * 0.02,
                                                                        ),
                                                                        Container(
                                                                          height:
                                                                              height * 0.07,
                                                                          width:
                                                                              height * 0.07,
                                                                          margin: EdgeInsets.only(
                                                                              top: width * 0.02,
                                                                              bottom: width * 0.02),
                                                                          decoration: BoxDecoration(
                                                                              border: Border.all(color: darkGreen, width: width * 0.01),
                                                                              borderRadius: BorderRadius.circular(10)),
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(5)),
                                                                            child:
                                                                                Image.network(
                                                                              recommendedUser.image,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              width * 0.025,
                                                                        ),
                                                                        Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: height * 0.008,
                                                                            ),
                                                                            Container(
                                                                                height: height * 0.045,
                                                                                child: FittedBox(
                                                                                  fit: BoxFit.fitHeight,
                                                                                  child: Text(
                                                                                    recommendedUser.firstName + " " + recommendedUser.lastName,
                                                                                    textAlign: TextAlign.start,
                                                                                    style: GoogleFonts.fredoka(color: backgroundColor, fontWeight: FontWeight.w600),
                                                                                  ),
                                                                                )),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Positioned(
                                                                      bottom:
                                                                          height *
                                                                              0.01,
                                                                      left: width *
                                                                          0.2,
                                                                      child:
                                                                          Container(
                                                                        height: height *
                                                                            0.029,
                                                                        width: width *
                                                                            0.55,
                                                                        child:
                                                                            Text(
                                                                          bottomText,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                          style: GoogleFonts.fredoka(
                                                                              fontSize: 18,
                                                                              color: backgroundColor,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      top: height *
                                                                          0.016,
                                                                      right: width *
                                                                          0.02,
                                                                      child: currentUser.findEmailInUserList(recommendedUser.email, currentUser.requestsSent) ||
                                                                              currentUser.findEmailInUserList(recommendedUser.email, currentUser.network)
                                                                          ? Container()
                                                                          : InkWell(
                                                                              onTap: () async {
                                                                                await currentUser.addFriendRequest(recommendedUser.email);
                                                                                setState(() {});
                                                                              },
                                                                              child: Container(
                                                                                child: ImageIcon(
                                                                                  AssetImage(
                                                                                    "assets/images/add-user.png",
                                                                                  ),
                                                                                  color: backgroundColor,
                                                                                  size: height * 0.03,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                          InkWell(
                                                              onTap: () async {
                                                                var delay = await Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder:
                                                                            (builder) {
                                                                  return AllClubConnections(
                                                                      connectionsThroughClubs);
                                                                }));
                                                              },
                                                              child: Container(
                                                                width: width *
                                                                    0.93,
                                                                height: height *
                                                                    0.08,
                                                                margin:
                                                                    EdgeInsets
                                                                        .only(
                                                                  bottom:
                                                                      height *
                                                                          0.01,
                                                                ),
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                        mainColor,
                                                                    border: Border.all(
                                                                        color:
                                                                            darkGreen,
                                                                        width: width *
                                                                            0.015),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(15))),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      height:
                                                                          height *
                                                                              0.04,
                                                                      child:
                                                                          FittedBox(
                                                                        fit: BoxFit
                                                                            .fitHeight,
                                                                        child:
                                                                            ImageIcon(
                                                                          AssetImage(
                                                                              "assets/images/more.png"),
                                                                          color:
                                                                              backgroundColor,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: width *
                                                                          0.015,
                                                                    ),
                                                                    Container(
                                                                        height: height *
                                                                            0.048,
                                                                        child:
                                                                            FittedBox(
                                                                          fit: BoxFit
                                                                              .fitHeight,
                                                                          child:
                                                                              Text(
                                                                            "View More",
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style:
                                                                                GoogleFonts.fredoka(color: backgroundColor, fontWeight: FontWeight.w700),
                                                                          ),
                                                                        )),
                                                                  ],
                                                                ),
                                                              ))
                                                        ])))))
                                  ]))
                        ]),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    ));
  }
}

/*
return InkWell(
                                onTap: () async {
                                  AppUser tempuser = AppUser();
                                  await tempuser.getDataFromDatabase(e.email);
                                  var temp = await Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (c) {
                                    print(
                                        "we getting out of the app dev with this");
                                    print(e.email);

                                    return MyProfileScreen(tempuser);
                                  }));
                                  setState(() {});
                                },
                                child: Container(
                                  width: width * 0.93,
                                  height: height * 0.1,
                                  margin: EdgeInsets.only(
                                    bottom: height * 0.01
                                  ),
                                  decoration: BoxDecoration(
                                      color: mainColor,
                                      border: Border.all(
                                          color: darkGreen,
                                          width: width * 0.015),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Stack(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: width * 0.02,
                                          ),
                                          Container(
                                            height: height * 0.07,
                                            width: height * 0.07,
                                            margin: EdgeInsets.only(
                                                top: width * 0.02,
                                                bottom: width * 0.02),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: darkGreen,
                                                    width: width * 0.01),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              child: Image.network(
                                                e.image,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * 0.025,
                                          ),
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: height * 0.008,
                                              ),
                                              Container(
                                                  height: height * 0.048,
                                                  child: FittedBox(
                                                    fit: BoxFit.fitHeight,
                                                    child: Text(
                                                      e.firstName +
                                                          " " +
                                                          e.lastName,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: GoogleFonts.fredoka(
                                                          color:
                                                              backgroundColor,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        bottom: height * 0.01,
                                        left: width * 0.2,
                                        child: Container(
                                          height: height * 0.03,
                                          width: width * 0.55,
                                          child: Text(
                                            currentGradeToString(
                                                    e.currentGrade) +
                                                " at " +
                                                e.getCurrentSchool().name,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.fredoka(
                                                fontSize: 20,
                                                color: backgroundColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: height * 0.015,
                                        right: width * 0.02,
                                        child: currentUser.findEmailInUserList(
                                                    e.email,
                                                    currentUser.requestsSent) ||
                                                currentUser.findEmailInUserList(
                                                    e.email,
                                                    currentUser.network)
                                            ? Container()
                                            : InkWell(
                                                onTap: () async {
                                                  await currentUser
                                                      .addFriendRequest(
                                                          e.email);
                                                  setState(() {});
                                                },
                                                child: Container(
                                                  child: ImageIcon(
                                                    AssetImage(
                                                      "assets/images/add-user.png",
                                                    ),
                                                    color: backgroundColor,
                                                    size: height * 0.035,
                                                  ),
                                                ),
                                              ),
                                      )
                                    ],
                                  ),
                                ),
                              );
*/
