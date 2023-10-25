import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/pages/homeFeedScreen/commentDetailScreen.dart';
import 'package:highschoolhub/pages/homeFeedScreen/createPostScreen.dart';
import 'package:highschoolhub/main.dart';
import 'package:highschoolhub/models/publicPost.dart';
import 'package:highschoolhub/models/reply.dart';
import 'package:highschoolhub/pages/AuthenticationPage.dart';
import 'package:highschoolhub/pages/profileScreen.dart';

class PostDetailScreen extends StatefulWidget {
  PublicPost post;
  PostDetailScreen(this.post);
  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  @override
  void initState() {
    print(widget.post.type);
    super.initState();
  }

  TextEditingController commentTec = TextEditingController();
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        color: blue,
        child: Stack(
          children: [
            Container(
                height: height,
                width: width,
                child: Opacity(
                  opacity: 0.1,
                  child: Image.asset(
                    "assets/images/backdrop.png",
                    fit: BoxFit.cover,
                  ),
                )),
            SafeArea(
              bottom: false,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: width * 0.95,
                  margin:
                      EdgeInsets.only(left: width * 0.025, bottom: width * 0.025),
                  decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(45),
                          bottomRight: Radius.circular(45))),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(45),
                        bottomRight: Radius.circular(45)),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        SizedBox(
                          height: height * 0.008,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: height * 0.008,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                height: height * 0.065,
                                width: height * 0.065,
                                decoration: BoxDecoration(
                                    color: red,
                                    border: Border.all(
                                        color: darkRed, width: width * 0.015),
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.all(width * 0.015),
                                child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: ImageIcon(
                                      AssetImage("assets/images/back.png"),
                                      color: backgroundColor,
                                    )),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(15)),
                          padding:
                              EdgeInsets.symmetric(vertical: height * 0.01),
                          margin: EdgeInsets.symmetric(
                              horizontal: width * 0.01),
                          child: Column(
                            children: [
                              widget.post.imageAddress == ""? Container():
                              Container(
                                  height: height * 0.25,
                                  width: width,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: width * 0.02),
                                  decoration: BoxDecoration(
                                      color: blue,
                                      border: Border.all(
                                          color: darkblue,
                                          width: width * 0.0125),
                                      borderRadius:
                                          BorderRadius.circular(8)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Image.network(
                                        widget.post.imageAddress,
                                        fit: BoxFit.cover),
                                  )),
                              SizedBox(height: height * 0.005),
                              Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: width * 0.03,
                                  ),
                                  InkWell(
                                    onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (builder) {
                                      return MyProfileScreen(currentUser);
                                    })),
                                    child: Container(
                                        height: height * 0.04,
                                        width: height * 0.04,
                                        decoration: BoxDecoration(
                                            color: blue,
                                            border: Border.all(
                                                color: darkblue,
                                                width: width * 0.008),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            child: Image.network(
                                              widget.post.author!.image,
                                              fit: BoxFit.cover,
                                            ))),
                                  ),
                                  SizedBox(
                                    width: width * 0.01,
                                  ),
                                  Container(
                                    height: height * 0.045,
                                    width: width * 0.5,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 0,
                                          child: InkWell(
                                            onTap: () =>
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (builder) {
                                              return MyProfileScreen(
                                                  currentUser);
                                            })),
                                            child: Container(
                                              height: height * 0.032,
                                              child: FittedBox(
                                                fit: BoxFit.fitHeight,
                                                child: Text(
                                                  widget.post.author!
                                                          .firstName +
                                                      " " +
                                                      widget.post.author!
                                                          .lastName,
                                                  style:
                                                      GoogleFonts.fredoka(
                                                          color: blue,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w600),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          child: Container(
                                            height: height * 0.02,
                                            child: FittedBox(
                                              fit: BoxFit.fitHeight,
                                              child: Text(
                                                "Posted on ${DateFormat('MM/dd/yyyy').format(widget.post.DatePosted)}",
                                                style: GoogleFonts.fredoka(
                                                    color: blue,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                  currentUser.userEmailInMyConnectionList(
                                          widget.post.author!.email)
                                      ? Container()
                                      : Container(
                                          height: height * 0.025,
                                          child: FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: ImageIcon(
                                              AssetImage(
                                                  "assets/images/link.png"),
                                              color: blue,
                                            ),
                                          ),
                                        ),
                                  SizedBox(
                                    width: width * 0.045,
                                  )
                                ],
                              ),
                              Container(
                                margin:
                                    EdgeInsets.only(top: height * 0.005),
                                height: height * 0.03,
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: width * 0.025,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        if (widget.post.likes
                                            .contains(currentUser.email)) {
                                          widget.post.likes
                                              .remove(currentUser.email);
                                        } else {
                                          widget.post.likes
                                              .add(currentUser.email);
                                        }
                                        await supaBase
                                            .from("Posts")
                                            .update(widget.post.toJson())
                                            .eq('id', widget.post.id);
                                        setState(() {});
                                      },
                                      child: SizedBox(
                                        child: Row(children: [
                                          Container(
                                              height: height * 0.02,
                                              child: FittedBox(
                                                fit: BoxFit.fitHeight,
                                                child: ImageIcon(
                                                  AssetImage(
                                                      "assets/images/like.png"),
                                                  color: widget.post.likes
                                                          .contains(
                                                              currentUser
                                                                  .email)
                                                      ? blue
                                                      : Colors
                                                          .grey.shade500,
                                                ),
                                              )),
                                          Container(
                                            height: height * 0.035,
                                            margin: EdgeInsets.only(
                                                left: width * 0.01),
                                            child: FittedBox(
                                              fit: BoxFit.fitHeight,
                                              child: Text(
                                                "Like",
                                                style: GoogleFonts.fredoka(
                                                  color: widget.post.likes
                                                          .contains(
                                                              currentUser
                                                                  .email)
                                                      ? blue
                                                      : Colors
                                                          .grey.shade500,
                                                  fontWeight:
                                                      FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ),
                                    const Expanded(child: SizedBox()),
                                    InkWell(
                                      onTap: () async {
                                        if (widget.post.celebrate
                                            .contains(currentUser.email)) {
                                          widget.post.celebrate
                                              .remove(currentUser.email);
                                        } else {
                                          widget.post.celebrate
                                              .add(currentUser.email);
                                        }
                                        await supaBase
                                            .from("Posts")
                                            .update(widget.post.toJson())
                                            .eq('id', widget.post.id);
                                        setState(() {});
                                      },
                                      child: SizedBox(
                                        child: Row(
                                          children: [
                                            Container(
                                                height: height * 0.025,
                                                child: FittedBox(
                                                  fit: BoxFit.fitHeight,
                                                  child: ImageIcon(
                                                      AssetImage(
                                                          "assets/images/cellebrate.png"),
                                                      color: widget.post
                                                              .celebrate
                                                              .contains(
                                                                  currentUser
                                                                      .email)
                                                          ? blue
                                                          : Colors.grey
                                                              .shade500),
                                                )),
                                            Container(
                                              height: height * 0.035,
                                              margin: EdgeInsets.only(
                                                  left: width * 0.01),
                                              child: FittedBox(
                                                fit: BoxFit.fitHeight,
                                                child: Text(
                                                  "Celebrate",
                                                  style:
                                                      GoogleFonts.fredoka(
                                                    color: widget
                                                            .post.celebrate
                                                            .contains(
                                                                currentUser
                                                                    .email)
                                                        ? blue
                                                        : Colors
                                                            .grey.shade500,
                                                    fontWeight:
                                                        FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Expanded(child: SizedBox()),
                                    SizedBox(
                                      child: Row(children: [
                                        Container(
                                            height: height * 0.025,
                                            margin: EdgeInsets.only(
                                                top: height * 0.005),
                                            child: FittedBox(
                                              fit: BoxFit.fitHeight,
                                              child: ImageIcon(
                                                AssetImage(
                                                    "assets/images/chat.png"),
                                                color: Colors.grey.shade500,
                                              ),
                                            )),
                                        Container(
                                          height: height * 0.035,
                                          margin: EdgeInsets.only(
                                              left: width * 0.01),
                                          child: FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Text(
                                              "Comments",
                                              style: GoogleFonts.fredoka(
                                                color: Colors.grey.shade500,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                    ),
                                    SizedBox(
                                      width: width * 0.025,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: height * 0.005),
                              Container(
                                width: width * 0.87,
                                child: Text(widget.post.postTitle,
                                    maxLines: 2,
                                    overflow: TextOverflow.fade,
                                    style: GoogleFonts.fredoka(
                                        height: 1.15,
                                        color: blue,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 24)),
                              ),
                              SizedBox(
                                height: height * 0.005,
                              ),
                              Container(
                                width: width * 0.87,
                                child: Text(
                                  widget.post.postDescription,
                                  style: TextStyle(
                                      color: blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.2,
                                      height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.0075,
                        ),
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(15)),
                            padding: EdgeInsets.symmetric(
                                vertical: height * 0.01,
                                horizontal: width * 0.01),
                            margin:
                                EdgeInsets.symmetric(horizontal: width * 0.01),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: width * 0.015,
                                    ),
                                    Container(
                                      height: height * 0.03,
                                      child: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Text(
                                          widget.post.type == PostType.Tournament
                                              ? "Tournament Type :"
                                              : widget.post.type ==
                                                      PostType.Volunteer
                                                  ? "Volunteer Type :"
                                                  : widget.post.type ==
                                                          PostType.Collaborate
                                                      ? "Collaboration Type :"
                                                      : "Post Type :",
                                          style: GoogleFonts.fredoka(
                                              color: blue,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                    Expanded(child: SizedBox())
                                  ],
                                ),
                                Container(
                                  width: width * 0.88,
                                  height: height * 0.04,
                                  child: ListView(
                                    padding: EdgeInsets.zero,
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      ...widget.post.getTypeList().map(
                                        (e) {
                                          return Container(
                                            padding:
                                                EdgeInsets.all(width * 0.008),
                                            margin: EdgeInsets.only(
                                                right: width * 0.0075),
                                            decoration: BoxDecoration(
                                                color: blue,
                                                border: Border.all(
                                                    color: darkblue,
                                                    width: width * 0.01),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: height * 0.02,
                                                  child: FittedBox(
                                                    fit: BoxFit.fitHeight,
                                                    child: ImageIcon(
                                                      AssetImage(e.image),
                                                      color: backgroundColor,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: width * 0.01),
                                                Container(
                                                  height: height * 0.03,
                                                  child: FittedBox(
                                                    fit: BoxFit.fitHeight,
                                                    child: Text(
                                                      e.clubTypeString == "none"
                                                          ? e.clubType
                                                              .toString()
                                                              .substring(9)
                                                          : e.clubTypeString,
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
                                        },
                                      ).toList()
                                    ],
                                  ),
                                ),
                                widget.post.type == PostType.Tournament
                                    ? Container(
                                        child: Column(
                                          children: [
                                            SizedBox(height: height * 0.0035),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: width * 0.015,
                                                ),
                                                SizedBox(
                                                  height: height * 0.02,
                                                  child: FittedBox(
                                                    fit: BoxFit.fitHeight,
                                                    child: ImageIcon(
                                                        AssetImage(
                                                            "assets/images/clubIcons/Academics.png"),
                                                        color: blue),
                                                  ),
                                                ),
                                                Container(
                                                  height: height * 0.03,
                                                  margin: EdgeInsets.only(
                                                      left: width * 0.01),
                                                  child: FittedBox(
                                                    fit: BoxFit.fitHeight,
                                                    child: Text(
                                                      "Grade Limit : ",
                                                      style: GoogleFonts.fredoka(
                                                          color: blue,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(child: SizedBox()),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        right: width * 0.02),
                                                    height: height * 0.03,
                                                    child: Row(children: [
                                                      Container(
                                                        height: height * 0.03,
                                                        child: FittedBox(
                                                          fit: BoxFit.fitHeight,
                                                          child: Text(
                                                              "Grades ${widget.post.tournamentGradeLimit.lowerBound} - ${widget.post.tournamentGradeLimit.upperBound}",
                                                              style: GoogleFonts
                                                                  .fredoka(
                                                                      color: blue,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600)),
                                                        ),
                                                      ),
                                                    ]))
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: width * 0.015,
                                                ),
                                                SizedBox(
                                                  height: height * 0.02,
                                                  child: FittedBox(
                                                    fit: BoxFit.fitHeight,
                                                    child: ImageIcon(
                                                        AssetImage(
                                                            "assets/images/place.png"),
                                                        color: blue),
                                                  ),
                                                ),
                                                Container(
                                                  height: height * 0.03,
                                                  margin: EdgeInsets.only(
                                                      left: width * 0.01),
                                                  child: FittedBox(
                                                    fit: BoxFit.fitHeight,
                                                    child: Text(
                                                      "Location : ",
                                                      style: GoogleFonts.fredoka(
                                                          color: blue,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(child: SizedBox()),
                                                widget.post.tournamentLocation
                                                            .address ==
                                                        ""
                                                    ? Container(
                                                        margin: EdgeInsets.only(
                                                            right: width * 0.02),
                                                        height: height * 0.03,
                                                        child: Row(children: [
                                                          Container(
                                                            height: height * 0.03,
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                              child: Text(
                                                                  "Virtual",
                                                                  style: GoogleFonts.fredoka(
                                                                      color: blue,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600)),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: width * 0.01,
                                                          ),
                                                          SizedBox(
                                                            height: height * 0.02,
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                              child: ImageIcon(
                                                                  AssetImage(
                                                                      "assets/images/virtual.png"),
                                                                  color: blue),
                                                            ),
                                                          ),
                                                        ]))
                                                    : Container()
                                              ],
                                            ),
                                            widget.post.tournamentLocation
                                                        .address ==
                                                    ""
                                                ? Container()
                                                : Container(
                                                    width: width * 0.86,
                                                    child: Text(
                                                      widget
                                                          .post
                                                          .tournamentLocation
                                                          .address,
                                                      style: GoogleFonts.fredoka(
                                                          color: blue,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 18,
                                                          height: 1.1),
                                                    ),
                                                  ),
                                            SizedBox(height: height * 0.0035),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: width * 0.015,
                                                ),
                                                SizedBox(
                                                  height: height * 0.02,
                                                  child: FittedBox(
                                                    fit: BoxFit.fitHeight,
                                                    child: ImageIcon(
                                                        AssetImage(
                                                            "assets/images/calendar.png"),
                                                        color: blue),
                                                  ),
                                                ),
                                                Container(
                                                  height: height * 0.03,
                                                  margin: EdgeInsets.only(
                                                      left: width * 0.01),
                                                  child: FittedBox(
                                                    fit: BoxFit.fitHeight,
                                                    child: Text(
                                                      "Event Date : ",
                                                      style: GoogleFonts.fredoka(
                                                          color: blue,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(child: SizedBox()),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        right: width * 0.02),
                                                    height: height * 0.03,
                                                    child: Row(children: [
                                                      Container(
                                                        height: height * 0.03,
                                                        child: FittedBox(
                                                          fit: BoxFit.fitHeight,
                                                          child: Text(
                                                              DateFormat(
                                                                      "MM/dd/yyyy")
                                                                  .format(widget
                                                                      .post
                                                                      .tournamentDate!),
                                                              style: GoogleFonts
                                                                  .fredoka(
                                                                      color: blue,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600)),
                                                        ),
                                                      ),
                                                    ]))
                                              ],
                                            ),
                                            SizedBox(height: height * 0.0035),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: width * 0.015,
                                                ),
                                                SizedBox(
                                                  height: height * 0.02,
                                                  child: FittedBox(
                                                    fit: BoxFit.fitHeight,
                                                    child: ImageIcon(
                                                        AssetImage(
                                                            "assets/images/web.png"),
                                                        color: blue),
                                                  ),
                                                ),
                                                Container(
                                                  height: height * 0.03,
                                                  margin: EdgeInsets.only(
                                                      left: width * 0.01),
                                                  child: FittedBox(
                                                    fit: BoxFit.fitHeight,
                                                    child: Text(
                                                      "Website : ",
                                                      style: GoogleFonts.fredoka(
                                                          color: blue,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(child: SizedBox()),
                                              ],
                                            ),
                                            Container(
                                              width: width * 0.84,
                                              child: Text(
                                                widget.post.tournamentWebsite,
                                                style: GoogleFonts.fredoka(
                                                    color: blue,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 19,
                                                    height: 1.1),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : widget.post.type == PostType.Volunteer
                                        ? Container(
                                            child: Column(
                                            children: [
                                              SizedBox(height: height * 0.0035),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: width * 0.015,
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.02,
                                                    child: FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: ImageIcon(
                                                          AssetImage(
                                                              "assets/images/clubIcons/Academics.png"),
                                                          color: blue),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: height * 0.03,
                                                    margin: EdgeInsets.only(
                                                        left: width * 0.01),
                                                    child: FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: Text(
                                                        "Grade Limit : ",
                                                        style:
                                                            GoogleFonts.fredoka(
                                                                color: blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(child: SizedBox()),
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          right: width * 0.02),
                                                      height: height * 0.03,
                                                      child: Row(children: [
                                                        Container(
                                                          height: height * 0.03,
                                                          child: FittedBox(
                                                            fit: BoxFit.fitHeight,
                                                            child: Text(
                                                                "Grades ${widget.post.grades!.lowerBound} - ${widget.post.grades!.upperBound}",
                                                                style: GoogleFonts.fredoka(
                                                                    color: blue,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ),
                                                        ),
                                                      ]))
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: width * 0.015,
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.02,
                                                    child: FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: ImageIcon(
                                                          AssetImage(
                                                              "assets/images/calendar.png"),
                                                          color: blue),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: height * 0.03,
                                                    margin: EdgeInsets.only(
                                                        left: width * 0.01),
                                                    child: FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: Text(
                                                        "Event Date : ",
                                                        style:
                                                            GoogleFonts.fredoka(
                                                                color: blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(child: SizedBox()),
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          right: width * 0.02),
                                                      height: height * 0.03,
                                                      child: Row(children: [
                                                        Container(
                                                          height: height * 0.03,
                                                          child: FittedBox(
                                                            fit: BoxFit.fitHeight,
                                                            child: Text(
                                                                DateFormat(
                                                                        "MM/dd/yyyy")
                                                                    .format(widget
                                                                        .post
                                                                        .volunteerDate!),
                                                                style: GoogleFonts.fredoka(
                                                                    color: blue,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ),
                                                        ),
                                                      ]))
                                                ],
                                              ),
                                              SizedBox(height: height * 0.0035),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: width * 0.015,
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.02,
                                                    child: FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: ImageIcon(
                                                          AssetImage(
                                                              "assets/images/time.png"),
                                                          color: blue),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: height * 0.03,
                                                    margin: EdgeInsets.only(
                                                        left: width * 0.01),
                                                    child: FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: Text(
                                                        "Event Time : ",
                                                        style:
                                                            GoogleFonts.fredoka(
                                                                color: blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(child: SizedBox()),
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          right: width * 0.02),
                                                      height: height * 0.03,
                                                      child: Row(children: [
                                                        Container(
                                                          height: height * 0.03,
                                                          child: FittedBox(
                                                            fit: BoxFit.fitHeight,
                                                            child: Text(
                                                                "${widget.post.volunteerFromTime.hour % 12}:${widget.post.volunteerFromTime.minute}${widget.post.volunteerFromTime.hour <= 12 ? "AM" : "PM"} - ${widget.post.volunteerToTime.hour % 12}:${widget.post.volunteerToTime.minute}${widget.post.volunteerToTime.hour <= 12 ? "AM" : "PM"}",
                                                                style: GoogleFonts.fredoka(
                                                                    color: blue,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ),
                                                        ),
                                                      ]))
                                                ],
                                              ),
                                              SizedBox(height: height * 0.0035),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: width * 0.015,
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.02,
                                                    child: FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: ImageIcon(
                                                          AssetImage(
                                                              "assets/images/place.png"),
                                                          color: blue),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: height * 0.03,
                                                    margin: EdgeInsets.only(
                                                        left: width * 0.01),
                                                    child: FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: Text(
                                                        "Location : ",
                                                        style:
                                                            GoogleFonts.fredoka(
                                                                color: blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(child: SizedBox()),
                                                  widget.post.volunteerLocation
                                                              .address ==
                                                          ""
                                                      ? Container(
                                                          margin: EdgeInsets.only(
                                                              right:
                                                                  width * 0.02),
                                                          height: height * 0.03,
                                                          child: Row(children: [
                                                            Container(
                                                              height:
                                                                  height * 0.03,
                                                              child: FittedBox(
                                                                fit: BoxFit
                                                                    .fitHeight,
                                                                child: Text(
                                                                    "Virtual",
                                                                    style: GoogleFonts.fredoka(
                                                                        color:
                                                                            blue,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600)),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: width * 0.01,
                                                            ),
                                                            SizedBox(
                                                              height:
                                                                  height * 0.02,
                                                              child: FittedBox(
                                                                fit: BoxFit
                                                                    .fitHeight,
                                                                child: ImageIcon(
                                                                    AssetImage(
                                                                        "assets/images/virtual.png"),
                                                                    color: blue),
                                                              ),
                                                            ),
                                                          ]))
                                                      : Container()
                                                ],
                                              ),
                                              widget.post.volunteerLocation
                                                          .address ==
                                                      ""
                                                  ? Container()
                                                  : Container(
                                                      width: width * 0.86,
                                                      child: Text(
                                                        widget
                                                            .post
                                                            .volunteerLocation
                                                            .address,
                                                        style:
                                                            GoogleFonts.fredoka(
                                                                color: blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 18,
                                                                height: 1.1),
                                                      ),
                                                    ),
                                              SizedBox(height: height * 0.0035),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: width * 0.015,
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.02,
                                                    child: FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: ImageIcon(
                                                          AssetImage(
                                                              "assets/images/web.png"),
                                                          color: blue),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: height * 0.03,
                                                    margin: EdgeInsets.only(
                                                        left: width * 0.01),
                                                    child: FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: Text(
                                                        "Website : ",
                                                        style:
                                                            GoogleFonts.fredoka(
                                                                color: blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(child: SizedBox()),
                                                ],
                                              ),
                                              Container(
                                                width: width * 0.84,
                                                child: Text(
                                                  widget.post.volunteerWebsite,
                                                  style: GoogleFonts.fredoka(
                                                      color: blue,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 19,
                                                      height: 1.1),
                                                ),
                                              ),
                                            ],
                                          ))
                                        : Container()
                              ],
                            )),
                        SizedBox(
                          height: height * 0.0075,
                        ),
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(15)),
                            padding: EdgeInsets.symmetric(
                                vertical: height * 0.01,
                                horizontal: width * 0.01),
                            margin:
                                EdgeInsets.symmetric(horizontal: width * 0.01),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: width * 0.025),
                                    Container(
                                      height: height * 0.032,
                                      child: FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: Text("Comments :",
                                              style: GoogleFonts.fredoka(
                                                  color: blue,
                                                  fontWeight: FontWeight.w600))),
                                    )
                                  ],
                                ),
                                Container(
                                  height: height * 0.05,
                                  width: width * 0.9,
                                  padding: EdgeInsets.only(
                                      left: width * 0.015, right: width * 0.015),
                                  
                                  decoration: BoxDecoration(
                                      color: backgroundColor,
                                      border: Border.all(
                                          color: blue, width: width * 0.01),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: height * 0.054,
                                        width: width * 0.78,
                                        child: SingleChildScrollView(
                                          physics: NeverScrollableScrollPhysics(),
                                          child: TextField(
                                            controller: commentTec,
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.only(
                                                  left: width * 0.0,
                                                  right: 0,
                                                  top: 0,
                                                  bottom: height * 0.025),
                                              hintText: "Enter Comment",
                                              hintStyle: GoogleFonts.fredoka(
                                                  color: blue,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 25),
                                            ),
                                            cursorHeight: height * 0.032,
                                            cursorWidth: width * 0.01,
                                            cursorColor: darkblue,
                                            maxLines: 1,
                                            style: GoogleFonts.fredoka(
                                                color: blue,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 25),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          commentThread tempComment =
                                              commentThread(
                                                  likes: [],
                                                  mainComment: comment(
                                                      content: commentTec.text,
                                                      email: currentUser.email,
                                                      sentTime: DateTime.now()));
                                          widget.post.comments.add(tempComment);
                                          await supaBase
                                              .from("Posts")
                                              .update(widget.post.toJson())
                                              .eq("id", widget.post.id);
                                          commentTec.text = "";
                                          setState(() {});
                                        },
                                        child: Container(
                                            margin: EdgeInsets.only(
                                                bottom: height * 0.005,
                                                top: height * 0.005,
                                                left: width * 0.012),
                                            child: FittedBox(
                                              fit: BoxFit.fitHeight,
                                              child: ImageIcon(
                                                  AssetImage(
                                                      "assets/images/send.png"),
                                                  color: blue),
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: height * 0.005),
                                Container(
                                    height: height * 0.35,
                                    child: ListView(
                                      padding: EdgeInsets.zero,
                                      children: [
                                        ...widget.post.comments.map((e) {
                                          print("here");
                                          return Container(
                                            margin : EdgeInsets.only(
                                              bottom : height * 0.0075, 
                                              left : width * 0.01, 
                                              right : width * 0.01
                                            ),
                                            child: Stack(children: [
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      right: width * 0.015,
                                                      bottom: width * 0.015,
                                                      top: width * 0.025,
                                                      left: width * 0.025),
                                                  margin: EdgeInsets.only(
                                                      left: width * 0.025,
                                                      top: height * 0.015),
                                                  decoration: BoxDecoration(
                                                      color: blue,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Opacity(
                                                          opacity: 0.55,
                                                          child: Text(
                                                              "posted by " +
                                                                  allUsers[e
                                                                          .mainComment!
                                                                          .email]!
                                                                      .firstName +
                                                                  " " +
                                                                  allUsers[e
                                                                          .mainComment!
                                                                          .email]!
                                                                      .lastName +
                                                                  " at " +
                                                                  DateFormat(
                                                                          "MM/dd/yyyy")
                                                                      .format(e
                                                                          .mainComment!
                                                                          .sentTime!),
                                                              style: GoogleFonts.fredoka(
                                                                  color:
                                                                      backgroundColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 16)),
                                                        ),
                                                        Text(e.mainComment!.content,
                                                            maxLines: 4,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: GoogleFonts.fredoka(
                                                                color:
                                                                    backgroundColor,
                                                                height: 1.1,
                                                                fontWeight:
                                                                    FontWeight.w600,
                                                                fontSize: 19)),
                                                        SizedBox(
                                                            height:
                                                                height * 0.005),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      width * 0.00),
                                                          padding:
                                                              EdgeInsets.symmetric(
                                                                  vertical: width *
                                                                      0.0125),
                                                          decoration: BoxDecoration(
                                                            color: darkblue.withOpacity(0.5), 
                                                            borderRadius : BorderRadius.circular(5)
                                                          ),
                                                          child: Row(children: [
                                                            SizedBox(
                                                                width: width * 0.1),
                                                            InkWell(
                                                              onTap : () async {
                                                                if(e.likes.contains(currentUser.email)){
                                                                  e.likes.remove(currentUser.email);
                                                                }else{
                                                                  e.likes.add(currentUser.email);
                                                                }
                                                                await supaBase.from("Posts").update(widget.post.toJson()).eq("id", widget.post.id);
                                                                setState((){});
                                                              },
                                                              child: Container(
                                                                child : Row(
                                                                  children : [
                                                                    Container(
                                                                      height: height * 0.018,
                                                                      child: FittedBox(
                                                                        fit: BoxFit.fitHeight,
                                                                        child: ImageIcon(
                                                                          AssetImage("assets/images/like.png"),
                                                                          color: e.likes.contains(currentUser.email) ? Colors.yellow : backgroundColor
                                                                        )
                                                                      )
                                                                    ),
                                                                    Container(
                                                                      height:
                                                                          height * 0.028,
                                                                      margin: EdgeInsets.only(
                                                                          top: height *0.001,
                                                                          left: width *0.01
                                                                        ),
                                                                      child: FittedBox(
                                                                      fit: BoxFit.fitHeight,
                                                                      child: Text(
                                                                          "Like (${e.likes.length})",
                                                                          style: GoogleFonts.fredoka(
                                                                              color: e.likes.contains(currentUser.email) ? Colors.yellow : backgroundColor,
                                                                              fontWeight: FontWeight.w700
                                                                          )
                                                                        )
                                                                      )
                                                                    ),
                                                                    
                                                                  ]
                                                                )
                                                              ),
                                                            ),
                                                            Container(
                                                                width: width * 0.2),
                                                            InkWell(
                                                              onTap : () async {
                                                                var done = await Navigator.of(context).push(
                                                                  MaterialPageRoute(builder : (c){
                                                                    return CommentDetailScreen(e, widget.post);
                                                                  })
                                                                );
                                                                setState((){});
                                                              },
                                                              child: Container(
                                                                child : Row(
                                                                  children : [
                                                                    Container(
                                                                      height:
                                                                          height *
                                                                              0.02,
                                                                      margin: EdgeInsets.only(
                                                                          top: height *
                                                                              0.0015,
                                                                          right: width *
                                                                              0.01),
                                                                      child: FittedBox(
                                                                          fit: BoxFit.fitHeight,
                                                                          child: ImageIcon(
                                                                            AssetImage(
                                                                                "assets/images/chat.png"),
                                                                            color:
                                                                                backgroundColor,
                                                                          ))),
                                                                  Container(
                                                                      height:
                                                                          height *
                                                                              0.028,
                                                                      child: FittedBox(
                                                                          fit: BoxFit
                                                                              .fitHeight,
                                                                          child: Text(
                                                                              "Reply (${e.replies.length})",
                                                                              style: GoogleFonts.fredoka(
                                                                                  color: backgroundColor,
                                                                                  fontWeight: FontWeight.w700)))),
                                                                  ]
                                                                )
                                                              ),
                                                            ),
                                                          ]),
                                                        ),
                                                        SizedBox(
                                                            height: height * 0.005),
                                                      ])),
                                              Positioned(
                                                  top: 0,
                                                  left: 0,
                                                  child: Container(
                                                      height: height * 0.032,
                                                      width: height * 0.032,
                                                      decoration: BoxDecoration(
                                                          color: blue,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  3)),
                                                      padding: EdgeInsets.all(
                                                          width * 0.005),
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  2),
                                                          child: Image.network(
                                                            allUsers[e.mainComment!
                                                                    .email]!
                                                                .image,
                                                            fit: BoxFit.cover,
                                                          )))),
                                            ]),
                                          );
                                        }).toList()
                                      ],
                                    )),
                                SizedBox(height: height * 0.005),
                              ],
                            )),
                        SizedBox(height: height * 0.015)
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}
