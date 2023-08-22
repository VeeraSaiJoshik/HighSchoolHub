import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/pages/AuthenticationPage.dart';
import 'package:highschoolhub/pages/SignUp.dart';
import 'package:highschoolhub/pages/SignUpScreen/ClubScreen.dart';
import 'package:highschoolhub/pages/SignUpScreen/SkillSpecifier.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import '../../main.dart';
import '../../models/class.dart';
import '../../models/school.dart';

class EditClassScreen extends StatefulWidget {
  const EditClassScreen({super.key});

  @override
  State<EditClassScreen> createState() => _EditClassScreenState();
}

class _EditClassScreenState extends State<EditClassScreen> {
  @override
  bool showBlackScreen = false;
  bool classesPickerVisibility = false;
  bool chooseSchoolForClassVisibility = false;
  void toggleShowBlackScreen() {
    setState(() {
      showBlackScreen = showBlackScreen == false;
    });
  }

  void showClassesPickerVisibility() {
    setState(() {
      classesPickerVisibility = classesPickerVisibility == false;
    });
  }

  void showChooseSchoolForClassVisibility() {
    setState(() {
      chooseSchoolForClassVisibility = chooseSchoolForClassVisibility == false;
    });
  }

  late schoolClassStudent schoolChoosingClass;
  List classesQueryList = [];
  List classes = [];
  List recList = [];
  void getSchoolData() async {
    recList = await getWebsiteData();
    setState(() {
      recList;
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

  TextEditingController schoolTec = TextEditingController();
  TextEditingController classesTec = TextEditingController();
  bool searchResultsLoading = true;
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

  void setSchoolChossingClass(schoolClassStudent gClass) {
    schoolChoosingClass = gClass;
  }

  void initStateFunction() async {
    await getWebsiteData();
    await getClassOptions();
    classesTec.addListener(() {
      setState(() {
        classesQueryList = sortListByQuery(classes, classesTec.text);
      });
    });
  }
  List<schoolClassStudent> backup = [];
  void initState(){
    initStateFunction();
    backup.addAll(currentUser.classes);
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
                                heroTag: "asdfdddd",
                                onPressed: () async {
                                  currentUser.classes = [];
                                  currentUser.classes.addAll(backup);
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
                                height: height * 0.0725,
                                child: FittedBox(
                                  child: Text(
                                    "Classes",
                                    style: GoogleFonts.fredoka(
                                      fontWeight: FontWeight.w800,
                                      color: orange,
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
                                heroTag: "asdfddasdf",
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
                      SizedBox(
                        height: height * 0.005,
                      ),
                      Expanded(
                          child: Container(
                        width: width,
                        child: SkillInfoScreen(
                            currentUser,
                            toggleShowBlackScreen,
                            showClassesPickerVisibility,
                            showChooseSchoolForClassVisibility,
                            setSchoolChossingClass,
                            heading: "Edit Classes"),
                      )),
                      SizedBox(
                        height: height * 0.005,
                      )
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
                                                        currentUser.addClass(e);
                                                      });
                                                    },
                                                    child:
                                                        ClassDisplayWidget(e));
                                              }).toList()
                                            : classesQueryList.map((e) {
                                                return InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        currentUser.addClass(e);
                                                      });
                                                    },
                                                    child:
                                                        ClassDisplayWidget(e));
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
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: backgroundColor,
                                                      height: 01,
                                                      fontSize: MediaQuery.of(
                                                                  context)
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
                          showChooseSchoolForClassVisibility();
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
                                            color: orange,
                                            width: width * 0.015),
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
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
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
