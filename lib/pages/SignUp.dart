import 'dart:convert';

import 'package:fl_geocoder/fl_geocoder.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/main.dart';
import 'package:highschoolhub/models/class.dart';
import 'package:highschoolhub/models/club.dart';
import 'package:highschoolhub/models/school.dart';
import 'package:highschoolhub/models/skills.dart';
import 'package:highschoolhub/models/uploadDataToDatabase.dart';
import 'package:highschoolhub/models/user.dart';
import 'package:highschoolhub/pages/AuthenticationPage.dart';
import 'package:highschoolhub/pages/SignUpScreen/AccountInfo.dart';
import 'package:highschoolhub/pages/SignUpScreen/ClubScreen.dart';
import 'package:highschoolhub/pages/SignUpScreen/EducationInfo.dart';
import 'package:highschoolhub/pages/SignUpScreen/SkillSpecifier.dart';
import 'package:highschoolhub/widgets/imageIcon.dart';
import 'package:lottie/lottie.dart';
import 'package:postgres/postgres.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class Range {
  int lowerBound;
  int upperBound;
  Range(this.lowerBound, this.upperBound);
  List<int> returnNumberInRange() {
    List<int> answer = [];

    for (int i = lowerBound; i <= upperBound; i++) {
      answer.add(i);
    }
    return answer;
  }
}

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  @override
  //! Variable Declerations
  List<Color> normalColorList = [blue, puprle, orange, mainColor];
  List<Color> darkColorList = [darkblue, darkPurple, darkOrange, darkGreen];
  List<bool> pageCompleted = [true, true, true, true];
  late TabController _tabController;
  bool loadingState = false;
  bool keyboardUp = false;
  bool showBlackScreen = false;
  final geocoder = FlGeocoder(googleMpasApiKey);
  bool searchResultsLoading = false;
  int currentScreen = 0;
  List<schoolClassDatabase> classes = [];
  List clubs = [];
  List clubRecommendedList = [];
  TextEditingController clubsTec = TextEditingController();
  List skills = [];
  List skillsRecommendedList = [];
  
  TextEditingController skillsTec = TextEditingController();
  //! School Data Acquisition Functions
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

  //! Get Data From Database
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

  Future<int> getClubDataFromdatabase() async {
    final result = await supaBase.from("Clubs").select();
    print("getting club data");
    print(result);
    classes = [];
    clubs = [];
    for (Map data in result) {
      club value = club();
      value.fromJson(data);
      bool flag = false;
      for (School s in currentUser.schools) {
        if (value.schoolContained(s.name)) flag = true;
      }
      if (flag) {
        print(data["type"]);
        clubs.add(value);
        print(value.className);
        print(value.type.toReadableString());
      }
    }
    return 1;
  }

  Future<int> getSkillsFromDatabase() async {
    final result = await supaBase.from("Skills").select();
    classes = [];
    for (Map data in result) {
      Skill value = Skill();
      value.fromJSON(data);
      skills.add(value);
    }
    return 1;
  }

  //! SHOW FUNCTIONS
  void setLoadingState() =>
      setState(() => loadingState = loadingState == false);
  void toggleShowBlackScreen() {
    setState(() {
      showBlackScreen = showBlackScreen == false;
      if (showBlackScreen == false && searchSchoolVisibility) {
        setState(() {
          showSearchSchool();
        });
      }
      if (showBlackScreen == false && classesPickerVisibility) {
        setState(() {
          showClassesPickerVisibility();
        });
      }
      if (showBlackScreen == false && chooseSchoolForClassVisibility) {
        setState(() {
          showClassesPickerVisibility();
        });
      }
      if (showBlackScreen == false && skillSearchVisibility) {
        toggleSkillSearch();
      }
      if (showBlackScreen == false && clubSearchVisibility) {
        toggleClubSearchScreen();
      }
    });
  }

  bool classesPickerVisibility = false;
  void showClassesPickerVisibility() {
    setState(() {
      classesPickerVisibility = classesPickerVisibility == false;
    });
  }

  bool clubSearchVisibility = false;
  void toggleClubSearchScreen() {
    setState(() => clubSearchVisibility = clubSearchVisibility == false);
  }

  bool skillSearchVisibility = false;
  void toggleSkillSearch() {
    setState(() => skillSearchVisibility = skillSearchVisibility == false);
  }

  bool monthPickerVisbility = false;
  void showMonthPicker() {
    setState(() {
      monthPickerVisbility = monthPickerVisbility == false;
    });
  }

  bool statePickerVisibility = false;
  void showStatePicker() {
    setState(() {
      statePickerVisibility = statePickerVisibility == false;
    });
  }
  bool gradePickerVisibility = false;
  void showGradePicker() {
    setState((){
      gradePickerVisibility = gradePickerVisibility == false;
    });
  }

  bool searchSchoolVisibility = false;
  void showSearchSchool() {
    setState(() {
      searchSchoolVisibility = searchSchoolVisibility == false;
    });
  }

  bool chooseSchoolForClassVisibility = false;
  void showChooseSchoolForClass() {
    setState(() {
      chooseSchoolForClassVisibility = chooseSchoolForClassVisibility == false;
    });
  }

  bool showClubSchoolPicker = false;
  void toggleClubSchoolPicker() {
    setState(() {
      showClubSchoolPicker = showClubSchoolPicker == false;
    });
  }

  //! INIT STATE FUNCTION
  void initStateFunction() async {
    _tabController = TabController(length: 4, vsync: this);
    await getWebsiteData();
    await getClassOptions();
    await getClubDataFromdatabase();
    await getSkillsFromDatabase();
    classesQueryList = classes;

    setState(() {});
    _tabController.addListener(() {
      setState(() {
        currentScreen = _tabController.index;
      });
    });
    classesTec.addListener(() {
      setState(() {
        classesQueryList = sortListByQuery(classes, classesTec.text);
      });
    });
    clubsTec.addListener(() {
      clubRecommendedList = sortListByQuery(clubs, clubsTec.text);
      setState(() {});
    });
    skillsTec.addListener(() {
      skillsRecommendedList = sortListByQuery(skills, skillsTec.text);
      setState(() {});
    });
  }

  void initState() {
    initStateFunction();
    super.initState();
  }

  //! Additional Functions
  List classesQueryList = [];
  late schoolClassStudent schoolChoosingClass;
  void setSchoolChossingClass(schoolClassStudent gClass) {
    schoolChoosingClass = gClass;
  }

  late clubAppData schoolChoosingClub;
  void setSchoolChoosingClub(clubAppData gClass) {
    schoolChoosingClub = gClass;
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

  Widget build(BuildContext context) {
    keyboardUp = MediaQuery.of(context).viewInsets.bottom != 0;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List arguments = ModalRoute.of(context)!.settings.arguments as List;
    AppUser currentUser = arguments[0];
    return Scaffold(
        body: SingleChildScrollView(
      physics:
          keyboardUp ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
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
                          SizedBox(
                            width: width * 0.05,
                          ),
                          Container(
                            height: height * 0.0725,
                            width: height * 0.0725,
                            child: FloatingActionButton(
                                heroTag: "asdf",
                                onPressed: () async {
                                  if (currentScreen != 0) {
                                    currentScreen--;
                                    _tabController.animateTo(currentScreen,
                                        duration: Duration(milliseconds: 300));
                                  } else {
                                    try {
                                      await Supabase.instance.client.auth
                                          .signOut();
                                    } on Exception catch (_) {}
                                    ;
                                    Navigator.of(context).popAndPushNamed(
                                        "authenticationScreen");
                                  }
                                  if (currentScreen == 2) {
                                    getClassOptions();
                                  }
                                  setState(() {});
                                },
                                elevation: 2,
                                backgroundColor: currentScreen == 0
                                    ? red
                                    : normalColorList[currentScreen],
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  side: BorderSide(
                                      width: width * 0.0125,
                                      color: currentScreen == 0
                                          ? darkRed
                                          : darkColorList[currentScreen]),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    currentScreen == 0
                                        ? width * 0.042
                                        : width * 0.03,
                                  ),
                                  child: RotatedBox(
                                    quarterTurns: 2,
                                    child: Image.asset(currentScreen == 0
                                        ? "assets/images/back.png"
                                        : "assets/images/arrow.png"),
                                  ),
                                )),
                          ),
                          Expanded(child: Container()),
                          InkWell(
                            child: Container(
                              height: height * 0.0725,
                              child: FittedBox(
                                child: Text(
                                  "Sign Up",
                                  style: GoogleFonts.fredoka(
                                      fontWeight: FontWeight.w800,
                                      color: normalColorList[currentScreen]),
                                ),
                              ),
                            ),
                          ),
                          Expanded(child: Container()),
                          Container(
                            height: height * 0.0725,
                            width: height * 0.0725,
                            child: FloatingActionButton(
                              heroTag: "asdfd",
                                onPressed: () async {
                                  if (currentScreen != 3) {
                                    currentScreen++;
                                    _tabController.animateTo(currentScreen,
                                        duration: Duration(milliseconds: 300));
                                  }else{ 
                                    await currentUser.setGeneralData();
                                    Navigator.of(context).popAndPushNamed("HomeScreen");
                                  }
                                  print("current Screen " +
                                      currentScreen.toString());
                                  if (currentScreen == 2) {
                                    getClassOptions();
                                  }
                                  if (currentScreen == 3) {
                                    getClubDataFromdatabase();
                                  }
                                  setState(() {});
                                },
                                elevation: 2,
                                backgroundColor: normalColorList[currentScreen],
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  side: BorderSide(
                                      width: width * 0.0125,
                                      color: darkColorList[currentScreen]),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    currentScreen == 3
                                        ? width * 0.035
                                        : width * 0.03,
                                  ),
                                  child: RotatedBox(
                                    quarterTurns: 0,
                                    child: Image.asset(currentScreen == 3
                                        ? "assets/images/done.png"
                                        : "assets/images/arrow.png"),
                                  ),
                                )),
                          ),
                          SizedBox(
                            width: width * 0.05,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Container(
                      width: width,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          AccountInfoScreen(
                              currentUser,
                              setLoadingState,
                              toggleShowBlackScreen,
                              showMonthPicker,
                              showStatePicker, 
                              showGradePicker),
                          EducationInfoScreen(toggleShowBlackScreen,
                              showSearchSchool, currentUser),
                          SkillInfoScreen(
                              currentUser,
                              toggleShowBlackScreen,
                              showClassesPickerVisibility,
                              showChooseSchoolForClass,
                              setSchoolChossingClass),
                          ClubInfoScreen(
                              toggleShowBlackScreen,
                              toggleSkillSearch,
                              toggleClubSearchScreen,
                              toggleClubSchoolPicker,
                              setSchoolChoosingClub)
                        ],
                      ),
                    )),
                    Container(
                      width: width * 0.9,
                      height: height * 0.08,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          NavigationIcon(
                              "assets/images/signUpScreenIcons/user.png",
                              pageCompleted,
                              normalColorList,
                              currentScreen,
                              0),
                          NavigationIcon(
                              "assets/images/signUpScreenIcons/school.png",
                              pageCompleted,
                              normalColorList,
                              currentScreen,
                              1),
                          NavigationIcon(
                              "assets/images/signUpScreenIcons/skills.png",
                              pageCompleted,
                              normalColorList,
                              currentScreen,
                              2),
                          NavigationIcon(
                              "assets/images/signUpScreenIcons/trophy.png",
                              pageCompleted,
                              normalColorList,
                              currentScreen,
                              3),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            loadingState
                ? Container(
                    height: height,
                    width: width,
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                        child: LoadingAnimationWidget.threeRotatingDots(
                            color: normalColorList[currentScreen],
                            size: height * 0.1)),
                  )
                : Container(),
            showBlackScreen
                ? InkWell(
                    onTap: () {
                      toggleShowBlackScreen();
                      if (monthPickerVisbility) {
                        showMonthPicker();
                      }
                      if (statePickerVisibility) {
                        showStatePicker();
                      }
                      if(gradePickerVisibility){
                        showGradePicker();
                      }
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
            monthPickerVisbility
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
                          ...[
                            Months.January,
                            Months.February,
                            Months.March,
                            Months.April,
                            Months.May,
                            Months.June,
                            Months.July,
                            Months.August,
                            Months.September,
                            Months.October,
                            Months.November,
                            Months.December
                          ].map((e) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  currentUser.dateOfBirth!.month = e;
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 150),
                                height: height * 0.08,
                                width: width * 0.75,
                                margin: EdgeInsets.only(bottom: width * 0.025),
                                decoration: BoxDecoration(
                                    color: currentUser.dateOfBirth!.month == e
                                        ? blue
                                        : backgroundColor,
                                    border: Border.all(
                                      color: darkblue,
                                      width: width * 0.015,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
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
                                                    monthToString(e)[0],
                                                    style: GoogleFonts.fredoka(
                                                        color: darkblue,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            AnimatedOpacity(
                                              duration:
                                                  Duration(milliseconds: 150),
                                              opacity: currentUser
                                                          .dateOfBirth!.month ==
                                                      e
                                                  ? 1
                                                  : 0,
                                              child: SizedBox(
                                                height: height * 0.04,
                                                child: FittedBox(
                                                  fit: BoxFit.fitHeight,
                                                  child: Text(
                                                    monthToString(e)[0],
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
                                  currentUser.userState = e;
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 150),
                                height: height * 0.08,
                                width: width * 0.75,
                                margin: EdgeInsets.only(bottom: width * 0.025),
                                decoration: BoxDecoration(
                                    color: currentUser.userState == e
                                        ? blue
                                        : backgroundColor,
                                    border: Border.all(
                                      color: darkblue,
                                      width: width * 0.015,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
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
                                                    style: GoogleFonts.fredoka(
                                                        color: darkblue,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            AnimatedOpacity(
                                              duration:
                                                  Duration(milliseconds: 150),
                                              opacity:
                                                  currentUser.userState == e
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
            gradePickerVisibility
                ? Center(
                    child: Container(
                      height: height * 0.47,
                      width: width * 0.8,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                      ),
                      padding: EdgeInsets.all(width * 0.025),
                      child: Column(
                        children: [
                          ...Grade.values.map((e) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  currentUser.changeGrade(e);
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 150),
                                height: height * 0.08,
                                width: width * 0.75,
                                margin: currentGradeToString(e) == "None" ? EdgeInsets.zero: EdgeInsets.only(bottom: width * 0.025),
                                decoration: BoxDecoration(
                                    color: currentUser.currentGrade == e
                                        ? blue
                                        : backgroundColor,
                                    border: Border.all(
                                      color: darkblue,
                                      width: width * 0.015,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
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
                                                    currentGradeToString(e),
                                                    style: GoogleFonts.fredoka(
                                                        color: darkblue,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            AnimatedOpacity(
                                              duration:
                                                  Duration(milliseconds: 150),
                                              opacity:
                                                  currentUser.currentGrade == e
                                                      ? 1
                                                      : 0,
                                              child: SizedBox(
                                                height: height * 0.04,
                                                child: FittedBox(
                                                  fit: BoxFit.fitHeight,
                                                  child: Text(
                                                    currentGradeToString(e),
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
                                                      color: puprle,
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
                                                                  color: puprle,
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
                                onTap: (){},
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  height: height * 0.3,
                                  width: width * 0.9,
                                  decoration: BoxDecoration(
                                      color: backgroundColor,
                                      border: Border.all(
                                          color: orange, width: width * 0.015),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15))),
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
                                                      currentUser.addClass(e);
                                                    });
                                                  },
                                                  child: ClassDisplayWidget(e));
                                            }).toList()
                                          : classesQueryList.map((e) {
                                              return InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      currentUser.addClass(e);
                                                    });
                                                  },
                                                  child: ClassDisplayWidget(e));
                                            }).toList(),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              "CreateSchoolSpecificClass",
                                              arguments: {
                                                "currentUser": currentUser
                                              });
                                        },
                                        child: Container(
                                          width: width * 0.85,
                                          height: height * 0.075,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            border: Border.all(
                                                color: darkOrange,
                                                width: width * 0.01),
                                            color: orange,
                                          ),
                                          margin: EdgeInsets.only(
                                              bottom: height * 0.01),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: height * 0.035,
                                                width: height * 0.035,
                                                child: ImageIcon(
                                                  AssetImage(
                                                      "assets/images/add_school.png"),
                                                  color: backgroundColor,
                                                ),
                                              ),
                                              SizedBox(
                                                width: width * 0.025,
                                              ),
                                              Text(
                                                "Add School Specific\nClass",
                                                style: GoogleFonts.fredoka(
                                                    fontWeight: FontWeight.w600,
                                                    color: backgroundColor,
                                                    height: 01,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .textScaleFactor *
                                                            20),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )),
                    ),
                  )
                : Container(),
            chooseSchoolForClassVisibility
                ? SingleChildScrollView(
                    child: InkWell(
                      onTap: () {
                        showChooseSchoolForClass();
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
                              SizedBox(
                                height: height * 0.01,
                              ),
                              AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  height: height * 0.35,
                                  width: width * 0.9,
                                  decoration: BoxDecoration(
                                      color: backgroundColor,
                                      border: Border.all(
                                          color: orange, width: width * 0.015),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  padding: EdgeInsets.all(width * 0.015),
                                  child: ListView(
                                    padding: EdgeInsets.zero,
                                    children: [
                                      ...currentUser.schools.map((e) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              schoolChoosingClass!
                                                  .classTakenAt = e;
                                            });
                                          },
                                          child: Container(
                                            width: width * 0.85,
                                            height: height * 0.08,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              border: Border.all(
                                                  color: schoolChoosingClass!
                                                              .classTakenAt !=
                                                          e
                                                      ? Colors.transparent
                                                      : darkOrange,
                                                  width: width * 0.01),
                                              color: schoolChoosingClass!
                                                          .classTakenAt !=
                                                      e
                                                  ? Color.fromARGB(
                                                      255, 226, 225, 225)
                                                  : orange,
                                            ),
                                            margin: EdgeInsets.only(
                                                bottom: height * 0.01),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: width * 0.01,
                                                ),
                                                Container(
                                                  height: height * 0.06,
                                                  width: height * 0.06,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: schoolChoosingClass!
                                                                    .classTakenAt !=
                                                                e
                                                            ? Colors.white
                                                            : darkOrange,
                                                        width: width * 0.01),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                  padding: EdgeInsets.all(
                                                      width * 0.005),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    child:
                                                        Image.network(e.image),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width * 0.02,
                                                ),
                                                Container(
                                                  width: width * 0.6,
                                                  child: Text(
                                                    e.name,
                                                    textAlign: TextAlign.left,
                                                    maxLines: 2,
                                                    style: GoogleFonts.fredoka(
                                                        color: schoolChoosingClass!
                                                                    .classTakenAt !=
                                                                e
                                                            ? orange
                                                            : backgroundColor,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: e
                                                                    .name.length <=
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
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ))
                            ],
                          )),
                    ),
                  )
                : Container(),
            //! CLUB SEARCH VISBILITY
            clubSearchVisibility
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
                                        color: mainColor, width: width * 0.015),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                padding: EdgeInsets.all(width * 0.015),
                                child: ListView(
                                  padding: EdgeInsets.all(0),
                                  children: clubRecommendedList.length == 0 &&
                                          clubsTec.text.isEmpty
                                      ? [
                                          ...clubs.map((e) {
                                            return InkWell(
                                              onTap: () {
                                                toggleShowBlackScreen();
                                                clubAppData temp =
                                                    clubAppData();
                                                temp.setClubData(e);
                                                currentUser.clubs.add(temp);
                                                setState(() {});
                                              },
                                              child: Container(
                                                width: width * 0.85,
                                                height: height * 0.07,
                                                margin: EdgeInsets.only(
                                                    bottom: width * 0.015),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: width * 0.01),
                                                decoration: BoxDecoration(
                                                    color: e.getClubTypeColor(),
                                                    border: Border.all(
                                                        color: e
                                                            .getClubTypeColorDark(),
                                                        width: width * 0.01),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: width * 0.0125,
                                                    ),
                                                    Container(
                                                      height: height * 0.052,
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
                                                                  .circular(8)),
                                                      padding: EdgeInsets.all(
                                                          width * 0.012),
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
                                                                FontWeight.w600,
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
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: width * 0.05),
                                                child: Text(
                                                  "Your club isn't found. Add it after making an account.",
                                                  maxLines: 3,
                                                  textAlign: TextAlign.center,
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
                                              ...clubRecommendedList.map((e) {
                                                return InkWell(
                                                  onTap: () {
                                                    toggleShowBlackScreen();
                                                    clubAppData temp =
                                                        clubAppData();
                                                    temp.setClubData(e);
                                                    currentUser.clubs.add(temp);
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
                                            ],
                                ),
                              )
                            ],
                          )),
                    ),
                  )
                : Container(),
            //! SKILL SEARCH VISBILITY
            skillSearchVisibility
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
                                        color: mainColor, width: width * 0.015),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                padding: EdgeInsets.all(width * 0.015),
                                child: ListView(
                                  padding: EdgeInsets.all(0),
                                  children: 
                                  skillsRecommendedList.length == 0 && skillsTec.text == ""? 
                                  skills.map((e){
                                         return InkWell(
                                        onTap: () async {
                                          currentUser.skills.add(e);
                                          print("here");
                                          setState((){});
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
                                                        Radius.circular(5))),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    e.className,
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.fredoka(
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                  }).toList():
                                  [
                                    ...skillsRecommendedList.map((e) {
                                      return InkWell(
                                        onTap: () async {
                                          currentUser.skills.add(e);
                                          print("here");
                                          setState((){});
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
                                                        Radius.circular(5))),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    e.className,
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.fredoka(
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                  ],
                                ),
                              )
                            ],
                          )),
                    ),
                  )
                : Container(),
            //! Club school picker
            showClubSchoolPicker
                ? SingleChildScrollView(
                    child: InkWell(
                      onTap: () {
                        toggleClubSchoolPicker();
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
                              SizedBox(
                                height: height * 0.01,
                              ),
                              AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  height: height * 0.35,
                                  width: width * 0.9,
                                  decoration: BoxDecoration(
                                      color: backgroundColor,
                                      border: Border.all(
                                          color: schoolChoosingClub.clubData
                                              .getClubTypeColor(),
                                          width: width * 0.015),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  padding: EdgeInsets.all(width * 0.015),
                                  child: ListView(
                                    padding: EdgeInsets.zero,
                                    children: [
                                      ...currentUser.schools.map((e) {
                                        if (schoolChoosingClub.clubData
                                                .schoolContained(e.name) ==
                                            false) return Container();
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              schoolChoosingClub!.schoolAt =
                                                  e.name;
                                            });
                                          },
                                          child: Container(
                                            width: width * 0.85,
                                            height: height * 0.08,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              border: Border.all(
                                                  color: schoolChoosingClub!
                                                              .schoolAt !=
                                                          e.name
                                                      ? Colors.transparent
                                                      : schoolChoosingClub
                                                          .clubData
                                                          .getClubTypeColorDark(),
                                                  width: width * 0.01),
                                              color: schoolChoosingClub!
                                                          .schoolAt !=
                                                      e.name
                                                  ? Color.fromARGB(
                                                      255, 226, 225, 225)
                                                  : schoolChoosingClub.clubData
                                                      .getClubTypeColor(),
                                            ),
                                            margin: EdgeInsets.only(
                                                bottom: height * 0.01),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: width * 0.01,
                                                ),
                                                Container(
                                                  height: height * 0.06,
                                                  width: height * 0.06,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: schoolChoosingClub!
                                                                    .schoolAt !=
                                                                e.name
                                                            ? Colors.white
                                                            : schoolChoosingClub
                                                                .clubData
                                                                .getClubTypeColorDark(),
                                                        width: width * 0.01),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                  padding: EdgeInsets.all(
                                                      width * 0.005),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    child:
                                                        Image.network(e.image),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width * 0.02,
                                                ),
                                                Container(
                                                  width: width * 0.6,
                                                  child: Text(
                                                    e.name,
                                                    textAlign: TextAlign.left,
                                                    maxLines: 2,
                                                    style: GoogleFonts.fredoka(
                                                        color: schoolChoosingClub!
                                                                    .schoolAt !=
                                                                e.name
                                                            ? schoolChoosingClub
                                                                .clubData
                                                                .getClubTypeColor()
                                                            : backgroundColor,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ))
                            ],
                          )),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    ));
  }
}

class NavigationIcon extends StatefulWidget {
  List pageCompleted;
  List normalColorList;
  int navigationIconScreen;
  int currentScreen;
  String imageAdress;
  NavigationIcon(this.imageAdress, this.pageCompleted, this.normalColorList,
      this.currentScreen, this.navigationIconScreen);

  @override
  State<NavigationIcon> createState() => _NavitionIconState();
}

class _NavitionIconState extends State<NavigationIcon> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return AnimatedOpacity(
      duration: Duration(milliseconds: 300),
      opacity: widget.pageCompleted[widget.navigationIconScreen] ? 1 : 0.8,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: height * 0.068,
        width: height * 0.068,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
              width: width * 0.011,
              color: widget.currentScreen >= widget.navigationIconScreen
                  ? widget.normalColorList[widget.navigationIconScreen]
                  : Colors.grey.shade300),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Container(
            margin: EdgeInsets.all(height * 0.0125),
            foregroundDecoration: BoxDecoration(
              color: widget.pageCompleted[widget.navigationIconScreen]
                  ? Colors.transparent
                  : Colors.grey.shade300,
              backgroundBlendMode: BlendMode.saturation,
            ),
            child: Image.asset(
              widget.imageAdress,
              fit: BoxFit.contain,
            )),
      ),
    );
  }
}

class SearchSChoolTextField extends StatefulWidget {
  double wantedHeight;
  double wantedWidth;
  Color mainColor;
  Color darkColor;
  String textFieldName;
  double textFieldNameWidth;
  TextEditingController tec;
  Function searchButtonOnTap;
  bool showButton;
  SearchSChoolTextField(
      this.wantedHeight,
      this.wantedWidth,
      this.mainColor,
      this.darkColor,
      this.textFieldName,
      this.textFieldNameWidth,
      this.tec,
      this.searchButtonOnTap,
      {this.showButton = true});
  @override
  State<SearchSChoolTextField> createState() => SearchSChoolTextFieldState();
}

class SearchSChoolTextFieldState extends State<SearchSChoolTextField> {
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
                right: width * 0.05,
                left: widget.showButton ? width * 0.12 : width * 0.05),
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

class ClassDisplayWidget extends StatelessWidget {
  schoolClassDatabase e;
  ClassDisplayWidget(this.e);

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String imageUrl = "";
    for (School s in e.schoolAssociatedWith) {
      for (School s2 in currentUser.schools) {
        if (s.name == s2.name) {
          imageUrl = s.image;
        }
      }
    }
    return Stack(
      children: [
        Container(
            width: width * 0.85,
            height: height * 0.07,
            margin: EdgeInsets.only(bottom: width * 0.015),
            padding: EdgeInsets.symmetric(vertical: width * 0.01),
            decoration: BoxDecoration(
                color: e.getColor(),
                border: Border.all(color: e.getDColor(), width: width * 0.01),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    height: height * 0.053,
                    width: height * 0.053,
                    margin: EdgeInsets.only(
                        right: (height * 0.07 - height * 0.053) / 2,
                        left: width * 0.01),
                    decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(
                            color: e.getDColor(), width: width * 0.008)),
                    padding: EdgeInsets.all(height * 0.018 / 2),
                    child: ImageIcon(
                      AssetImage(e.getImageAddy()),
                      color: e.getColor(),
                    )),
                SizedBox(width: width * 0.01),
                Container(
                  width: width * 0.6,
                  child: Text(
                    e.className,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.fredoka(
                        fontWeight: FontWeight.w600,
                        color: backgroundColor,
                        height: 1,
                        fontSize: MediaQuery.of(context).textScaleFactor * 18),
                  ),
                )
              ],
            )),
        imageUrl == ""
            ? Container()
            : Positioned(
                top: width * 0.02,
                right: width * 0.02,
                child: Container(
                    height: height * 0.025,
                    width: height * 0.025,
                    decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(
                            color: e.getDColor(), width: width * 0.005)),
                    padding: EdgeInsets.all(1),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.fitHeight,
                    )),
              )
      ],
    );
  }
}
