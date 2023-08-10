import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/main.dart';
import 'package:highschoolhub/models/user.dart';
import 'package:highschoolhub/pages/AuthenticationPage.dart';
import 'package:lottie/lottie.dart';

import '../../models/class.dart';
import '../../models/school.dart';
import '../SignUp.dart' as su;

import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

List<String> subjects = [
  "Buisness", // G
  "Computers", // B
  "Language", //P
  "Music", //
  "English", //G
  "Math", // B
  "Sports", //P
  "Art", //
  "Social_Studies", //G
  "Science", // B
  "Electives", //P
];

Color getColor(String fieldOfStudy) {
  int colorVal = subjects.indexOf(fieldOfStudy) % 4;
  List<Color> colors = [mainColor, blue, puprle, orange];
  return colors[colorVal];
}

Color getDColor(String fieldOfStudy) {
  int colorVal = subjects.indexOf(fieldOfStudy) % 4;
  List<Color> colors = [darkGreen, darkblue, darkPurple, darkOrange];
  return colors[colorVal];
}

class CreateSchoolSpecificClass extends StatefulWidget {
  const CreateSchoolSpecificClass({super.key});

  @override
  State<CreateSchoolSpecificClass> createState() =>
      _CreateSchoolSpecificClassState();
}

class _CreateSchoolSpecificClassState extends State<CreateSchoolSpecificClass> {
  @override
  TextEditingController classNameTec = TextEditingController();
  schoolClassDatabase creatingClass =
      schoolClassDatabase(schoolAssociatedWith: []);

  bool blackScreenEnabled = false;
  bool searchResultsLoading = false;
  bool showSchoolSearch = false;
  bool keyboardUp = false;

  void toggleBlackScreen() {
    setState(() {
      blackScreenEnabled = blackScreenEnabled == false;
    });
  }

  void toggleShowSearch() {
    setState(() {
      showSchoolSearch = showSchoolSearch == false;
    });
  }

  void updateFunction(String fos) {
    setState(() {
      creatingClass.fieldOfStudy = fos;
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
  TextEditingController classesTec = new TextEditingController();
  void getSchoolData() async {
    recList = await getWebsiteData();
    print(recList);
    setState(() {
      recList;
    });
  }

  void initState(){
    classesTec.addListener(() {
      creatingClass.className = classesTec.text;
      print(creatingClass.className);
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    keyboardUp = MediaQuery.of(context).viewInsets.bottom != 0;
    List<List<String>> data = [
      [
        "Math", //g
        "Science", // b
        "Computers",
      ],
      [
        "Buisness", //g
        "English", // b
        "Social_Studies",
      ],
      [
        "Language", //b
        "Sports",
        "Electives"
      ],
      [
        "Art",
        "Music", //g
        ""
      ], // b
    ];
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    AppUser currentUser = arg["currentUser"];
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        color: mainColor,
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
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Container(
                          height: height * 0.04,
                          margin: EdgeInsets.only(left: width * 0.06),
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text(
                              "Class Name",
                              style: GoogleFonts.fredoka(
                                  color: mainColor,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        Container(
                          height: height * 0.005,
                        ),
                        Row(children: [
                          Expanded(child: Container()),
                          SignUpScreenTextField(
                              height * 0.08,
                              width * 0.85,
                              mainColor,
                              darkGreen,
                              "Class Name",
                              width * 0,
                              classesTec),
                          Expanded(
                            child: Container(),
                          )
                        ]),
                        SizedBox(
                          height: height * 0.012,
                        ),
                        Container(
                          height: height * 0.04,
                          margin: EdgeInsets.only(left: width * 0.06),
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text(
                              "Category",
                              style: GoogleFonts.fredoka(
                                  color: blue, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        Container(
                          height: height * 0.01,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(),
                            ),
                            Container(
                              width: width * 0.82,
                              height: height * 0.25,
                              child: ListView(
                                padding: EdgeInsets.zero,
                                children: [
                                  ...data.map((e) {
                                    return Container(
                                      margin: EdgeInsets.only(
                                          bottom: height * 0.01),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ...e.map((data) {
                                            return CategoryWidget(data,
                                                creatingClass, updateFunction);
                                          }).toList()
                                        ],
                                      ),
                                    );
                                  }).toList()
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.005,
                        ),
                        Container(
                          height: height * 0.04,
                          margin: EdgeInsets.only(left: width * 0.06),
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text(
                              "School",
                              style: GoogleFonts.fredoka(
                                  color: puprle, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        Container(
                          height: height * 0.004,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: height * 0.25,
                              width: width * 0.82,
                              child: ListView(
                                padding: EdgeInsets.zero,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      toggleBlackScreen();
                                      toggleShowSearch();
                                    },
                                    child: Container(
                                      width: width * 0.9,
                                      height: height * 0.08,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          border: Border.all(
                                              color: Colors.grey.shade500,
                                              width: width * 0.015),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: height * 0.03,
                                            child: Image.asset(
                                              "assets/images/add_school.png",
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * 0.025,
                                          ),
                                          Container(
                                            height: height * 0.05,
                                            child: FittedBox(
                                              fit: BoxFit.fitHeight,
                                              child: Text(
                                                "Add School",
                                                style: GoogleFonts.fredoka(
                                                    color: Colors.grey.shade500,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: creatingClass.schoolAssociatedWith.isEmpty ?width * 0.025 : width * 0.015,
                                  ),
                                  creatingClass.schoolAssociatedWith.isEmpty
                                      ? Container(
                                          child: Column(children: [
                                          Container(
                                            height: height * 0.08,
                                            child: Image.asset(
                                              "assets/images/addSchool.png",
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                          SizedBox(
                                            height: height * 0.01,
                                          ),
                                          Container(
                                            height: height * 0.06,
                                            child: FittedBox(
                                              fit: BoxFit.fitHeight,
                                              child: Text(
                                                "Add what schools the course\nis offered in",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.fredoka(
                                                    color: puprle,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ),
                                        ]))
                                      : Container(
                                          child: Column(
                                            children: [
                                              ...creatingClass
                                                  .schoolAssociatedWith
                                                  .map((e) {
                                                return Container(
                                                  height: height * 0.085,
                                                  width: width * 0.9,
                                                  decoration: BoxDecoration(
                                                      color: puprle,
                                                      border: Border.all(
                                                          color: darkPurple,
                                                          width: width * 0.0125),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15))),
                                                  margin: EdgeInsets.only(
                                                      bottom: height * 0.01),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: width * 0.01,
                                                      ),
                                                      Container(
                                                        height: height * 0.06,
                                                        width: height * 0.06,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                              color: darkPurple,
                                                              width:
                                                                  width * 0.01),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                        padding: EdgeInsets.all(
                                                            width * 0.005),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          child: Image.network(
                                                              e.image),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: width * 0.02,
                                                      ),
                                                      Container(
                                                        width: width * 0.6,
                                                        child: Text(
                                                          e.name,
                                                          textAlign:
                                                              TextAlign.left,
                                                          maxLines: 2,
                                                          style: GoogleFonts.fredoka(
                                                              color: backgroundColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: e.name
                                                                          .length <=
                                                                      23
                                                                  ? MediaQuery.of(
                                                                              context)
                                                                          .textScaleFactor *
                                                                      23
                                                                  : MediaQuery.of(
                                                                              context)
                                                                          .textScaleFactor *
                                                                      18,
                                                              height: 1),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            ],
                                          ),
                                        )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.016),
                        Row(
                          children: [
                            Expanded(child: Container()),
                            InkWell(
                              onTap : () async {
                                await supaBase.from("Classes").insert(
                                  creatingClass.toJson()
                                );
                                print("done");
                                currentUser.addClass(creatingClass);
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                height: height * 0.078,
                                width: width * 0.85,
                                decoration: BoxDecoration(
                                    color: mainColor,
                                    border: Border.all(
                                      color: darkGreen,
                                      width: width * 0.0125,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          height: height * 0.03,
                                          child: ImageIcon(
                                            AssetImage(
                                              "assets/images/add_school.png",
                                            ),
                                            color: backgroundColor,
                                          )),
                                      SizedBox(
                                        width: width * 0.03,
                                      ),
                                      Container(
                                          height: height * 0.05,
                                          child: FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Text(
                                              "Create Class",
                                              style: GoogleFonts.fredoka(
                                                  color: backgroundColor,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          )),
                                    ]),
                              ),
                            ),
                            Expanded(child: Container()),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            blackScreenEnabled
                ? InkWell(
                    onTap: () {
                      toggleBlackScreen();
                    },
                    child: Container(
                      height: height,
                      width: width,
                      color: Colors.black.withOpacity(0.65),
                    ),
                  )
                : Container(),
            showSchoolSearch
                ? SingleChildScrollView(
                    child: InkWell(
                      onTap: () {
                        toggleBlackScreen();
                        toggleShowSearch();
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
                                  height * 0.08,
                                  width * 0.9,
                                  mainColor,
                                  darkGreen,
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
                                        color: mainColor, width: width * 0.015),
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
                                                      color: mainColor,
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
                                                              color: mainColor,
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
                                                    setState(() {
                                                      creatingClass
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
                                                                  color:
                                                                      mainColor,
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

class SignUpScreenTextField extends StatefulWidget {
  double wantedHeight;
  double wantedWidth;
  Color mainColor;
  Color darkColor;
  String textFieldName;
  double textFieldNameWidth;
  TextEditingController tec;

  SignUpScreenTextField(this.wantedHeight, this.wantedWidth, this.mainColor,
      this.darkColor, this.textFieldName, this.textFieldNameWidth, this.tec);
  @override
  State<SignUpScreenTextField> createState() => _SignUpScreenTextFieldState();
}

class _SignUpScreenTextFieldState extends State<SignUpScreenTextField> {
  @override
  bool tapped = false;
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: widget.wantedHeight * 1.02,
      width: widget.wantedWidth,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Container(
                width: widget.wantedWidth,
                height: widget.wantedHeight,
                decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    border: Border.all(
                        color: widget.mainColor, width: width * 0.015)),
                padding:
                    EdgeInsets.only(left: width * 0.032, top: height * 0.008),
                child: Text(
                  "",
                  style: GoogleFonts.fredoka(
                      fontWeight: FontWeight.w700,
                      color: widget.tec.text == ""
                          ? Colors.grey.shade400
                          : Colors.transparent,
                      fontSize: MediaQuery.of(context).textScaleFactor * 30),
                )),
          ),
          Container(
            child: Positioned(
              left: width * 0.045,
              top: 0,
              child: Container(
                height: height * 0.01,
                width: widget.textFieldNameWidth,
                padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                color: backgroundColor,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    widget.textFieldName,
                    style: GoogleFonts.fredoka(
                        color: widget.darkColor, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: TextFormField(
              controller: widget.tec,
              onChanged: (d) {
                setState(() {});
              },
              onTap: () {
                setState(() {
                  tapped = true;
                });
              },
              onTapOutside: (d) {
                setState(() {
                  tapped = false;
                });
              },
              style: GoogleFonts.fredoka(
                  fontWeight: FontWeight.w600,
                  color: widget.mainColor,
                  fontSize: MediaQuery.of(context).textScaleFactor * 30),
              cursorColor: widget.mainColor,
              cursorHeight: widget.wantedHeight * 0.5,
              decoration: InputDecoration(border: InputBorder.none),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  String category;
  schoolClassDatabase creatingClass;
  Function onTapFunction;
  CategoryWidget(this.category, this.creatingClass, this.onTapFunction);

  @override
  Widget build(BuildContext context) {
    bool check = category == creatingClass.fieldOfStudy;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (category == "") {
      return Container(
        width: width * 0.26,
        height: width * 0.26,
      );
    }
    return InkWell(
      onTap: () {
        onTapFunction(category);
      },
      child: Container(
        width: width * 0.26,
        height: width * 0.24,
        decoration: BoxDecoration(
            color: check ? getColor(category) : Colors.grey.shade300,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(
                color: check ? getDColor(category) : Colors.grey.shade300,
                width: width * 0.01)),
        child: Column(
          children: [
            SizedBox(height: width * 0.035),
            Container(
              height: width * 0.1,
              width: width * 0.1,
              child: ImageIcon(
                AssetImage("assets/images/classImage/" + category + ".png"),
                color: check ? backgroundColor : getColor(category),
              ),
            ),
            Expanded(child: Container()),
            Container(
              height: height * 0.027,
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(
                  category == "Social_Studies" ? "Humanities" : category,
                  maxLines: 2,
                  style: GoogleFonts.fredoka(
                      color: check ? backgroundColor : getColor(category),
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                ),
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
