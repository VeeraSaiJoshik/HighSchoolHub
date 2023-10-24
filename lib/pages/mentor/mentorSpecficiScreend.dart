import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/main.dart';
import 'package:highschoolhub/models/club.dart';
import 'package:highschoolhub/models/mentor.dart';
import 'package:highschoolhub/models/user.dart';
import 'package:highschoolhub/pages/AuthenticationPage.dart';

class MentorDetailScreen extends StatefulWidget {
  Mentor mentor;
  bool showSendMessage;
  MentorDetailScreen(this.mentor, {this.showSendMessage = true});

  @override
  State<MentorDetailScreen> createState() => _MentorDetailScreenState();
}

class _MentorDetailScreenState extends State<MentorDetailScreen> {
  @override
  late AppUser mentoruser;
  void initState() {
    mentoruser = allUsers[widget.mentor.userEmail]!;
    if(currentUser.mentorContainedinMentorList(widget.mentor, currentUser.mentorRequestsSent) || currentUser.mentorContainedinMentorList(widget.mentor, currentUser.mentors)){
      widget.showSendMessage = false;
      setState(() {
        
      });
    }
    super.initState();
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        child: Stack(
          children: [
            Container(
              height: height,
              width: width,
              color: orange,
            ),
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
                child: Column(children: [
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
                              height: height * 0.025,
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: height * 0.02,
                                  ),
                                  InkWell(
                                    onTap: (){
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      padding: EdgeInsets.all(width * 0.02),
                                      child: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: ImageIcon(
                                          AssetImage("assets/images/back.png"),
                                          color: backgroundColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: width * 0.025, right: width * 0.025),
                              width: width * 0.9,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: height * 0.035,
                                    margin: EdgeInsets.only(
                                        left: width * 0.04, top: width * 0.015),
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Text(
                                        "Mentor : ",
                                        style: GoogleFonts.fredoka(
                                            color: orange,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: width * 0.88,
                                    height: height * 0.1,
                                    decoration: BoxDecoration(
                                        color: orange,
                                        border: Border.all(
                                            color: darkOrange.withOpacity(0.5),
                                            width: width * 0.015),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: width * 0.025),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: width * 0.015,
                                        ),
                                        Container(
                                          height: height * 0.07,
                                          width: height * 0.07,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: darkOrange,
                                                  width: width * 0.01),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8))),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Image.network(
                                                mentoruser.image,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 0.015,
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: height * 0.005,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        height: height * 0.04,
                                                        child: Text(
                                                          mentoruser.firstName +
                                                              " " +
                                                              mentoruser
                                                                  .lastName,
                                                          style: GoogleFonts
                                                              .fredoka(
                                                                  color:
                                                                      backgroundColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 32),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: height * 0.001,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        height: height * 0.025,
                                                        child: Text(
                                                          mentoruser
                                                                  .currentGrade
                                                                  .toString()
                                                                  .substring(
                                                                      6) +
                                                              " at " +
                                                              mentoruser
                                                                  .getCurrentSchool()
                                                                  .name,
                                                          maxLines: 1,
                                                          style: GoogleFonts
                                                              .fredoka(
                                                            color:
                                                                backgroundColor,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 0.015,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: width * 0.03,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Container(
                                margin: EdgeInsets.only(
                                    left: width * 0.025, right: width * 0.025),
                                width: width * 0.9,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          height: height * 0.035,
                                          margin: EdgeInsets.only(
                                              left: width * 0.04,
                                              top: width * 0.02),
                                          child: FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Text(
                                              "Mentoring Topic : ",
                                              style: GoogleFonts.fredoka(
                                                  color: orange,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          )),
                                      Container(
                                        width: width * 0.88,
                                        height: height * 0.09,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: width * 0.025),
                                        decoration: BoxDecoration(
                                            color: orange,
                                            border: Border.all(
                                                color:
                                                    darkOrange.withOpacity(0.5),
                                                width: width * 0.015),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12))),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: width * 0.015,
                                            ),
                                            Container(
                                              height: height * 0.065,
                                              width: height * 0.065,
                                              decoration: BoxDecoration(
                                                  color: backgroundColor,
                                                  border: Border.all(
                                                      width: width * 0.0125,
                                                      color: darkOrange),
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              padding:
                                                  EdgeInsets.all(width * 0.017),
                                              child: ImageIcon(
                                                widget.mentor.type !=
                                                        MentorShipType.Classes
                                                    ? AssetImage(
                                                        "assets/images/clubIcons/" +
                                                            widget.mentor
                                                                .mentorSubject
                                                                .toReadableString()
                                                                .substring(9) +
                                                            ".png")
                                                    : AssetImage(
                                                        "assets/images/classImage/" +
                                                            widget.mentor
                                                                .mentorSubjectClass +
                                                            ".png"),
                                                color: orange,
                                              ),
                                            ),
                                            SizedBox(
                                              width: width * 0.015,
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: Text(
                                                  widget.mentor.type ==
                                                          MentorShipType.Classes
                                                      ? widget
                                                          .mentor
                                                          .mentoringClass[0]
                                                          .className
                                                      : widget.mentor.type ==
                                                              MentorShipType
                                                                  .Skills
                                                          ? widget
                                                              .mentor
                                                              .mentoringSkill[0]
                                                              .className
                                                          : widget.mentor.other,
                                                  maxLines: 2,
                                                  style: GoogleFonts.fredoka(
                                                      color: backgroundColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: (widget.mentor.type ==
                                                                          MentorShipType
                                                                              .Classes
                                                                      ? widget
                                                                          .mentor
                                                                          .mentoringClass[
                                                                              0]
                                                                          .className
                                                                      : widget.mentor.type ==
                                                                              MentorShipType
                                                                                  .Skills
                                                                          ? widget
                                                                              .mentor
                                                                              .mentoringSkill[
                                                                                  0]
                                                                              .className
                                                                          : widget
                                                                              .mentor
                                                                              .other)
                                                                  .length >
                                                              17
                                                          ? 20
                                                          : 25,
                                                      height: 1.2),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width * 0.01,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.004,
                                      ),
                                      widget.mentor.type ==
                                              MentorShipType.Classes
                                          ? Container()
                                          : Container(
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                          height:
                                                              height * 0.035,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: width *
                                                                      0.04,
                                                                  top: width *
                                                                      0.008),
                                                          child: FittedBox(
                                                            fit: BoxFit
                                                                .fitHeight,
                                                            child: Text(
                                                              "Meet Location : ",
                                                              style: GoogleFonts.fredoka(
                                                                  color: orange,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                          )),
                                                      Expanded(
                                                          child: Container()),
                                                      Container(
                                                          height:
                                                              height * 0.035,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: width *
                                                                      0.04,
                                                                  top: width *
                                                                      0.005),
                                                          child: FittedBox(
                                                            fit: BoxFit
                                                                .fitHeight,
                                                            child: Text(
                                                              widget.mentor
                                                                          .location
                                                                          .toString()
                                                                          .substring(
                                                                              23)
                                                                          .replaceAll(
                                                                              "_",
                                                                              " ") ==
                                                                      "Both"
                                                                  ? "Hybrid"
                                                                  : widget
                                                                      .mentor
                                                                      .location
                                                                      .toString()
                                                                      .substring(
                                                                          23)
                                                                      .replaceAll(
                                                                          "_",
                                                                          " "),
                                                              style: GoogleFonts.fredoka(
                                                                  color: orange,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.0015,
                                                  ),
                                                ],
                                              ),
                                            ),
                                      widget.mentor.type ==
                                              MentorShipType.Classes
                                          ? Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      height: height * 0.035,
                                                      margin: EdgeInsets.only(
                                                          left: width * 0.04,
                                                          top: width * 0.00),
                                                      child: FittedBox(
                                                        fit: BoxFit.fitHeight,
                                                        child: Text(
                                                          "Course Taken At : ",
                                                          style: GoogleFonts
                                                              .fredoka(
                                                                  color: orange,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                        ),
                                                      )),
                                                  Container(
                                                    height: height * 0.09,
                                                    margin: EdgeInsets.only(
                                                        left: width * 0.025,
                                                        right: width * 0.025),
                                                    width: width * 0.9,
                                                    decoration: BoxDecoration(
                                                        color: orange,
                                                        border: Border.all(
                                                            color: darkOrange
                                                                .withOpacity(
                                                                    0.5),
                                                            width:
                                                                width * 0.013),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    13))),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                          width: width * 0.013,
                                                        ),
                                                        Container(
                                                            height:
                                                                height * 0.066,
                                                            width:
                                                                height * 0.066,
                                                            margin: EdgeInsets.only(
                                                                top: height *
                                                                    0.00),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .grey
                                                                    .shade200,
                                                                border: Border.all(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            226,
                                                                            98,
                                                                            0),
                                                                    width: width *
                                                                        0.01),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(10)),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                      width *
                                                                          0.0),
                                                              child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  child: Image
                                                                      .network(
                                                                    widget
                                                                        .mentor
                                                                        .courseTakenAt[
                                                                            0]
                                                                        .image,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  )),
                                                            )),
                                                        SizedBox(
                                                          width: width * 0.02,
                                                        ),
                                                        Container(
                                                          width: width * 0.6,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: height *
                                                                      0.0),
                                                          child: Text(
                                                            widget
                                                                .mentor
                                                                .courseTakenAt[
                                                                    0]
                                                                .name,
                                                            textAlign:
                                                                TextAlign.left,
                                                            maxLines: 2,
                                                            style: GoogleFonts
                                                                .fredoka(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade200,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize: widget.mentor.courseTakenAt[0].name.length <=
                                                                            25
                                                                        ? MediaQuery.of(context).textScaleFactor *
                                                                            26
                                                                        : widget.mentor.courseTakenAt[0].name.length <=
                                                                                30
                                                                            ? MediaQuery.of(context).textScaleFactor *
                                                                                23
                                                                            : MediaQuery.of(context).textScaleFactor *
                                                                                16,
                                                                    height: 1),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Row(
                                              children: [
                                                Container(
                                                    height: height * 0.035,
                                                    margin: EdgeInsets.only(
                                                        left: width * 0.04,
                                                        top: width * 0.004),
                                                    child: FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: Text(
                                                        "Experience: ",
                                                        style:
                                                            GoogleFonts.fredoka(
                                                                color: orange,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                      ),
                                                    )),
                                                Expanded(child: Container()),
                                                Container(
                                                    height: height * 0.035,
                                                    margin: EdgeInsets.only(
                                                        right: width * 0.04,
                                                        top: width * 0.005),
                                                    child: FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: Text(
                                                        widget.mentor
                                                            .getExperienceToString(),
                                                        style:
                                                            GoogleFonts.fredoka(
                                                                color: orange,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                      SizedBox(
                                        height: height * 0.004,
                                      ),
                                      widget.mentor.type !=
                                              MentorShipType.Classes
                                          ? Container()
                                          : Container(
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: height * 0.005,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                          height:
                                                              height * 0.035,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: width *
                                                                      0.04,
                                                                  top: width *
                                                                      0.005),
                                                          child: FittedBox(
                                                            fit: BoxFit
                                                                .fitHeight,
                                                            child: Text(
                                                              "Meet Location : ",
                                                              style: GoogleFonts.fredoka(
                                                                  color: orange,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                          )),
                                                      Expanded(
                                                          child: Container()),
                                                      Container(
                                                          height:
                                                              height * 0.035,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: width *
                                                                      0.04,
                                                                  top: width *
                                                                      0.005),
                                                          child: FittedBox(
                                                            fit: BoxFit
                                                                .fitHeight,
                                                            child: Text(
                                                              widget.mentor
                                                                          .location
                                                                          .toString()
                                                                          .substring(
                                                                              23)
                                                                          .replaceAll(
                                                                              "_",
                                                                              " ") ==
                                                                      "Both"
                                                                  ? "Hybrid"
                                                                  : widget
                                                                      .mentor
                                                                      .location
                                                                      .toString()
                                                                      .substring(
                                                                          23)
                                                                      .replaceAll(
                                                                          "_",
                                                                          " "),
                                                              style: GoogleFonts.fredoka(
                                                                  color: orange,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.0015,
                                                  ),
                                                ],
                                              ),
                                            ),
                                      Row(
                                        children: [
                                          Container(
                                              height: height * 0.035,
                                              margin: EdgeInsets.only(
                                                  left: width * 0.04,
                                                  top: width * 0.005),
                                              child: FittedBox(
                                                fit: BoxFit.fitHeight,
                                                child: Text(
                                                  "Rating : ",
                                                  style: GoogleFonts.fredoka(
                                                      color: orange,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              )),
                                          Expanded(child: Container()),
                                          Container(
                                              height: height * 0.035,
                                              margin: EdgeInsets.only(
                                                  right: width * 0.04,
                                                  top: width * 0.005),
                                              child: FittedBox(
                                                fit: BoxFit.fitHeight,
                                                child: Text(
                                                  widget.mentor.numberOfRating
                                                          .toString() +
                                                      " ratings",
                                                  style: GoogleFonts.fredoka(
                                                      color: orange,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height * 0.004,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: width * 0.04,
                                          ),
                                          Stack(
                                            children: [
                                              SizedBox(
                                                height: height * 0.03,
                                                width: height * 0.03,
                                                child: ImageIcon(
                                                  AssetImage(
                                                      "assets/images/star.png"),
                                                  color: widget.mentor.rating >=
                                                          1
                                                      ? Color(0xffFFC300)
                                                      : Colors.grey.shade400,
                                                ),
                                              ),
                                              Container(
                                                height: height * 0.03,
                                                width: height * 0.03,
                                                child: Center(
                                                  child: SizedBox(
                                                    height: height * 0.02,
                                                    child: ImageIcon(
                                                      AssetImage(
                                                          "assets/images/star.png"),
                                                      color: widget.mentor
                                                                  .rating >=
                                                              1
                                                          ? Color(0xffFFD700)
                                                          : Colors
                                                              .grey.shade400,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Container(
                                            width: width * 0.0125,
                                          ),
                                          Stack(
                                            children: [
                                              SizedBox(
                                                height: height * 0.03,
                                                width: height * 0.03,
                                                child: ImageIcon(
                                                  AssetImage(
                                                      "assets/images/star.png"),
                                                  color: widget.mentor.rating >=
                                                          1
                                                      ? Color(0xffFFC300)
                                                      : Colors.grey.shade400,
                                                ),
                                              ),
                                             Container(
                                                height: height * 0.03,
                                                width: height * 0.03,
                                                child: Center(
                                                  child: SizedBox(
                                                    height: height * 0.02,
                                                    child: ImageIcon(
                                                      AssetImage(
                                                          "assets/images/star.png"),
                                                      color: widget.mentor
                                                                  .rating >=
                                                              1
                                                          ? Color(0xffFFD700)
                                                          : Colors
                                                              .grey.shade400,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Container(
                                            width: width * 0.0125,
                                          ),
                                          Stack(
                                            children: [
                                              SizedBox(
                                                height: height * 0.03,
                                                width: height * 0.03,
                                                child: ImageIcon(
                                                  AssetImage(
                                                      "assets/images/star.png"),
                                                  color: widget.mentor.rating >=
                                                          1
                                                      ? Color(0xffFFC300)
                                                      : Colors.grey.shade400,
                                                ),
                                              ),
                                            Container(
                                                height: height * 0.03,
                                                width: height * 0.03,
                                                child: Center(
                                                  child: SizedBox(
                                                    height: height * 0.02,
                                                    child: ImageIcon(
                                                      AssetImage(
                                                          "assets/images/star.png"),
                                                      color: widget.mentor
                                                                  .rating >=
                                                              1
                                                          ? Color(0xffFFD700)
                                                          : Colors
                                                              .grey.shade400,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Container(
                                            width: width * 0.0125,
                                          ),
                                          Stack(
                                            children: [
                                              SizedBox(
                                                height: height * 0.03,
                                                width: height * 0.03,
                                                child: ImageIcon(
                                                  AssetImage(
                                                      "assets/images/star.png"),
                                                  color: widget.mentor.rating >=
                                                          1
                                                      ? Color(0xffFFC300)
                                                      : Colors.grey.shade400,
                                                ),
                                              ),
                                             Container(
                                                height: height * 0.03,
                                                width: height * 0.03,
                                                child: Center(
                                                  child: SizedBox(
                                                    height: height * 0.02,
                                                    child: ImageIcon(
                                                      AssetImage(
                                                          "assets/images/star.png"),
                                                      color: widget.mentor
                                                                  .rating >=
                                                              1
                                                          ? Color(0xffFFD700)
                                                          : Colors
                                                              .grey.shade400,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Container(
                                            width: width * 0.0125,
                                          ),
                                          Stack(
                                            children: [
                                              SizedBox(
                                                height: height * 0.03,
                                                width: height * 0.03,
                                                child: ImageIcon(
                                                  AssetImage(
                                                      "assets/images/star.png"),
                                                  color: widget.mentor.rating >=
                                                          1
                                                      ? Color(0xffFFC300)
                                                      : Colors.grey.shade400,
                                                ),
                                              ),
                                          Container(
                                                height: height * 0.03,
                                                width: height * 0.03,
                                                child: Center(
                                                  child: SizedBox(
                                                    height: height * 0.02,
                                                    child: ImageIcon(
                                                      AssetImage(
                                                          "assets/images/star.png"),
                                                      color: widget.mentor
                                                                  .rating >=
                                                              1
                                                          ? Color(0xffFFD700)
                                                          : Colors
                                                              .grey.shade400,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Container(
                                            width: width * 0.0125,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                              height: height * 0.035,
                                              margin: EdgeInsets.only(
                                                  left: width * 0.04,
                                                  top: width * 0.005),
                                              child: FittedBox(
                                                fit: BoxFit.fitHeight,
                                                child: Text(
                                                  "Description : ",
                                                  style: GoogleFonts.fredoka(
                                                      color: orange,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              )),
                                        ],
                                      ),
                                      Container(
                                        height: widget.mentor.type !=
                                                MentorShipType.Classes
                                            ? (widget.showSendMessage ? height * 0.235 : height * 0.33)
                                            : (widget.showSendMessage ? height * 0.13 : height * 0.235),
                                        margin: EdgeInsets.symmetric(
                                          horizontal: width * 0.04
                                        ),
                                        child: ListView(
                                          padding: EdgeInsets.zero,
                                          children: [
                                            Text(
                                              widget.mentor.description, 
                                              maxLines: null, 
                                              style: TextStyle(
                                                color: orange, 
                                                fontSize: 15, 
                                                fontWeight: FontWeight.w700
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.013,
                                      ),
                                    ])), 
                              Expanded(
                                child: Container(),
                              ),
                              widget.showSendMessage == false ? Container() : 
                              InkWell(
                                onTap: ()async {
                                  await currentUser.addMentorRequest(widget.mentor);
                                  setState(() {
                                    widget.showSendMessage = false;
                                  });
                                },
                                child: Container(
                                  height: height * 0.08,
                                  width: width * 0.9, 
                                  margin: EdgeInsets.only(
                                    left: width * 0.025, 
                                    right: width * 0.025
                                  ),
                                  decoration: BoxDecoration(
                                    color: orange, 
                                    border: Border.all(
                                      color: darkOrange.withOpacity(0.5), 
                                      width: width * 0.015
                                    ), 
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15)
                                    )
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: height * 0.035, 
                                        child: ImageIcon(
                                          AssetImage("assets/images/send.png"), 
                                          color: backgroundColor,
                                        )
                                      ), 
                                      SizedBox(
                                        width: width * 0.02,
                                      ),
                                      Container(
                                        height: height * 0.043, 
                                        child: FittedBox(
                                          fit: BoxFit.fitHeight, 
                                          child: Text(
                                            "Send Mentor Request", 
                                            style: GoogleFonts.fredoka(
                                              color: backgroundColor, 
                                              fontWeight: FontWeight.w700
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ), 
                              Container(
                                height: height * 0.01,
                              )
                          ])),
                ]))
          ],
        ),
      ),
    );
  }
}
