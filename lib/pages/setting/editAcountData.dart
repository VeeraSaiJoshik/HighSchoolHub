import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/pages/AuthenticationPage.dart';
import 'package:highschoolhub/pages/SignUpScreen/AccountInfo.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/user.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({super.key});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  @override
  File? userProfile;
  bool showBlackScreen = false;
  bool loadingState = false;
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
    setState(() {
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

  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  Months birthMonth = Months.None;
  TextEditingController dayController = new TextEditingController();
  TextEditingController yearController = new TextEditingController();
  String imageUrl = "";
  AppUser currentUserTemp = AppUser();
  void initState() {
    currentUser.newImageChosen = false;

    currentUserTemp.currentGrade = currentUser.currentGrade;
    currentUserTemp.classes = [];
    currentUserTemp.classes.addAll(currentUser.classes);
    currentUserTemp.clubs = [];
    currentUserTemp.clubs.addAll(currentUser.clubs);
    currentUserTemp.dateOfBirth = currentUser.dateOfBirth;
    currentUserTemp.email = currentUser.email;
    currentUserTemp.firstName = currentUser.firstName;
    currentUserTemp.lastName = currentUser.lastName;
    currentUserTemp.skills = [];
    currentUserTemp.skills.addAll(currentUser.skills);
    currentUserTemp.schools = [];
    currentUserTemp.schools.addAll(currentUser.schools);
    currentUserTemp.userState;
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
                                heroTag: "asdfdd",
                                onPressed: () async {
                                  currentUser.currentGrade =
                                      currentUserTemp.currentGrade;
                                  currentUser.classes = [];
                                  currentUser.classes
                                      .addAll(currentUserTemp.classes);
                                  currentUser.clubs = [];
                                  currentUser.clubs
                                      .addAll(currentUserTemp.clubs);
                                  currentUser.dateOfBirth =
                                      currentUserTemp.dateOfBirth;
                                  currentUser.email = currentUserTemp.email;
                                  currentUser.firstName =
                                      currentUserTemp.firstName;
                                  currentUser.lastName =
                                      currentUserTemp.lastName;
                                  currentUser.skills = [];
                                  currentUser.skills
                                      .addAll(currentUserTemp.skills);
                                  currentUser.schools = [];
                                  currentUser.schools
                                      .addAll(currentUserTemp.schools);
                                  currentUser.userState;

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
                                    "Account",
                                    style: GoogleFonts.fredoka(
                                      fontWeight: FontWeight.w800,
                                      color: blue,
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
                                heroTag: "asdfddd",
                                onPressed: () async {
                                  await currentUser.updateData();
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
                      Expanded(
                        child: Container(
                          width: width,
                          child: AccountInfoScreen(
                              currentUser,
                              setLoadingState,
                              toggleShowBlackScreen,
                              showMonthPicker,
                              showStatePicker,
                              showGradePicker),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
                        if (gradePickerVisibility) {
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
                                  margin:
                                      EdgeInsets.only(bottom: width * 0.025),
                                  decoration: BoxDecoration(
                                      color: currentUser.dateOfBirth!.month == e
                                          ? blue
                                          : backgroundColor,
                                      border: Border.all(
                                        color: darkblue,
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
                                                      monthToString(e)[0],
                                                      style:
                                                          GoogleFonts.fredoka(
                                                              color: darkblue,
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
                                                            .dateOfBirth!
                                                            .month ==
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
                                  margin:
                                      EdgeInsets.only(bottom: width * 0.025),
                                  decoration: BoxDecoration(
                                      color: currentUser.userState == e
                                          ? blue
                                          : backgroundColor,
                                      border: Border.all(
                                        color: darkblue,
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
                                                              color: darkblue,
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
                                  margin: currentGradeToString(e) == "None"
                                      ? EdgeInsets.zero
                                      : EdgeInsets.only(bottom: width * 0.025),
                                  decoration: BoxDecoration(
                                      color: currentUser.currentGrade == e
                                          ? blue
                                          : backgroundColor,
                                      border: Border.all(
                                        color: darkblue,
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
                                                      currentGradeToString(e),
                                                      style:
                                                          GoogleFonts.fredoka(
                                                              color: darkblue,
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
                                                opacity:
                                                    currentUser.currentGrade ==
                                                            e
                                                        ? 1
                                                        : 0,
                                                child: SizedBox(
                                                  height: height * 0.04,
                                                  child: FittedBox(
                                                    fit: BoxFit.fitHeight,
                                                    child: Text(
                                                      currentGradeToString(e),
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
            ],
          ),
        ),
      ),
    );
  }
}

/**
 * 
 */