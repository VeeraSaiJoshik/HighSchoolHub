import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/pages/AuthenticationPage.dart';
import 'package:highschoolhub/pages/addConnectionsScreen.dart';
import 'package:highschoolhub/pages/profileScreen.dart';

import '../../models/user.dart';

class ConnectionsScreen extends StatefulWidget {
  const ConnectionsScreen({super.key});

  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen> {
  @override
  TextEditingController networkSearchTec = TextEditingController();
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
              opacity: 0.35,
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
              top: true,
              child: Container(
                height: height,
                width: width,
                child: Column(
                  children: [
                    Container(
                      height: height * 0.015,
                    ),
                    Container(
                      width: width,
                      height: height * 0.062,
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
                                  margin: EdgeInsets.only(left: width * 0.04),
                                  child: ImageIcon(
                                    AssetImage("assets/images/menus.png"),
                                    color: mainColor,
                                  ),
                                ));
                          }),
                          SizedBox(
                            width: width * 0.03,
                          ),
                          Container(
                            height: height * 0.062,
                            width: width * 0.8,
                            padding: EdgeInsets.only(
                                left: width * 0.015, right: width * 0.015),
                            decoration: BoxDecoration(
                                color: backgroundColor,
                                border: Border.all(
                                    color: mainColor, width: width * 0.011),
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
                                      hintText: " Search Connections",
                                      hintStyle: GoogleFonts.fredoka(
                                          color: mainColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 30),
                                    ),
                                    cursorHeight: height * 0.036,
                                    cursorWidth: width * 0.01,
                                    cursorColor: darkGreen,
                                    maxLines: 1,
                                    style: GoogleFonts.fredoka(
                                        color: mainColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 30),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Expanded(
                      child: Container(
                        width: width * 0.93,
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (c) {
                                  return AddConnectionsScreen();
                                }));
                              },
                              child: Container(
                                height: height * 0.08,
                                decoration: BoxDecoration(
                                  color: mainColor,
                                  border: Border.all(
                                      color: darkGreen, width: width * 0.015),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: width * 0.03,
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: height * 0.005),
                                      height: height * 0.045,
                                      width: height * 0.045,
                                      child: ImageIcon(
                                        AssetImage(
                                          "assets/images/community.png",
                                        ),
                                        color: backgroundColor,
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.03,
                                    ),
                                    Container(
                                      height: height * 0.05,
                                      child: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Text(
                                          "Search Community",
                                          style: GoogleFonts.fredoka(
                                            color: backgroundColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            ...currentUser.requestsReceived.map((e) {
                              return InkWell(
                                onTap: () async {
                                  var temp = await Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (c) {
                                    return MyProfileScreen(
                                      e.email,
                                    );
                                  }));
                                  setState(() {});
                                },
                                child: Container(
                                  width: width * 0.93,
                                  height: height * 0.144,
                                  margin: EdgeInsets.only(top: height * 0.01),
                                  decoration: BoxDecoration(
                                      color: mainColor,
                                      border: Border.all(
                                          color: darkGreen,
                                          width: width * 0.015),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
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
                                                  borderRadius:
                                                      BorderRadius.all(
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
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      await currentUser
                                                          .acceptFriendRequest(
                                                              e.email);
                                                      setState(() {});
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
                                                                  Radius
                                                                      .circular(
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
                                                                  Radius
                                                                      .circular(
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
                                            height:
                                                width * 0.013 + height * 0.0,
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
                                            currentGradeToString(
                                                    e.currentGrade) +
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
                                      ...currentUser.network.map((e) {
                                        return InkWell(
                                          onTap: () async {
                                            var temp =
                                                await Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                        builder: (c) {
                                              return MyProfileScreen(
                                                e.email,
                                              );
                                            }));
                                            setState(() {});
                                          },
                                          child: Container(
                                            width: width * 0.93,
                                            height: height * 0.1,
                                            decoration: BoxDecoration(
                                                color: mainColor,
                                                border: Border.all(
                                                    color: darkGreen,
                                                    width: width * 0.015),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15))),
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
                                                              width:
                                                                  width * 0.01),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    7)),
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
                                                          height:
                                                              height * 0.0025,
                                                        ),
                                                        Container(
                                                            height:
                                                                height * 0.05,
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                              child: Text(
                                                                e.firstName +
                                                                    " " +
                                                                    e.lastName,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
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
                                                Positioned(
                                                  bottom: height * 0.008,
                                                  left: width * 0.2,
                                                  child: Container(
                                                    height: height * 0.03,
                                                    width: width * 0.55,
                                                    child: Text(
                                                      currentGradeToString(
                                                              e.currentGrade) +
                                                          " at " +
                                                          e
                                                              .getCurrentSchool()
                                                              .name,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: GoogleFonts.fredoka(
                                                          fontSize: 20,
                                                          color:
                                                              backgroundColor,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList()
                                    ],
                                  ),
                                ),
                              );
                            }).toList()
                          ],
                        ),
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
