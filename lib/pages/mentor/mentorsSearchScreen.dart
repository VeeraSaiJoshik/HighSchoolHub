import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/main.dart';
import 'package:highschoolhub/models/class.dart';
import 'package:highschoolhub/models/mentor.dart';
import 'package:highschoolhub/models/skills.dart';
import 'package:highschoolhub/pages/AuthenticationPage.dart';
import 'package:highschoolhub/pages/connections/filtersScreen.dart';
import 'package:highschoolhub/pages/mentor/createMentorPostScreen.dart';
import 'package:highschoolhub/pages/mentor/mentorFilterScreen.dart';
import 'package:highschoolhub/pages/mentor/mentorSpecficiScreend.dart';
import 'package:highschoolhub/models/filter.dart';
import '../../models/club.dart';
import '../connections/addConnectionsScreen.dart';

List<topicSubjects> subjectList = [
  topicSubjects(
      clubType: ClubType.Academics,
      clubTypeString: "None",
      image: "assets/images/clubIcons/Academics.png"),
  topicSubjects(
      clubType: ClubType.Art,
      clubTypeString: "Art",
      image: "assets/images/clubIcons/Art.png"),
  topicSubjects(
      clubType: ClubType.Buisness,
      clubTypeString: "Buisness",
      image: "assets/images/clubIcons/Buisness.png"),
  topicSubjects(
      clubType: ClubType.Culture,
      clubTypeString: "none",
      image: "assets/images/clubIcons/Culture.png"),
  topicSubjects(
      clubType: ClubType.Engineering,
      clubTypeString: "none",
      image: "assets/images/clubIcons/Engineering.png"),
  topicSubjects(
      clubType: ClubType.Math,
      clubTypeString: "Math",
      image: "assets/images/clubIcons/Math.png"),
  topicSubjects(
      clubType: ClubType.Media,
      clubTypeString: "none",
      image: "assets/images/clubIcons/Media.png"),
  topicSubjects(
      clubType: ClubType.Music,
      clubTypeString: "Music",
      image: "assets/images/clubIcons/Music.png"),
  topicSubjects(
      clubType: ClubType.Science,
      clubTypeString: "Science",
      image: "assets/images/clubIcons/Science.png"),
  topicSubjects(
      clubType: ClubType.Service,
      clubTypeString: "none",
      image: "assets/images/clubIcons/Service.png"),
  topicSubjects(
      clubType: ClubType.Speech,
      clubTypeString: "none",
      image: "assets/images/clubIcons/Speech.png"),
  topicSubjects(
      clubType: ClubType.Sports,
      clubTypeString: "Sports",
      image: "assets/images/clubIcons/Sports.png"),
  topicSubjects(
      clubType: ClubType.Technology,
      clubTypeString: "Computers",
      image: "assets/images/clubIcons/Technology.png"),
  topicSubjects(
      clubType: ClubType.None,
      clubTypeString: "Electives",
      image: "assets/images/classImage/Electives.png"),
  topicSubjects(
      clubType: ClubType.None,
      clubTypeString: "English",
      image: "assets/images/classImage/English.png"),
  topicSubjects(
      clubType: ClubType.None,
      clubTypeString: "Language",
      image: "assets/images/classImage/Language.png"),
  topicSubjects(
      clubType: ClubType.None,
      clubTypeString: "Social_Studies",
      image: "assets/images/classImage/Social_Studies.png"),
];

class MentorsSearchScreen extends StatefulWidget {
  const MentorsSearchScreen({super.key});

  @override
  State<MentorsSearchScreen> createState() => MentorsSearchScreenState();
}

class MentorsSearchScreenState extends State<MentorsSearchScreen> {
  TextEditingController networkSearchTec = TextEditingController();
  bool mentoreePage = true;

  @override
  List<Mentor> allMentorPosts = [];
  MentorFilter filter = MentorFilter();
  List<Mentor> afterFilterScreen = [];
  List<Mentor> sortAllMyMentors(afterFilterScreen) {
    List<MentorSort> answer = [];
    for (Mentor tempMentor in afterFilterScreen) {
      double rating = 0;
      // distance
      if (MentorShipMeetLocation.Both == tempMentor.location ||
          MentorShipMeetLocation.Virtual == tempMentor.location)
        rating = 15;
      else {
        double distance = getDistance(
            currentUser.getCurrentSchool().address.lat,
            currentUser.getCurrentSchool().address.lon,
            allUsers[tempMentor.userEmail]!.getCurrentSchool().address.lat,
            allUsers[tempMentor.userEmail]!.getCurrentSchool().address.lon);
        if (distance < 31) {
          rating += (31 - distance) / 31 * 15;
        }
      }
      // current school
      if (allUsers[tempMentor.userEmail]!.getCurrentSchool().name ==
          currentUser.getCurrentSchool().name) {
        rating += 2;
      }
      if (allUsers[tempMentor.userEmail]!
              .getCurrentSchool()
              .address
              .stateShortName
              .toLowerCase() ==
          currentUser.getCurrentSchool().address.stateShortName) rating += 8;
      // same classes
      rating += tempMentor.rating / 5 * 10;
      
      print("base rating "  + tempMentor.getMentorTopicName() + " " + rating.toString());
      if (tempMentor.type == MentorShipType.Classes) {
        print("base rating" + rating.toString());
        int tempRating = 0;
        double classRating = 0;
        for (schoolClassStudent tempClass in currentUser.classes) {
          if (tempClass.classInfo!.subjects
              .contains(tempMentor.mentorSubjectClass)) tempRating++;
          if (tempClass.classInfo!.className ==
              tempMentor.mentoringClass[0].className) {
            classRating = 10;
            if (tempClass.classTakenAt!.name ==
                tempMentor.courseTakenAt[0].name) classRating += 5;
            
          }
        }
        if (allUsers[tempMentor.userEmail]!.userState == currentUser.userState) {
          classRating + 5;
        }
        print("This was my class rating " + tempMentor.getMentorTopicName());
        print(classRating);
        classRating =
            classRating + tempRating / currentUser.classes.length * 10;
        rating = rating + classRating;
        // checking similarity between clubs
        int clubRating = 0;
        for (clubAppData tempSkill in currentUser.clubs) {
          topicSubjects currentTopics = subjectList[0];
          for (topicSubjects temp in subjectList) {
            if (tempSkill.clubData.type == temp.clubType) {
              
              currentTopics = temp;
            }
          }
          if (tempMentor.mentorSubjectClass == currentTopics.clubTypeString) {
            clubRating += 1;
            break;
          }
        }
        print(rating);
        rating = rating + clubRating / currentUser.clubs.length * 15;
        // checking similarity between skills
        int skillRating = 0;
        for (Skill tempSkill in currentUser.skills) {
          List<topicSubjects> currentTopics = [];
          for (topicSubjects temp in subjectList) {
            if (tempSkill.types!.contains(temp.clubType)) {
              currentTopics.add(temp);
            }
          }
          for (topicSubjects temp in currentTopics) {
            if (tempMentor.mentorSubjectClass == temp.clubTypeString) {
              skillRating += 1;
              break;
            }
          }
        }
        print(rating);
        rating = rating + skillRating / currentUser.skills.length * 15;
      } else if (tempMentor.type == MentorShipType.Skills) {
        int skillRating = 0;
        for (Skill tempSkill in currentUser.skills) {
          List<topicSubjects> currentTopics = [];
          if (tempSkill.className == tempMentor.mentoringSkill[0].className)
            rating = rating + 5;
          for (topicSubjects temp in subjectList) {
            if (tempSkill.types!.contains(temp.clubType)) {
              currentTopics.add(temp);
            }
          }
          for (topicSubjects temp in currentTopics) {
            if (tempMentor.mentorSubjectClass == temp.clubTypeString) {
              skillRating += 1;
              break;
            }
          }
        }
        rating = rating + skillRating / currentUser.skills.length * 25;
        int clubRating = 0;
        for (clubAppData tempSkill in currentUser.clubs) {
          topicSubjects currentTopics = subjectList[0];
          for (topicSubjects temp in subjectList) {
            if (tempSkill.clubData.type == temp.clubType) {
              currentTopics = temp;
            }
          }
          if (tempMentor.mentorSubjectClass == currentTopics.clubTypeString) {
            clubRating += 1;
            break;
          }
        }
        rating = rating + clubRating / currentUser.clubs.length * 15;
        int tempRating = 0;
        double classRating = 0;
        for (schoolClassStudent tempClass in currentUser.classes) {
          if (tempClass.classInfo!.subjects
              .contains(tempMentor.mentorSubjectClass)) tempRating++;
        }
        classRating =
            classRating + tempRating / currentUser.classes.length * 15;
        rating = rating + classRating;
      } else {
        int skillRating = 0;
        for (Skill tempSkill in currentUser.skills) {
          List<topicSubjects> currentTopics = [];
          for (topicSubjects temp in subjectList) {
            if (tempSkill.types!.contains(temp.clubType)) {
              currentTopics.add(temp);
            }
          }
          for (topicSubjects temp in currentTopics) {
            if (tempMentor.mentorSubjectClass == temp.clubTypeString) {
              skillRating += 1;
              break;
            }
          }
        }
        rating = rating + skillRating / currentUser.skills.length * 16.66;
        int clubRating = 0;
        for (clubAppData tempSkill in currentUser.clubs) {
          topicSubjects currentTopics = subjectList[0];
          for (topicSubjects temp in subjectList) {
            if (tempSkill.clubData.type == temp.clubType) {
              currentTopics = temp;
            }
          }
          if (tempMentor.mentorSubjectClass == currentTopics.clubTypeString) {
            clubRating += 1;
            break;
          }
        }
        rating = rating + clubRating / currentUser.clubs.length * 16.66;
        int tempRating = 0;
        double classRating = 0;
        for (schoolClassStudent tempClass in currentUser.classes) {
          if (tempClass.classInfo!.subjects
              .contains(tempMentor.mentorSubjectClass)) tempRating++;
        }
        classRating =
            classRating + tempRating / currentUser.classes.length * 16.66;
        rating = rating + classRating;
      }
      answer.add(MentorSort(rating, tempMentor));
    }
    answer.sort((a, b) => a.rating.compareTo(b.rating));
    List<Mentor> answerList = [];
    for (MentorSort tempMentorElement in answer) {
      print("topic : " + tempMentorElement.m.getMentorTopicName() + " rating : " + tempMentorElement.rating.toString());
      answerList.insert(0, tempMentorElement.m);
    }
    return answerList;
  }

  void initStateFunction() async {
    List<Map> data = await supaBase.from("MentorPosts").select();
    allMentorPosts = [];
    afterFilterScreen = [];
    for (Map d in data) {
      Mentor m = Mentor();
      m.parseJson(d);
      allMentorPosts.add(m);
    }
    for(Mentor m in allMentorPosts){
      afterFilterScreen.add(m);
    }

    afterFilterScreen = sortAllMyMentors(afterFilterScreen);

    setState(() {
      
    });
    setState(() {});
  }
  List<Mentor> mentorDisplayList = [];
  void initState() {
    initStateFunction();
    
    networkSearchTec.addListener(() {
      mentorDisplayList = [];
      for(Mentor m in allMentorPosts){
        m.getGScore(networkSearchTec.text);
        if(m.gScore > 0) mentorDisplayList.add(m);
      }
      mentorDisplayList.sort((a, b) => a.gScore.compareTo(b.gScore));
      mentorDisplayList = [...mentorDisplayList.reversed];
      setState(() {});
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Container(
            height: height,
            width: width,
            color: backgroundColor,
            child: Stack(children: [
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
                  bottom: false,
                  child: Container(
                      height: height,
                      width: width,
                      child: Column(children: [
                        Container(
                          height: height * 0.015,
                        ),
                        Container(
                          width: width,
                          height: height * 0.062,
                          child: Row(
                            children: [
                              
                              Container(
                                height: height * 0.062,
                                width: width * 0.8,
                                margin:
                                          EdgeInsets.only(left: width * 0.04),
                                padding: EdgeInsets.only(
                                    left: width * 0.015, right: width * 0.015),
                                decoration: BoxDecoration(
                                    color: backgroundColor,
                                    border: Border.all(
                                        color: orange, width: width * 0.011),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Row(
                                  children: [
                                    Container(
                                      height: height * 0.062,
                                      width: width * 0.73,
                                      child: TextField(
                                        controller: networkSearchTec,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                              left: width * 0.01,
                                              right: 0,
                                              top: 0,
                                              bottom: height * 0.0035),
                                          hintText: " Search Mentors",
                                          hintStyle: GoogleFonts.fredoka(
                                              color: orange,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 30),
                                        ),
                                        cursorHeight: height * 0.036,
                                        cursorWidth: width * 0.01,
                                        cursorColor: darkOrange,
                                        maxLines: 1,
                                        style: GoogleFonts.fredoka(
                                            color: orange,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 30),
                                      ),
                                    ),
                                  ],
                                ),
                              ), 
                              SizedBox(
                                width: width * 0.01,
                              ),
                              InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      height: height * 0.062,
                                      width: height * 0.062,
                                      
                                      decoration: BoxDecoration(
                                        color: red, 
                                        border: Border.all(
                                          width: width * 0.012, 
                                          color: darkRed
                                        ), 
                                        borderRadius: BorderRadius.all(Radius.circular(8))
                                      ),
                                      padding: EdgeInsets.all(
                                        width * 0.02
                                      ),
                                      child: ImageIcon(
                                        AssetImage("assets/images/back.png"),
                                        color: backgroundColor,
                                      ),
                                    )),
                              
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.007,
                        ),
                        Expanded(
                            child: Container(
                                width: width,
                                child: Column(children: [
                                  Expanded(
                                    child: Container(
                                        width: width,
                                        child: Stack(
                                          children: [
                                            Container(
                                              width: width,
                                              height: height,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: height * 0.04,
                                                    width: width * 0.93,
                                                    child: Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (c) {
                                                              return MentorFilterScreen(
                                                                  filter);
                                                            }));
                                                          },
                                                          child: Container(
                                                            height:
                                                                height * 0.038,
                                                            width: width * 0.25,
                                                            margin: EdgeInsets.only(
                                                                top: height *
                                                                    0.001,
                                                                bottom: height *
                                                                    0.0015,
                                                                right: width *
                                                                    0.02),
                                                            decoration:
                                                                BoxDecoration(
                                                                    color:
                                                                        orange,
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: darkOrange
                                                                          .withOpacity(
                                                                              0.5),
                                                                      width: width *
                                                                          0.01,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(8))),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                  width: width *
                                                                      0.015,
                                                                ),
                                                                ImageIcon(
                                                                  AssetImage(
                                                                    "assets/images/add_school.png",
                                                                  ),
                                                                  color:
                                                                      backgroundColor,
                                                                  size: 13.5,
                                                                ),
                                                                SizedBox(
                                                                  width: width *
                                                                      0.015,
                                                                ),
                                                                Text(
                                                                  "Filters",
                                                                  style: GoogleFonts.fredoka(
                                                                      color:
                                                                          backgroundColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          MediaQuery.of(context).textScaleFactor *
                                                                              19,
                                                                      letterSpacing: width *
                                                                          0.01 /
                                                                          4.5),
                                                                ),
                                                                SizedBox(
                                                                  width: width *
                                                                      0.015,
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      ListView(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    children: [],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.01,
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      width: width,
                                                      child: ListView(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        children: [
                                                          ...(mentorDisplayList.length == 0 && networkSearchTec.text.length == 0 ? afterFilterScreen : mentorDisplayList)
                                                              .map((e) {
                                                            if (filter
                                                                    .fitsFilter(
                                                                        e) ==
                                                                false) {
                                                              return Container();
                                                            }
                                                            return InkWell(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder:
                                                                            (c) {
                                                                  return MentorDetailScreen(
                                                                      e);
                                                                }));
                                                              },
                                                              child: Stack(
                                                                children: [
                                                                  Container(
                                                                      height: height *
                                                                          0.17,
                                                                      margin: EdgeInsets.only(
                                                                          left: width *
                                                                              0.02,
                                                                          right: width *
                                                                              0.02,
                                                                          bottom: height *
                                                                              0.01),
                                                                      decoration: BoxDecoration(
                                                                          color:
                                                                              orange,
                                                                          border: Border.all(
                                                                              color: darkOrange.withOpacity(
                                                                                  0.5),
                                                                              width: width *
                                                                                  0.017),
                                                                          borderRadius: BorderRadius.circular(
                                                                              15)),
                                                                      padding: EdgeInsets.all(width *
                                                                          0.02),
                                                                      child: Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Container(
                                                                                  height: height * 0.066,
                                                                                  width: height * 0.066,
                                                                                  padding: EdgeInsets.all(width * 0.02),
                                                                                  decoration: BoxDecoration(border: Border.all(color: darkOrange.withOpacity(0.5), width: width * 0.012), borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                                  child: ClipRRect(
                                                                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                                                                      child: ImageIcon(
                                                                                        AssetImage(e.getIconImageAddress()),
                                                                                        color: backgroundColor,
                                                                                      )),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: width * 0.02,
                                                                                ),
                                                                                Container(
                                                                                  width: width * 0.6,
                                                                                  margin: EdgeInsets.only(top: height * 0.0),
                                                                                  child: Text(
                                                                                    e.getMentorTopicName(),
                                                                                    textAlign: TextAlign.left,
                                                                                    maxLines: 2,
                                                                                    style: GoogleFonts.fredoka(color: Colors.grey.shade200, fontWeight: FontWeight.w600, fontSize: e.getMentorTopicName().length <= 25 ? MediaQuery.of(context).textScaleFactor * 26.5 : MediaQuery.of(context).textScaleFactor * 22, height: 1.15),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: height * 0.005,
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Container(
                                                                                  width: width * 0.43,
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Row(children: [
                                                                                        Container(
                                                                                          height: height * 0.03,
                                                                                          child: FittedBox(
                                                                                            fit: BoxFit.fitHeight,
                                                                                            child: Text(
                                                                                              "Mentor:",
                                                                                              style: GoogleFonts.fredoka(color: backgroundColor, fontWeight: FontWeight.w700),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ]),
                                                                                      Row(
                                                                                        children: [
                                                                                          Container(
                                                                                            height: height * 0.03,
                                                                                            width: height * 0.03,
                                                                                            decoration: BoxDecoration(border: Border.all(color: darkOrange.withOpacity(0.5), width: width * 0.005), borderRadius: BorderRadius.circular(5)),
                                                                                            child: ClipRRect(
                                                                                              borderRadius: BorderRadius.all(Radius.circular(2)),
                                                                                              child: Image.network(
                                                                                                allUsers[e.userEmail]!.image,
                                                                                                fit: BoxFit.fill,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: width * 0.007,
                                                                                          ),
                                                                                          Container(
                                                                                            height: height * 0.031,
                                                                                            margin: EdgeInsets.only(bottom: height * 0.001),
                                                                                            child: FittedBox(
                                                                                              fit: BoxFit.fitHeight,
                                                                                              child: Text(
                                                                                                allUsers[e.userEmail]!.firstName + " " + allUsers[e.userEmail]!.lastName,
                                                                                                style: GoogleFonts.fredoka(color: backgroundColor, fontWeight: FontWeight.w600),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  width: width * 0.445,
                                                                                  margin: EdgeInsets.only(bottom: height * 0.006),
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Row(children: [
                                                                                        Container(
                                                                                          height: height * 0.03,
                                                                                          child: FittedBox(
                                                                                            fit: BoxFit.fitHeight,
                                                                                            child: Text(
                                                                                              "Rating:",
                                                                                              style: GoogleFonts.fredoka(color: backgroundColor, fontWeight: FontWeight.w700),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Expanded(child: Container()),
                                                                                        Container(
                                                                                          height: height * 0.03,
                                                                                          child: FittedBox(
                                                                                            fit: BoxFit.fitHeight,
                                                                                            child: Text(
                                                                                              e.numberOfRating.toString() + " Reviews",
                                                                                              style: GoogleFonts.fredoka(color: backgroundColor, fontWeight: FontWeight.w700),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Container()
                                                                                      ]),
                                                                                      SizedBox(
                                                                                        height: height * 0.001,
                                                                                      ),
                                                                                      Row(
                                                                                        children: [
                                                                                          Stack(
                                                                                            children: [
                                                                                              SizedBox(
                                                                                                height: height * 0.025,
                                                                                                width: height * 0.025,
                                                                                                child: ImageIcon(
                                                                                                  AssetImage("assets/images/star.png"),
                                                                                                  color: e.rating >= 1 ? Color(0xffFFC300) : backgroundColor,
                                                                                                ),
                                                                                              ),
                                                                                              Container(
                                                                                                height: height * 0.025,
                                                                                                width: height * 0.025,
                                                                                                child: Center(
                                                                                                  child: SizedBox(
                                                                                                    height: height * 0.018,
                                                                                                    child: ImageIcon(
                                                                                                      AssetImage("assets/images/star.png"),
                                                                                                      color: e.rating >= 1 ? Color(0xffFFD700) : backgroundColor,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                          Container(
                                                                                            width: width * 0.0125,
                                                                                          ),
                                                                                          Stack(
                                                                                            children: [
                                                                                              SizedBox(
                                                                                                height: height * 0.025,
                                                                                                width: height * 0.025,
                                                                                                child: ImageIcon(
                                                                                                  AssetImage("assets/images/star.png"),
                                                                                                  color: e.rating >= 2 ? Color(0xffFFC300) : backgroundColor,
                                                                                                ),
                                                                                              ),
                                                                                              Container(
                                                                                                height: height * 0.025,
                                                                                                width: height * 0.025,
                                                                                                child: Center(
                                                                                                  child: SizedBox(
                                                                                                    height: height * 0.018,
                                                                                                    child: ImageIcon(
                                                                                                      AssetImage("assets/images/star.png"),
                                                                                                      color: e.rating >= 2 ? Color(0xffFFD700) : backgroundColor,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                          Container(
                                                                                            width: width * 0.01,
                                                                                          ),
                                                                                          Stack(
                                                                                            children: [
                                                                                              SizedBox(
                                                                                                height: height * 0.025,
                                                                                                width: height * 0.025,
                                                                                                child: ImageIcon(
                                                                                                  AssetImage("assets/images/star.png"),
                                                                                                  color: e.rating >= 3 ? Color(0xffFFC300) : backgroundColor,
                                                                                                ),
                                                                                              ),
                                                                                              Container(
                                                                                                height: height * 0.025,
                                                                                                width: height * 0.025,
                                                                                                child: Center(
                                                                                                  child: SizedBox(
                                                                                                    height: height * 0.018,
                                                                                                    child: ImageIcon(
                                                                                                      AssetImage("assets/images/star.png"),
                                                                                                      color: e.rating >= 3 ? Color(0xffFFD700) : backgroundColor,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                          Container(
                                                                                            width: width * 0.0125,
                                                                                          ),
                                                                                          Stack(
                                                                                            children: [
                                                                                              SizedBox(
                                                                                                height: height * 0.025,
                                                                                                width: height * 0.025,
                                                                                                child: ImageIcon(
                                                                                                  AssetImage("assets/images/star.png"),
                                                                                                  color: e.rating >= 4 ? Color(0xffFFC300) : backgroundColor,
                                                                                                ),
                                                                                              ),
                                                                                              Container(
                                                                                                height: height * 0.025,
                                                                                                width: height * 0.025,
                                                                                                child: Center(
                                                                                                  child: SizedBox(
                                                                                                    height: height * 0.018,
                                                                                                    child: ImageIcon(
                                                                                                      AssetImage("assets/images/star.png"),
                                                                                                      color: e.rating >= 4 ? Color(0xffFFD700) : backgroundColor,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                          Container(
                                                                                            width: width * 0.0125,
                                                                                          ),
                                                                                          Stack(
                                                                                            children: [
                                                                                              SizedBox(
                                                                                                height: height * 0.025,
                                                                                                width: height * 0.025,
                                                                                                child: ImageIcon(
                                                                                                  AssetImage("assets/images/star.png"),
                                                                                                  color: e.rating >= 5 ? Color(0xffFFC300) : backgroundColor,
                                                                                                ),
                                                                                              ),
                                                                                              Container(
                                                                                                height: height * 0.025,
                                                                                                width: height * 0.025,
                                                                                                child: Center(
                                                                                                  child: SizedBox(
                                                                                                    height: height * 0.018,
                                                                                                    child: ImageIcon(
                                                                                                      AssetImage("assets/images/star.png"),
                                                                                                      color: e.rating >= 5 ? Color(0xffFFD700) : backgroundColor,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                          Container(
                                                                                            width: width * 0.0125,
                                                                                          ),
                                                                                        ],
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ])),
                                                                  currentUser.mentorContainedinMentorList(e, currentUser.mentorRequestsSent) || currentUser.mentorContainedinMentorList(e, currentUser.mentors) ? 
                                                                  Container() : 
                                                                  Positioned(
                                                                    right: width *
                                                                        0.065,
                                                                    top: width *
                                                                        0.05,
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () async {
                                                                            await currentUser.addMentorRequest(e);
                                                                            setState(() {
                                                                              
                                                                            });
                                                                            print("done");
                                                                          },
                                                                      child: Container(
                                                                          height: height * 0.045,
                                                                          width: height * 0.045,
                                                                          padding: EdgeInsets.all(width * 0.015),
                                                                          child: FittedBox(
                                                                            child:
                                                                                ImageIcon(
                                                                              AssetImage("assets/images/link.png"),
                                                                              color: backgroundColor,
                                                                            ),
                                                                            fit:
                                                                                BoxFit.fitHeight,
                                                                          )),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          })
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            /*Positioned(
                                              bottom: height * 0.02,
                                              child: Container(
                                                width: width,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                      onTap: () async {
                                                        var temp = await Navigator
                                                                .of(context)
                                                            .push(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (ctx) {
                                                          return CreateMentorPostScreen();
                                                        }));
                                                        initStateFunction();
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            width * 0.01),
                                                        decoration: BoxDecoration(
                                                            color:
                                                                backgroundColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15))),
                                                        child: Container(
                                                          height: height * 0.07,
                                                          width: height * 0.07,
                                                          decoration: BoxDecoration(
                                                              color: orange,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              12)),
                                                              border: Border.all(
                                                                  color: darkOrange
                                                                      .withOpacity(
                                                                          0.5),
                                                                  width: width *
                                                                      0.0125)),
                                                          padding:
                                                              EdgeInsets.all(
                                                                  width * 0.02),
                                                          child: FittedBox(
                                                            fit: BoxFit
                                                                .fitHeight,
                                                            child: ImageIcon(
                                                              AssetImage(
                                                                  "assets/images/add_school.png"),
                                                              color:
                                                                  backgroundColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )*/
                                          ],
                                        )),
                                  )
                                ])))
                      ])))
            ])));
  }
}

class MentorSort {
  double rating;
  Mentor m;
  MentorSort(this.rating, this.m);
}

class MyPostsMentoreePage extends StatefulWidget {
  const MyPostsMentoreePage({super.key});

  @override
  State<MyPostsMentoreePage> createState() => _MyPostsMentoreePageState();
}

class _MyPostsMentoreePageState extends State<MyPostsMentoreePage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: height,
      child: Column(
        children: [],
      ),
    );
  }
}
