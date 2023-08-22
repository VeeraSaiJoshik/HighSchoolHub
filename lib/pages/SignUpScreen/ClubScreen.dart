import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/pages/AuthenticationPage.dart';

class ClubInfoScreen extends StatefulWidget {
  Function toggleBlackScreen;
  Function toggleSkillSearchScreen;
  Function toggleClubSearchScreen;
  Function toggleSchoolChoosingScreen;
  Function setSchoolChoosingClub;
  ClubInfoScreen(this.toggleBlackScreen, this.toggleSkillSearchScreen,
      this.toggleClubSearchScreen, this.toggleSchoolChoosingScreen, this.setSchoolChoosingClub);
  @override
  State<ClubInfoScreen> createState() => _ClubInfoScreenState();
}

class _ClubInfoScreenState extends State<ClubInfoScreen> {
  @override
  int currentPage = 1;
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        height: height,
        width: width,
        child: Stack(
          children: [
            Positioned(
              top: height * 0.1,
              child: Container(
                height: height * 1,
                width: width,
                child: currentPage == 1
                    ?
                    //! CLUBS PAGE CODE
                    ListView(
                        children: [
                          Container(
                            child: Column(
                              children: [
                                currentUser.clubs.length == 0
                                    ? Container()
                                    : Column(
                                        children: [
                                          ...currentUser.clubs.map((e) {
                                            return Stack(
                                              children: [
                                                Container(
                                                    width: width * 0.9,
                                                    height: height * 0.159,
                                                    margin: EdgeInsets.only(
                                                        bottom: height * 0.01),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                height * 0.008),
                                                    decoration: BoxDecoration(
                                                        color: e.clubData
                                                            .getClubTypeColor(),
                                                        border: Border.all(
                                                            color: e.clubData
                                                                .getClubTypeColorDark(),
                                                            width:
                                                                width * 0.01),
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
                                                          height:
                                                              height * 0.008,
                                                        ),
                                                        Container(
                                                          width: width * 0.9 -
                                                              height * 0.025,
                                                          height: height * 0.06,
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                height: height *
                                                                    0.06,
                                                                width: height *
                                                                    0.06,
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
                                                                padding: EdgeInsets
                                                                    .all(width *
                                                                        0.02),
                                                                child: e.getImage(
                                                                    finalColor: e
                                                                        .clubData
                                                                        .getClubTypeColor()),
                                                              ),
                                                              SizedBox(
                                                                width: width *
                                                                    0.025,
                                                              ),
                                                              Container(
                                                                width: width *
                                                                    0.55,
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        e.clubData
                                                                            .className,
                                                                        style: GoogleFonts.fredoka(
                                                                            color:
                                                                                backgroundColor,
                                                                            fontWeight: FontWeight
                                                                                .w600,
                                                                            fontSize: e.clubData.className.length <= 23
                                                                                ? MediaQuery.of(context).textScaleFactor * 26
                                                                                : MediaQuery.of(context).textScaleFactor * 22,
                                                                            height: 1),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    SizedBox(),
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
                                                                child:
                                                                    Container(
                                                                  height:
                                                                      height *
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
                                                          height:
                                                              height * 0.007,
                                                        ),
                                                        Container(
                                                          height:
                                                              height * 0.017,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: height *
                                                                      0.005,
                                                                  left: height *
                                                                      0.009 /
                                                                      2),
                                                          child: FittedBox(
                                                            fit: BoxFit
                                                                .fitHeight,
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
                                                              height: height *
                                                                  0.0325,
                                                              width: height *
                                                                  0.0325,
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
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5))),
                                                              padding: EdgeInsets
                                                                  .all(width *
                                                                      0.005),
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius
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
                                                                    : Image.network(e.getSchoolImage(currentUser.schools)),
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
                                                    onTap: () {
                                                      widget.toggleBlackScreen();
                                                      widget.setSchoolChoosingClub(e);
                                                      widget.toggleSchoolChoosingScreen();
                                                    },
                                                    child: Container(
                                                      height: height * 0.036,
                                                      width: width * 0.68,
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  e.schoolAt ==
                                                                          ""
                                                                      ? "Click to choose school"
                                                                      : e.schoolAt,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: GoogleFonts
                                                                      .fredoka(
                                                                    color:
                                                                        backgroundColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        MediaQuery.of(context).textScaleFactor *
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
                                InkWell(
                                  onTap: () {
                                    widget.toggleClubSearchScreen();
                                    widget.toggleBlackScreen();
                                  },
                                  child: Container(
                                    width: width * 0.9,
                                    height: height * 0.09,
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
                                              "Add Club",
                                              style: GoogleFonts.fredoka(
                                                  color: Colors.grey.shade500,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                currentUser.clubs.length == 0
                                    ? Column(
                                        children: [
                                          Container(
                                            height: height * 0.1,
                                          ),
                                          Container(
                                            height: height * 0.2,
                                            child: Image.asset(
                                                "assets/images/club.png"),
                                          ),
                                          SizedBox(
                                            height: height * 0.01,
                                          ),
                                          Container(
                                            width: width * 0.85,
                                            child: Text(
                                              "Connect with like-minded people! Add your clubs to find shared interests. Don't see your club? Add it later!",
                                              maxLines: 3,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.fredoka(
                                                  height: 1.3,
                                                  color: mainColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .textScaleFactor *
                                                          17),
                                            ),
                                          )
                                        ],
                                      )
                                    : Container()
                              ],
                            ),
                          ), 
                          Container(
                            height : height * 0.4
                          ),
                        ],
                      )
                    :
                    //! SKILLS PAGE CODE
                    ListView(
                        children: [
                          Container(
                            child: Column(
                              children: [
                                currentUser.skills.length != 0?
                                 Column(
                                  children: currentUser.skills.map((e){
                                    return Container(
                                    width: width * 0.9,
                                    height: height * 0.09,
                                    margin: EdgeInsets.only(
                                      bottom : height * 0.01
                                    ),
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
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                  }).toList(),
                                ):Container(),
                                InkWell(
                                  onTap: () {
                                    widget.toggleSkillSearchScreen();
                                    widget.toggleBlackScreen();
                                  },
                                  child: Container(
                                    width: width * 0.9,
                                    height: height * 0.09,
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
                                          height: height * 0.025,
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
                                              "Add Skills",
                                              style: GoogleFonts.fredoka(
                                                  color: Colors.grey.shade500,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                
                                currentUser.skills.length != 0 ? 
                               Container()
                                :
                                Container(
                                  child: Column(
                                    children: [
                                      Container(
                                  height: height * 0.1,
                                ),
                                      Container(
                                  height: height * 0.18,
                                  child:
                                      Image.asset("assets/images/skills.png"),
                                ),
                                SizedBox(
                                  height: height * 0.025,
                                ),
                                Container(
                                  width: width * 0.85,
                                  child: Text(
                                    "Add your skills to connect with competitions, clubs, projects, and like-minded individuals.",
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.fredoka(
                                        height: 1.3,
                                        color: mainColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: MediaQuery.of(context)
                                                .textScaleFactor *
                                            17),
                                  ),
                                )
                                    ],
                                  ),
                                )
                                
                              ],
                            ),
                          )
                        ],
                      ),
              ),
            ),
            Positioned(
              top: height * 0.015,
              left: width * 0.05,
              child: Container(
                height: height * 0.07,
                width: width * 0.9,
                decoration: BoxDecoration(
                    color: backgroundColor,
                    border: Border.all(
                      color: darkGreen,
                      width: width * 0.0125,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.all(width * 0.01),
                      width: width * 0.9 - width * 0.02,
                      height: height * 0.07 - width * 0.02,
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            width: currentPage == 2
                                ? (width * 0.875 - width * 0.02) / 2
                                : 0,
                          ),
                          Container(
                            height: height * 0.07 - width * 0.02,
                            width: (width * 0.875 - width * 0.02) / 2,
                            decoration: BoxDecoration(
                                color: mainColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(width * 0.01),
                      width: width * 0.9 - width * 0.02,
                      height: height * 0.07 - width * 0.02,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {});
                            },
                            child: Container(
                              height: height * 0.07 - width * 0.02,
                              width: (width * 0.875 - width * 0.02) / 2,
                              child: Center(
                                child: Container(
                                  height: height * 0.05,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      "Clubs",
                                      style: GoogleFonts.fredoka(
                                          color: backgroundColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {});
                            },
                            child: Container(
                              height: height * 0.07 - width * 0.02,
                              width: (width * 0.875 - width * 0.02) / 2,
                              child: Center(
                                child: Container(
                                  height: height * 0.05,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      "Skills",
                                      style: GoogleFonts.fredoka(
                                          color: backgroundColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(width * 0.01),
                      width: width * 0.9 - width * 0.02,
                      height: height * 0.07 - width * 0.02,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                currentPage = 1;
                              });
                            },
                            child: AnimatedOpacity(
                              opacity: currentPage == 1 ? 0 : 1,
                              duration: Duration(milliseconds: 300),
                              child: Container(
                                height: height * 0.07 - width * 0.02,
                                width: (width * 0.875 - width * 0.02) / 2,
                                child: Center(
                                  child: Container(
                                    height: height * 0.05,
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Text(
                                        "Clubs",
                                        style: GoogleFonts.fredoka(
                                            color: mainColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                currentPage = 2;
                              });
                            },
                            child: AnimatedOpacity(
                              opacity: currentPage == 2 ? 0 : 1,
                              duration: Duration(milliseconds: 300),
                              child: Container(
                                height: height * 0.07 - width * 0.02,
                                width: (width * 0.875 - width * 0.02) / 2,
                                child: Center(
                                  child: Container(
                                    height: height * 0.05,
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Text(
                                        "Skills",
                                        style: GoogleFonts.fredoka(
                                            color: mainColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
