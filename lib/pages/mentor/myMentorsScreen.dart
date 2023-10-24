// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/chatScreen.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/main.dart';
import 'package:highschoolhub/models/chat.dart';
import 'package:highschoolhub/models/mentor.dart';
import 'package:highschoolhub/pages/AuthenticationPage.dart';
import 'package:highschoolhub/pages/mentor/mentorSpecficiScreend.dart';
import 'package:highschoolhub/pages/profileScreen.dart';

class listElement {
  mentorDatabase md;
  double rating = 0;
  listElement(this.md, {this.rating = 0});
}

class MyMentorScreen extends StatefulWidget {
  const MyMentorScreen({super.key});

  @override
  State<MyMentorScreen> createState() => MyMentorScreenState();
}

class MyMentorScreenState extends State<MyMentorScreen> {
  @override
  List<listElement> allElementsList = [];
  List<listElement> showList = [];
  bool ratedBefore = false;
  int perviousRating = 0;
  late mentorDatabase mentorInQuestion;
  void updateData() async {
    await currentUser.updateMentorshipParameters();
    initStateFunction();
    sortAllElementsList();
    setState(() {});
  }

  void initStateFunction() {
    allElementsList = [];
    print("these are the mentees");
    print(currentUser.mentees);
    for (mentorDatabase m in currentUser.mentors) {
      allElementsList.add(listElement(m));
    }
  }

  void sortAllElementsList() {
    for (listElement m in allElementsList) {
      allUsers[m.md!.email]!.getCorpusRatingFromQuery(networkSearchTec.text);
      m.rating = allUsers[m.md!.email]!.gScore +
          m.md!.topic!.getGScore(networkSearchTec.text);
    }
    allElementsList.sort((a, b) => a.rating.compareTo(b.rating));
    showList = [];
    for (listElement m in allElementsList) {
      if (m.rating != 0) {
        showList.insert(0, m);
      }
    }
  }

  void initState() {
    updateData();
    networkSearchTec.addListener(() {
      setState(() {
        sortAllElementsList();
      });
    });
    super.initState();
  }

  TextEditingController networkSearchTec = TextEditingController();
  bool showRatingPicker = false;
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        child: Stack(
          children: [
            Opacity(
              opacity: 0.25,
              child: Container(
                height: height,
                width: width,
                child: Image.asset(
                  "assets/images/backdrop.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SafeArea(
                top: true,
                bottom: false,
                child: Container(
                    height: height,
                    width: width,
                    child: Column(children: [
                      Container(
                        height: height * 0.015,
                      ),
                      Container(
                        width: width,
                        height: height * 0.062,
                        child: Row(
                          children: [
                            Container(
                              height: height * 0.062,
                              width: width * 0.8,
                              margin: EdgeInsets.only(left: width * 0.03),
                              padding: EdgeInsets.only(
                                  left: width * 0.015, right: width * 0.015),
                              decoration: BoxDecoration(
                                  color: backgroundColor,
                                  border: Border.all(
                                      color: orange, width: width * 0.011),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Row(
                                children: [
                                  Container(
                                    height: height * 0.062,
                                    width: width * 0.73,
                                    child: TextField(
                                      controller: networkSearchTec,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(
                                            left: width * 0.01,
                                            right: 0,
                                            top: 0,
                                            bottom: height * 0.0035),
                                        hintText: " Search My Mentors",
                                        hintStyle: GoogleFonts.fredoka(
                                            color: orange,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 30),
                                      ),
                                      cursorHeight: height * 0.036,
                                      cursorWidth: width * 0.01,
                                      cursorColor: darkOrange,
                                      maxLines: 1,
                                      style: GoogleFonts.fredoka(
                                          color: orange,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 30),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: width * 0.01,
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  height: height * 0.062,
                                  width: height * 0.062,
                                  decoration: BoxDecoration(
                                      color: red,
                                      border: Border.all(
                                          width: width * 0.012, color: darkRed),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  padding: EdgeInsets.all(width * 0.02),
                                  child: ImageIcon(
                                    AssetImage("assets/images/back.png"),
                                    color: backgroundColor,
                                  ),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.007,
                      ),
                      Expanded(
                        child: Container(
                          width: width,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              ...(networkSearchTec.text.isEmpty
                                      ? allElementsList
                                      : showList)
                                  .map((e) {
                                return Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: orange,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10))),
                                      margin: EdgeInsets.only(
                                          left: width * 0.028,
                                          right: width * 0.028,
                                          bottom: width * 0.015),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  darkOrange.withOpacity(0.5),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10))),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: width * 0.019,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (builder) {
                                                    return MyProfileScreen(
                                                        allUsers[e.md!.email]!);
                                                  }));
                                                },
                                                child: Container(
                                                  height: height * 0.098,
                                                  width: width,
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal:
                                                          width * 0.0175),
                                                  decoration: BoxDecoration(
                                                      color: orange,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: width * 0.02,
                                                      ),
                                                      Container(
                                                        height: height * 0.08,
                                                        width: height * 0.08,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: width *
                                                                    0.013,
                                                                color: darkOrange
                                                                    .withOpacity(
                                                                        0.5)),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5)),
                                                            child:
                                                                Image.network(
                                                              allUsers[e.md!
                                                                      .email]!
                                                                  .image,
                                                              fit: BoxFit.cover,
                                                            )),
                                                      ),
                                                      SizedBox(
                                                        width: width * 0.015,
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                height: height *
                                                                    0.01,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          height *
                                                                              0.04,
                                                                      child:
                                                                          Text(
                                                                        allUsers[e.md!.email]!.firstName +
                                                                            " " +
                                                                            allUsers[e.md!.email]!.lastName,
                                                                        style: GoogleFonts.fredoka(
                                                                            color:
                                                                                backgroundColor,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontSize: 32),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: height *
                                                                    0.003,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      height: height *
                                                                          0.025,
                                                                      child:
                                                                          Text(
                                                                        allUsers[e.md!.email]!.currentGrade.toString().substring(6) +
                                                                            " at " +
                                                                            allUsers[e.md!.email]!.getCurrentSchool().name,
                                                                        maxLines:
                                                                            1,
                                                                        style: GoogleFonts
                                                                            .fredoka(
                                                                          color:
                                                                              backgroundColor,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          fontSize:
                                                                              18,
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
                                              ),
                                              SizedBox(
                                                height: width * 0.019,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (builder) {
                                                    return MentorDetailScreen(
                                                        e.md!.topic!,
                                                        showSendMessage: false);
                                                  }));
                                                },
                                                child: Container(
                                                  height: height * 0.078,
                                                  width: width,
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal:
                                                          width * 0.0175),
                                                  decoration: BoxDecoration(
                                                      color: orange,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: height * 0.002,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            height:
                                                                height * 0.028,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: width *
                                                                        0.018),
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                              child: Text(
                                                                "Topic : ",
                                                                style: GoogleFonts.fredoka(
                                                                    color:
                                                                        backgroundColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                              child:
                                                                  Container()),
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                showRatingPicker =
                                                                    true;
                                                                mentorInQuestion =
                                                                    e.md;
                                                                ratedBefore = mentorInQuestion.myRating == -1;
                                                                perviousRating = mentorInQuestion.myRating;
                                                              });
                                                            },
                                                            child: Stack(
                                                              children: [
                                                                Container(
                                                                  height:
                                                                      height *
                                                                          0.028,
                                                                  margin: EdgeInsets.only(
                                                                      right: width *
                                                                          0.022),
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .fitHeight,
                                                                    child: Text(
                                                                      "Rate Mentor",
                                                                      style: GoogleFonts.fredoka(
                                                                          color:
                                                                              backgroundColor,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  bottom: 0,
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        height *
                                                                            0.0025,
                                                                    width:
                                                                        width *
                                                                            0.25,
                                                                    decoration: BoxDecoration(
                                                                        color:
                                                                            backgroundColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(5)),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Expanded(
                                                          child: SizedBox()),
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: width * 0.02,
                                                          ),
                                                          Container(
                                                            height:
                                                                height * 0.038,
                                                            width:
                                                                height * 0.038,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    width *
                                                                        0.01),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  backgroundColor,
                                                              border: Border.all(
                                                                  color:
                                                                      darkOrange,
                                                                  width: width *
                                                                      0.0065),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              5)),
                                                            ),
                                                            child: ImageIcon(
                                                              AssetImage(
                                                                e.md!.topic!
                                                                    .getIconImageAddress(),
                                                              ),
                                                              color: orange,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                width * 0.012,
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                                height: height *
                                                                    0.038,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      e.md!
                                                                          .topic!
                                                                          .getMentorTopicName(),
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: GoogleFonts.fredoka(
                                                                          color:
                                                                              backgroundColor,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize: (e.md!.topic!.getMentorTopicName()).length <= 21
                                                                              ? 24
                                                                              : 20),
                                                                    ),
                                                                  ],
                                                                )),
                                                          ),
                                                          SizedBox(
                                                            width: width * 0.01,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: height * 0.007,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: width * 0.019,
                                              ),
                                            ],
                                          )),
                                    ),
                                    Positioned(
                                      right: width * 0.075,
                                      top: width * 0.04,
                                      child: InkWell(
                                        onTap: () {
                                          Chat tempChat = Chat(
                                              user1Email: currentUser.email,
                                              user2Email: e.md!.email);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder: (c) {
                                            return ChatScreen(tempChat);
                                          }));
                                        },
                                        child: Container(
                                          height: height * 0.025,
                                          child: FittedBox(
                                              fit: BoxFit.fitHeight,
                                              child: ImageIcon(
                                                AssetImage(
                                                    "assets/images/chat.png"),
                                                color: backgroundColor,
                                              )),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              }).toList()
                            ],
                          ),
                        ),
                      )
                    ]))),
            showRatingPicker
                ? InkWell(
                  onTap: () async {
                    if(perviousRating != mentorInQuestion.myRating){
                      for(mentorDatabase temp in currentUser.mentors){
                        if(temp.topic!.description == mentorInQuestion!.topic!.description){
                          currentUser.mentors.remove(temp);
                          break;
                        }
                      }
                      currentUser.mentors.add(mentorInQuestion);
                      await currentUser.updateMentorshipParametersInDatabase();
                      Map data = (await supaBase.from("MentorPosts").select().eq("Description", mentorInQuestion.topic!.description))[0];
                      Mentor tempMentorPost = Mentor();
                      tempMentorPost.parseJson(data);
                      if(ratedBefore){
                        tempMentorPost.rating = ((tempMentorPost.rating - perviousRating + mentorInQuestion.myRating)/tempMentorPost.numberOfRating).toInt();
                      }else{
                        tempMentorPost.rating = ((tempMentorPost.rating+ mentorInQuestion.myRating)/tempMentorPost.numberOfRating + 1).toInt();
                        tempMentorPost.numberOfRating++;
                      }
                      await supaBase.from("MentorPosts").update(tempMentorPost.toJson()).eq("id", data["id"]);
                      print("done");
                    }
                    
                    setState(() {
                      showRatingPicker = false;
                    });
                  },
                  child: Container(
                      height: height,
                      width: width,
                      color: Colors.black.withOpacity(0.75),
                      child: Center(
                          child: Container(
                        height: height * 0.12,
                        width: width * 0.95,
                        decoration: BoxDecoration(
                            color: orange,
                            border: Border.all(
                                color: darkOrange.withOpacity(0.5),
                                width: width * 0.02),
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: height * 0.037,
                              margin: EdgeInsets.only(
                                  left: width * 0.025, top: height * 0.004),
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  "Rate " +
                                      allUsers[mentorInQuestion.email]!
                                          .firstName +
                                      " " +
                                      allUsers[mentorInQuestion.email]!.lastName +
                                      " : ",
                                  style: GoogleFonts.fredoka(
                                      color: backgroundColor,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.005,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: width * 0.03,
                                ),
                                InkWell(
                                  onTap: (){
                                    mentorInQuestion.myRating = 1;
                                    setState(() {
                                      
                                    });
                                  },
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        height: height * 0.04,
                                        width: height * 0.04,
                                        child: ImageIcon(
                                          AssetImage("assets/images/star.png"),
                                          color: mentorInQuestion.myRating >= 1
                                              ? Color(0xffFFC300)
                                              : Colors.grey.shade200,
                                        ),
                                      ),
                                      Container(
                                        height: height * 0.04,
                                        width: height * 0.04,
                                        child: Center(
                                          child: SizedBox(
                                            height: height * 0.028,
                                            child: FittedBox(
                                              fit: BoxFit.fitHeight, 
                                              child:  ImageIcon(
                                              AssetImage("assets/images/star.png"),
                                              color: mentorInQuestion.myRating >= 1
                                                  ? Color(0xffFFD700)
                                                  : backgroundColor,
                                            ),
                                            )
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: width * 0.016,
                                ),
                                InkWell(
                                  onTap: (){
                                    mentorInQuestion.myRating = 2;
                                    setState(() {
                                      
                                    });
                                  },
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        height: height * 0.04,
                                        width: height * 0.04,
                                        child: ImageIcon(
                                          AssetImage("assets/images/star.png"),
                                          color: mentorInQuestion.myRating >= 2
                                              ? Color(0xffFFC300)
                                              : Colors.grey.shade200,
                                        ),
                                      ),
                                      Container(
                                        height: height * 0.04,
                                        width: height * 0.04,
                                        child: Center(
                                          child: SizedBox(
                                            height: height * 0.028,
                                            child: FittedBox(
                                              fit: BoxFit.fitHeight, 
                                              child:  ImageIcon(
                                              AssetImage("assets/images/star.png"),
                                              color: mentorInQuestion.myRating >= 2
                                                  ? Color(0xffFFD700)
                                                  : backgroundColor,
                                            ),
                                            )
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: width * 0.016,
                                ),
                                InkWell(
                                  onTap: (){
                                    mentorInQuestion.myRating = 3;
                                    setState(() {
                                      
                                    });
                                  },
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        height: height * 0.04,
                                        width: height * 0.04,
                                        child: ImageIcon(
                                          AssetImage("assets/images/star.png"),
                                          color: mentorInQuestion.myRating >= 3
                                              ? Color(0xffFFC300)
                                              : Colors.grey.shade200,
                                        ),
                                      ),
                                      Container(
                                        height: height * 0.04,
                                        width: height * 0.04,
                                        child: Center(
                                          child: SizedBox(
                                            height: height * 0.028,
                                            child: FittedBox(
                                              fit: BoxFit.fitHeight, 
                                              child:  ImageIcon(
                                              AssetImage("assets/images/star.png"),
                                              color: mentorInQuestion.myRating >= 3
                                                  ? Color(0xffFFD700)
                                                  : backgroundColor,
                                            ),
                                            )
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: width * 0.016,
                                ),
                                InkWell(
                                  onTap: (){
                                    mentorInQuestion.myRating = 4;
                                    setState(() {
                                      
                                    });
                                  },
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        height: height * 0.04,
                                        width: height * 0.04,
                                        child: ImageIcon(
                                          AssetImage("assets/images/star.png"),
                                          color: mentorInQuestion.myRating >= 4
                                              ? Color(0xffFFC300)
                                              : Colors.grey.shade200,
                                        ),
                                      ),
                                      Container(
                                        height: height * 0.04,
                                        width: height * 0.04,
                                        child: Center(
                                          child: SizedBox(
                                            height: height * 0.028,
                                            child: FittedBox(
                                              fit: BoxFit.fitHeight, 
                                              child:  ImageIcon(
                                              AssetImage("assets/images/star.png"),
                                              color: mentorInQuestion.myRating >= 4
                                                  ? Color(0xffFFD700)
                                                  : backgroundColor,
                                            ),
                                            )
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: width * 0.016,
                                ),
                                InkWell(
                                  onTap: (){
                                    mentorInQuestion.myRating = 5;
                                    setState(() {
                                      
                                    });
                                  },
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        height: height * 0.04,
                                        width: height * 0.04,
                                        child: ImageIcon(
                                          AssetImage("assets/images/star.png"),
                                          color: mentorInQuestion.myRating >= 5
                                              ? Color(0xffFFC300)
                                              : Colors.grey.shade200,
                                        ),
                                      ),
                                      Container(
                                        height: height * 0.04,
                                        width: height * 0.04,
                                        child: Center(
                                          child: SizedBox(
                                            height: height * 0.028,
                                            child: FittedBox(
                                              fit: BoxFit.fitHeight, 
                                              child:  ImageIcon(
                                              AssetImage("assets/images/star.png"),
                                              color: mentorInQuestion.myRating >= 5
                                                  ? Color(0xffFFD700)
                                                  : backgroundColor,
                                            ),
                                            )
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: width * 0.0125,
                                ),
                              ],
                            )
                          ],
                        ),
                      )),
                    ),
                )
                : Container()
          ],
        ),
      ),
    );
  }
}
