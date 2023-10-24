import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/chatScreen.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/models/chat.dart';
import 'package:highschoolhub/models/user.dart';
import 'package:highschoolhub/pages/AuthenticationPage.dart';
import 'package:highschoolhub/pages/profileScreen.dart';

import '../home/connectionsScreen.dart';

class searchListWidget{
  AppUser user;
  bool inNetwork;
  double gScore = 0;
  double getCorpusRatingFromQuery(String query){
    gScore = user.getCorpusRatingFromQuery(query);
    return gScore;
  }
  searchListWidget(this.user, {this.inNetwork = false});
}

class MyConnectionsScreen extends StatefulWidget {
  const MyConnectionsScreen({super.key});

  @override
  State<MyConnectionsScreen> createState() => _MyConnectionsScreenState();
}

class _MyConnectionsScreenState extends State<MyConnectionsScreen> {
  @override
  List<searchListWidget> userConnectionList = [];
  List<searchListWidget> displayList = [];
  TextEditingController networkSearchTec = TextEditingController();
  void initStateFunction() async {
    await currentUser.updateNetworkParameters();
    for (AppUser tempUser in currentUser.requestsReceived) {
      userConnectionList.add(searchListWidget(tempUser, inNetwork: false));
    }
    for (AppUser tempUser in currentUser.network) {
      userConnectionList.add(searchListWidget(tempUser, inNetwork: true));
    }
    displayList = userConnectionList;
    setState(() {});
  }

  List<searchListWidget> sortListByQuery(
      List<searchListWidget> corpus, String query) {
    print(corpus.length);
    List<searchListWidget> finalStringList = [];
    for (var value in corpus) {
      value.getCorpusRatingFromQuery(query);
    }
    corpus.sort((a, b) {
      if (a.gScore.compareTo(b.gScore) != 0)
        return a.gScore.compareTo(b.gScore);
      return (a.user.firstName).compareTo(b.user.firstName);
    });
    int i = 0;
    print("g scores");
    for (var value in corpus.reversed) {
      print(value.gScore);
      if (value.gScore != 0 || query.length <= 2) {
        print("this got added");
        finalStringList.add(value);
      } else {
        print("this did not get added");
      }
      i++;
    }
    print("final string list");
    print(finalStringList);
    return finalStringList;
  }

  void initState() {
    initStateFunction();
    networkSearchTec.addListener(() { 
      setState(() {
        displayList =
            sortListByQuery(userConnectionList, networkSearchTec.text);
        if (networkSearchTec.text == "") {
          displayList = userConnectionList;
        }
      });
    });
    super.initState();
  }

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
              opacity: 0.35,
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
                child: Column(
                  children: [
                    Container(
                      width: width,
                      height: height * 0.062,
                      child: Row(
                        children: [
                          Container(
                            height: height * 0.064,
                            width: width * 0.8,
                            margin: EdgeInsets.only(left: width * 0.03),
                            padding: EdgeInsets.only(
                                left: width * 0.01, right: width * 0.015),
                            decoration: BoxDecoration(
                                color: backgroundColor,
                                border: Border.all(
                                    color: mainColor, width: width * 0.012),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Row(
                              children: [
                                Container(
                                  height: height * 0.064,
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
                                      hintText: " Search Mentors",
                                      hintStyle: GoogleFonts.fredoka(
                                          color: mainColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 30),
                                    ),
                                    cursorHeight: height * 0.036,
                                    cursorWidth: width * 0.01,
                                    cursorColor: mainColor,
                                    maxLines: 1,
                                    style: GoogleFonts.fredoka(
                                        color: mainColor,
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
                    SizedBox(height: height * 0.01),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: displayList.map((thing) {
                          AppUser e = thing.user;
                          if (thing.inNetwork) {
                            return InkWell(
                              onTap: () async {
                                AppUser tempuser = AppUser();
                                await tempuser.getDataFromDatabase(e.email);
                                var temp = await Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (c) {
                                  return MyProfileScreen(
                                    tempuser,
                                  );
                                }));
                                setState(() {});
                              },
                              child: Container(
                                width: width * 0.93,
                                height: height * 0.1,
                                margin: EdgeInsets.only(
                                    bottom: height * 0.0075,
                                    left: width * 0.02,
                                    right: width * 0.02),
                                decoration: BoxDecoration(
                                    color: mainColor,
                                    border: Border.all(
                                        color: darkGreen, width: width * 0.015),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: Stack(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: width * 0.02,
                                        ),
                                        Container(
                                          height: height * 0.07,
                                          width: height * 0.07,
                                          margin: EdgeInsets.only(
                                              top: width * 0.02,
                                              bottom: width * 0.02),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: darkGreen,
                                                  width: width * 0.01),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            child: Image.network(
                                              e.image,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 0.025,
                                        ),
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: height * 0.008,
                                            ),
                                            Container(
                                                height: height * 0.048,
                                                child: FittedBox(
                                                  fit: BoxFit.fitHeight,
                                                  child: Text(
                                                    e.firstName +
                                                        " " +
                                                        e.lastName,
                                                    textAlign: TextAlign.start,
                                                    style: GoogleFonts.fredoka(
                                                        color: backgroundColor,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      bottom: height * 0.01,
                                      left: width * 0.2,
                                      child: Container(
                                        height: height * 0.03,
                                        width: width * 0.55,
                                        child: Text(
                                          currentGradeToString(e.currentGrade) +
                                              " at " +
                                              e.getCurrentSchool().name,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.fredoka(
                                              fontSize: 20,
                                              color: backgroundColor,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: height * 0.015,
                                      right: width * 0.02,
                                      child: currentUser.findEmailInUserList(
                                                  e.email,
                                                  currentUser.requestsSent) ||
                                              currentUser.findEmailInUserList(
                                                  e.email, currentUser.network)
                                          ? Container()
                                          : InkWell(
                                              onTap: () async {
                                                await currentUser
                                                    .addFriendRequest(e.email);
                                                setState(() {});
                                              },
                                              child: Container(
                                                child: ImageIcon(
                                                  AssetImage(
                                                    "assets/images/add-user.png",
                                                  ),
                                                  color: backgroundColor,
                                                  size: height * 0.035,
                                                ),
                                              ),
                                            ),
                                    ),
                                    Positioned(
                                      top: width * 0.035,
                                      right: width * 0.03,
                                      child: InkWell(
                                        onTap: (){
                                          Chat tempChat = Chat(user1Email: currentUser.email, user2Email: e.email);
                                          Navigator.of(context).push(
                                            MaterialPageRoute(builder: (c){
                                              return ChatScreen(tempChat);
                                            })
                                          );
                                        },
                                        child: Container(
                                          height: height * 0.03,
                                          child: FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: ImageIcon(
                                              AssetImage(
                                                  "assets/images/chat.png"),
                                              color: backgroundColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return InkWell(
                              onTap: () async {
                                AppUser tempuser = AppUser();
                                await tempuser.getDataFromDatabase(e.email);
                                var temp = await Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (c) {
                                  return MyProfileScreen(tempuser);
                                }));
                                setState(() {});
                              },
                              child: Container(
                                width: width * 0.93,
                                height: height * 0.144,
                                margin: EdgeInsets.only(
                                    bottom: height * 0.0075,
                                    left: width * 0.02,
                                    right: width * 0.02),
                                decoration: BoxDecoration(
                                    color: mainColor,
                                    border: Border.all(
                                        color: darkGreen, width: width * 0.015),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: width * 0.02,
                                            ),
                                            Container(
                                              height: height * 0.07,
                                              width: height * 0.07,
                                              margin: EdgeInsets.only(
                                                  top: width * 0.02,
                                                  bottom: width * 0.013 +
                                                      height * 0.002),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: darkGreen,
                                                      width: width * 0.01),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(7)),
                                                child: Image.network(
                                                  e.image,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width * 0.022,
                                            ),
                                            Column(
                                              children: [
                                                SizedBox(
                                                  height: height * 0.0025,
                                                ),
                                                Container(
                                                    height: height * 0.05,
                                                    child: FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: Text(
                                                        e.firstName +
                                                            " " +
                                                            e.lastName,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: GoogleFonts.fredoka(
                                                            color:
                                                                backgroundColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: width,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    await currentUser
                                                        .acceptFriendRequest(
                                                            e.email);
                                                    setState(() {
                                                      thing.inNetwork = true;
                                                    });
                                                  },
                                                  child: Container(
                                                    height: height * 0.2,
                                                    width: width * 0.4,
                                                    decoration: BoxDecoration(
                                                        color: mainColor,
                                                        border: Border.all(
                                                          color: darkGreen,
                                                          width: width * 0.01,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          height:
                                                              height * 0.026,
                                                          child: FittedBox(
                                                            fit: BoxFit
                                                                .fitHeight,
                                                            child: Text(
                                                              "Connect",
                                                              style: GoogleFonts.fredoka(
                                                                  color:
                                                                      backgroundColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    await currentUser
                                                        .declineFriendRequest(
                                                            e.email);
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    height: height * 0.2,
                                                    width: width * 0.4,
                                                    decoration: BoxDecoration(
                                                        color: red,
                                                        border: Border.all(
                                                          color: darkRed,
                                                          width: width * 0.01,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          height:
                                                              height * 0.026,
                                                          child: FittedBox(
                                                            fit: BoxFit
                                                                .fitHeight,
                                                            child: Text(
                                                              "Dismiss",
                                                              style: GoogleFonts.fredoka(
                                                                  color:
                                                                      backgroundColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: width * 0.013 + height * 0.0,
                                        )
                                      ],
                                    ),
                                    Positioned(
                                      top: height * 0.045,
                                      left: width * 0.2,
                                      child: Container(
                                        height: height * 0.03,
                                        width: width * 0.55,
                                        child: Text(
                                          currentGradeToString(e.currentGrade) +
                                              " at " +
                                              e.getCurrentSchool().name,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.fredoka(
                                              fontSize: 20,
                                              color: backgroundColor,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        }).toList(),
                      ),
                    ),
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
