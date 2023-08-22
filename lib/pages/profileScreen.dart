import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/models/user.dart';
import 'package:highschoolhub/pages/AuthenticationPage.dart';
import 'package:highschoolhub/pages/SignUpScreen/AccountInfo.dart';

class MyProfileScreen extends StatefulWidget {
  String profileUserEmail;
  MyProfileScreen(this.profileUserEmail);
  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  late AppUser profileUser = AppUser();
  bool showFullView = true;
  bool requestSent = false;
  void initStateFunction() async {
    if (currentUser.network.contains(widget.profileUserEmail) ||
        widget.profileUserEmail == currentUser.email) {
      showFullView = true;
    }
    if (currentUser.email != widget.profileUserEmail)
      await profileUser.getDataFromDatabase(widget.profileUserEmail);
  }

  void initState() {
    initStateFunction();
    super.initState();
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
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
            Container(
              height: height,
              width: width,
              child: Column(
                children: [
                  SizedBox(
                    height: width * 0.025,
                  ),
                  true ? 
                  Container(
                    height: height * 0.365,
                    width: width * 0.95,
                    decoration: BoxDecoration(
                        color: blue,
                        border:
                            Border.all(width: width * 0.015, color: darkblue),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(45),
                            topRight: Radius.circular(45),
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25))),
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 0.035,
                        ),
                        Container(
                          height: height * 0.05,
                          width: width,
                          child: Row(
                            children: [
                              Builder(builder: (context) {
                                return InkWell(
                                    onTap: () {
                                      Scaffold.of(context).openDrawer();
                                    },
                                    child: Container(
                                      height: height * 0.04,
                                      width: height * 0.04,
                                      margin:
                                          EdgeInsets.only(left: width * 0.06),
                                      child: RotatedBox(quarterTurns: 2, 
                                      child: ImageIcon(
                                        AssetImage("assets/images/arrow.png"),
                                        color: backgroundColor,
                                      ),),
                                    ));
                              }),
                            ],
                          ),
                        ),
                        Container(
                          height: height * 0.16,
                          width: height * 0.16,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: darkblue, width: width * 0.02),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            child: currentUser.image.runtimeType == String
                                ? Image.network(
                                    Uri.encodeFull(currentUser.image),
                                    fit: BoxFit.cover,
                                    key: UniqueKey(),
                                  )
                                : Container(),
                          ),
                        ),
                        Stack(
                          children: [
                            Container(
                              height: height * 0.06,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  currentUser.firstName +
                                      " " +
                                      currentUser.lastName,
                                  style: GoogleFonts.fredoka(
                                      color: backgroundColor,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  requestSent = requestSent == false;
                                });
                              },
                              child: Container(
                                height: height * 0.035,
                                width: width * 0.3,
                                margin: EdgeInsets.only(
                                    top: height * 0.059, left: width * 0.13),
                                decoration: BoxDecoration(
                                  color: requestSent ? blue : backgroundColor, 
                                  border: Border.all(
                                    color: requestSent ? darkblue : Colors.grey.shade300, 
                                    width: width * 0.008
                                  ), 
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8)
                                  )
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: 
                                  requestSent ? 
                                  [
                                    Container(
                                      height: height * 0.03, 
                                      child: FittedBox(
                                        fit: BoxFit.fitHeight, 
                                        child: Text(
                                          "Pending", 
                                          style : GoogleFonts.fredoka(
                                            color: requestSent ? backgroundColor :  blue,
                                            fontWeight: FontWeight.w600, 
                                          )
                                        ),
                                      ),
                                    ), 
                                  ]:
                                  [
                                    Container(
                                      height: height * 0.015, 
                                      child: 
                                      ImageIcon(
                                        AssetImage(
                                        "assets/images/add_school.png"),
                                        color: requestSent ? backgroundColor :  blue,
                                      ),
                                    ), 
                                    SizedBox(
                                      width: width * 0.005,
                                    ),
                                    Container(
                                      height: height * 0.03, 
                                      child: FittedBox(
                                        fit: BoxFit.fitHeight, 
                                        child: Text(
                                          "Connect", 
                                          style : GoogleFonts.fredoka(
                                            color: requestSent ? backgroundColor :  blue,
                                            fontWeight: FontWeight.w600, 
                                          )
                                        ),
                                      ),
                                    ), 
                                    SizedBox(
                                      width: width * 0.02,
                                    ),
                                  ],
                                ),
                              ),
                            )
                           
                          ],
                        ), 
                       
                      ],
                    ),
                  )
                  : 
                  Container(
                    height: height * 0.4,
                    width: width * 0.95,
                    decoration: BoxDecoration(
                        color: blue,
                        border:
                            Border.all(width: width * 0.015, color: darkblue),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(45),
                            topRight: Radius.circular(45),
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25))),
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 0.035,
                        ),
                        Container(
                          height: height * 0.05,
                          width: width,
                          child: Row(
                            children: [
                              Builder(builder: (context) {
                                return InkWell(
                                    onTap: () {
                                      Scaffold.of(context).openDrawer();
                                    },
                                    child: Container(
                                      height: height * 0.04,
                                      width: height * 0.04,
                                      margin:
                                          EdgeInsets.only(left: width * 0.06),
                                      child: RotatedBox(quarterTurns: 2, 
                                      child: ImageIcon(
                                        AssetImage("assets/images/arrow.png"),
                                        color: backgroundColor,
                                      ),),
                                    ));
                              }),
                            ],
                          ),
                        ),
                        Container(
                          height: height * 0.16,
                          width: height * 0.16,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: darkblue, width: width * 0.02),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            child: currentUser.image.runtimeType == String
                                ? Image.network(
                                    Uri.encodeFull(currentUser.image),
                                    fit: BoxFit.cover,
                                    key: UniqueKey(),
                                  )
                                : Container(),
                          ),
                        ),
                        Stack(
                          children: [
                            Container(
                              height: height * 0.06,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  currentUser.firstName +
                                      " " +
                                      currentUser.lastName,
                                  style: GoogleFonts.fredoka(
                                      color: backgroundColor,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            Container(
                              height: height * 0.03,
                              margin: EdgeInsets.only(
                                  top: height * 0.055, left: width * 0.02),
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  currentUser.email,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.fredoka(
                                      color: backgroundColor,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            )
                          ],
                        ), 
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Container(
                          height: height * 0.03,
                          width: width * 0.75, 
                          child: Row(
                            children: [
                              Text(
                                "Grade : " + currentGradeToString( currentUser.currentGrade), 
                                style: GoogleFonts.fredoka(
                                  color: backgroundColor, 
                                  fontWeight: FontWeight.w600, 
                                  fontSize: 17
                                ),
                              ), 
                              Expanded(child : Container()),
                               Text(
                                "State : " + stateToString(currentUser.userState), 
                                style: GoogleFonts.fredoka(
                                  color: backgroundColor, 
                                  fontWeight: FontWeight.w600, 
                                  fontSize: 17
                                ),
                              )
                            ],
                          ),
                        )
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
                            width: width * 0.95,
                            margin:
                                EdgeInsets.symmetric(horizontal: width * 0.025),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 235, 235, 235),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: height * 0.02, top: height * 0.01),
                                  child: Text(
                                    "School",
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.fredoka(
                                        fontSize: MediaQuery.of(context)
                                                .textScaleFactor *
                                            30,
                                        fontWeight: FontWeight.w700,
                                        color: puprle),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Container(
                                  width: width * 0.9,
                                  margin:
                                      EdgeInsets.only(left: width * 0.025),
                                  child: Column(
                                    children: [
                                      ...currentUser.schools.map((e) {
                                        return Container(
                                          width: width * 0.9,
                                          height: height * 0.1,
                                          margin: EdgeInsets.only(
                                              bottom: height * 0.01),
                                          decoration: BoxDecoration(
                                              color: puprle,
                                              border: Border.all(
                                                  color: darkPurple,
                                                  width: width * 0.01),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(width: width * 0.02),
                                              Container(
                                                height: height * 0.075,
                                                width: height * 0.075,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    border: Border.all(
                                                        color:
                                                            backgroundColor,
                                                        width: width * 0.01)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  child: Image.network(
                                                    e.image,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      right: width * 0.05,
                                                      left: width * 0.025),
                                                  height: height * 0.08,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height: height * 0.04,
                                                        width: width * 0.8,
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                e.name,
                                                                style: GoogleFonts.fredoka(
                                                                    color:
                                                                        backgroundColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize: e.name.length <= 25
                                                                        ? MediaQuery.of(context).textScaleFactor *
                                                                            22
                                                                        : MediaQuery.of(context).textScaleFactor *
                                                                            18,
                                                                    height:
                                                                        1),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: height * 0.01,
                                                      ),
                                                      Container(
                                                        height: height * 0.03,
                                                        child: ListView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          padding:
                                                              EdgeInsets.zero,
                                                          children: [
                                                            ...e.grades
                                                                .map((grade) {
                                                              return InkWell(
                                                                onTap: () {},
                                                                child:
                                                                    Container(
                                                                  height:
                                                                      height *
                                                                          0.028,
                                                                  width:
                                                                      height *
                                                                          0.028,
                                                                  padding: EdgeInsets
                                                                      .all(width *
                                                                          0.00),
                                                                  margin: EdgeInsets.only(
                                                                      right: width *
                                                                          0.01),
                                                                  decoration: BoxDecoration(
                                                                      color: (e.attendedGrades.contains(grade))
                                                                          ? puprle
                                                                          : backgroundColor,
                                                                      border: Border.all(
                                                                          color:
                                                                              darkPurple,
                                                                          width: width *
                                                                              0.008),
                                                                      borderRadius:
                                                                          BorderRadius.all(Radius.circular(5))),
                                                                  child:
                                                                      Center(
                                                                    child:
                                                                        FittedBox(
                                                                      fit: BoxFit
                                                                          .fitHeight,
                                                                      child:
                                                                          Text(
                                                                        grade
                                                                            .toString(),
                                                                        style:
                                                                            GoogleFonts.fredoka(
                                                                          color: (e.attendedGrades.contains(grade))
                                                                              ? backgroundColor
                                                                              : darkPurple,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }).toList()
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: width * 0.02),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.015,
                          ),
                          Container(
                            height: height * 0.41,
                            width: width * 0.95,
                            margin:
                                EdgeInsets.symmetric(horizontal: width * 0.025),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 235, 235, 235),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: height * 0.02, top: height * 0.01),
                                  child: Text(
                                    "Skills",
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.fredoka(
                                        fontSize: MediaQuery.of(context)
                                                .textScaleFactor *
                                            30,
                                        fontWeight: FontWeight.w700,
                                        color: mainColor),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Expanded(
                                  child: Container(
                                    width: width * 0.9,
                                    margin:
                                        EdgeInsets.only(left: width * 0.025),
                                    child: ListView(
                                      padding: EdgeInsets.zero,
                                      children: currentUser.skills.map((e) {
                                        return Container(
                                          width: width * 0.9,
                                          height: height * 0.09,
                                          margin: EdgeInsets.only(
                                              bottom: height * 0.01),
                                          decoration: BoxDecoration(
                                              color: mainColor,
                                              border: Border.all(
                                                  color: darkGreen,
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
                                                height: height * 0.05,
                                                child: FittedBox(
                                                  fit: BoxFit.fitHeight,
                                                  child: Text(
                                                    e.className,
                                                    style: GoogleFonts.fredoka(
                                                        color: backgroundColor,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.015,
                          ),
                          Container(
                            height: height * 0.41,
                            width: width * 0.95,
                            margin:
                                EdgeInsets.symmetric(horizontal: width * 0.025),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 235, 235, 235),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: height * 0.02, top: height * 0.01),
                                  child: Text(
                                    "Clubs",
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.fredoka(
                                        fontSize: MediaQuery.of(context)
                                                .textScaleFactor *
                                            30,
                                        fontWeight: FontWeight.w700,
                                        color: mainColor),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Expanded(
                                  child: Container(
                                    width: width * 0.9,
                                    margin:
                                        EdgeInsets.only(left: width * 0.025),
                                    child: ListView(
                                      padding: EdgeInsets.zero,
                                      children: [
                                        ...currentUser.clubs.map((e) {
                                          return Stack(
                                            children: [
                                              Container(
                                                  width: width * 0.9,
                                                  height: height * 0.159,
                                                  margin: EdgeInsets.only(
                                                      bottom: height * 0.01),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          height * 0.008),
                                                  decoration: BoxDecoration(
                                                      color: e.clubData
                                                          .getClubTypeColor(),
                                                      border: Border.all(
                                                          color: e.clubData
                                                              .getClubTypeColorDark(),
                                                          width: width * 0.01),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15))),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        height: height * 0.008,
                                                      ),
                                                      Container(
                                                        width: width * 0.9 -
                                                            height * 0.025,
                                                        height: height * 0.06,
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              height:
                                                                  height * 0.06,
                                                              width:
                                                                  height * 0.06,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    backgroundColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300,
                                                                    width: width *
                                                                        0.008),
                                                              ),
                                                              padding:
                                                                  EdgeInsets.all(
                                                                      width *
                                                                          0.02),
                                                              child: e.getImage(
                                                                  finalColor: e
                                                                      .clubData
                                                                      .getClubTypeColor()),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  width * 0.025,
                                                            ),
                                                            Container(
                                                              width:
                                                                  width * 0.55,
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      e.clubData
                                                                          .className,
                                                                      style: GoogleFonts.fredoka(
                                                                          color:
                                                                              backgroundColor,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize: e.clubData.className.length <= 23
                                                                              ? MediaQuery.of(context).textScaleFactor *
                                                                                  26
                                                                              : MediaQuery.of(context).textScaleFactor *
                                                                                  22,
                                                                          height:
                                                                              1),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: SizedBox(),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  currentUser
                                                                      .clubs
                                                                      .remove(
                                                                          e);
                                                                });
                                                              },
                                                              child: Container(
                                                                height: height *
                                                                    0.035,
                                                                child:
                                                                    FittedBox(
                                                                  fit: BoxFit
                                                                      .fitHeight,
                                                                  child: Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color:
                                                                        backgroundColor,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: height * 0.007,
                                                      ),
                                                      Container(
                                                        height: height * 0.017,
                                                        margin: EdgeInsets.only(
                                                            top: height * 0.005,
                                                            left: height *
                                                                0.009 /
                                                                2),
                                                        child: FittedBox(
                                                          fit: BoxFit.fitHeight,
                                                          child: Text(
                                                            "club participated at :",
                                                            style: GoogleFonts.fredoka(
                                                                color:
                                                                    backgroundColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                height: 1),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: height * 0.01,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width:
                                                                width * 0.002,
                                                          ),
                                                          Container(
                                                            height:
                                                                height * 0.0325,
                                                            width:
                                                                height * 0.0325,
                                                            decoration: BoxDecoration(
                                                                color: e.schoolAt ==
                                                                        ""
                                                                    ? backgroundColor
                                                                    : Colors
                                                                        .white,
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300,
                                                                    width: width *
                                                                        0.005),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5))),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    width *
                                                                        0.005),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              5)),
                                                              child: e.schoolAt ==
                                                                      ""
                                                                  ? ImageIcon(
                                                                      AssetImage(
                                                                          "assets/images/classImage/school.png"),
                                                                      color: e
                                                                          .clubData
                                                                          .getClubTypeColor(),
                                                                    )
                                                                  : Image.network(
                                                                      e.getSchoolImage(
                                                                          currentUser
                                                                              .schools)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: height * 0.01,
                                                      )
                                                    ],
                                                  )),
                                              Positioned(
                                                bottom: height * 0.021,
                                                right: width * 0.105,
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: Container(
                                                    height: height * 0.036,
                                                    width: width * 0.68,
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                e.schoolAt == ""
                                                                    ? "Click to choose school"
                                                                    : e.schoolAt,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    GoogleFonts
                                                                        .fredoka(
                                                                  color:
                                                                      backgroundColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      MediaQuery.of(context)
                                                                              .textScaleFactor *
                                                                          18,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList()
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.015,
                          ),
                          Container(
                            height: height * 0.41,
                            width: width * 0.95,
                            margin:
                                EdgeInsets.symmetric(horizontal: width * 0.025),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 235, 235, 235),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: height * 0.02, top: height * 0.01),
                                  child: Text(
                                    "Classes",
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.fredoka(
                                        fontSize: MediaQuery.of(context)
                                                .textScaleFactor *
                                            30,
                                        fontWeight: FontWeight.w700,
                                        color: orange),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Expanded(
                                  child: Container(
                                    width: width * 0.9,
                                    margin:
                                        EdgeInsets.only(left: width * 0.025),
                                    child: ListView(
                                      padding: EdgeInsets.zero,
                                      children: [
                                        ...currentUser.classes.map((e) {
                                          return Stack(
                                            children: [
                                              Container(
                                                  width: width * 0.9,
                                                  height: height * 0.159,
                                                  margin: EdgeInsets.only(
                                                      bottom: height * 0.01),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          height * 0.008),
                                                  decoration: BoxDecoration(
                                                      color: e.classInfo!
                                                          .getColor(),
                                                      border: Border.all(
                                                          color: e.classInfo!
                                                              .getDColor(),
                                                          width: width * 0.01),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15))),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        height: height * 0.008,
                                                      ),
                                                      Container(
                                                        width: width * 0.9 -
                                                            height * 0.025,
                                                        height: height * 0.06,
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              height:
                                                                  height * 0.06,
                                                              width:
                                                                  height * 0.06,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    backgroundColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300,
                                                                    width: width *
                                                                        0.008),
                                                              ),
                                                              padding:
                                                                  EdgeInsets.all(
                                                                      width *
                                                                          0.02),
                                                              child: ImageIcon(
                                                                AssetImage(e
                                                                    .classInfo!
                                                                    .getImageAddy()),
                                                                color: e
                                                                    .classInfo!
                                                                    .getColor(),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  width * 0.025,
                                                            ),
                                                            Container(
                                                              width:
                                                                  width * 0.55,
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      e.classInfo!
                                                                          .className,
                                                                      style: GoogleFonts.fredoka(
                                                                          color:
                                                                              backgroundColor,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize: e.classInfo!.className.length <= 23
                                                                              ? MediaQuery.of(context).textScaleFactor *
                                                                                  28
                                                                              : MediaQuery.of(context).textScaleFactor *
                                                                                  22,
                                                                          height:
                                                                              1),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: SizedBox(),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: height * 0.007,
                                                      ),
                                                      Container(
                                                        height: height * 0.017,
                                                        margin: EdgeInsets.only(
                                                            top: height * 0.005,
                                                            left: height *
                                                                0.009 /
                                                                2),
                                                        child: FittedBox(
                                                          fit: BoxFit.fitHeight,
                                                          child: Text(
                                                            "class taken at :",
                                                            style: GoogleFonts.fredoka(
                                                                color:
                                                                    backgroundColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                height: 1),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: height * 0.01,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width:
                                                                width * 0.002,
                                                          ),
                                                          Container(
                                                            height:
                                                                height * 0.0325,
                                                            width:
                                                                height * 0.0325,
                                                            decoration: BoxDecoration(
                                                                color: e.classTakenAt ==
                                                                        null
                                                                    ? backgroundColor
                                                                    : Colors
                                                                        .white,
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300,
                                                                    width: width *
                                                                        0.005),
                                                                borderRadius:
                                                                    BorderRadius.all(
                                                                        Radius.circular(
                                                                            5))),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    width *
                                                                        0.005),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              5)),
                                                              child: e.classTakenAt ==
                                                                      null
                                                                  ? ImageIcon(
                                                                      AssetImage(
                                                                          "assets/images/classImage/school.png"),
                                                                      color: e
                                                                          .classInfo!
                                                                          .getColor(),
                                                                    )
                                                                  : Image.network(e
                                                                      .classTakenAt!
                                                                      .image),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: height * 0.01,
                                                      )
                                                    ],
                                                  )),
                                              Positioned(
                                                bottom: height * 0.02,
                                                right: width * 0.105,
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: Container(
                                                    height: height * 0.036,
                                                    width: width * 0.68,
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                e.classTakenAt ==
                                                                        null
                                                                    ? "Click to choose school"
                                                                    : e.classTakenAt!
                                                                        .name,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    GoogleFonts
                                                                        .fredoka(
                                                                  color:
                                                                      backgroundColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize:
                                                                      MediaQuery.of(context)
                                                                              .textScaleFactor *
                                                                          17,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
