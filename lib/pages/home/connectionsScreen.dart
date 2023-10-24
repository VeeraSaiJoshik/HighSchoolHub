import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/pages/AuthenticationPage.dart';
import 'package:highschoolhub/pages/connections/myConnectionsScreen.dart';
import 'package:highschoolhub/pages/connections/suggestedConnectionsScreen.dart';
import 'package:highschoolhub/pages/profileScreen.dart';

import '../../models/user.dart';
import '../connections/addConnectionsScreen.dart';

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
    return Container(
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
                    height: height * 0.065,
                    child: Row(
                      children: [
                        Builder(builder: (context) {
                          return InkWell(
                              onTap: () {
                                Scaffold.of(context).openDrawer();
                              },
                              child: Container(
                                height: height * 0.05,
                                width: height * 0.05,
                                margin: EdgeInsets.only(left: width * 0.04),
                                child: ImageIcon(
                                  AssetImage("assets/images/menus.png"),
                                  color: mainColor,
                                ),
                              ));
                        }),
                        SizedBox(
                          width: width * 0.1,
                        ),
                        Container(
                          height: height * 0.065,
                          child : FittedBox(
                            fit : BoxFit.fitHeight, 
                            child: Text(
                              "Connections", 
                              style : GoogleFonts.fredoka(
                                color : mainColor, 
                                fontWeight: FontWeight.w700
                              )
                            ),
                          )
                        ),
                      
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
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
                              height: height * 0.092,
                              decoration: BoxDecoration(
                                  color: mainColor,
                                  border: Border.all(
                                      color: darkGreen, width: width * 0.018),
                                  borderRadius: BorderRadius.circular(15)),
                              margin: EdgeInsets.only(bottom: height * 0.01),
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
                                        "assets/images/searchCommunity.png",
                                      ),
                                      color: backgroundColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.03,
                                  ),
                                  Container(
                                    height: height * 0.045,
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
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (c) {
                                return SuggestedConnectionsScreen();
                              }));
                            },
                            child: Container(
                              height: height * 0.092,
                              decoration: BoxDecoration(
                                  color: mainColor,
                                  border: Border.all(
                                      color: darkGreen,
                                      width: width * 0.018),
                                  borderRadius: BorderRadius.circular(15)),
                              margin : EdgeInsets.only(bottom: height * 0.01),
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
                                        "assets/images/suggested_connections.png",
                                      ),
                                      color: backgroundColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.03,
                                  ),
                                  Container(
                                    height: height * 0.043,
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Text(
                                        "Suggested Connections",
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
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (c) {
                                return MyConnectionsScreen();
                              }));
                            },
                            child: Container(
                              height: height * 0.092,
                              decoration: BoxDecoration(
                                  color: mainColor,
                                  border: Border.all(
                                      color: darkGreen, width: width * 0.018),
                                  borderRadius: BorderRadius.circular(15)),
                              margin:
                                  EdgeInsets.only(bottom: height * 0.0015),
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
                                    height: height * 0.045,
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Text(
                                        "My Connections",
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
    );
  }
}
