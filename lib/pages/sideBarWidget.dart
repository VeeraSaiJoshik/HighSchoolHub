import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/models/user.dart';
import 'package:highschoolhub/pages/AuthenticationPage.dart';

enum Screen { Setting, Sign_Out, Home, connections }

class SideBarWidget extends StatefulWidget {
  Screen currentScreen;
  Function changeCurrentScreen;
  SideBarWidget(this.currentScreen, this.changeCurrentScreen);

  @override
  State<SideBarWidget> createState() => _SideBarWidgetState();
}

class _SideBarWidgetState extends State<SideBarWidget> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width * 0.67,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: Stack(
        children: [
          Opacity(
            opacity: 0.0,
            child: SizedBox(
              height: height,
              width: width * 0.65,
              child: Image.asset(
                "assets/images/backdrop.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: height,
            width: width * 0.67,
            child: Column(
              children: [
                Container(
                  height: height * 0.34,
                  width: width * 0.67,
                  decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: 0.2,
                        child: SizedBox(
                          height: height * 0.3,
                          width: width * 0.67,
                          child: FittedBox(
                            child: ImageIcon(
                              AssetImage("assets/images/backdrop.png",), 
                              color: darkGreen,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        height: height * 0.34,
                        width: width * 0.67,
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).padding.top +
                                  height * 0.01,
                            ),
                            Container(
                                height: height * 0.15,
                                width: height * 0.15,
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  border: Border.all(
                                      color: darkGreen, width: width * 0.018),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: Image.network(
                                    currentUser.image,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                            SizedBox(
                              height: height * 0.008,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: height * 0.045,
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
                              ],
                            ),
                            Container(
                              width: width * 0.6,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      currentUser.email,
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.fredoka(
                                          color: backgroundColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 19,
                                          height: 1),
                                    ),
                                  ),
                                ],
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
                    width: width * 0.67,
                    child: Column(
                      children: [
                        SideBarOptionWidget(
                          "assets/images/home.png", 
                          "Home", 
                          widget.currentScreen, 
                          Screen.Home, 
                          widget.changeCurrentScreen, 
                          blue, 
                        ),
                        SideBarOptionWidget(
                          "assets/images/setting.png", 
                          "Settings", 
                          widget.currentScreen, 
                          Screen.Setting, 
                          widget.changeCurrentScreen, 
                          puprle
                        ), 
                        SideBarOptionWidget(
                          "assets/images/Connections.png", 
                          "Connections", 
                          widget.currentScreen, 
                          Screen.connections, 
                          widget.changeCurrentScreen, 
                          mainColor
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await currentUser.signOut();
                    currentUser = AppUser();
                    Navigator.of(context)
                        .popAndPushNamed("authenticationScreen");
                  },
                  child: Container(
                    width: width * 0.67,
                    height: height * 0.055,
                    child: Row(children: [
                      SizedBox(
                        width: width * 0.045,
                      ),
                      Container(
                        height: height * 0.035,
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: ImageIcon(
                            AssetImage("assets/images/logout.png"),
                            color: red,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.035,
                      ),
                      Container(
                        height: height * 0.047,
                        margin: EdgeInsets.only(bottom: height * 0.003),
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(
                            "Sign Out",
                            style: GoogleFonts.fredoka(
                                color: red, fontWeight: FontWeight.w700),
                          ),
                        ),
                      )
                    ]),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SideBarOptionWidget extends StatefulWidget {
  String icon;
  String text;
  Screen currentScreen;
  Screen optionScreen;
  Function changeScreenFunction;
  Color primaryColor;
  double imageHeight;
  SideBarOptionWidget(this.icon, this.text, this.currentScreen,
      this.optionScreen, this.changeScreenFunction, this.primaryColor, {this.imageHeight = 0.035});
  @override
  State<SideBarOptionWidget> createState() => _SideBarOptionWidgetState();
}

class _SideBarOptionWidgetState extends State<SideBarOptionWidget> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: (){
        widget.changeScreenFunction(widget.optionScreen);
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(
              bottom: height * 0.0125
            ),
            width: width * 0.67,
            height: height * 0.05,
            child: Row(
              children: [
                SizedBox(
                  width: width * 0.038,
                ),
                Container(
                  height: height * widget.imageHeight,
                  width: height * widget.imageHeight,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: ImageIcon(
                      AssetImage(widget.icon),
                      color:  Colors.grey,
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.035,
                ),
                Container(
                  height: height * 0.047,
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      widget.text,
                      style: GoogleFonts.fredoka(
                          color: Colors.grey,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                )
              ],
            ),
          ),
          AnimatedOpacity(
            duration: Duration(milliseconds: 150),
            opacity: widget.currentScreen == widget.optionScreen ? 1 : 0,
            child: Container(
              margin: EdgeInsets.only(
                bottom: height * 0.0125
              ),
              width: width * 0.67,
              height: height * 0.05,
              child: Row(
                children: [
                  SizedBox(
                    width: width * 0.038,
                  ),
                  Container(
                    height: height * widget.imageHeight,
                    width: height * widget.imageHeight,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: ImageIcon(
                        AssetImage(widget.icon),
                        color:widget.primaryColor
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.035,
                  ),
                  Container(
                    height: height * 0.047,
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text(
                        widget.text,
                        style: GoogleFonts.fredoka(
                            color: widget.primaryColor,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
