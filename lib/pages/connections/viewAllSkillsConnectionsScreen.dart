import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/models/school.dart';
import 'package:highschoolhub/pages/connections/suggestedConnectionsScreen.dart';

import '../../models/user.dart';
import '../AuthenticationPage.dart';

class AllSKillConnections extends StatefulWidget {
  List<schoolSkillConnections> connectionsThroughSkills;
  AllSKillConnections(this.connectionsThroughSkills);
  @override
  State<AllSKillConnections> createState() =>
      _AllSKillConnectionsState();
}

class _AllSKillConnectionsState extends State<AllSKillConnections> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        color: mainColor,
        child: Stack(
          children: [
            Opacity(
              opacity: 0.15,
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
                            color: Colors.grey.shade300, width: width * 0.008),
                        borderRadius: BorderRadius.all(Radius.circular(35))),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Container(
                            width: width * 0.92,
                            height: height * 0.07,
                            child: Row(
                              children: [
                                Container(
                                  width: height * 0.02,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    height: height * 0.063,
                                    width: height * 0.063,
                                    decoration: BoxDecoration(
                                        color: red,
                                        border: Border.all(
                                            color: darkRed,
                                            width: width * 0.012),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    padding: EdgeInsets.all(width * 0.025),
                                    child:
                                        Image.asset("assets/images/back.png"),
                                  ),
                                ),
                                Container(
                                  width: width * 0.07,
                                ),
                                Container(
                                    height: height * 0.06,
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Text(
                                        "Same Skills",
                                        style: GoogleFonts.fredoka(
                                          color: mainColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Expanded(
                              child: Container(
                            margin:
                                EdgeInsets.symmetric(horizontal: height * 0.01),
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children: [
                                ...widget.connectionsThroughSkills.map((e) {
                                  AppUser recommendedUser = e.user;
                                  String bottomText = "";
                                  
                                  bottomText = e.skillsInCommon.toString() + " skills in common";
                                  return InkWell(
                                    onTap: () async {},
                                    child: Container(
                                      width: width * 0.93,
                                      height: height * 0.1,
                                      margin: EdgeInsets.only(
                                        bottom: height * 0.01,
                                      ),
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
                                                        width: width * 0.01),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  child: Image.network(
                                                    recommendedUser.image,
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
                                                      height: height * 0.045,
                                                      child: FittedBox(
                                                        fit: BoxFit.fitHeight,
                                                        child: Text(
                                                          recommendedUser
                                                                  .firstName +
                                                              " " +
                                                              recommendedUser
                                                                  .lastName,
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
                                          Positioned(
                                            bottom: height * 0.01,
                                            left: width * 0.2,
                                            child: Container(
                                              height: height * 0.029,
                                              width: width * 0.55,
                                              child: Text(
                                                bottomText,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.start,
                                                style: GoogleFonts.fredoka(
                                                    fontSize: 18,
                                                    color: backgroundColor,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                        top: height * 0.016,
                                        right: width * 0.02,
                                        child: currentUser.findEmailInUserList(
                                                    e.user.email,
                                                    currentUser.requestsSent) ||
                                                currentUser.findEmailInUserList(
                                                    e.user.email,
                                                    currentUser.network)
                                            ? Container()
                                            : InkWell(
                                                onTap: () async {
                                                  await currentUser
                                                      .addFriendRequest(
                                                          e.user.email);
                                                  setState(() {});
                                                },
                                                child: Container(
                                                  child: ImageIcon(
                                                    AssetImage(
                                                      "assets/images/add-user.png",
                                                    ),
                                                    color: backgroundColor,
                                                    size: height * 0.03,
                                                  ),
                                                ),
                                              ),
                                      )
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList()
                              ],
                            ),
                          )),
                          SizedBox(
                            height: height * 0.01,
                          )
                        ]),
                  )
                ]))
          ],
        ),
      ),
    );
  }
}
