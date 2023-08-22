import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/pages/AuthenticationPage.dart';
import 'package:highschoolhub/pages/SignUp.dart';
import 'package:highschoolhub/pages/SignUpScreen/EducationInfo.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import '../../models/school.dart';

class EditSchoolScreen extends StatefulWidget {
  const EditSchoolScreen({super.key});

  @override
  State<EditSchoolScreen> createState() => _EditSchoolScreenState();
}

class _EditSchoolScreenState extends State<EditSchoolScreen> {
  @override
  bool showBlackScreen = false;
  bool searchSchoolVisibility = false;
  bool searchResultsLoading = false;
  void toggleShowBlackScreen() {
    setState(() {
      showBlackScreen = showBlackScreen == false;
      if (showBlackScreen == false && searchSchoolVisibility) {
        setState(() {
          showSearchSchool();
        });
      }
    });
  }

  void showSearchSchool() {
    setState(() {
      searchSchoolVisibility = searchSchoolVisibility == false;
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
    setState(() {
      recList;
    });
  }
  void initStateFunction() async {
    await getWebsiteData();
  }
  List<School> preChangeSchoolData = [];
  void initState(){
    preChangeSchoolData.addAll(currentUser.schools);
    initStateFunction();
    super.initState();
  }
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    int currentScreen = 0;
    bool keyboardUp = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      body: SingleChildScrollView(
        physics: keyboardUp
            ? BouncingScrollPhysics()
            : NeverScrollableScrollPhysics(),
        child: Container(
          height: height,
          width: width,
          color: backgroundColor,
          child: Stack(
            children: [
              Opacity(
                opacity: 0.5,
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
                child: Container(
                  width: width,
                  child: Column(
                    children: [
                      Container(
                        width: width,
                        height: height * 0.0725,
                        child: Row(
                          children: [
                            SizedBox(width: width * 0.05),
                            Container(
                              height: height * 0.0725,
                              width: height * 0.0725,
                              child: FloatingActionButton(
                                heroTag: "asdfddmcydn",
                                onPressed: () async {
                                  currentUser.schools = [];
                                  currentUser.schools.addAll(preChangeSchoolData);
                                  Navigator.of(context).pop();
                                },
                                elevation: 2,
                                backgroundColor: red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  side: BorderSide(
                                      width: width * 0.0125, color: darkRed),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    currentScreen == 0
                                        ? width * 0.042
                                        : width * 0.03,
                                  ),
                                  child: RotatedBox(
                                    quarterTurns: 2,
                                    child:
                                        Image.asset("assets/images/back.png"),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                            InkWell(
                              child: Container(
                                height: height * 0.067,
                                child: FittedBox(
                                  child: Text(
                                    "Education",
                                    style: GoogleFonts.fredoka(
                                      fontWeight: FontWeight.w800,
                                      color: puprle,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                            Container(
                              height: height * 0.0725,
                              width: height * 0.0725,
                              child: FloatingActionButton(
                                heroTag: "asdfdd74757",
                                onPressed: () async {
                                  await currentUser.updateData(imageAlso: false);
                                  Navigator.of(context).pop();
                                },
                                elevation: 2,
                                backgroundColor: mainColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  side: BorderSide(
                                    width: width * 0.0125,
                                    color: darkGreen,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    currentScreen == 3
                                        ? width * 0.035
                                        : width * 0.03,
                                  ),
                                  child: RotatedBox(
                                    quarterTurns: 0,
                                    child:
                                        Image.asset("assets/images/done.png"),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: width * 0.05),
                          ],
                        ),
                      ),
                      Container(
                        height: height * 0.01,
                      ),
                      Expanded(
                          child: Container(
                        child: EducationInfoScreen(toggleShowBlackScreen,
                            showSearchSchool, currentUser),
                      )),
                      Container(
                        height: height * 0.01,
                      ),
                    ],
                  ),
                ),
              ),
              showBlackScreen
                  ? InkWell(
                      onTap: () {
                        toggleShowBlackScreen();
                      },
                      child: AnimatedOpacity(
                        opacity: showBlackScreen ? 1 : 0,
                        duration: Duration(milliseconds: 300),
                        child: Container(
                          height: height,
                          width: width,
                          color: Colors.black.withOpacity(0.75),
                        ),
                      ),
                    )
                  : Container(),
              searchSchoolVisibility
                  ? SingleChildScrollView(
                      child: InkWell(
                        onTap: () {
                          showSearchSchool();
                          toggleShowBlackScreen();
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
                                    puprle,
                                    darkPurple,
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
                                          color: puprle, width: width * 0.015),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
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
                                                        color: puprle,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ]),
                                        )
                                      : recList.length > 0 &&
                                              recList[0] == "none"
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
                                                                color: puprle,
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
                                                      i <
                                                          showSchoolString
                                                              .length;
                                                      i++) {
                                                    if (showSchoolString
                                                            .substring(
                                                                i - 1, i) ==
                                                        " ") {
                                                      finalString = finalString +
                                                          showSchoolString
                                                              .substring(
                                                                  i, i + 1)
                                                              .toUpperCase();
                                                    } else {
                                                      finalString = finalString +
                                                          showSchoolString
                                                              .substring(
                                                                  i, i + 1)
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
                                                        currentUser
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
                                                                    width *
                                                                        0.02,
                                                                vertical:
                                                                    width *
                                                                        0.01),
                                                        decoration: BoxDecoration(
                                                            color: const Color
                                                                    .fromARGB(
                                                                255,
                                                                226,
                                                                225,
                                                                225),
                                                            borderRadius:
                                                                const BorderRadius.all(
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
                                                                        puprle,
                                                                    fontSize:
                                                                        MediaQuery.of(context).textScaleFactor *
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
      ),
    );
  }
}
