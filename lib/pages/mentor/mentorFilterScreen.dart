import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/models/club.dart';
import 'package:highschoolhub/models/filter.dart';
import 'package:highschoolhub/models/mentor.dart';
import 'package:highschoolhub/models/school.dart';
import 'package:highschoolhub/models/user.dart';
import 'package:highschoolhub/pages/SignUpScreen/AccountInfo.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:lottie/lottie.dart';

import '../SignUp.dart';

List<topicSubjects> subjectList = [
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

class MentorFilterScreen extends StatefulWidget {
  MentorFilter mentorFilter;
  MentorFilterScreen(this.mentorFilter);

  @override
  State<MentorFilterScreen> createState() => _MentorFilterScreenState();
}

class _MentorFilterScreenState extends State<MentorFilterScreen> {
  @override
  void changeStarNumber(int newStarNumber) {
    setState(() {
      widget.mentorFilter.stars = newStarNumber;
    });
  }

  bool showBlackScreen = false;
  bool showSchoolScreen = false;
  bool showStateScreen = false;
  bool searchResultsLoading = false;
  List<int> numbers = [1, 2, 3, 4, 5];
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
    late Range gradeRange;
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
        gradeRange = Range(lowerBound, upperBound);
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
    if (actualStringRecommendationList.isEmpty) {
      return ["none"];
    }
    return actualStringRecommendationList;
  }

  List recList = [];
  TextEditingController schoolTec = new TextEditingController();
  TextEditingController classesTec = new TextEditingController();
  void getSchoolData() async {
    recList = await getWebsiteData();
    setState(() {
      recList;
    });
  }

  bool keyboardUp = false;
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Color darkGrey = const Color.fromARGB(255, 186, 185, 185);

    void toggleBlackScreen() {
      setState(() {
        print(showBlackScreen);
        showBlackScreen = !showBlackScreen;
        print(showBlackScreen);
      });
    }

    void toggleSchoolScreen() {
      setState(() {
        showSchoolScreen = !showSchoolScreen;
      });
    }

    void toggleStateScreen() {
      setState(() {
        showStateScreen = !showStateScreen;
      });
    }

    keyboardUp = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        color: orange,
        child: Stack(
          children: [
            Opacity(
              opacity: 0.15,
              child: Container(
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
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                  color: Colors.grey.shade300,
                                  width: width * 0.01),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(35))),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: height * 0.025,
                                ),
                                Container(
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
                                          height: height * 0.07,
                                          width: height * 0.07,
                                          decoration: BoxDecoration(
                                              color: red,
                                              border: Border.all(
                                                  color: darkRed,
                                                  width: width * 0.015),
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(10))),
                                          padding: EdgeInsets.all(width * 0.02),
                                          child: FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: ImageIcon(
                                              const AssetImage(
                                                  "assets/images/back.png"),
                                              color: backgroundColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(),
                                      ),
                                      Container(
                                        height: height * 0.07,
                                        child: FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: Text(
                                            "Filters",
                                            style: GoogleFonts.fredoka(
                                                color: orange,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(),
                                      ),
                                      Container(
                                        height: height * 0.07,
                                        width: height * 0.07,
                                      ),
                                      Container(
                                        width: height * 0.0,
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
                                      padding: EdgeInsets.zero,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: width * 0.025,
                                              right: width * 0.025),
                                          width: width * 0.9,
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: height * 0.0075,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: height * 0.015,
                                                  ),
                                                  Container(
                                                      height: height * 0.038,
                                                      child: FittedBox(
                                                        fit: BoxFit.fitHeight,
                                                        child: Text(
                                                          "Topic Type : ",
                                                          style: GoogleFonts
                                                              .fredoka(
                                                                  color: orange,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                        ),
                                                      ))
                                                ],
                                              ),
                                              SizedBox(
                                                height: height * 0.0075,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        widget.mentorFilter
                                                            .addMentorShipType(
                                                                MentorShipType
                                                                    .Classes);
                                                      });
                                                    },
                                                    child: AnimatedContainer(
                                                      duration: const Duration(
                                                          milliseconds: 50),
                                                      height: height * 0.13,
                                                      width: width * 0.26,
                                                      decoration: BoxDecoration(
                                                          color: widget
                                                                  .mentorFilter
                                                                  .mentorShipType
                                                                  .contains(MentorShipType
                                                                      .Classes)
                                                              ? orange
                                                              : backgroundColor,
                                                          border: Border.all(
                                                              color: widget
                                                                      .mentorFilter
                                                                      .mentorShipType
                                                                      .contains(MentorShipType
                                                                          .Classes)
                                                                  ? darkOrange
                                                                      .withOpacity(0.5)
                                                                  : darkGrey,
                                                              width: width * 0.015),
                                                          borderRadius: const BorderRadius.all(Radius.circular(12))),
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height:
                                                                height * 0.01,
                                                          ),
                                                          Container(
                                                            height:
                                                                height * 0.065,
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                              child: ImageIcon(
                                                                const AssetImage(
                                                                    "assets/images/mentorIcons/classes.png"),
                                                                color: widget
                                                                        .mentorFilter
                                                                        .mentorShipType
                                                                        .contains(
                                                                            MentorShipType.Classes)
                                                                    ? backgroundColor
                                                                    : darkGrey,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                height * 0.001,
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                height * 0.035,
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                              child: Text(
                                                                "Class",
                                                                style:
                                                                    GoogleFonts
                                                                        .fredoka(
                                                                  color: widget
                                                                          .mentorFilter
                                                                          .mentorShipType
                                                                          .contains(
                                                                              MentorShipType.Classes)
                                                                      ? backgroundColor
                                                                      : darkGrey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.025,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        widget.mentorFilter
                                                            .addMentorShipType(
                                                                MentorShipType
                                                                    .Skills);
                                                      });
                                                    },
                                                    child: AnimatedContainer(
                                                      duration: const Duration(
                                                          milliseconds: 50),
                                                      height: height * 0.13,
                                                      width: width * 0.26,
                                                      decoration: BoxDecoration(
                                                          color: widget
                                                                  .mentorFilter
                                                                  .mentorShipType
                                                                  .contains(MentorShipType
                                                                      .Skills)
                                                              ? orange
                                                              : backgroundColor,
                                                          border: Border.all(
                                                              color: widget
                                                                      .mentorFilter
                                                                      .mentorShipType
                                                                      .contains(MentorShipType
                                                                          .Skills)
                                                                  ? darkOrange
                                                                      .withOpacity(0.5)
                                                                  : darkGrey,
                                                              width: width * 0.015),
                                                          borderRadius: const BorderRadius.all(Radius.circular(12))),
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height:
                                                                height * 0.01,
                                                          ),
                                                          Container(
                                                            height:
                                                                height * 0.06,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom:
                                                                        height *
                                                                            0.005),
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                              child: ImageIcon(
                                                                const AssetImage(
                                                                    "assets/images/mentorIcons/skills.png"),
                                                                color: widget
                                                                        .mentorFilter
                                                                        .mentorShipType
                                                                        .contains(
                                                                            MentorShipType.Skills)
                                                                    ? backgroundColor
                                                                    : darkGrey,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                height * 0.001,
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                height * 0.035,
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                              child: Text(
                                                                "Skills",
                                                                style:
                                                                    GoogleFonts
                                                                        .fredoka(
                                                                  color: widget
                                                                          .mentorFilter
                                                                          .mentorShipType
                                                                          .contains(
                                                                              MentorShipType.Skills)
                                                                      ? backgroundColor
                                                                      : darkGrey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.025,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        widget.mentorFilter
                                                            .addMentorShipType(
                                                                MentorShipType
                                                                    .Other);
                                                      });
                                                    },
                                                    child: AnimatedContainer(
                                                      duration: const Duration(
                                                          milliseconds: 50),
                                                      height: height * 0.13,
                                                      width: width * 0.26,
                                                      decoration: BoxDecoration(
                                                          color: widget
                                                                  .mentorFilter
                                                                  .mentorShipType
                                                                  .contains(MentorShipType
                                                                      .Other)
                                                              ? orange
                                                              : backgroundColor,
                                                          border: Border.all(
                                                              color: widget
                                                                      .mentorFilter
                                                                      .mentorShipType
                                                                      .contains(MentorShipType
                                                                          .Other)
                                                                  ? darkOrange
                                                                      .withOpacity(0.5)
                                                                  : darkGrey,
                                                              width: width * 0.015),
                                                          borderRadius: const BorderRadius.all(Radius.circular(12))),
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height:
                                                                height * 0.01,
                                                          ),
                                                          Container(
                                                            height:
                                                                height * 0.06,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom:
                                                                        height *
                                                                            0.005),
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                              child: ImageIcon(
                                                                const AssetImage(
                                                                    "assets/images/mentorIcons/clubs.png"),
                                                                color: widget
                                                                        .mentorFilter
                                                                        .mentorShipType
                                                                        .contains(
                                                                            MentorShipType.Other)
                                                                    ? backgroundColor
                                                                    : darkGrey,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                height * 0.001,
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                height * 0.035,
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                              child: Text(
                                                                "Other",
                                                                style:
                                                                    GoogleFonts
                                                                        .fredoka(
                                                                  color: widget
                                                                          .mentorFilter
                                                                          .mentorShipType
                                                                          .contains(
                                                                              MentorShipType.Other)
                                                                      ? backgroundColor
                                                                      : darkGrey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: height * 0.01,
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: width * 0.025,
                                                right: width * 0.025),
                                            width: width * 0.9,
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: Column(children: [
                                              SizedBox(
                                                height: height * 0.0075,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: height * 0.015,
                                                  ),
                                                  Container(
                                                      height: height * 0.038,
                                                      child: FittedBox(
                                                        fit: BoxFit.fitHeight,
                                                        child: Text(
                                                          "Topic Subject : ",
                                                          style: GoogleFonts
                                                              .fredoka(
                                                                  color: orange,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                        ),
                                                      )),
                                                  Expanded(
                                                    child: Container(),
                                                  ),
                                                  Container(
                                                      height: height * 0.038,
                                                      child: FittedBox(
                                                        fit: BoxFit.fitHeight,
                                                        child: Text(
                                                          widget
                                                                      .mentorFilter
                                                                      .topicSubjectsList
                                                                      .isEmpty ||
                                                                  widget
                                                                          .mentorFilter
                                                                          .topicSubjectsList
                                                                          .length ==
                                                                      17
                                                              ? "All Topics"
                                                              : "${widget.mentorFilter.topicSubjectsList.length} Topics",
                                                          style: GoogleFonts
                                                              .fredoka(
                                                                  color: orange,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                        ),
                                                      )),
                                                  SizedBox(
                                                    width: height * 0.015,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: height * 0.002,
                                              ),
                                              Container(
                                                width: width * 0.88,
                                                height: height * 0.13,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: width * 0.02),
                                                child: ListView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  padding: EdgeInsets.zero,
                                                  children: [
                                                    ...subjectList.map((e) {
                                                      return InkWell(
                                                        onTap: () {
                                                          widget.mentorFilter
                                                              .addTopicSubjectsList(
                                                                  e);
                                                          setState(() {});
                                                        },
                                                        child:
                                                            AnimatedContainer(
                                                          duration: const Duration(
                                                              milliseconds: 50),
                                                          height: height * 0.08,
                                                          width: height * 0.12,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: width *
                                                                      0.015),
                                                          decoration: BoxDecoration(
                                                              color: widget.mentorFilter
                                                                      .containsTopic(
                                                                          e)
                                                                  ? orange
                                                                  : backgroundColor,
                                                              border: Border.all(
                                                                  color: widget
                                                                          .mentorFilter
                                                                          .containsTopic(
                                                                              e)
                                                                      ? darkOrange.withOpacity(
                                                                          0.5)
                                                                      : darkGrey,
                                                                  width: width *
                                                                      0.015),
                                                              borderRadius:
                                                                  const BorderRadius.all(
                                                                      Radius.circular(10))),
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: height *
                                                                    0.0125,
                                                              ),
                                                              Container(
                                                                height: height *
                                                                    0.06,
                                                                child:
                                                                    FittedBox(
                                                                  fit: BoxFit
                                                                      .fitHeight,
                                                                  child:
                                                                      ImageIcon(
                                                                    AssetImage(e
                                                                        .image),
                                                                    color: widget
                                                                            .mentorFilter
                                                                            .containsTopic(e)
                                                                        ? backgroundColor
                                                                        : darkGrey,
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                  child:
                                                                      Container()),
                                                              Container(
                                                                width: height *
                                                                    0.1,
                                                                child: Text(
                                                                  e.clubTypeString ==
                                                                          "none"
                                                                      ? e.clubType
                                                                          .toReadableString()
                                                                          .substring(
                                                                              9)
                                                                      : e.clubTypeString
                                                                          .replaceAll(
                                                                              "_",
                                                                              " "),
                                                                  maxLines: 2,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: GoogleFonts.fredoka(
                                                                      color: widget.mentorFilter.containsTopic(
                                                                              e)
                                                                          ? backgroundColor
                                                                          : darkGrey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize: (e.clubTypeString == "none" ? e.clubType.toReadableString().substring(9) : e.clubTypeString.replaceAll("_", " ")).length >
                                                                              10
                                                                          ? 15
                                                                          : 20,
                                                                      height:
                                                                          1),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                  child:
                                                                      Container()),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }).toList()
                                                  ],
                                                ),
                                              )
                                            ])),
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: width * 0.025,
                                              right: width * 0.025),
                                          width: width * 0.9,
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: height * 0.0075,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: height * 0.015,
                                                  ),
                                                  Container(
                                                      height: height * 0.038,
                                                      child: FittedBox(
                                                        fit: BoxFit.fitHeight,
                                                        child: Text(
                                                          "Meeting Type : ",
                                                          style: GoogleFonts
                                                              .fredoka(
                                                                  color: orange,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                        ),
                                                      ))
                                                ],
                                              ),
                                              SizedBox(
                                                height: height * 0.00,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          widget.mentorFilter
                                                              .addMeetingTypes(
                                                                  MentorShipMeetLocation
                                                                      .Live);
                                                        });
                                                      },
                                                      child: MeetingTypeWidgetChoose(
                                                          "In-Person",
                                                          "inperson",
                                                          widget.mentorFilter
                                                              .meetingTypes
                                                              .contains(
                                                                  MentorShipMeetLocation
                                                                      .Live))),
                                                  SizedBox(
                                                    width: width * 0.025,
                                                  ),
                                                  InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          widget.mentorFilter
                                                              .addMeetingTypes(
                                                                  MentorShipMeetLocation
                                                                      .Both);
                                                        });
                                                      },
                                                      child: MeetingTypeWidgetChoose(
                                                          "Both",
                                                          "both",
                                                          widget.mentorFilter
                                                              .meetingTypes
                                                              .contains(
                                                                  MentorShipMeetLocation
                                                                      .Both))),
                                                  SizedBox(
                                                    width: width * 0.025,
                                                  ),
                                                  InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          widget.mentorFilter
                                                              .addMeetingTypes(
                                                                  MentorShipMeetLocation
                                                                      .Virtual);
                                                        });
                                                      },
                                                      child: MeetingTypeWidgetChoose(
                                                          "Virtual",
                                                          "virtual",
                                                          widget.mentorFilter
                                                              .meetingTypes
                                                              .contains(
                                                                  MentorShipMeetLocation
                                                                      .Virtual))),
                                                ],
                                              ),
                                              SizedBox(
                                                height: height * 0.0123,
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: width * 0.025,
                                                right: width * 0.025),
                                            width: width * 0.9,
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: Column(children: [
                                              SizedBox(
                                                height: height * 0.0075,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: height * 0.015,
                                                  ),
                                                  Container(
                                                      height: height * 0.038,
                                                      child: FittedBox(
                                                        fit: BoxFit.fitHeight,
                                                        child: Text(
                                                          "Rating : ",
                                                          style: GoogleFonts
                                                              .fredoka(
                                                                  color: orange,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                        ),
                                                      )),
                                                  Expanded(
                                                    child: Container(),
                                                  ),
                                                  Container(
                                                      height: height * 0.038,
                                                      child: FittedBox(
                                                        fit: BoxFit.fitHeight,
                                                        child: Text(
                                                          "Atleast ${widget.mentorFilter.stars} Stars",
                                                          style: GoogleFonts
                                                              .fredoka(
                                                                  color: orange,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                        ),
                                                      )),
                                                  SizedBox(
                                                    width: height * 0.015,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: height * 0.005,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: width * 0.03,
                                                  ),
                                                  ...[1, 2, 3, 4, 5].map((e) {
                                                    return Container(
                                                      margin: EdgeInsets.only(
                                                          right: width * 0.015),
                                                      child: StarWidget(
                                                          e,
                                                          widget.mentorFilter
                                                              .stars,
                                                          changeStarNumber),
                                                    );
                                                  }).toList()
                                                ],
                                              ),
                                              SizedBox(
                                                height: height * 0.015,
                                              ),
                                            ])),
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: width * 0.025,
                                                right: width * 0.025),
                                            width: width * 0.9,
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: Column(children: [
                                              SizedBox(
                                                height: height * 0.0075,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: height * 0.015,
                                                  ),
                                                  Container(
                                                      height: height * 0.038,
                                                      child: FittedBox(
                                                        fit: BoxFit.fitHeight,
                                                        child: Text(
                                                          "Experience : ",
                                                          style: GoogleFonts
                                                              .fredoka(
                                                                  color: orange,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                        ),
                                                      )),
                                                  Expanded(
                                                    child: Container(),
                                                  ),
                                                  Container(
                                                      height: height * 0.038,
                                                      child: FittedBox(
                                                        fit: BoxFit.fitHeight,
                                                        child: Text(
                                                          "${widget.mentorFilter.experienceToYears()} Years",
                                                          style: GoogleFonts
                                                              .fredoka(
                                                                  color: orange,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                        ),
                                                      )),
                                                  SizedBox(
                                                    width: height * 0.015,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: height * 0.005,
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
                                                        data: SliderThemeData(
                                                          rangeThumbShape:
                                                              const RoundRangeSliderThumbShape(
                                                            enabledThumbRadius:
                                                                1,
                                                            disabledThumbRadius:
                                                                1,
                                                          ),
                                                          thumbShape:
                                                              const RoundSliderThumbShape(
                                                            enabledThumbRadius:
                                                                11,
                                                            disabledThumbRadius:
                                                                11,
                                                          ),
                                                          trackHeight:
                                                              height * 0.01,
                                                        ),
                                                        child: Slider(
                                                          value: widget
                                                              .mentorFilter
                                                              .experience
                                                              .toDouble(),
                                                          onChanged: (x) {
                                                            setState(() {
                                                              widget.mentorFilter
                                                                      .experience =
                                                                  x.toInt();
                                                            });
                                                          },
                                                          min: 0,
                                                          max: 6,
                                                          activeColor: orange,
                                                          inactiveColor:
                                                              backgroundColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                      bottom: height * 0.008,
                                                      left: width * 0.026,
                                                      child: Container(
                                                        height: height * 0.038,
                                                        child: FittedBox(
                                                          fit: BoxFit.fitHeight,
                                                          child: Text(
                                                            "0",
                                                            style: GoogleFonts
                                                                .fredoka(
                                                                    color:
                                                                        orange,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                          ),
                                                        ),
                                                      )),
                                                  Positioned(
                                                      bottom: height * 0.008,
                                                      right: width * 0.012,
                                                      child: Container(
                                                        height: height * 0.038,
                                                        child: FittedBox(
                                                          fit: BoxFit.fitHeight,
                                                          child: Text(
                                                            "5+",
                                                            style: GoogleFonts
                                                                .fredoka(
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
                                                height: height * 0.015,
                                              ),
                                            ])),
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: width * 0.025,
                                                right: width * 0.025),
                                            width: width * 0.9,
                                            height: height * 0.3,
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: Column(children: [
                                              SizedBox(
                                                height: height * 0.0075,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: height * 0.015,
                                                  ),
                                                  Container(
                                                      height: height * 0.038,
                                                      child: FittedBox(
                                                        fit: BoxFit.fitHeight,
                                                        child: Text(
                                                          "Mentor Grade : ",
                                                          style: GoogleFonts
                                                              .fredoka(
                                                                  color: orange,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                        ),
                                                      )),
                                                  Expanded(
                                                    child: Container(),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: height * 0.001,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: ListView(
                                                    padding: EdgeInsets.zero,
                                                    children: [
                                                      ...Grade.values.map((e) {
                                                        if (e == Grade.None) {
                                                          return Container();
                                                        }
                                                        return InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              widget
                                                                  .mentorFilter
                                                                  .addGrades(e);
                                                            });
                                                          },
                                                          child: Container(
                                                            height:
                                                                height * 0.07,
                                                            width: width * 0.85,
                                                            margin: EdgeInsets.only(
                                                                left: width *
                                                                    0.025,
                                                                right: width *
                                                                    0.025,
                                                                bottom: height *
                                                                    0.005),
                                                            decoration: BoxDecoration(
                                                                color: widget.mentorFilter
                                                                        .grades
                                                                        .contains(
                                                                            e)
                                                                    ? orange
                                                                    : backgroundColor,
                                                                border: Border.all(
                                                                    color: widget
                                                                            .mentorFilter
                                                                            .grades
                                                                            .contains(
                                                                                e)
                                                                        ? darkOrange.withOpacity(
                                                                            0.5)
                                                                        : darkGrey,
                                                                    width: width *
                                                                        0.015),
                                                                borderRadius:
                                                                    const BorderRadius.all(Radius.circular(10))),
                                                            child: Center(
                                                              child: Container(
                                                                height: height *
                                                                    0.045,
                                                                child:
                                                                    FittedBox(
                                                                  fit: BoxFit
                                                                      .fitHeight,
                                                                  child: Text(
                                                                    e
                                                                        .toString()
                                                                        .substring(
                                                                            6),
                                                                    style: GoogleFonts.fredoka(
                                                                        color: widget.mentorFilter.grades.contains(e)
                                                                            ? backgroundColor
                                                                            : const Color.fromARGB(
                                                                                255,
                                                                                175,
                                                                                175,
                                                                                175),
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: height * 0.015,
                                              ),
                                            ])),
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: width * 0.025,
                                                right: width * 0.025),
                                            width: width * 0.9,
                                            height: height * 0.3,
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: Column(children: [
                                              SizedBox(
                                                height: height * 0.0075,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: height * 0.015,
                                                  ),
                                                  Container(
                                                      height: height * 0.038,
                                                      child: FittedBox(
                                                        fit: BoxFit.fitHeight,
                                                        child: Text(
                                                          "Mentor State : ",
                                                          style: GoogleFonts
                                                              .fredoka(
                                                                  color: orange,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                        ),
                                                      )),
                                                  Expanded(
                                                    child: Container(),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: height * 0.001,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: ListView(
                                                    padding: EdgeInsets.zero,
                                                    children: [
                                                      ...widget.mentorFilter
                                                          .stateList
                                                          .map((e) {
                                                        if (e == Grade.None) {
                                                          return Container();
                                                        }
                                                        return InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              widget
                                                                  .mentorFilter
                                                                  .addStateList(
                                                                      e);
                                                            });
                                                          },
                                                          child: Container(
                                                            height:
                                                                height * 0.07,
                                                            width: width * 0.85,
                                                            margin: EdgeInsets.only(
                                                                left: width *
                                                                    0.025,
                                                                right: width *
                                                                    0.025,
                                                                bottom: height *
                                                                    0.005),
                                                            decoration: BoxDecoration(
                                                                color: widget
                                                                        .mentorFilter
                                                                        .stateList
                                                                        .contains(
                                                                            e)
                                                                    ? orange
                                                                    : backgroundColor,
                                                                border: Border.all(
                                                                    color: widget
                                                                            .mentorFilter
                                                                            .stateList
                                                                            .contains(
                                                                                e)
                                                                        ? darkOrange.withOpacity(
                                                                            0.5)
                                                                        : darkGrey,
                                                                    width: width *
                                                                        0.015),
                                                                borderRadius:
                                                                    const BorderRadius.all(Radius.circular(10))),
                                                            child: Center(
                                                              child: Container(
                                                                height: height *
                                                                    0.045,
                                                                child:
                                                                    FittedBox(
                                                                  fit: BoxFit
                                                                      .fitHeight,
                                                                  child: Text(
                                                                    e
                                                                        .toString()
                                                                        .substring(
                                                                            9),
                                                                    style: GoogleFonts.fredoka(
                                                                        color: widget.mentorFilter.stateList.contains(e)
                                                                            ? backgroundColor
                                                                            : const Color.fromARGB(
                                                                                255,
                                                                                175,
                                                                                175,
                                                                                175),
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                      InkWell(
                                                        onTap: () {
                                                          toggleBlackScreen();
                                                          toggleStateScreen();
                                                        },
                                                        child: Container(
                                                            height:
                                                                height * 0.07,
                                                            width: width * 0.85,
                                                            margin: EdgeInsets.only(
                                                                left: width *
                                                                    0.025,
                                                                right: width *
                                                                    0.025,
                                                                bottom: height *
                                                                    0.005),
                                                            decoration: BoxDecoration(
                                                                color: orange,
                                                                border: Border.all(
                                                                    color: darkOrange
                                                                        .withOpacity(
                                                                            0.5),
                                                                    width: width *
                                                                        0.015),
                                                                borderRadius:
                                                                    const BorderRadius.all(
                                                                        Radius.circular(
                                                                            10))),
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
                                                                          0.028,
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .fitHeight,
                                                                    child:
                                                                        ImageIcon(
                                                                      const AssetImage(
                                                                          "assets/images/add_school.png"),
                                                                      color:
                                                                          backgroundColor,
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: width *
                                                                      0.02,
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
                                                                      "Add State",
                                                                      style: GoogleFonts.fredoka(
                                                                          color:
                                                                              backgroundColor,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: height * 0.015,
                                              ),
                                            ])),
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: width * 0.025,
                                                right: width * 0.025),
                                            width: width * 0.9,
                                            height: height * 0.3,
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: Column(children: [
                                              SizedBox(
                                                height: height * 0.0075,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: height * 0.015,
                                                  ),
                                                  Container(
                                                      height: height * 0.038,
                                                      child: FittedBox(
                                                        fit: BoxFit.fitHeight,
                                                        child: Text(
                                                          "Mentor's School : ",
                                                          style: GoogleFonts
                                                              .fredoka(
                                                                  color: orange,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                        ),
                                                      )),
                                                  Expanded(
                                                    child: Container(),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: height * 0.001,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: ListView(
                                                    padding: EdgeInsets.zero,
                                                    children: [
                                                      ...widget.mentorFilter
                                                          .filterSchools
                                                          .map((e) {
                                                        if (e == Grade.None) {
                                                          return Container();
                                                        }
                                                        return InkWell(
                                                          onTap: () {},
                                                          child: Container(
                                                              height: height *
                                                                  0.087,
                                                              width:
                                                                  width * 0.85,
                                                              margin: EdgeInsets.only(
                                                                  left: width *
                                                                      0.025,
                                                                  right: width *
                                                                      0.025,
                                                                  bottom:
                                                                      height *
                                                                          0.005),
                                                              decoration: BoxDecoration(
                                                                  color: orange,
                                                                  border: Border.all(
                                                                      color: darkOrange
                                                                          .withOpacity(
                                                                              0.5),
                                                                      width: width *
                                                                          0.015),
                                                                  borderRadius:
                                                                      const BorderRadius.all(
                                                                          Radius.circular(
                                                                              10))),
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    width:
                                                                        width *
                                                                            0.012,
                                                                  ),
                                                                  Container(
                                                                    height:
                                                                        height *
                                                                            0.063,
                                                                    width:
                                                                        height *
                                                                            0.063,
                                                                    decoration: BoxDecoration(
                                                                        color:
                                                                            orange,
                                                                        border: Border.all(
                                                                            color: darkOrange.withOpacity(
                                                                                0.5),
                                                                            width: width *
                                                                                0.012),
                                                                        borderRadius:
                                                                            const BorderRadius.all(Radius.circular(8))),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          const BorderRadius.all(
                                                                              Radius.circular(5)),
                                                                      child: Image
                                                                          .network(
                                                                        e.image,
                                                                        fit: BoxFit
                                                                            .fill,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: width *
                                                                        0.02,
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      child:
                                                                          Text(
                                                                        e.name,
                                                                        maxLines:
                                                                            2,
                                                                        style: GoogleFonts.fredoka(
                                                                            color:
                                                                                backgroundColor,
                                                                            fontWeight: FontWeight
                                                                                .w600,
                                                                            fontSize:
                                                                                25,
                                                                            height:
                                                                                1),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: width *
                                                                        0.015,
                                                                  ),
                                                                ],
                                                              )),
                                                        );
                                                      }).toList(),
                                                      InkWell(
                                                        onTap: () {
                                                          toggleSchoolScreen();
                                                          toggleBlackScreen();
                                                        },
                                                        child: Container(
                                                            height:
                                                                height * 0.07,
                                                            width: width * 0.85,
                                                            margin: EdgeInsets.only(
                                                                left: width *
                                                                    0.025,
                                                                right: width *
                                                                    0.025,
                                                                bottom: height *
                                                                    0.005),
                                                            decoration: BoxDecoration(
                                                                color: orange,
                                                                border: Border.all(
                                                                    color: darkOrange
                                                                        .withOpacity(
                                                                            0.5),
                                                                    width: width *
                                                                        0.015),
                                                                borderRadius:
                                                                    const BorderRadius.all(
                                                                        Radius.circular(
                                                                            10))),
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
                                                                          0.028,
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .fitHeight,
                                                                    child:
                                                                        ImageIcon(
                                                                      const AssetImage(
                                                                          "assets/images/add_school.png"),
                                                                      color:
                                                                          backgroundColor,
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: width *
                                                                      0.02,
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
                                                                      "Add School",
                                                                      style: GoogleFonts.fredoka(
                                                                          color:
                                                                              backgroundColor,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: height * 0.015,
                                              ),
                                            ])),
                                        SizedBox(
                                          height: height * 0.02,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ])),
                    ])),
            showBlackScreen
                ? InkWell(
                    onTap: () {
                      setState(() {
                        showBlackScreen = false;
                        showSchoolScreen = false;
                        showStateScreen = false;
                      });
                    },
                    child: Container(
                      height: height,
                      width: width,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  )
                : Container(),
            showStateScreen
                ? Center(
                    child: Container(
                      height: height * 0.5,
                      width: width * 0.8,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                      ),
                      padding: EdgeInsets.all(width * 0.025),
                      child: ListView(
                        padding: const EdgeInsets.all(0),
                        children: [
                          ...USStates.values.map((e) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  widget.mentorFilter.addStateList(e);
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                height: height * 0.08,
                                width: width * 0.75,
                                margin: EdgeInsets.only(bottom: width * 0.025),
                                decoration: BoxDecoration(
                                    color: widget.mentorFilter.stateList
                                            .contains(e)
                                        ? orange
                                        : backgroundColor,
                                    border: Border.all(
                                      color: !widget.mentorFilter.stateList
                                              .contains(e)
                                          ? darkOrange
                                          : darkOrange.withOpacity(0.5),
                                      width: width * 0.015,
                                    ),
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(10))),
                                child: Center(
                                    child: Container(
                                        height: height * 0.04,
                                        child: Stack(
                                          children: [
                                            AnimatedOpacity(
                                              duration:
                                                  const Duration(milliseconds: 150),
                                              opacity: 1,
                                              child: SizedBox(
                                                height: height * 0.04,
                                                child: FittedBox(
                                                  fit: BoxFit.fitHeight,
                                                  child: Text(
                                                    stateToString(e),
                                                    style: GoogleFonts.fredoka(
                                                        color: !widget
                                                                .mentorFilter
                                                                .stateList
                                                                .contains(e)
                                                            ? darkOrange
                                                            : darkOrange
                                                                .withOpacity(
                                                                    0.5),
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            AnimatedOpacity(
                                              duration:
                                                  const Duration(milliseconds: 150),
                                              opacity: widget
                                                      .mentorFilter.stateList
                                                      .contains(e)
                                                  ? 1
                                                  : 0,
                                              child: SizedBox(
                                                height: height * 0.04,
                                                child: FittedBox(
                                                  fit: BoxFit.fitHeight,
                                                  child: Text(
                                                    stateToString(e),
                                                    style: GoogleFonts.fredoka(
                                                        color: backgroundColor,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ))),
                              ),
                            );
                          }).toList()
                        ],
                      ),
                    ),
                  )
                : Container(),
            showSchoolScreen
                ? SingleChildScrollView(
                    child: InkWell(
                      onTap: () {
                        toggleSchoolScreen();
                        toggleBlackScreen();
                      },
                      child: Container(
                          height: height,
                          width: width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                height:
                                    keyboardUp ? height * 0.25 : height * 0.3,
                              ),
                              SearchSChoolTextField(
                                  height * 0.075,
                                  width * 0.9,
                                  orange,
                                  darkOrange,
                                  "",
                                  0,
                                  schoolTec,
                                  getSchoolData),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                height: height * 0.25,
                                width: width * 0.9,
                                decoration: BoxDecoration(
                                    color: backgroundColor,
                                    border: Border.all(
                                        color: orange, width: width * 0.015),
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(15))),
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
                                    : recList.isNotEmpty && recList[0] == "none"
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
                                            padding: const EdgeInsets.all(0),
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
                                                    setState(() {
                                                      widget.mentorFilter
                                                          .addSchool(data);
                                                      searchResultsLoading =
                                                          false;
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
                                                      decoration: const BoxDecoration(
                                                          color: Color
                                                                  .fromARGB(
                                                              255, 226, 225, 225),
                                                          borderRadius:
                                                              BorderRadius
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
          ],
        ),
      ),
    );
  }
}

class StarWidget extends StatefulWidget {
  int starNumber;
  int ratingNumber;
  Function setRatingNumber;
  StarWidget(this.starNumber, this.ratingNumber, this.setRatingNumber);
  @override
  State<StarWidget> createState() => _StarWidgetState();
}

class _StarWidgetState extends State<StarWidget> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    Color darkGray = const Color.fromARGB(255, 186, 185, 185);
    return InkWell(
      onTap: () {
        widget.setRatingNumber(widget.starNumber);
      },
      child: Stack(
        children: [
          SizedBox(
            height: height * 0.032,
            width: height * 0.032,
            child: ImageIcon(
              const AssetImage("assets/images/star.png"),
              color: widget.ratingNumber >= widget.starNumber
                  ? const Color(0xffFFC300)
                  : Colors.grey.shade400,
            ),
          ),
          Container(
            height: height * 0.032,
            width: height * 0.032,
            child: Center(
              child: SizedBox(
                height: height * 0.02,
                child: ImageIcon(
                  const AssetImage("assets/images/star.png"),
                  color: widget.ratingNumber >= widget.starNumber
                      ? const Color(0xffFFD700)
                      : Colors.grey.shade400,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MeetingTypeWidgetChoose extends StatefulWidget {
  String title;
  String image;
  bool chosen;
  MeetingTypeWidgetChoose(this.title, this.image, this.chosen);
  @override
  State<MeetingTypeWidgetChoose> createState() =>
      _MeetingTypeWidgetChooseState();
}

class _MeetingTypeWidgetChooseState extends State<MeetingTypeWidgetChoose> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Color darkGray = const Color.fromARGB(255, 186, 185, 185);
    return Container(
      height: height * 0.13,
      width: width * 0.26,
      decoration: BoxDecoration(
          color: widget.chosen ? orange : backgroundColor,
          border: Border.all(
              color: widget.chosen ? darkOrange.withOpacity(0.5) : darkGray,
              width: width * 0.015),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      child: Column(
        children: [
          SizedBox(
            height: height * 0.01,
          ),
          Container(
            height: height * 0.065,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: ImageIcon(
                  AssetImage("assets/images/" + widget.image + ".png"),
                  color: widget.chosen ? backgroundColor : darkGray),
            ),
          ),
          SizedBox(
            height: height * 0.004,
          ),
          SizedBox(
            height: height * 0.03,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Text(
                widget.title,
                style: GoogleFonts.fredoka(
                  color: widget.chosen ? backgroundColor : darkGray,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
