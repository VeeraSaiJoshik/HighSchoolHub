import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/models/club.dart';
import 'package:highschoolhub/models/skills.dart';
import 'package:highschoolhub/pages/AuthenticationPage.dart';
import 'package:highschoolhub/pages/SignUp.dart';
import 'package:highschoolhub/pages/SignUpScreen/ClubScreen.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

import '../../main.dart';
import '../../models/school.dart';
class EditClubScreen extends StatefulWidget {
  const EditClubScreen({super.key});

  @override
  State<EditClubScreen> createState() => _EditClubScreenState();
}

class _EditClubScreenState extends State<EditClubScreen> {
  @override
  List<clubAppData> backUp1 = [];
  List<Skill> backUp2 = [];
  bool clubSearchVisibility = false;
  bool blackScreenVisible = false;
  List skills = [];
  List skillsRecommendedList = [];
  TextEditingController skillTec = TextEditingController();
  TextEditingController schoolTec = TextEditingController();
  List clubs = [];
  List clubRecommendedList = [];
  TextEditingController clubsTec = TextEditingController();
  void toggleBlackScreen(){
    setState(() {
      blackScreenVisible = blackScreenVisible == false;
    });
  }
  void toggleClubSearchScreen() {
    setState(() => clubSearchVisibility = clubSearchVisibility == false);
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
  bool skillSearchVisibility = false;
  void toggleSkillSearch() {
    setState(() => skillSearchVisibility = skillSearchVisibility == false);
  }
  bool showClubSchoolPicker = false;
  void toggleClubSchoolPicker() {
    setState(() {
      showClubSchoolPicker = showClubSchoolPicker == false;
    });
  }
  late clubAppData schoolChoosingClub;
  void setSchoolChoosingClub(clubAppData gClass) {
    schoolChoosingClub = gClass;
  }
  Future<int> getClubDataFromdatabase() async {
    final result = await supaBase.from("Clubs").select();
    print("getting club data");
    
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
    skills = [];
    for (Map data in result) {
      Skill value = Skill();
      value.fromJSON(data);
      skills.add(value);
    }
    return 1;
  }
  bool searchReulstsLoading = false;
  Future<List> getWebsiteData() async {
    setState(() {
      searchReulstsLoading = true;
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
      searchReulstsLoading = false;
      print("yeah");
    });
    if (actualStringRecommendationList.length == 0) {
      return ["none"];
    }
    return actualStringRecommendationList;
  }

  List recList = [];
  void getSchoolData() async {
    recList = await getWebsiteData();
    setState(() {
      recList;
    });
  }
  void initStateFunction() async {
    await getWebsiteData();
    await getClubDataFromdatabase();
    await getSkillsFromDatabase();
    clubsTec.addListener(() {
      clubRecommendedList = sortListByQuery(clubs, clubsTec.text);
      setState(() {});
    });
    skillTec.addListener(() {
      skillsRecommendedList = sortListByQuery(skills, skillTec.text);
      setState(() {});
    });
  }
  void initState(){
    backUp1.addAll(currentUser.clubs);
    backUp2.addAll(currentUser.skills);
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
                                heroTag: "asdfddpoiuy",
                                onPressed: () async {
                                  currentUser.clubs = [];
                                  currentUser.skills = [];
                                  currentUser.clubs.addAll(backUp1);
                                  currentUser.skills.addAll(backUp2);
                                  Navigator.of(context).pop();
                                },
                                elevation: 2,
                                backgroundColor: red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  side: BorderSide(
                                    width: width * 0.0125,
                                    color:darkRed
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    currentScreen == 0
                                        ? width * 0.042
                                        : width * 0.03,
                                  ),
                                  child: RotatedBox(
                                    quarterTurns: 2,
                                    child: Image.asset(
                                      "assets/images/back.png"
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                            InkWell(
                              child: Container(
                                height: height * 0.0725,
                                child: FittedBox(
                                  child: Text(
                                    "Extra",
                                    style: GoogleFonts.fredoka(
                                      fontWeight: FontWeight.w800,
                                      color: mainColor,
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
                                heroTag: "asdfdd1245",
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
                                    child: Image.asset(
                                      "assets/images/done.png"
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: width * 0.05),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ), 
                      Expanded(
                        child: Container(
                          width: width, 
                          child: ClubInfoScreen(toggleBlackScreen, toggleSkillSearch, toggleClubSearchScreen, toggleClubSchoolPicker, setSchoolChoosingClub),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      )
                    ],
                  ),
                ),
              ),
              blackScreenVisible
                ? InkWell(
                    onTap: () {
                      toggleBlackScreen();
                    },
                    child: AnimatedOpacity(
                      opacity: blackScreenVisible ? 1 : 0,
                      duration: Duration(milliseconds: 300),
                      child: Container(
                        height: height,
                        width: width,
                        color: Colors.black.withOpacity(0.75),
                      ),
                    ),
                  )
                : Container(),
              skillSearchVisibility
                ? SingleChildScrollView(
                    child: InkWell(
                      onTap: () {
                        toggleSkillSearch();
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
                                  skillTec,
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
                                  skillsRecommendedList.length == 0 && skillTec.text == ""? 
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
                clubSearchVisibility
                ? SingleChildScrollView(
                    child: InkWell(
                      onTap: () {
                        toggleBlackScreen();
                        setState(() {
                          clubSearchVisibility = false;
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
                                                    toggleBlackScreen();
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
                showClubSchoolPicker
                ? SingleChildScrollView(
                    child: InkWell(
                      onTap: () {
                        toggleClubSchoolPicker();
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
      ),
    );
  }
}