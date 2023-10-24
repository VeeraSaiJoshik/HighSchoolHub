// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/models/club.dart';
import 'package:highschoolhub/models/mentor.dart';
import 'package:highschoolhub/models/skills.dart';
import 'package:lottie/lottie.dart';

import '../../globalInfo.dart';

import '../../main.dart';
import '../../models/class.dart';
import '../../models/school.dart';
import '../AuthenticationPage.dart';
import '../SignUp.dart' as su;

import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

import '../SignUp.dart';


class CreateMentorPostScreen extends StatefulWidget {
  const CreateMentorPostScreen({super.key});

  @override
  State<CreateMentorPostScreen> createState() => _CreateMentorPostScreenState();
}

class _CreateMentorPostScreenState extends State<CreateMentorPostScreen> {
  @override
  List skills = [];
  List skillsRecommendedList = [];
  Future<int> getSkillsFromDatabase() async {
    final result = await supaBase.from("Skills").select();
    skills = [];
    for (Map data in result) {
      Skill value = Skill();
      value.fromJSON(data);
      skills.add(value);
    }
    return 1;
  }

  TextEditingController skillsTec = TextEditingController();
  bool skillSearchVisibility = false;
  void toggleSkillSearchVisibility() {
    setState(() {
      skillSearchVisibility = !skillSearchVisibility;
    });
  }

  Mentor currentMentor = Mentor(userEmail: currentUser.email);

  bool showBlackScreen = false;
  bool showSchoolScreen = false;
  bool keyboardUp = false;
  bool searchResultsLoading = false;
  List classes = [];
  List classesQueryList = [];
  TextEditingController classesTec = new TextEditingController();
  TextEditingController descriptionTec = new TextEditingController();
  Future<int> getClassOptions() async {
    final result = await supaBase.from("Classes").select();
    classes = [];
    for (Map data in result) {
      schoolClassDatabase value = schoolClassDatabase();
      value.fromJson(data);
      if (value.schoolAssociatedWith.isEmpty) {
        classes.add(value);
      } else {
        for (Map data2 in data["Schools"]) {
          bool contains = false;
          for (School schoolData in currentUser.schools) {
            if (data2["name"] == schoolData.name && contains == false) {
              classes.add(value);
              contains = true;
            }
          }
          if (contains) break;
        }
      }
    }
    return 1;
  }

  List sortListByQuery(List corpus, String query) {
    List<List> tempList = [];
    print(corpus.length);
    List finalStringList = [];
    for (var value in corpus) {
      value.getCorpusRatingFromQuery(query);
    }
    corpus.sort((a, b) {
      if (a.gScore.compareTo(b.gScore) != 0)
        return a.gScore.compareTo(b.gScore);
      return a.className.compareTo(b.className);
    });
    int i = 0;

    for (var value in corpus.reversed) {
      if (value.gScore != 0 && i <= 6) {
        finalStringList.add(value);
      }
      i++;
    }
    return finalStringList;
  }

  void toggleSchoolScreen() {
    toggleBlackScreen();
    setState(() {
      showSchoolScreen = !showSchoolScreen;
    });
  }

  void toggleBlackScreen() {
    setState(() {
      showBlackScreen = !showBlackScreen;
    });
  }

  void changeType(MentorShipType other) {
    setState(() {
      currentMentor.type = other;
    });
  }

  void changeMeetLocation(MentorShipMeetLocation other) {
    setState(() {
      currentMentor.location = other;
    });
  }

  void changeClupTopicType(ClubType c) {
    setState(() {
      currentMentor.mentorSubject = c;
    });
  }

  void initStateFunciton() async {
    await getClassOptions();
    await getSkillsFromDatabase();
    classesQueryList = classes;
    skillsRecommendedList = skills;
  }

  void initState() {
    currentMentor.type = MentorShipType.Classes;

    initStateFunciton();
    skillsTec.addListener(() {
      skillsRecommendedList = sortListByQuery(skills, skillsTec.text);
      setState(() {});
    });
    classesTec.addListener(() {
      setState(() {
        classesQueryList = sortListByQuery(classes, classesTec.text);
      });
    });
    setState(() {});
    super.initState();
  }

  bool classesPickerVisibility = false;
  void showClassesPickerVisibility() {
    setState(() {
      classesPickerVisibility = !classesPickerVisibility;
    });
  }

  Future<School> getFullSchoolData(
      String schoolName, String formattedName) async {
    String ogName = schoolName;
    String tempSchoolName = schoolName.replaceAll(" ", "+");

    schoolName = schoolName.replaceAll(" ", "+") + "+Crest";
    String searchUrl = "https://www.google.com/search?q=" +
        schoolName +
        "&tbm=isch&ved=2ahUKEwiCvdaK3KWAAxXwPN4AHW6nCg8Q2-cCegQIABAA&oq=" +
        schoolName +
        "&gs_lcp=CgNpbWcQAzoECCMQJzoFCAAQgAQ6CAgAEIAEELEDOggIABCxAxCDAToHCAAQigUQQzoLCAAQgAQQsQMQgwE6BAgAEAM6BwgjEOoCECc6BwgAEBgQgAQ6BggAEAgQHjoECAAQHlDqgQFYg7YBYLG3AWgCcAB4AIABYIgBthOSAQI0NJgBAKABAaoBC2d3cy13aXotaW1nsAEKwAEB&sclient=img&ei=YZS9ZMKIAvD5-LYP7s6qeA&bih=1047&biw=1241";
    Uri url = Uri.parse(searchUrl);
    var response = await http.get(url);
    var document = parser.parse(response.body);
    List<dom.Element> images = document.getElementsByTagName("img");
    String imageURL = images[1].attributes["src"] as String;
    searchUrl =
        "https://nces.ed.gov/ccd/schoolsearch/school_list.asp?Search=1&InstName=" +
            tempSchoolName +
            "&SchoolID=&Address=&City=&State=&Zip=&Miles=&County=&PhoneAreaCode=&Phone=&DistrictName=&DistrictID=&SchoolType=1&SchoolType=2&SchoolType=3&SchoolType=4&SpecificSchlTypes=all&IncGrade=-1&LoGrade=-1&HiGrade=-1";
    url = Uri.parse(searchUrl);
    response = await http.get(url);
    document = parser.parse(response.body);
    List<dom.Element> actualLinkList = document.getElementsByTagName("a");
    for (dom.Element link in actualLinkList) {
      try {
        if (link.attributes["href"]!.contains("school_detail.asp")) {
          searchUrl = "https://nces.ed.gov/ccd/schoolsearch/" +
              link.attributes["href"]!;
          break;
        }
      } catch (e) {}
    }
    for (dom.Element link in actualLinkList) {
      try {
        if (link.attributes["title"]!.contains("Map latest data")) {
          break;
        }
      } catch (e) {}
    }
    url = Uri.parse(searchUrl);
    response = await http.get(url);
    document = parser.parse(response.body);
    List<dom.Element> gradeProspects = document.getElementsByTagName("font");
    late su.Range gradeRange;
    for (dom.Element element in gradeProspects) {
      if (element.text.contains("(grades")) {
        List<String> gradeRateText =
            element.text.replaceAll("(", "").replaceAll(")", "").split(" ");
        int lowerBound, upperBound;
        if (gradeRateText[gradeRateText.indexOf("-") - 1] == "KG") {
          lowerBound = 1;
        } else {
          lowerBound = int.parse(gradeRateText[gradeRateText.indexOf("-") - 1]);
        }
        upperBound = int.parse(gradeRateText[gradeRateText.indexOf("-") + 1]);
        gradeRange = su.Range(lowerBound, upperBound);
        break;
      }
    }
    List<dom.Element> address = document.getElementsByTagName("font");
    School finalAnswer = School(image: imageURL, name: formattedName);
    finalAnswer.grades = gradeRange.returnNumberInRange();
    actualLinkList = document.getElementsByTagName("a");
    String tempAddress = "";
    for (dom.Element link in actualLinkList) {
      try {
        if (link.attributes["title"]!.contains("Map latest data")) {
          List<dom.Element> elements = link.children;
          searchUrl = link.attributes["href"]!;
          tempAddress = link.text;
          print(link.children[0].outerHtml);
        }
      } catch (e) {}
    }
    String apiKey = googleMpasApiKey;
    final encodedAddress = Uri.encodeQueryComponent(tempAddress);
    final url2 =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$encodedAddress&key=$apiKey';
    http.Response results = await http.get(Uri.parse(url2));

    final data = json.decode(results.body);
    finalAnswer.address.fromJson(data["results"][0]);
    return finalAnswer;
  }

  Future<List> getWebsiteData() async {
    setState(() {
      searchResultsLoading = true;
      print("yeah");
    });
    List finalAnswersList = [];
    String enteredSchool = schoolTec.text;
    String stringUrl =
        "https://nces.ed.gov/ccd/schoolsearch/school_list.asp?Search=1&InstName=" +
            enteredSchool.replaceAll(" ", "+") +
            "&SchoolID=&Address=&City=&State=&Zip=&Miles=&County=&PhoneAreaCode=&Phone=&DistrictName=&DistrictID=&SchoolType=1&SchoolType=2&SchoolType=3&SchoolType=4&SpecificSchlTypes=all&IncGrade=-1&LoGrade=-1&HiGrade=-1";
    print(stringUrl);
    final url = Uri.parse(stringUrl);
    final response = await http.get(url);
    var document = parser.parse(response.body);
    List<dom.Element> getItems = document.getElementsByTagName("strong");
    List<String> actualStringRecommendationList = [];
    bool startAdding = false;
    for (int i = 0; i < getItems.length; i++) {
      if (startAdding &&
          getItems[i].text.contains("Page 1") == false &&
          getItems[i].text != "") {
        actualStringRecommendationList.add(getItems[i].text);
      } else if (startAdding == true) {
        startAdding = false;
      }
      if (getItems[i].text.contains("Grades")) {
        startAdding = true;
      }
    }
    setState(() {
      searchResultsLoading = false;
      print("yeah");
    });
    if (actualStringRecommendationList.length == 0) {
      return ["none"];
    }
    return actualStringRecommendationList;
  }

  List recList = [];
  TextEditingController schoolTec = new TextEditingController();
  void getSchoolData() async {
    recList = await getWebsiteData();
    print(recList);
    setState(() {
      recList;
    });
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        color: orange,
        child: Stack(
          children: [
            Opacity(
              opacity: 0.2,
              child: SizedBox(
                height: height,
                width: width,
                child: Image.asset(
                  "assets/images/backdrop.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
                width: width,
                child: Column(children: [
                  Container(
                    height: width * 0.04,
                  ),
                  Container(
                      width: width * 0.94,
                      height: height - width * 0.08,
                      decoration: BoxDecoration(
                          color: backgroundColor,
                          border: Border.all(
                              color: Colors.grey.shade300, width: width * 0.01),
                          borderRadius: BorderRadius.all(Radius.circular(35))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Container(
                              width: width * 0.92,
                              height: height * 0.07,
                              child: Row(children: [
                                Container(
                                  width: height * 0.02,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    height: height * 0.068,
                                    width: height * 0.068,
                                    decoration: BoxDecoration(
                                        color: red,
                                        border: Border.all(
                                            color: darkRed,
                                            width: width * 0.012),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    padding: EdgeInsets.all(width * 0.03),
                                    child:
                                        Image.asset("assets/images/back.png"),
                                  ),
                                ),
                                Container(
                                  width: width * 0.05,
                                ),
                                Container(
                                    height: height * 0.06,
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Text(
                                        "Mentor Post",
                                        style: GoogleFonts.fredoka(
                                          color: orange,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ))
                              ])),
                          SizedBox(
                            height: width * 0.02,
                          ),
                          Expanded(
                            child: Container(
                              width: width,
                              margin: EdgeInsets.symmetric(
                                  horizontal: width * 0.02),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: ListView(
                                  padding: EdgeInsets.zero,
                                  children: [
                                    Container(
                                      width: width * 0.87,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: height * 0.038,
                                            margin: EdgeInsets.only(
                                                left: width * 0.035,
                                                top: width * 0.02),
                                            child: FittedBox(
                                              fit: BoxFit.fitHeight,
                                              child: Text(
                                                "Mentorship Options :",
                                                style: GoogleFonts.fredoka(
                                                  color: orange,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: height * 0.002,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: width * 0.025,
                                                vertical: height * 0.002),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                MentorshipOptionWidget(
                                                    currentMentor.type,
                                                    MentorShipType.Classes,
                                                    "classes",
                                                    "Classes",
                                                    changeType),
                                                MentorshipOptionWidget(
                                                    currentMentor.type,
                                                    MentorShipType.Skills,
                                                    "skills",
                                                    "Skills",
                                                    changeType),
                                                MentorshipOptionWidget(
                                                    currentMentor.type,
                                                    MentorShipType.Other,
                                                    "clubs",
                                                    "Other",
                                                    changeType),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: width * 0.025,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    // Mentor Class Choice
                                    currentMentor.type == MentorShipType.Classes
                                        ? Container(
                                            width: width * 0.87,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                            ),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: height * 0.038,
                                                        margin: EdgeInsets.only(
                                                            left: width * 0.035,
                                                            top: width * 0.02),
                                                        child: FittedBox(
                                                          fit: BoxFit.fitHeight,
                                                          child: Text(
                                                            "Mentor Class Choice :",
                                                            style: GoogleFonts
                                                                .fredoka(
                                                              color: currentMentor
                                                                          .mentoringClass
                                                                          .length ==
                                                                      1
                                                                  ? currentMentor
                                                                      .mentoringClass[
                                                                          0]
                                                                      .getColor()
                                                                  : orange,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  currentMentor.mentoringClass
                                                              .length ==
                                                          1
                                                      ? InkWell(
                                                          onTap: () {
                                                            toggleBlackScreen();
                                                            showClassesPickerVisibility();
                                                          },
                                                          child: Container(
                                                            height:
                                                                height * 0.09,
                                                            width: width * 0.83,
                                                            decoration: BoxDecoration(
                                                                color: currentMentor
                                                                    .mentoringClass[
                                                                        0]
                                                                    .getColor(),
                                                                border: Border.all(
                                                                    color: currentMentor
                                                                        .mentoringClass[
                                                                            0]
                                                                        .getDColor(),
                                                                    width: width *
                                                                        0.013),
                                                                borderRadius:
                                                                    BorderRadius.all(
                                                                        Radius.circular(
                                                                            13))),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                  width: width *
                                                                      0.013,
                                                                ),
                                                                Container(
                                                                    height:
                                                                        height *
                                                                            0.066,
                                                                    width:
                                                                        height *
                                                                            0.066,
                                                                    margin: EdgeInsets.only(
                                                                        top: height *
                                                                            0.00),
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade200,
                                                                        border: Border.all(
                                                                            color: currentMentor.mentoringClass[0]
                                                                                .getDColor(),
                                                                            width: width *
                                                                                0.01),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10)),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.all(
                                                                          width *
                                                                              0.018),
                                                                      child: FittedBox(
                                                                          fit: BoxFit.fitHeight,
                                                                          child: ImageIcon(
                                                                            AssetImage(currentMentor.mentoringClass[0].getImageAddy()),
                                                                            color:
                                                                                currentMentor.mentoringClass[0].getColor(),
                                                                          )),
                                                                    )),
                                                                SizedBox(
                                                                  width: width *
                                                                      0.018,
                                                                ),
                                                                Container(
                                                                  width: width *
                                                                      0.6,
                                                                  margin: EdgeInsets.only(
                                                                      top: height *
                                                                          0.0),
                                                                  child: Text(
                                                                    currentMentor
                                                                        .mentoringClass[
                                                                            0]
                                                                        .className,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    maxLines: 2,
                                                                    style: GoogleFonts.fredoka(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade200,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontSize: currentMentor.mentoringClass[0].className.length <= 25
                                                                            ? MediaQuery.of(context).textScaleFactor *
                                                                                28
                                                                            : MediaQuery.of(context).textScaleFactor *
                                                                                18,
                                                                        height:
                                                                            1),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : InkWell(
                                                          onTap: () {
                                                            toggleBlackScreen();
                                                            showClassesPickerVisibility();
                                                          },
                                                          child: Container(
                                                            height:
                                                                height * 0.09,
                                                            width: width * 0.83,
                                                            decoration: BoxDecoration(
                                                                color: orange,
                                                                border: Border.all(
                                                                    color: darkOrange
                                                                        .withOpacity(
                                                                            0.5),
                                                                    width: width *
                                                                        0.013),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            13))),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                  width: width *
                                                                      0.013,
                                                                ),
                                                                Container(
                                                                    height:
                                                                        height *
                                                                            0.066,
                                                                    width:
                                                                        height *
                                                                            0.066,
                                                                    margin: EdgeInsets.only(
                                                                        top: height *
                                                                            0.00),
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade200,
                                                                        border: Border.all(
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                226,
                                                                                98,
                                                                                0),
                                                                            width: width *
                                                                                0.01),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10)),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.all(
                                                                          width *
                                                                              0.018),
                                                                      child:
                                                                          FittedBox(
                                                                        fit: BoxFit
                                                                            .fitHeight,
                                                                        child:
                                                                            ImageIcon(
                                                                          AssetImage(
                                                                              "assets/images/suggestedConnectionsImages/classes.png"),
                                                                          color:
                                                                              orange,
                                                                        ),
                                                                      ),
                                                                    )),
                                                                SizedBox(
                                                                  width: width *
                                                                      0.018,
                                                                ),
                                                                Container(
                                                                  width: width *
                                                                      0.6,
                                                                  margin: EdgeInsets.only(
                                                                      top: height *
                                                                          0.0),
                                                                  child: Text(
                                                                    "Choose Class",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    maxLines: 2,
                                                                    style: GoogleFonts.fredoka(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade200,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontSize: "Choose School".length <= 25
                                                                            ? MediaQuery.of(context).textScaleFactor *
                                                                                28
                                                                            : MediaQuery.of(context).textScaleFactor *
                                                                                18,
                                                                        height:
                                                                            1),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                  SizedBox(
                                                    height: height * 0.01,
                                                  ),
                                                ]))
                                        // Mentor Skill Choice
                                        : currentMentor.type ==
                                                MentorShipType.Skills
                                            ? Container(
                                                width: width * 0.87,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15)),
                                                ),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            height:
                                                                height * 0.038,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: width *
                                                                        0.035,
                                                                    top: width *
                                                                        0.02),
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                              child: Text(
                                                                "Mentor Skill Choice :",
                                                                style:
                                                                    GoogleFonts
                                                                        .fredoka(
                                                                  color: currentMentor
                                                                              .mentoringClass
                                                                              .length ==
                                                                          1
                                                                      ? currentMentor
                                                                          .mentoringClass[
                                                                              0]
                                                                          .getColor()
                                                                      : orange,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      currentMentor
                                                                  .mentoringSkill
                                                                  .length ==
                                                              1
                                                          ? InkWell(
                                                              onTap: () {
                                                                toggleBlackScreen();
                                                                toggleSkillSearchVisibility();
                                                              },
                                                              child: Container(
                                                                height: height *
                                                                    0.09,
                                                                width: width *
                                                                    0.83,
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                        orange,
                                                                    border: Border.all(
                                                                        color: darkOrange.withOpacity(
                                                                            0.5),
                                                                        width: width *
                                                                            0.013),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(13))),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    SizedBox(
                                                                      width: width *
                                                                          0.013,
                                                                    ),
                                                                    Container(
                                                                        height: height *
                                                                            0.066,
                                                                        width: height *
                                                                            0.066,
                                                                        margin: EdgeInsets.only(
                                                                            top: height *
                                                                                0.00),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.grey.shade200,
                                                                            border: Border.all(color: Color.fromARGB(255, 226, 98, 0), width: width * 0.01),
                                                                            borderRadius: BorderRadius.circular(10)),
                                                                        child: Padding(
                                                                          padding:
                                                                              EdgeInsets.all(width * 0.018),
                                                                          child: FittedBox(
                                                                              fit: BoxFit.fitHeight,
                                                                              child: ImageIcon(
                                                                                AssetImage("assets/images/clubIcons/${currentMentor.mentoringSkill[0].types![0].toReadableString().substring(9)}.png"),
                                                                                color: orange,
                                                                              )),
                                                                        )),
                                                                    SizedBox(
                                                                      width: width *
                                                                          0.018,
                                                                    ),
                                                                    Container(
                                                                      width:
                                                                          width *
                                                                              0.6,
                                                                      margin: EdgeInsets.only(
                                                                          top: height *
                                                                              0.0),
                                                                      child:
                                                                          Text(
                                                                        currentMentor
                                                                            .mentoringSkill[0]
                                                                            .className,
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        maxLines:
                                                                            2,
                                                                        style: GoogleFonts.fredoka(
                                                                            color: Colors
                                                                                .grey.shade200,
                                                                            fontWeight: FontWeight
                                                                                .w600,
                                                                            fontSize: currentMentor.mentoringSkill[0].className.length <= 25
                                                                                ? MediaQuery.of(context).textScaleFactor * 28
                                                                                : MediaQuery.of(context).textScaleFactor * 18,
                                                                            height: 1),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          : InkWell(
                                                              onTap: () {
                                                                toggleBlackScreen();
                                                                toggleSkillSearchVisibility();
                                                              },
                                                              child: Container(
                                                                height: height *
                                                                    0.09,
                                                                width: width *
                                                                    0.83,
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                        orange,
                                                                    border: Border.all(
                                                                        color: darkOrange.withOpacity(
                                                                            0.5),
                                                                        width: width *
                                                                            0.013),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(13))),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    SizedBox(
                                                                      width: width *
                                                                          0.013,
                                                                    ),
                                                                    Container(
                                                                        height: height *
                                                                            0.066,
                                                                        width: height *
                                                                            0.066,
                                                                        margin: EdgeInsets.only(
                                                                            top: height *
                                                                                0.00),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.grey.shade200,
                                                                            border: Border.all(color: Color.fromARGB(255, 226, 98, 0), width: width * 0.01),
                                                                            borderRadius: BorderRadius.circular(10)),
                                                                        child: Padding(
                                                                          padding:
                                                                              EdgeInsets.all(width * 0.024),
                                                                          child:
                                                                              FittedBox(
                                                                            fit:
                                                                                BoxFit.fitHeight,
                                                                            child:
                                                                                ImageIcon(
                                                                              AssetImage("assets/images/suggestedConnectionsImages/skills.png"),
                                                                              color: orange,
                                                                            ),
                                                                          ),
                                                                        )),
                                                                    SizedBox(
                                                                      width: width *
                                                                          0.018,
                                                                    ),
                                                                    Container(
                                                                      width:
                                                                          width *
                                                                              0.6,
                                                                      margin: EdgeInsets.only(
                                                                          top: height *
                                                                              0.0),
                                                                      child:
                                                                          Text(
                                                                        "Choose Skill",
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        maxLines:
                                                                            2,
                                                                        style: GoogleFonts.fredoka(
                                                                            color: Colors
                                                                                .grey.shade200,
                                                                            fontWeight: FontWeight
                                                                                .w600,
                                                                            fontSize: "Choose School".length <= 25
                                                                                ? MediaQuery.of(context).textScaleFactor * 28
                                                                                : MediaQuery.of(context).textScaleFactor * 18,
                                                                            height: 1),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                      SizedBox(
                                                        height: height * 0.01,
                                                      ),
                                                    ]))
                                            // Mentor Other Choice
                                            : Container(
                                                width: width * 0.87,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15)),
                                                ),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            height:
                                                                height * 0.038,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: width *
                                                                        0.035,
                                                                    top: width *
                                                                        0.02),
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                              child: Text(
                                                                "Mentor Choice :",
                                                                style:
                                                                    GoogleFonts
                                                                        .fredoka(
                                                                  color: currentMentor
                                                                              .mentoringClass
                                                                              .length ==
                                                                          1
                                                                      ? currentMentor
                                                                          .mentoringClass[
                                                                              0]
                                                                          .getColor()
                                                                      : orange,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SearchSChoolTextField(
                                                          height * 0.072,
                                                          width * 0.83,
                                                          orange,
                                                          orange,
                                                          "Mentoring Topic",
                                                          0,
                                                          skillsTec,
                                                          () {},
                                                          showButton: false),
                                                      SizedBox(
                                                        height: height * 0.01,
                                                      ),
                                                    ])),

                                    SizedBox(height: height * 0.01),
                                    currentMentor.type != MentorShipType.Other
                                        ? Container()
                                        : Container(
                                            width: width * 0.87,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                            ),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: height * 0.038,
                                                        margin: EdgeInsets.only(
                                                            left: width * 0.035,
                                                            top: width * 0.02),
                                                        child: FittedBox(
                                                          fit: BoxFit.fitHeight,
                                                          child: Text(
                                                            "Topic Subject :",
                                                            style: GoogleFonts
                                                                .fredoka(
                                                              color: orange,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                          child: SizedBox())
                                                    ],
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                width * 0.025,
                                                            vertical:
                                                                height * 0.002),
                                                    width: width * 0.85,
                                                    height: height * 0.12,
                                                    child: ListView(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        children: ClubType
                                                            .values
                                                            .map((e) {
                                                          return MentorshipSubject(
                                                              currentMentor
                                                                  .mentorSubject,
                                                              e,
                                                              "both",
                                                              e
                                                                  .toReadableString()
                                                                  .substring(9),
                                                              changeClupTopicType);
                                                        }).toList()),
                                                  ),
                                                  Container(
                                                    height: width * 0.025,
                                                  ),
                                                ])),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    currentMentor.type == MentorShipType.Classes
                                        ? Container(
                                            width: width * 0.87,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                            ),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: height * 0.038,
                                                        margin: EdgeInsets.only(
                                                            left: width * 0.035,
                                                            top: width * 0.02),
                                                        child: FittedBox(
                                                          fit: BoxFit.fitHeight,
                                                          child: Text(
                                                            "Class Taken At :",
                                                            style: GoogleFonts
                                                                .fredoka(
                                                              color: orange,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                          child: SizedBox())
                                                    ],
                                                  ),
                                                  currentMentor.courseTakenAt
                                                              .length ==
                                                          1
                                                      ? InkWell(
                                                          onTap: () {
                                                            toggleSchoolScreen();
                                                          },
                                                          child: Container(
                                                            height:
                                                                height * 0.09,
                                                            width: width * 0.83,
                                                            decoration: BoxDecoration(
                                                                color: orange,
                                                                border: Border.all(
                                                                    color: darkOrange
                                                                        .withOpacity(
                                                                            0.5),
                                                                    width: width *
                                                                        0.013),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            13))),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                  width: width *
                                                                      0.013,
                                                                ),
                                                                Container(
                                                                    height:
                                                                        height *
                                                                            0.066,
                                                                    width:
                                                                        height *
                                                                            0.066,
                                                                    margin: EdgeInsets.only(
                                                                        top: height *
                                                                            0.00),
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade200,
                                                                        border: Border.all(
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                226,
                                                                                98,
                                                                                0),
                                                                            width: width *
                                                                                0.01),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10)),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.all(
                                                                          width *
                                                                              0.0),
                                                                      child: ClipRRect(
                                                                          borderRadius: BorderRadius.circular(5),
                                                                          child: Image.network(
                                                                            currentMentor.courseTakenAt[0].image,
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          )),
                                                                    )),
                                                                SizedBox(
                                                                  width: width *
                                                                      0.02,
                                                                ),
                                                                Container(
                                                                  width: width *
                                                                      0.6,
                                                                  margin: EdgeInsets.only(
                                                                      top: height *
                                                                          0.0),
                                                                  child: Text(
                                                                    currentMentor
                                                                        .courseTakenAt[
                                                                            0]
                                                                        .name,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    maxLines: 2,
                                                                    style: GoogleFonts.fredoka(
                                                                        color: Colors.grey.shade200,
                                                                        fontWeight: FontWeight.w600,
                                                                        fontSize: currentMentor.courseTakenAt[0].name.length <= 25
                                                                            ? MediaQuery.of(context).textScaleFactor * 26
                                                                            : currentMentor.courseTakenAt[0].name.length <= 30
                                                                                ? MediaQuery.of(context).textScaleFactor * 23
                                                                                : MediaQuery.of(context).textScaleFactor * 16,
                                                                        height: 1),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : InkWell(
                                                          onTap: () {
                                                            toggleSchoolScreen();
                                                          },
                                                          child: Container(
                                                            height:
                                                                height * 0.09,
                                                            width: width * 0.83,
                                                            decoration: BoxDecoration(
                                                                color: orange,
                                                                border: Border.all(
                                                                    color: darkOrange
                                                                        .withOpacity(
                                                                            0.5),
                                                                    width: width *
                                                                        0.013),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            13))),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                  width: width *
                                                                      0.013,
                                                                ),
                                                                Container(
                                                                    height:
                                                                        height *
                                                                            0.066,
                                                                    width:
                                                                        height *
                                                                            0.066,
                                                                    margin: EdgeInsets.only(
                                                                        top: height *
                                                                            0.00),
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade200,
                                                                        border: Border.all(
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                226,
                                                                                98,
                                                                                0),
                                                                            width: width *
                                                                                0.01),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10)),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.all(
                                                                          width *
                                                                              0.0125),
                                                                      child:
                                                                          FittedBox(
                                                                        fit: BoxFit
                                                                            .fitHeight,
                                                                        child:
                                                                            ImageIcon(
                                                                          AssetImage(
                                                                              "assets/images/addSchoolv2.png"),
                                                                          color:
                                                                              orange,
                                                                        ),
                                                                      ),
                                                                    )),
                                                                SizedBox(
                                                                  width: width *
                                                                      0.02,
                                                                ),
                                                                Container(
                                                                  width: width *
                                                                      0.6,
                                                                  margin: EdgeInsets.only(
                                                                      top: height *
                                                                          0.0),
                                                                  child: Text(
                                                                    "Choose School",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    maxLines: 2,
                                                                    style: GoogleFonts.fredoka(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade200,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontSize: "Choose School".length <= 25
                                                                            ? MediaQuery.of(context).textScaleFactor *
                                                                                28
                                                                            : MediaQuery.of(context).textScaleFactor *
                                                                                18,
                                                                        height:
                                                                            1),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                  Container(
                                                    height: width * 0.025,
                                                  ),
                                                ]))
                                        : Container(
                                            width: width * 0.87,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                            ),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: height * 0.038,
                                                        margin: EdgeInsets.only(
                                                            left: width * 0.035,
                                                            top: width * 0.02),
                                                        child: FittedBox(
                                                          fit: BoxFit.fitHeight,
                                                          child: Text(
                                                            "Experience :",
                                                            style: GoogleFonts
                                                                .fredoka(
                                                              color: orange,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                          child: Container()),
                                                      Container(
                                                        height: height * 0.038,
                                                        margin: EdgeInsets.only(
                                                            right:
                                                                width * 0.035,
                                                            top: width * 0.02),
                                                        child: FittedBox(
                                                          fit: BoxFit.fitHeight,
                                                          child: Text(
                                                            currentMentor
                                                                .getExperienceToString(),
                                                            style: GoogleFonts
                                                                .fredoka(
                                                              color: orange,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        height: height * 0.05,
                                                      ),
                                                      Positioned(
                                                        left: width * 0.0325,
                                                        bottom: 0.05,
                                                        child: Container(
                                                          width: width * 0.78,
                                                          child: SliderTheme(
                                                            data:
                                                                SliderThemeData(
                                                              rangeThumbShape:
                                                                  RoundRangeSliderThumbShape(
                                                                enabledThumbRadius:
                                                                    1,
                                                                disabledThumbRadius:
                                                                    1,
                                                              ),
                                                              thumbShape:
                                                                  RoundSliderThumbShape(
                                                                enabledThumbRadius:
                                                                    11.5,
                                                                disabledThumbRadius:
                                                                    11.5,
                                                              ),
                                                              trackHeight:
                                                                  height * 0.01,
                                                            ),
                                                            child: Slider(
                                                              value: currentMentor
                                                                  .experience
                                                                  .toDouble(),
                                                              onChanged: (x) {
                                                                setState(() {
                                                                  currentMentor
                                                                          .experience =
                                                                      x.toInt();
                                                                });
                                                              },
                                                              min: 0,
                                                              max: 6,
                                                              activeColor:
                                                                  orange,
                                                              inactiveColor:
                                                                  backgroundColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                          bottom:
                                                              height * 0.008,
                                                          left: width * 0.026,
                                                          child: Container(
                                                            height:
                                                                height * 0.038,
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                              child: Text(
                                                                "0",
                                                                style: GoogleFonts.fredoka(
                                                                    color:
                                                                        orange,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                            ),
                                                          )),
                                                      Positioned(
                                                          bottom:
                                                              height * 0.008,
                                                          right: width * 0.012,
                                                          child: Container(
                                                            height:
                                                                height * 0.038,
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                              child: Text(
                                                                "5+",
                                                                style: GoogleFonts.fredoka(
                                                                    color:
                                                                        orange,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                            ),
                                                          ))
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.005,
                                                  ),
                                                ])),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    Container(
                                        width: width * 0.87,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    height: height * 0.038,
                                                    margin: EdgeInsets.only(
                                                        left: width * 0.035,
                                                        top: width * 0.02),
                                                    child: FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: Text(
                                                        "Description :",
                                                        style:
                                                            GoogleFonts.fredoka(
                                                          color: orange,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                height: height * 0.2,
                                                width: width * 0.83,
                                                padding: EdgeInsets.all(
                                                    width * 0.02),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15)),
                                                  border: Border.all(
                                                    color:
                                                        orange, // Use Colors.orange for the orange color
                                                    width: width * 0.015,
                                                  ),
                                                ),
                                                child: TextField(
                                                  maxLines: null,
                                                  textAlignVertical:
                                                      TextAlignVertical.top,
                                                  controller: descriptionTec,
                                                  cursorColor: orange,
                                                  decoration: InputDecoration(
                                                    isCollapsed: true,
                                                    hintText:
                                                        "You can use this space to share your expertise, prerequisites for mentees, weekly availability, and any other relevant details.",
                                                    hintMaxLines: 10,
                                                    fillColor: Colors.red,
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    hintStyle: TextStyle(
                                                        color: Colors
                                                            .grey.shade500,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 16),
                                                  ),
                                                  style: TextStyle(
                                                      color: orange,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 16),
                                                ),
                                              ),
                                              SizedBox(
                                                height: height * 0.01,
                                              ),
                                            ])),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    Container(
                                        width: width * 0.87,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    height: height * 0.038,
                                                    margin: EdgeInsets.only(
                                                        left: width * 0.035,
                                                        top: width * 0.02),
                                                    child: FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: Text(
                                                        "Meeting Type :",
                                                        style:
                                                            GoogleFonts.fredoka(
                                                          color: orange,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(child: SizedBox())
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: width * 0.025,
                                                    vertical: height * 0.002),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    MentorshipMeetWidget(
                                                        currentMentor.location,
                                                        MentorShipMeetLocation
                                                            .Virtual,
                                                        "virtual",
                                                        "Virtual",
                                                        changeMeetLocation),
                                                    MentorshipMeetWidget(
                                                        currentMentor.location,
                                                        MentorShipMeetLocation
                                                            .Live,
                                                        "both",
                                                        "Both",
                                                        changeMeetLocation),
                                                    MentorshipMeetWidget(
                                                        currentMentor.location,
                                                        MentorShipMeetLocation
                                                            .Both,
                                                        "inperson",
                                                        "Live",
                                                        changeMeetLocation),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: width * 0.025,
                                              ),
                                            ])),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        print(currentMentor.allFieldFilledOut());
                                        currentMentor.description = descriptionTec.text;
                                        currentMentor.other = skillsTec.text;
                                        if (currentMentor.allFieldFilledOut()) {
                                          print("started");
                                          print(currentMentor.toJson());
                                          Map data = await supaBase
                                              .from("MentorPosts")
                                              .insert(currentMentor.toJson())
                                              .select()
                                              .single();
                                          print("part one done");

                                          currentMentor.id = data["id"];
                                          
                                          currentUser
                                              .addMentorPost(currentMentor);
                                          List<Map> mentorJsonList = [];
                                          for (Mentor m
                                              in currentUser.mentorposts) {
                                            mentorJsonList.add(m.toJson());
                                          }
                                          await supaBase
                                              .from("user_auth_table")
                                              .update({
                                            "MentorPosts": currentUser
                                                .mentorposts
                                                .map((e) => e.toJson())
                                                .toList()
                                          }).eq("email", currentUser.email);

                                          print("done");
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      child: Container(
                                        width: width,
                                        height: height * 0.09,
                                        decoration: BoxDecoration(
                                            color: orange,
                                            border: Border.all(
                                                color:
                                                    darkOrange.withOpacity(0.5),
                                                width: width * 0.015),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: height * 0.04,
                                              child: FittedBox(
                                                fit: BoxFit.fitHeight,
                                                child: ImageIcon(
                                                  AssetImage(
                                                      "assets/images/send.png"),
                                                  color: backgroundColor,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width * 0.025,
                                            ),
                                            Container(
                                              height: height * 0.06,
                                              child: FittedBox(
                                                  fit: BoxFit.fitHeight,
                                                  child: Text(
                                                    "Post",
                                                    style: GoogleFonts.fredoka(
                                                        color: backgroundColor,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  )),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.015,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                ])),
            showBlackScreen
                ? InkWell(
                    onTap: () {
                      toggleBlackScreen();
                      showSchoolScreen = false;
                      classesPickerVisibility = false;
                      setState(() {});
                    },
                    child: Container(
                      height: height,
                      width: width,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  )
                : Container(),
            showSchoolScreen
                ? SingleChildScrollView(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          showBlackScreen = false;
                          showSchoolScreen = false;
                        });
                      },
                      child: Container(
                          height: height,
                          width: width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AnimatedContainer(
                                duration: Duration(milliseconds: 150),
                                height:
                                    keyboardUp ? height * 0.25 : height * 0.3,
                              ),
                              su.SearchSChoolTextField(
                                  height * 0.075,
                                  width * 0.9,
                                  orange,
                                  orange,
                                  "",
                                  0,
                                  schoolTec,
                                  getSchoolData),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                height: height * 0.25,
                                width: width * 0.9,
                                decoration: BoxDecoration(
                                    color: backgroundColor,
                                    border: Border.all(
                                        color: orange, width: width * 0.015),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                padding: EdgeInsets.all(width * 0.015),
                                child: searchResultsLoading
                                    ? Center(
                                        child: Stack(children: [
                                          Positioned(
                                            bottom: height * 0.03,
                                            left: width * 0.12,
                                            child: Container(
                                              height: height * 0.2,
                                              child: Lottie.asset(
                                                  "assets/animations/loading.json",
                                                  fit: BoxFit.fitHeight),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: height * 0.015,
                                            left: width * 0.17,
                                            child: Container(
                                              height: height * 0.04,
                                              child: FittedBox(
                                                fit: BoxFit.fitHeight,
                                                child: Text(
                                                  "Fetching Results...",
                                                  style: GoogleFonts.fredoka(
                                                      color: orange,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                            ),
                                          )
                                        ]),
                                      )
                                    : recList.length > 0 && recList[0] == "none"
                                        ? Center(
                                            child: Stack(children: [
                                              Positioned(
                                                bottom: height * 0.06,
                                                left: width * 0.25,
                                                child: Container(
                                                  height: height * 0.16,
                                                  child: Image.asset(
                                                      "assets/images/empty.png",
                                                      fit: BoxFit.fitHeight),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: height * 0.01,
                                                left: width * 0.18,
                                                child: Container(
                                                  height: height * 0.04,
                                                  child: FittedBox(
                                                    fit: BoxFit.fitHeight,
                                                    child: Text(
                                                      "No Results Found",
                                                      style:
                                                          GoogleFonts.fredoka(
                                                              color: orange,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ]),
                                          )
                                        : ListView(
                                            padding: EdgeInsets.all(0),
                                            children: [
                                              ...recList.map((e) {
                                                String showSchoolString =
                                                    e as String;
                                                String finalString =
                                                    showSchoolString
                                                        .substring(0, 1)
                                                        .toUpperCase();
                                                for (int i = 1;
                                                    i < showSchoolString.length;
                                                    i++) {
                                                  if (showSchoolString
                                                          .substring(
                                                              i - 1, i) ==
                                                      " ") {
                                                    finalString = finalString +
                                                        showSchoolString
                                                            .substring(i, i + 1)
                                                            .toUpperCase();
                                                  } else {
                                                    finalString = finalString +
                                                        showSchoolString
                                                            .substring(i, i + 1)
                                                            .toLowerCase();
                                                  }
                                                }
                                                return InkWell(
                                                  onTap: () async {
                                                    setState(() {
                                                      searchResultsLoading =
                                                          true;
                                                    });
                                                    School data =
                                                        await getFullSchoolData(
                                                            e, finalString);
                                                    print(data.image);
                                                    currentMentor
                                                        .addSchool(data);
                                                    setState(() {
                                                      searchResultsLoading =
                                                          false;
                                                    });
                                                    setState(() {
                                                      showBlackScreen = false;
                                                      showSchoolScreen = false;
                                                      schoolTec.text = "";
                                                    });
                                                  },
                                                  child: Container(
                                                      width: width * 0.85,
                                                      height: height * 0.07,
                                                      margin: EdgeInsets.only(
                                                          bottom: width *
                                                              0.015),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  width * 0.02,
                                                              vertical:
                                                                  width * 0.01),
                                                      decoration: BoxDecoration(
                                                          color: const Color
                                                                  .fromARGB(
                                                              255, 226, 225, 225),
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius.circular(
                                                                      5))),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              finalString,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts.fredoka(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: orange,
                                                                  fontSize:
                                                                      MediaQuery.of(context)
                                                                              .textScaleFactor *
                                                                          18),
                                                            ),
                                                          )
                                                        ],
                                                      )),
                                                );
                                              }).toList()
                                            ],
                                          ),
                              )
                            ],
                          )),
                    ),
                  )
                : Container(),
            classesPickerVisibility
                ? SingleChildScrollView(
                    child: InkWell(
                      onTap: () {
                        showClassesPickerVisibility();
                        toggleBlackScreen();
                      },
                      child: Container(
                          height: height,
                          width: width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AnimatedContainer(
                                duration: Duration(milliseconds: 150),
                                height:
                                    keyboardUp ? height * 0.25 : height * 0.3,
                              ),
                              SearchSChoolTextField(
                                height * 0.08,
                                width * 0.9,
                                orange,
                                darkOrange,
                                "",
                                0,
                                classesTec,
                                getSchoolData,
                                showButton: false,
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              InkWell(
                                onTap: () {},
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  height: height * 0.3,
                                  width: width * 0.9,
                                  decoration: BoxDecoration(
                                      color: backgroundColor,
                                      border: Border.all(
                                          color: orange, width: width * 0.015),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  padding: EdgeInsets.all(width * 0.015),
                                  child: ListView(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    children: [
                                      ...classesQueryList.isEmpty
                                          ? classes.map((e) {
                                              return InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      currentMentor.addClass(e);
                                                    });
                                                  },
                                                  child: ClassDisplayWidget(e));
                                            }).toList()
                                          : classesQueryList.map((e) {
                                              return InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      currentMentor.addClass(e);
                                                    });
                                                  },
                                                  child: ClassDisplayWidget(e));
                                            }).toList(),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )),
                    ),
                  )
                : Container(),
            skillSearchVisibility
                ? SingleChildScrollView(
                    child: InkWell(
                      onTap: () {
                        toggleSkillSearchVisibility();
                        toggleBlackScreen();
                      },
                      child: Container(
                          height: height,
                          width: width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AnimatedContainer(
                                duration: Duration(milliseconds: 150),
                                height:
                                    keyboardUp ? height * 0.25 : height * 0.3,
                              ),
                              SearchSChoolTextField(
                                  height * 0.08,
                                  width * 0.9,
                                  orange,
                                  orange,
                                  "",
                                  0,
                                  skillsTec,
                                  getSchoolData,
                                  showButton: false),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                height: height * 0.25,
                                width: width * 0.9,
                                decoration: BoxDecoration(
                                    color: backgroundColor,
                                    border: Border.all(
                                        color: orange, width: width * 0.015),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                padding: EdgeInsets.all(width * 0.015),
                                child: ListView(
                                  padding: EdgeInsets.all(0),
                                  children: skillsRecommendedList.length == 0 &&
                                          skillsTec.text == ""
                                      ? skills.map((e) {
                                          return InkWell(
                                            onTap: () async {
                                              currentUser.skills.add(e);
                                              print("here");
                                              setState(() {});
                                            },
                                            child: Container(
                                                width: width * 0.85,
                                                height: height * 0.07,
                                                margin: EdgeInsets.only(
                                                    bottom: width * 0.015),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: width * 0.02,
                                                    vertical: width * 0.01),
                                                decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 226, 225, 225),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                5))),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        e.className,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: GoogleFonts.fredoka(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: orange,
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .textScaleFactor *
                                                                18),
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          );
                                        }).toList()
                                      : [
                                          ...skillsRecommendedList.map((e) {
                                            return InkWell(
                                              onTap: () async {
                                                currentMentor.addSkill(e);
                                                setState(() {});
                                              },
                                              child: Container(
                                                  width: width * 0.85,
                                                  height: height * 0.07,
                                                  margin: EdgeInsets.only(
                                                      bottom: width * 0.015),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: width * 0.02,
                                                      vertical: width * 0.01),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              226,
                                                              225,
                                                              225),
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  5))),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          e.className,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: GoogleFonts.fredoka(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: orange,
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .textScaleFactor *
                                                                  22),
                                                        ),
                                                      )
                                                    ],
                                                  )),
                                            );
                                          }).toList()
                                        ],
                                ),
                              )
                            ],
                          )),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

//MentorshipMeetType
class MentorshipMeetWidget extends StatefulWidget {
  MentorShipMeetLocation currentMentorType;
  MentorShipMeetLocation wantedMentorType;
  String imageName;
  String name;
  Function changeType;
  MentorshipMeetWidget(this.currentMentorType, this.wantedMentorType,
      this.imageName, this.name, this.changeType);

  @override
  State<MentorshipMeetWidget> createState() => MentorshipMeetWidgetState();
}

class MentorshipMeetWidgetState extends State<MentorshipMeetWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        widget.changeType(widget.wantedMentorType);
      },
      child: AnimatedContainer(
        duration: Duration(microseconds: 150),
        height: height * 0.1,
        width: width * 0.25,
        decoration: BoxDecoration(
            color: widget.currentMentorType == widget.wantedMentorType
                ? orange
                : Colors.grey.shade200,
            border: Border.all(
                color: widget.currentMentorType != widget.wantedMentorType
                    ? Color.fromARGB(255, 186, 185, 185)
                    : darkOrange.withOpacity(0.5),
                width: width * 0.0125),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.005,
            ),
            Container(
              height: height * 0.05,
              padding: EdgeInsets.only(top: height * 0.005),
              child: FittedBox(
                  child: ImageIcon(
                AssetImage("assets/images/${widget.imageName}.png"),
                color: widget.currentMentorType == widget.wantedMentorType
                    ? Colors.grey.shade200
                    : Color.fromARGB(255, 186, 185, 185),
              )),
            ),
            SizedBox(
              height: height * 0.001,
            ),
            SizedBox(
              height: height * 0.03,
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(
                  widget.name,
                  style: GoogleFonts.fredoka(
                    color: widget.currentMentorType == widget.wantedMentorType
                        ? Colors.grey.shade200
                        : Color.fromARGB(255, 186, 185, 185),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MentorshipOptionWidget extends StatefulWidget {
  MentorShipType currentMentorType;
  MentorShipType wantedMentorType;
  String imageName;
  String name;
  Function changeType;
  MentorshipOptionWidget(this.currentMentorType, this.wantedMentorType,
      this.imageName, this.name, this.changeType);

  @override
  State<MentorshipOptionWidget> createState() => _MentorshipOptionWidgetState();
}

class _MentorshipOptionWidgetState extends State<MentorshipOptionWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        widget.changeType(widget.wantedMentorType);
      },
      child: AnimatedContainer(
        duration: Duration(microseconds: 150),
        height: height * 0.14,
        width: width * 0.25,
        decoration: BoxDecoration(
            color: widget.currentMentorType == widget.wantedMentorType
                ? orange
                : Colors.grey.shade200,
            border: Border.all(
                color: widget.currentMentorType != widget.wantedMentorType
                    ? Color.fromARGB(255, 186, 185, 185)
                    : darkOrange.withOpacity(0.5),
                width: width * 0.0125),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.005,
            ),
            Container(
              height: height * 0.08,
              padding: EdgeInsets.all(height * 0.008),
              child: FittedBox(
                  child: ImageIcon(
                AssetImage("assets/images/mentorIcons/${widget.imageName}.png"),
                color: widget.currentMentorType == widget.wantedMentorType
                    ? Colors.grey.shade200
                    : Color.fromARGB(255, 186, 185, 185),
              )),
            ),
            SizedBox(
              height: height * 0.001,
            ),
            SizedBox(
              height: height * 0.03,
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(
                  widget.name,
                  style: GoogleFonts.fredoka(
                    color: widget.currentMentorType == widget.wantedMentorType
                        ? Colors.grey.shade200
                        : Color.fromARGB(255, 186, 185, 185),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MentorshipSubject extends StatefulWidget {
  ClubType currentMentorType;
  ClubType wantedMentorType;
  String imageName;
  String name;
  Function changeType;
  MentorshipSubject(this.currentMentorType, this.wantedMentorType,
      this.imageName, this.name, this.changeType);

  @override
  State<MentorshipSubject> createState() => MentorshipSubjectState();
}

class MentorshipSubjectState extends State<MentorshipSubject> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (widget.name == "None") return Container();
    return InkWell(
      onTap: () {
        widget.changeType(widget.wantedMentorType);
      },
      child: AnimatedContainer(
        margin: EdgeInsets.only(right: width * 0.02),
        duration: Duration(microseconds: 150),
        height: height * 0.14,
        width: width * 0.252,
        decoration: BoxDecoration(
            color: widget.currentMentorType == widget.wantedMentorType
                ? orange
                : Colors.grey.shade200,
            border: Border.all(
                color: widget.currentMentorType != widget.wantedMentorType
                    ? Color.fromARGB(255, 186, 185, 185)
                    : darkOrange.withOpacity(0.5),
                width: width * 0.0125),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.005,
            ),
            Container(
              height: height * 0.05,
              padding: EdgeInsets.all(height * 0.002),
              child: FittedBox(
                  child: ImageIcon(
                AssetImage("assets/images/clubIcons/${widget.name}.png"),
                color: widget.currentMentorType == widget.wantedMentorType
                    ? Colors.grey.shade200
                    : Color.fromARGB(255, 186, 185, 185),
              )),
            ),
            SizedBox(
              height: height * 0.00,
            ),
            Container(
              height: height * 0.03,
              padding: EdgeInsets.symmetric(
                  vertical: widget.name.length <= 8 ? 0 : height * 0.003),
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(
                  widget.name,
                  style: GoogleFonts.fredoka(
                    color: widget.currentMentorType == widget.wantedMentorType
                        ? Colors.grey.shade200
                        : Color.fromARGB(255, 186, 185, 185),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
// make the choose screen
// make the description screen
// if it is a class where did you take it instead of experience
// if it is other then get to choose the subject
/*
Container(
              width: width,
              child: Column(
                children: [
                  Container(
                    height: width * 0.04,
                  ),
                  Container(
                    width: width * 0.94,
                    height: height - width * 0.08,
                    decoration: BoxDecoration(
                        color: backgroundColor,
                        border: Border.all(
                            color: Colors.grey.shade300, width: width * 0.01),
                        borderRadius: BorderRadius.all(Radius.circular(35))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Container(
                          width: width * 0.92,
                          height: height * 0.07,
                          child: Row(
                            children: [
                              Container(
                                width: height * 0.02,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  height: height * 0.068,
                                  width: height * 0.068,
                                  decoration: BoxDecoration(
                                      color: red,
                                      border: Border.all(
                                          color: darkRed, width: width * 0.012),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  padding: EdgeInsets.all(width * 0.03),
                                  child: Image.asset("assets/images/back.png"),
                                ),
                              ),
                              Container(
                                width: width * 0.05,
                              ),
                              Container(
                                  height: height * 0.06,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      "Create Class",
                                      style: GoogleFonts.fredoka(
                                        color: mainColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        ),]))
 */