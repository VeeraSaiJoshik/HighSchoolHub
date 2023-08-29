import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/pages/addConnectionsScreen.dart';

class ConnectionsScreen extends StatefulWidget {
  const ConnectionsScreen({super.key});

  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen> {
  @override
  TextEditingController networkSearchTec =
      TextEditingController();
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
                              onTap: (){
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (c){
                                    return AddConnectionsScreen();
                                  })
                                );
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
                                      margin: EdgeInsets.only(
                                        top: height * 0.005
                                      ),
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
