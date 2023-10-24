import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/models/club.dart';
import 'package:highschoolhub/models/filter.dart';
import 'package:highschoolhub/models/skills.dart';
import 'package:highschoolhub/pages/SignUp.dart';
import 'package:lottie/lottie.dart';

import '../../main.dart';
import '../../models/class.dart';
import '../../models/school.dart';
import '../../models/user.dart';
import '../AuthenticationPage.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

import '../SignUpScreen/AccountInfo.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class SearchSChoolTextField2 extends StatefulWidget {
  double wantedHeight;
  double wantedWidth;
  Color mainColor;
  Color darkColor;
  String textFieldName;
  double textFieldNameWidth;
  TextEditingController tec;
  Function searchButtonOnTap;
  bool showButton;
  bool numbersOnly;
  SearchSChoolTextField2(
      this.wantedHeight,
      this.wantedWidth,
      this.mainColor,
      this.darkColor,
      this.textFieldName,
      this.textFieldNameWidth,
      this.tec,
      this.searchButtonOnTap,
      {this.showButton = true,
      this.numbersOnly = false});
  @override
  State<SearchSChoolTextField2> createState() => SearchSChoolTextField2State();
}

class SearchSChoolTextField2State extends State<SearchSChoolTextField2> {
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
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border: Border.all(
                        color: widget.mainColor, width: width * 0.01)),
                padding:
                    EdgeInsets.only(left: width * 0.032, top: height * 0.008),
                child: Text(
                  widget.textFieldName,
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
            padding: EdgeInsets.only(
                right: width * 0.001,
                top: height * 0.001,
                left: width * 0.02),
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
                  fontSize: MediaQuery.of(context).textScaleFactor * 25),
              keyboardType: widget.numbersOnly
                  ? TextInputType.number
                  : TextInputType.text,
              cursorColor: widget.mainColor,
              cursorHeight: widget.wantedHeight * 0.5,
              decoration: InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.only(
                top: height * 0,
                bottom: height * 0.0145
              ), 
              fillColor: Colors.grey.shade100),
            ),
          ),
          widget.showButton == false
              ? Container()
              : Positioned(
                  left: width * 0.025,
                  top: height * 0.022,
                  child: InkWell(
                    onTap: () {
                      widget.searchButtonOnTap();
                    },
                    child: Container(
                      height: widget.wantedHeight * 0.55,
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Icon(
                          Icons.search_rounded,
                          color: widget.darkColor,
                        ),
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}

class _FilterScreenState extends State<FilterScreen> {
  @override
  bool statePickerVisibility = false;
  bool showBlackScreen = false;
  bool classesPickerVisibility = false;
  bool zipCodePickerVisibility = false;
  List classesQueryList = [];
  List classes = [];
  TextEditingController classesTec = TextEditingController();
  TextEditingController schoolTec = TextEditingController();
  TextEditingController distanceTec = TextEditingController();
  List recList = [];
  bool searchResultsLoading = false;
  List<Skill> skillsRecommendedList = [];
  List<Skill> skills = [];
  List clubs = [];
  List clubRecommendedList = [];
  TextEditingController clubsTec = TextEditingController();
  TextEditingController zipCodeTec = TextEditingController();
  bool clubSearchVisibility = false;
  bool searchSchoolVisibility = false;
  void toggleSearchSchoolVisibility() {
    setState(() {
      searchSchoolVisibility = !searchSchoolVisibility;
    });
  }

  void toggleClubSearch() {
    setState(() {
      clubSearchVisibility = !clubSearchVisibility;
    });
  }

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

  void changeToCertainSchool() {
    print("here");
    currentUser.searchFilterSearchCommunity.schools.type =
        filterTypeSchool.certainSchool;
    setState(() {});
    print(currentUser.searchFilterSearchCommunity.schools.type);
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

  void changeToZipCode() {
    print("here");
    currentUser.searchFilterSearchCommunity.schools.type =
        filterTypeSchool.ZipCode;
    setState(() {});
    print(currentUser.searchFilterSearchCommunity.schools.type);
  }

  void changeToStates() {
    print("here");
    currentUser.searchFilterSearchCommunity.schools.type =
        filterTypeSchool.State;
    setState(() {});
    print(currentUser.searchFilterSearchCommunity.schools.type);
  }

  void changeToDistance() {
    print("here");
    currentUser.searchFilterSearchCommunity.schools.type =
        filterTypeSchool.Distance;
    setState(() {});
    print(currentUser.searchFilterSearchCommunity.schools.type);
  }

  Future<int> getClubDataFromdatabase() async {
    final result = await supaBase.from("Clubs").select();
    print("getting club data");
    print(result);
    clubs = [];
    for (Map data in result) {
      club value = club();
      value.fromJson(data);
      bool flag = false;
      clubs.add(value);
    }
    return 1;
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

  void getSchoolData() async {
    recList = await getWebsiteData();
    setState(() {
      recList;
    });
  }

  void toggleClassesPickerVisibility() {
    setState(() {
      classesPickerVisibility = !classesPickerVisibility;
    });
  }

  void toggleBlackScreen() {
    setState(() {
      showBlackScreen = !showBlackScreen;
    });
  }

  void toggleZipCodeVisibility() {
    setState(() {
      zipCodePickerVisibility = !zipCodePickerVisibility;
    });
  }

  void toggleStateScreen() {
    setState(() {
      statePickerVisibility = !statePickerVisibility;
    });
  }

  bool showSkillPickerScreen = false;
  void toggleSkillPickerScreen() {
    setState(() {
      showSkillPickerScreen = !showSkillPickerScreen;
    });
  }

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
    print(classes);
    return 1;
  }

  TextEditingController skillsTec = TextEditingController();
  void initStateFunction() async {
    await getClassOptions();
    await getClubDataFromdatabase();
    await getSkillsFromDatabase();
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

  void initState() {
    initStateFunction();
    distanceTec.text = currentUser.searchFilterSearchCommunity.schools.distance.toString();
    classesQueryList = classes;
    distanceTec.addListener(() {
      currentUser.searchFilterSearchCommunity.schools.distance = int.parse(distanceTec.text);
    });
    skillsTec.addListener(() {
      skillsRecommendedList =
          sortListByQuery(skills, skillsTec.text) as List<Skill>;
      setState(() {});
    });
    classesTec.addListener(() {
      setState(() {
        classesQueryList = sortListByQuery(classes, classesTec.text);
      });
    });
    clubsTec.addListener(() {
      print(clubsTec);
      clubRecommendedList = sortListByQuery(clubs, clubsTec.text);
      setState(() {});
    });
    zipCodeTec.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  bool keyboardUp = false;
  Widget build(BuildContext context) {
    keyboardUp = MediaQuery.of(context).viewInsets.bottom != 0;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Map<filterTypeSchool, Widget> schoolFilterToWidget = {
      filterTypeSchool.certainSchool: Container(
        width: width * 0.8,
        margin: EdgeInsets.only(left: width * 0.025),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: height * 0.005,
            ),
            InkWell(
              onTap: () {
                toggleBlackScreen();
                toggleSearchSchoolVisibility();
              },
              child: Container(
                width: width * 0.8,
                height: height * 0.065,
                decoration: BoxDecoration(
                    color: puprle,
                    border: Border.all(color: darkPurple, width: width * 0.014),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: height * 0.025,
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: ImageIcon(
                            AssetImage(
                              "assets/images/add_school.png",
                            ),
                            color: backgroundColor,
                          ),
                        )),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Container(
                      height: height * 0.04,
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Text(
                          "Add School",
                          style: GoogleFonts.fredoka(
                            color: backgroundColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            ...currentUser.searchFilterSearchCommunity.schools.schools.map((e) {
              return InkWell(
                onTap : (){
                  currentUser.searchFilterSearchCommunity.schools.addSchool(e);
                  setState(() {
                    
                  });
                },
                child: Container(
                  width: width * 0.9,
                  height: height * 0.08,
                  margin: EdgeInsets.only(top: height * 0.01 / 1.5),
                  decoration: BoxDecoration(
                      color: puprle,
                      border: Border.all(color: darkPurple, width: width * 0.014),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: width * 0.015),
                      Container(
                        height: height * 0.055,
                        width: height * 0.055,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                                color: backgroundColor, width: width * 0.01)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          child: Image.network(
                            e.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: width * 0.02),
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(),
                              ),
                              Container(
                                width: width * 0.75,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        e.name,
                                        style: GoogleFonts.fredoka(
                                            color: backgroundColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: e.name.length <= 25
                                                ? MediaQuery.of(context)
                                                        .textScaleFactor *
                                                    23.5
                                                : MediaQuery.of(context)
                                                        .textScaleFactor *
                                                    20,
                                            height: 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: width * 0.02),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
      filterTypeSchool.State: Container(
        width: width * 0.8,
        margin: EdgeInsets.only(left: width * 0.025),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: height * 0.005,
            ),
            InkWell(
              onTap: () {
                toggleStateScreen();
                toggleBlackScreen();
              },
              child: Container(
                width: width * 0.8,
                height: height * 0.065,
                decoration: BoxDecoration(
                    color: puprle,
                    border: Border.all(color: darkPurple, width: width * 0.014),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: height * 0.025,
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: ImageIcon(
                            AssetImage(
                              "assets/images/add_school.png",
                            ),
                            color: backgroundColor,
                          ),
                        )),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Container(
                      height: height * 0.04,
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Text(
                          "Add States",
                          style: GoogleFonts.fredoka(
                            color: backgroundColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * 0.005,
            ),
            ...currentUser.searchFilterSearchCommunity.schools.currentState
                .map((e) {
              return Container(
                width: width * 0.8,
                height: height * 0.07,
                margin: EdgeInsets.only(bottom: height * 0.005),
                decoration: BoxDecoration(
                    color: puprle,
                    border: Border.all(color: darkPurple, width: width * 0.014),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: height * 0.04,
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Text(
                          stateToString(e),
                          style: GoogleFonts.fredoka(
                            color: backgroundColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
      filterTypeSchool.ZipCode: Container(
        width: width * 0.8,
        margin: EdgeInsets.only(left: width * 0.025),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: height * 0.005,
            ),
            InkWell(
              onTap: () {
                zipCodeTec.text = "";
                toggleZipCodeVisibility();
                toggleBlackScreen();
              },
              child: Container(
                width: width * 0.8,
                height: height * 0.065,
                decoration: BoxDecoration(
                    color: puprle,
                    border: Border.all(color: darkPurple, width: width * 0.014),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: height * 0.025,
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: ImageIcon(
                            AssetImage(
                              "assets/images/add_school.png",
                            ),
                            color: backgroundColor,
                          ),
                        )),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Container(
                      height: height * 0.04,
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Text(
                          "Add Zip Code",
                          style: GoogleFonts.fredoka(
                            color: backgroundColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * 0.005,
            ),
            ...currentUser.searchFilterSearchCommunity.schools.zipcode.map((e) {
              return InkWell(
                onTap: (){
                  
                  currentUser.searchFilterSearchCommunity.schools.addZipCode(e);
                  setState(() {
                    
                  });
                },
                child: Container(
                  width: width * 0.8,
                  height: height * 0.07,
                  margin: EdgeInsets.only(bottom: height * 0.005),
                  decoration: BoxDecoration(
                      color: puprle,
                      border: Border.all(color: darkPurple, width: width * 0.014),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: height * 0.04,
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(
                            e,
                            style: GoogleFonts.fredoka(
                              color: backgroundColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
      filterTypeSchool.None: Container(),
      filterTypeSchool.Distance: Container(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: height * 0.026,
              margin: EdgeInsets.only(left: width * 0.035),
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(
                  "schools in x miles radius :",
                  style: GoogleFonts.fredoka(
                      color: darkPurple, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.005,
            ),
            Container(
              height: height * 0.05,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      left: width * 0.03, 
                      bottom: height * 0.005
                    ),
                    child: SearchSChoolTextField2(
                            height * 0.045,
                            width * 0.2,
                            puprle,
                            darkPurple,
                            "",
                            0,
                            distanceTec,
                            getSchoolData,
                            showButton: false,
                            numbersOnly: true,
                          ),
                  ), 
                  SizedBox(
                    width : width * 0.01
                  ),
                  Container(
                    height: height * 0.045,
                    child: FittedBox(
                      fit: BoxFit.fitHeight, 
                      child : Text(
                        "Miles", 
                        style : GoogleFonts.fredoka(
                          color : puprle, 
                          fontWeight: FontWeight.w600
                        )
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )
    };
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: width,
          height: height,
          color: mainColor,
          child: Stack(
            children: [
              Opacity(
                opacity: 0.15,
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
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                    height: height * 0.063,
                                    width: height * 0.063,
                                    decoration: BoxDecoration(
                                        color: red,
                                        border: Border.all(
                                            color: darkRed,
                                            width: width * 0.012),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    padding: EdgeInsets.all(width * 0.025),
                                    child:
                                        Image.asset("assets/images/back.png"),
                                  ),
                                ),
                                Container(
                                  width: width * 0.075,
                                ),
                                Container(
                                    height: height * 0.06,
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Text(
                                        "Edit Filters",
                                        style: GoogleFonts.fredoka(
                                          color: mainColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: width * 0.85,
                              child: ListView(
                                padding: EdgeInsets.zero,
                                children: [
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    height: currentUser
                                                .searchFilterSearchCommunity
                                                .schools
                                                .type ==
                                            filterTypeSchool.Distance
                                        ? height * 0.19
                                        : height * 0.34,
                                    width: width * 0.85,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            80, 224, 224, 224),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: height * 0.05,
                                          margin: EdgeInsets.only(
                                              left: width * 0.03,
                                              top: width * 0.01),
                                          child: FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Text(
                                              "Schools",
                                              style: GoogleFonts.fredoka(
                                                  color: puprle,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: width * 0.8,
                                              height: height * 0.04,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4)),
                                                child: ListView(
                                                  padding: EdgeInsets.zero,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  children: [
                                                    SchoolFilterTypes(
                                                        currentUser
                                                                .searchFilterSearchCommunity
                                                                .schools
                                                                .type ==
                                                            filterTypeSchool
                                                                .certainSchool,
                                                        "School",
                                                        changeToCertainSchool),
                                                    SizedBox(
                                                      width: width * 0.013,
                                                    ),
                                                    SchoolFilterTypes(
                                                        currentUser
                                                                .searchFilterSearchCommunity
                                                                .schools
                                                                .type ==
                                                            filterTypeSchool
                                                                .State,
                                                        "States",
                                                        changeToStates),
                                                    SizedBox(
                                                      width: width * 0.013,
                                                    ),
                                                    SchoolFilterTypes(
                                                        currentUser
                                                                .searchFilterSearchCommunity
                                                                .schools
                                                                .type ==
                                                            filterTypeSchool
                                                                .ZipCode,
                                                        "Zip Code",
                                                        changeToZipCode),
                                                    SizedBox(
                                                      width: width * 0.013,
                                                    ),
                                                    SchoolFilterTypes(
                                                        currentUser
                                                                .searchFilterSearchCommunity
                                                                .schools
                                                                .type ==
                                                            filterTypeSchool
                                                                .Distance,
                                                        "Distance",
                                                        changeToDistance),
                                                    SizedBox(
                                                      width: width * 0.013,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: height * 0.005,
                                        ),
                                        Expanded(
                                          child: schoolFilterToWidget[
                                              currentUser
                                                  .searchFilterSearchCommunity
                                                  .schools
                                                  .type]!,
                                        ),
                                        Container(
                                          height: height * 0.008,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Container(
                                    height: height * 0.3,
                                    width: width * 0.85,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            80, 224, 224, 224),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: height * 0.05,
                                          margin: EdgeInsets.only(
                                              left: width * 0.03,
                                              top: width * 0.01),
                                          child: FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Text(
                                              "Grades",
                                              style: GoogleFonts.fredoka(
                                                  color: blue,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: width * 0.785,
                                            margin: EdgeInsets.only(
                                                left: width * 0.0275),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              child: ListView(
                                                padding: EdgeInsets.zero,
                                                children: [
                                                  ...Grade.values.map((e) {
                                                    if (e == Grade.None)
                                                      return Container();
                                                    return InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          currentUser
                                                              .searchFilterSearchCommunity
                                                              .addGrade(e);
                                                        });
                                                      },
                                                      child: AnimatedContainer(
                                                        duration: Duration(
                                                            milliseconds: 150),
                                                        height: height * 0.08,
                                                        width: width * 0.75,
                                                        margin: currentGradeToString(
                                                                    e) ==
                                                                "None"
                                                            ? EdgeInsets.zero
                                                            : EdgeInsets.only(
                                                                bottom: width *
                                                                    0.025),
                                                        decoration:
                                                            BoxDecoration(
                                                                color: currentUser
                                                                        .searchFilterSearchCommunity
                                                                        .grades
                                                                        .contains(
                                                                            e)
                                                                    ? blue
                                                                    : Colors
                                                                        .grey
                                                                        .shade200,
                                                                border:
                                                                    Border.all(
                                                                  color:
                                                                      darkblue,
                                                                  width: width *
                                                                      0.015,
                                                                ),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                        child: Center(
                                                            child: Container(
                                                                height: height *
                                                                    0.04,
                                                                child: Stack(
                                                                  children: [
                                                                    AnimatedOpacity(
                                                                      duration: Duration(
                                                                          milliseconds:
                                                                              150),
                                                                      opacity:
                                                                          1,
                                                                      child:
                                                                          SizedBox(
                                                                        height: height *
                                                                            0.04,
                                                                        child:
                                                                            FittedBox(
                                                                          fit: BoxFit
                                                                              .fitHeight,
                                                                          child:
                                                                              Text(
                                                                            currentGradeToString(e),
                                                                            style:
                                                                                GoogleFonts.fredoka(color: darkblue, fontWeight: FontWeight.w700),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    AnimatedOpacity(
                                                                      duration: Duration(
                                                                          milliseconds:
                                                                              150),
                                                                      opacity: currentUser
                                                                              .searchFilterSearchCommunity
                                                                              .grades
                                                                              .contains(e)
                                                                          ? 1
                                                                          : 0,
                                                                      child:
                                                                          SizedBox(
                                                                        height: height *
                                                                            0.04,
                                                                        child:
                                                                            FittedBox(
                                                                          fit: BoxFit
                                                                              .fitHeight,
                                                                          child:
                                                                              Text(
                                                                            currentGradeToString(e),
                                                                            style:
                                                                                GoogleFonts.fredoka(color: backgroundColor, fontWeight: FontWeight.w700),
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
                                          ),
                                        ),
                                        Container(
                                          height: height * 0.008,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Container(
                                    height: height * 0.35,
                                    width: width * 0.85,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            80, 224, 224, 224),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: height * 0.05,
                                          margin: EdgeInsets.only(
                                              left: width * 0.03,
                                              top: width * 0.01),
                                          child: FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Text(
                                              "Classes",
                                              style: GoogleFonts.fredoka(
                                                  color: orange,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: width * 0.785,
                                            margin: EdgeInsets.only(
                                                left: width * 0.0275),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              child: ListView(
                                                padding: EdgeInsets.zero,
                                                children: [
                                                  ...currentUser
                                                      .searchFilterSearchCommunity
                                                      .classes
                                                      .map((e) {
                                                    return InkWell(
                                                      onTap: () {
                                                        currentUser
                                                            .searchFilterSearchCommunity
                                                            .addClass(e);
                                                        setState(() {});
                                                      },
                                                      child: AnimatedContainer(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  150),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom:
                                                                      height *
                                                                          0.007),
                                                          height: height * 0.08,
                                                          width: width * 0.75,
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: e
                                                                      .getColor(),
                                                                  border: Border
                                                                      .all(
                                                                    color: e
                                                                        .getDColor(),
                                                                    width: width *
                                                                        0.015,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10))),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                  height:
                                                                      height *
                                                                          0.053,
                                                                  width: height *
                                                                      0.053,
                                                                  margin: EdgeInsets.only(
                                                                      right:
                                                                          (height * 0.07 - height * 0.053) /
                                                                              2,
                                                                      left: width *
                                                                          0.013),
                                                                  decoration: BoxDecoration(
                                                                      color:
                                                                          backgroundColor,
                                                                      borderRadius:
                                                                          BorderRadius.all(Radius.circular(
                                                                              8)),
                                                                      border: Border.all(
                                                                          color: e
                                                                              .getDColor(),
                                                                          width: width *
                                                                              0.008)),
                                                                  padding:
                                                                      EdgeInsets.all(height * 0.018 / 2),
                                                                  child: ImageIcon(
                                                                    AssetImage(e
                                                                        .getImageAddy()),
                                                                    color: e
                                                                        .getColor(),
                                                                  )),
                                                              SizedBox(
                                                                  width: width *
                                                                      0.005),
                                                              Container(
                                                                width:
                                                                    width * 0.6,
                                                                child: Text(
                                                                  e.className,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: GoogleFonts.fredoka(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color:
                                                                          backgroundColor,
                                                                      height: 1,
                                                                      fontSize: e.className.length < 25
                                                                          ? MediaQuery.of(context).textScaleFactor *
                                                                              23
                                                                          : MediaQuery.of(context).textScaleFactor *
                                                                              18),
                                                                ),
                                                              )
                                                            ],
                                                          )),
                                                    );
                                                  }).toList(),
                                                  InkWell(
                                                    onTap: () {
                                                      print(classes);
                                                      toggleBlackScreen();
                                                      toggleClassesPickerVisibility();
                                                    },
                                                    child: AnimatedContainer(
                                                      duration: Duration(
                                                          milliseconds: 150),
                                                      height: height * 0.07,
                                                      width: width * 0.75,
                                                      decoration: BoxDecoration(
                                                          color: orange,
                                                          border: Border.all(
                                                            color: darkOrange,
                                                            width:
                                                                width * 0.015,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          ImageIcon(
                                                            AssetImage(
                                                              "assets/images/add_school.png",
                                                            ),
                                                            color:
                                                                backgroundColor,
                                                            size: 23,
                                                          ),
                                                          SizedBox(
                                                              width: width *
                                                                  0.025),
                                                          SizedBox(
                                                            height:
                                                                height * 0.035,
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                              child: Text(
                                                                "Pick Classes",
                                                                style: GoogleFonts.fredoka(
                                                                    color:
                                                                        backgroundColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: height * 0.008,
                                        ),
                                      ],
                                    ),
                                  ),
                                  //! Skills
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Container(
                                    height: height * 0.35,
                                    width: width * 0.85,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            80, 224, 224, 224),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: height * 0.05,
                                          margin: EdgeInsets.only(
                                              left: width * 0.03,
                                              top: width * 0.01),
                                          child: FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Text(
                                              "Skills",
                                              style: GoogleFonts.fredoka(
                                                  color: mainColor,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: width * 0.785,
                                            margin: EdgeInsets.only(
                                                left: width * 0.0275),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              child: ListView(
                                                padding: EdgeInsets.zero,
                                                children: [
                                                  ...currentUser
                                                      .searchFilterSearchCommunity
                                                      .skills
                                                      .map((e) {
                                                    return InkWell(
                                                      onTap: () {
                                                        currentUser
                                                            .searchFilterSearchCommunity
                                                            .addSkill(e);
                                                        setState(() {});
                                                      },
                                                      child: AnimatedContainer(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  150),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom:
                                                                      height *
                                                                          0.007),
                                                          height: height * 0.08,
                                                          width: width * 0.75,
                                                          decoration:
                                                              BoxDecoration(
                                                                  color:
                                                                      mainColor,
                                                                  border: Border
                                                                      .all(
                                                                    color:
                                                                        darkGreen,
                                                                    width: width *
                                                                        0.015,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10))),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                width:
                                                                    width * 0.6,
                                                                child: Text(
                                                                  e.className,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: GoogleFonts.fredoka(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color:
                                                                          backgroundColor,
                                                                      height: 1,
                                                                      fontSize: e.className.length < 25
                                                                          ? MediaQuery.of(context).textScaleFactor *
                                                                              23
                                                                          : MediaQuery.of(context).textScaleFactor *
                                                                              18),
                                                                ),
                                                              )
                                                            ],
                                                          )),
                                                    );
                                                  }).toList(),
                                                  InkWell(
                                                    onTap: () {
                                                      toggleBlackScreen();
                                                      toggleSkillPickerScreen();
                                                    },
                                                    child: AnimatedContainer(
                                                      duration: Duration(
                                                          milliseconds: 150),
                                                      height: height * 0.07,
                                                      width: width * 0.75,
                                                      decoration: BoxDecoration(
                                                          color: mainColor,
                                                          border: Border.all(
                                                            color: darkGreen,
                                                            width:
                                                                width * 0.015,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          ImageIcon(
                                                            AssetImage(
                                                              "assets/images/add_school.png",
                                                            ),
                                                            color:
                                                                backgroundColor,
                                                            size: 23,
                                                          ),
                                                          SizedBox(
                                                              width: width *
                                                                  0.025),
                                                          SizedBox(
                                                            height:
                                                                height * 0.035,
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                              child: Text(
                                                                "Filter Skills",
                                                                style: GoogleFonts.fredoka(
                                                                    color:
                                                                        backgroundColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: height * 0.008,
                                        ),
                                      ],
                                    ),
                                  ),
                                  //! Clubs
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Container(
                                    height: height * 0.35,
                                    width: width * 0.85,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            80, 224, 224, 224),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: height * 0.05,
                                          margin: EdgeInsets.only(
                                              left: width * 0.03,
                                              top: width * 0.01),
                                          child: FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Text(
                                              "Clubs",
                                              style: GoogleFonts.fredoka(
                                                  color: mainColor,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: width * 0.785,
                                            margin: EdgeInsets.only(
                                                left: width * 0.0275),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              child: ListView(
                                                padding: EdgeInsets.zero,
                                                children: [
                                                  ...currentUser
                                                      .searchFilterSearchCommunity
                                                      .clubs
                                                      .map((e) {
                                                    return InkWell(
                                                      onTap: () {
                                                        currentUser
                                                            .searchFilterSearchCommunity
                                                            .addClub(e);
                                                        setState(() {});
                                                      },
                                                      child: AnimatedContainer(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  150),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom:
                                                                      height *
                                                                          0.007),
                                                          height: height * 0.08,
                                                          width: width * 0.75,
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: e
                                                                      .getClubTypeColor(),
                                                                  border: Border
                                                                      .all(
                                                                    color: e
                                                                        .getClubTypeColorDark(),
                                                                    width: width *
                                                                        0.015,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10))),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                width: width *
                                                                    0.0125,
                                                              ),
                                                              Container(
                                                                height: height *
                                                                    0.052,
                                                                width: height *
                                                                    0.052,
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                        backgroundColor,
                                                                    border: Border.all(
                                                                        color: e
                                                                            .getClubTypeColorDark(),
                                                                        width: width *
                                                                            0.008),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8)),
                                                                padding: EdgeInsets
                                                                    .all(width *
                                                                        0.012),
                                                                child: e.getImage(
                                                                    "",
                                                                    finalColor:
                                                                        e.getClubTypeColor()),
                                                              ),
                                                              SizedBox(
                                                                width: width *
                                                                    0.017,
                                                              ),
                                                              Container(
                                                                width:
                                                                    width * 0.6,
                                                                child: Text(
                                                                  e.className,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: GoogleFonts.fredoka(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color:
                                                                          backgroundColor,
                                                                      height: 1,
                                                                      fontSize: e.className.length < 25
                                                                          ? MediaQuery.of(context).textScaleFactor *
                                                                              23
                                                                          : MediaQuery.of(context).textScaleFactor *
                                                                              18),
                                                                ),
                                                              )
                                                            ],
                                                          )),
                                                    );
                                                  }).toList(),
                                                  InkWell(
                                                    onTap: () {
                                                      toggleBlackScreen();
                                                      toggleClubSearch();
                                                    },
                                                    child: AnimatedContainer(
                                                      duration: Duration(
                                                          milliseconds: 150),
                                                      height: height * 0.07,
                                                      width: width * 0.75,
                                                      decoration: BoxDecoration(
                                                          color: mainColor,
                                                          border: Border.all(
                                                            color: darkGreen,
                                                            width:
                                                                width * 0.015,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          ImageIcon(
                                                            AssetImage(
                                                              "assets/images/add_school.png",
                                                            ),
                                                            color:
                                                                backgroundColor,
                                                            size: 23,
                                                          ),
                                                          SizedBox(
                                                              width: width *
                                                                  0.025),
                                                          SizedBox(
                                                            height:
                                                                height * 0.035,
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                              child: Text(
                                                                "Filter Clubs",
                                                                style: GoogleFonts.fredoka(
                                                                    color:
                                                                        backgroundColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: height * 0.008,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              showBlackScreen
                  ? SingleChildScrollView(
                      child: InkWell(
                        onTap: () {
                          toggleBlackScreen();
                          classesPickerVisibility = false;
                          showSkillPickerScreen = false;
                          statePickerVisibility = false;
                          zipCodePickerVisibility = false;
                          setState(() {});
                        },
                        child: Container(
                          height: height,
                          width: width,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    )
                  : Container(),
              classesPickerVisibility
                  ? SingleChildScrollView(
                      child: InkWell(
                        onTap: () {
                          toggleClassesPickerVisibility();
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
                                            color: orange,
                                            width: width * 0.015),
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
                                                        currentUser
                                                            .searchFilterSearchCommunity
                                                            .addClass(e);
                                                      });
                                                    },
                                                    child:
                                                        ClassDisplayWidget(e));
                                              }).toList()
                                            : classesQueryList.map((e) {
                                                return InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        currentUser
                                                            .searchFilterSearchCommunity
                                                            .addClass(e);
                                                      });
                                                    },
                                                    child:
                                                        ClassDisplayWidget(e));
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
              showSkillPickerScreen
                  ? SingleChildScrollView(
                      child: InkWell(
                        onTap: () {
                          toggleBlackScreen();
                          toggleSkillPickerScreen();
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
                                    mainColor,
                                    darkGreen,
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
                                          color: mainColor,
                                          width: width * 0.015),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  padding: EdgeInsets.all(width * 0.015),
                                  child: ListView(
                                    padding: EdgeInsets.all(0),
                                    children: skillsRecommendedList.length ==
                                                0 &&
                                            skillsTec.text == ""
                                        ? skills.map((e) {
                                            return InkWell(
                                              onTap: () async {
                                                currentUser
                                                    .searchFilterSearchCommunity
                                                    .addSkill(e);
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
                                                              color: mainColor,
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
                                                  currentUser.skills.add(e);
                                                  print("here");
                                                  setState(() {});
                                                },
                                                child: Container(
                                                    width: width * 0.85,
                                                    height: height * 0.07,
                                                    margin: EdgeInsets.only(
                                                        bottom: width * 0.015),
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
                                                            e.className,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: GoogleFonts.fredoka(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    mainColor,
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
                                          ],
                                  ),
                                )
                              ],
                            )),
                      ),
                    )
                  : Container(),
              clubSearchVisibility
                  ? SingleChildScrollView(
                      child: InkWell(
                        onTap: () {
                          toggleClubSearch();
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
                                    mainColor,
                                    darkGreen,
                                    "",
                                    0,
                                    clubsTec,
                                    getSchoolData,
                                    showButton: false),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    height: height * 0.3,
                                    width: width * 0.9,
                                    decoration: BoxDecoration(
                                        color: backgroundColor,
                                        border: Border.all(
                                            color: mainColor,
                                            width: width * 0.015),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    padding: EdgeInsets.all(width * 0.015),
                                    child: ListView(
                                      padding: EdgeInsets.all(0),
                                      children: clubRecommendedList.length ==
                                                  0 &&
                                              clubsTec.text.isEmpty
                                          ? [
                                              ...clubs.map((e) {
                                                return InkWell(
                                                  onTap: () {
                                                    currentUser
                                                        .searchFilterSearchCommunity
                                                        .addClub(e);
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    width: width * 0.85,
                                                    height: height * 0.07,
                                                    margin: EdgeInsets.only(
                                                        bottom: width * 0.015),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical:
                                                                width * 0.01),
                                                    decoration: BoxDecoration(
                                                        color: e
                                                            .getClubTypeColor(),
                                                        border: Border.all(
                                                            color: e
                                                                .getClubTypeColorDark(),
                                                            width:
                                                                width * 0.01),
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    8))),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: width * 0.0125,
                                                        ),
                                                        Container(
                                                          height:
                                                              height * 0.052,
                                                          width: height * 0.052,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  backgroundColor,
                                                              border: Border.all(
                                                                  color: e
                                                                      .getClubTypeColorDark(),
                                                                  width: width *
                                                                      0.008),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          padding:
                                                              EdgeInsets.all(
                                                                  width *
                                                                      0.012),
                                                          child: e.getImage("",
                                                              finalColor: e
                                                                  .getClubTypeColor()),
                                                        ),
                                                        SizedBox(
                                                          width: width * 0.013,
                                                        ),
                                                        Container(
                                                          width: width * 0.65,
                                                          child: Text(
                                                            e.className,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: GoogleFonts.fredoka(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    backgroundColor,
                                                                height: 1,
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .textScaleFactor *
                                                                    18),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }).toList()
                                            ]
                                          : clubRecommendedList.isEmpty
                                              ? [
                                                  Container(
                                                    height: height * 0.15,
                                                    margin: EdgeInsets.only(
                                                        top: height * 0.035),
                                                    child: Image.asset(
                                                      "assets/images/club.png",
                                                      fit: BoxFit.fitHeight,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.01,
                                                  ),
                                                  Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                width * 0.05),
                                                    child: Text(
                                                      "The club you are searching for is not in our database.",
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts.fredoka(
                                                          height: 1.3,
                                                          color: mainColor,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .textScaleFactor *
                                                              17),
                                                    ),
                                                  )
                                                ]
                                              : [
                                                  ...clubRecommendedList
                                                      .map((e) {
                                                    return InkWell(
                                                      onTap: () {
                                                        currentUser
                                                            .searchFilterSearchCommunity
                                                            .addClub(e);
                                                        setState(() {});
                                                      },
                                                      child: Container(
                                                        width: width * 0.85,
                                                        height: height * 0.07,
                                                        margin: EdgeInsets.only(
                                                            bottom:
                                                                width * 0.015),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical:
                                                                    width *
                                                                        0.01),
                                                        decoration: BoxDecoration(
                                                            color: e
                                                                .getClubTypeColor(),
                                                            border: Border.all(
                                                                color: e
                                                                    .getClubTypeColorDark(),
                                                                width: width *
                                                                    0.01),
                                                            borderRadius:
                                                                const BorderRadius
                                                                        .all(
                                                                    Radius
                                                                        .circular(
                                                                            8))),
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: width *
                                                                  0.0125,
                                                            ),
                                                            Container(
                                                              height: height *
                                                                  0.052,
                                                              width: height *
                                                                  0.052,
                                                              decoration: BoxDecoration(
                                                                  color:
                                                                      backgroundColor,
                                                                  border: Border.all(
                                                                      color: e
                                                                          .getClubTypeColorDark(),
                                                                      width: width *
                                                                          0.008),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8)),
                                                              padding: EdgeInsets
                                                                  .all(width *
                                                                      0.012),
                                                              child: e.getImage(
                                                                  "",
                                                                  finalColor: e
                                                                      .getClubTypeColor()),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  width * 0.013,
                                                            ),
                                                            Container(
                                                              width:
                                                                  width * 0.65,
                                                              child: Text(
                                                                e.className,
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: GoogleFonts.fredoka(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color:
                                                                        backgroundColor,
                                                                    height: 1,
                                                                    fontSize:
                                                                        MediaQuery.of(context).textScaleFactor *
                                                                            18),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }).toList()
                                                ],
                                    ))
                              ],
                            )),
                      ),
                    )
                  : Container(),
              statePickerVisibility
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
                          padding: EdgeInsets.all(0),
                          children: [
                            ...USStates.values.map((e) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    currentUser
                                        .searchFilterSearchCommunity.schools
                                        .addState(e);
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 150),
                                  height: height * 0.08,
                                  width: width * 0.75,
                                  margin:
                                      EdgeInsets.only(bottom: width * 0.025),
                                  decoration: BoxDecoration(
                                      color: currentUser
                                              .searchFilterSearchCommunity
                                              .schools
                                              .currentState
                                              .contains(e)
                                          ? puprle
                                          : backgroundColor,
                                      border: Border.all(
                                        color: darkPurple,
                                        width: width * 0.015,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Center(
                                      child: Container(
                                          height: height * 0.04,
                                          child: Stack(
                                            children: [
                                              AnimatedOpacity(
                                                duration:
                                                    Duration(milliseconds: 150),
                                                opacity: 1,
                                                child: SizedBox(
                                                  height: height * 0.04,
                                                  child: FittedBox(
                                                    fit: BoxFit.fitHeight,
                                                    child: Text(
                                                      stateToString(e),
                                                      style:
                                                          GoogleFonts.fredoka(
                                                              color: darkPurple,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              AnimatedOpacity(
                                                duration:
                                                    Duration(milliseconds: 150),
                                                opacity: currentUser
                                                        .searchFilterSearchCommunity
                                                        .schools
                                                        .currentState
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
                                                          color:
                                                              backgroundColor,
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
              zipCodePickerVisibility
                  ? SingleChildScrollView(
                      child: InkWell(
                        onTap: () {
                          toggleBlackScreen();
                          zipCodePickerVisibility = false;
                        },
                        child: Container(
                            height: height,
                            width: width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SearchSChoolTextField(
                                    height * 0.075,
                                    width * 0.9,
                                    puprle,
                                    darkPurple,
                                    "Enter Zipcode",
                                    width * 0,
                                    zipCodeTec,
                                    getSchoolData,
                                    showButton: false,
                                    numbersOnly: true),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                SingleChildScrollView(
                                  child: InkWell(
                                    onTap: () {
                                      currentUser
                                          .searchFilterSearchCommunity.schools
                                          .addZipCode(zipCodeTec.text);
                                      zipCodeTec.text = "";
                                      toggleBlackScreen();
                                      zipCodePickerVisibility = false;
                                      setState(() {});
                                    },
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      height: zipCodeTec.text.length == 5
                                          ? height * 0.065
                                          : 0,
                                      width: zipCodeTec.text.length == 5
                                          ? width * 0.4
                                          : 0,
                                      decoration: BoxDecoration(
                                          color: puprle,
                                          border: Border.all(
                                              color: darkPurple,
                                              width: width * 0.015),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: zipCodeTec.text.length == 5
                                            ? [
                                                Container(
                                                    height: height * 0.0225,
                                                    child: FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: ImageIcon(
                                                        AssetImage(
                                                          "assets/images/add_school.png",
                                                        ),
                                                        color: backgroundColor,
                                                      ),
                                                    )),
                                                SizedBox(
                                                  width: width * 0.015,
                                                ),
                                                Container(
                                                  height: height * 0.04,
                                                  child: FittedBox(
                                                    fit: BoxFit.fitHeight,
                                                    child: Text(
                                                      "Add",
                                                      style:
                                                          GoogleFonts.fredoka(
                                                        color: backgroundColor,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ]
                                            : [],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ),
                    )
                  : Container(),
              searchSchoolVisibility
                  ? SingleChildScrollView(
                      child: InkWell(
                        onTap: () {
                          toggleSearchSchoolVisibility();
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
                                    height * 0.075,
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
                                                            .searchFilterSearchCommunity
                                                            .schools
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

class SchoolFilterTypes extends StatefulWidget {
  bool enabled;
  String name;
  Function onTap;
  SchoolFilterTypes(this.enabled, this.name, this.onTap);
  @override
  State<SchoolFilterTypes> createState() => _SchoolFilterTypesState();
}

class _SchoolFilterTypesState extends State<SchoolFilterTypes> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        print("here");
        widget.onTap();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: height * 0.04,
        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
        decoration: BoxDecoration(
            color: widget.enabled ? puprle : Colors.grey.shade200,
            border: Border.all(color: puprle, width: width * 0.01),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Text(
            widget.name,
            style: GoogleFonts.fredoka(
                color: widget.enabled ? backgroundColor : puprle,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
