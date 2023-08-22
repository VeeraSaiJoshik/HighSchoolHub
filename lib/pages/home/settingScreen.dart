import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/pages/profileScreen.dart';
import 'package:highschoolhub/pages/setting/editAcountData.dart';
import 'package:highschoolhub/pages/setting/editClasses.dart';
import 'package:highschoolhub/pages/setting/editClubs.dart';
import 'package:highschoolhub/pages/setting/editSchoolData.dart';

import '../../globalInfo.dart';
import '../AuthenticationPage.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String imageUrl = currentUser.image;
    print(imageUrl);
    return SafeArea(
        top: false,
        bottom: false,
        child: Container(
            width: width,
            height: height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: width * 0.025,
                ),
                Container(
                  height: height * 0.365,
                  width: width * 0.95,
                  decoration: BoxDecoration(
                      color: puprle,
                      border:
                          Border.all(width: width * 0.015, color: darkPurple),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(45),
                          topRight: Radius.circular(45),
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25))),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.035,
                      ),
                      Container(
                        height: height * 0.05,
                        width: width,
                        child: Row(
                          children: [
                             Builder(
                              builder: (context) {
                                return InkWell(
                                  onTap: (){
                                     Scaffold.of(context).openDrawer();
                                  },
                                  child: Container(
                              height: height * 0.04,
                              width: height * 0.04,
                              margin: EdgeInsets.only(left: width * 0.06),
                              child: ImageIcon(
                                AssetImage("assets/images/menus.png"),
                                color: backgroundColor,
                              ),
                            )
                                );
                              }
                            ),
                            
                          ],
                        ),
                      ),
                      Container(
                        height: height * 0.16,
                        width: height * 0.16,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: darkPurple, width: width * 0.02),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          child: 
                          currentUser.image.runtimeType == String ?
                          Image.network(
                            Uri.encodeFull(currentUser.image),
                            fit: BoxFit.cover,
                            key: UniqueKey(),
                          ):Container(),
                        ),
                      ),
                      Stack(
                        children: [
                          Container(
                            height: height * 0.06,
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
                          Container(
                            height: height * 0.03,
                            margin: EdgeInsets.only(
                                top: height * 0.055, left: width * 0.02),
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                currentUser.email,
                                
                                textAlign: TextAlign.center,
                                style: GoogleFonts.fredoka(
                                    color: backgroundColor,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(height: width * 0.025),
                Expanded(
                    child: Container(
                  width: width,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      InkWell(
                        onTap: () async {
                         Navigator.of(context).push(
                          MaterialPageRoute(builder: (c){
                            return MyProfileScreen(currentUser.email);
                          })
                         );
                        },
                        child: Container(
                          width: width * 0.95,
                          height: height * 0.09,
                          margin: EdgeInsets.symmetric(horizontal: width * 0.025),
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            border: Border.all(
                                color: darkGreen, width: width * 0.015),
                          ),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: width * 0.04, right: width * 0.025),
                                height: height * 0.04,
                                width: height * 0.04,
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: ImageIcon(
                                    AssetImage(
                                        "assets/images/view.png"),
                                    color: backgroundColor,
                                  ),
                                ),
                              ),
                              Container(
                                height: height * 0.06,
                                width: width * 0.65,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(),
                                    ),
                                    Container(
                                        height: height * 0.045,
                                        child: FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: Text(
                                            "View My Profile",
                                            style: GoogleFonts.fredoka(
                                                color: backgroundColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        )),
                                    Expanded(
                                      child: Container(),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(child: Container()),
                              Container(
                                height: height * 0.035,
                                width: height * 0.035,
                                margin: EdgeInsets.only(right: width * 0.025),
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: ImageIcon(
                                      AssetImage(
                                          "assets/images/openSettings.png"),
                                      color: backgroundColor),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(height: width * 0.025),
                      InkWell(
                        onTap: () async {
                          await Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                            return EditAccountScreen();
                          }));
                          imageCache.clear();

                          setState(() {
                            print(currentUser.image );
                            currentUser.image = currentUser.image + "?v=${DateTime.now().millisecondsSinceEpoch}";
                          });
                        },
                        child: Container(
                          width: width * 0.95,
                          height: height * 0.09,
                          margin: EdgeInsets.symmetric(horizontal: width * 0.025),
                          decoration: BoxDecoration(
                            color: blue,
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            border:
                                Border.all(color: darkblue, width: width * 0.015),
                          ),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: width * 0.04, right: width * 0.015),
                                height: height * 0.0425,
                                width: height * 0.0425,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: ImageIcon(
                                    AssetImage(
                                        "assets/images/signUpScreenIcons/user.png"),
                                    color: backgroundColor,
                                  ),
                                ),
                              ),
                              Container(
                                height: height * 0.06,
                                width: width * 0.65,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(),
                                    ),
                                    Container(
                                        height: height * 0.045,
                                        child: FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: Text(
                                            "Edit Account Info",
                                            style: GoogleFonts.fredoka(
                                                color: backgroundColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        )),
                                    Expanded(
                                      child: Container(),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(child: Container()),
                              Container(
                                height: height * 0.035,
                                width: height * 0.035,
                                margin: EdgeInsets.only(right: width * 0.025),
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: ImageIcon(
                                      AssetImage(
                                          "assets/images/openSettings.png"),
                                      color: backgroundColor),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(height: width * 0.025),
                      InkWell(
                        onTap: () async {
                          var delayV = await Navigator.of(context).push(MaterialPageRoute(builder: (c){
                            return EditSchoolScreen();
                          }));
                        },
                        child: Container(
                          width: width * 0.95,
                          height: height * 0.09,
                          margin: EdgeInsets.symmetric(horizontal: width * 0.025),
                          decoration: BoxDecoration(
                            color: puprle,
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            border: Border.all(
                                color: darkPurple, width: width * 0.015),
                          ),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: width * 0.04, right: width * 0.025),
                                height: height * 0.0425,
                                width: height * 0.0425,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: ImageIcon(
                                    AssetImage(
                                        "assets/images/signUpScreenIcons/school.png"),
                                    color: backgroundColor,
                                  ),
                                ),
                              ),
                              Container(
                                height: height * 0.06,
                                width: width * 0.65,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(),
                                    ),
                                    Container(
                                        height: height * 0.045,
                                        child: FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: Text(
                                            "Edit School Info",
                                            style: GoogleFonts.fredoka(
                                                color: backgroundColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        )),
                                    Expanded(
                                      child: Container(),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(child: Container()),
                              Container(
                                height: height * 0.035,
                                width: height * 0.035,
                                margin: EdgeInsets.only(right: width * 0.025),
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: ImageIcon(
                                      AssetImage(
                                          "assets/images/openSettings.png"),
                                      color: backgroundColor),
                                ),
                              )
                            ],
                          ),
                        ),
                      ), 
                      Container(height: width * 0.025),
                      InkWell(
                        onTap: () async {
                          var t = await Navigator.of(context).push(
                            MaterialPageRoute(builder: (builder){
                              return EditClassScreen();
                            })
                          );
                          setState(() {});
                        },
                        child: Container(
                          width: width * 0.95,
                          height: height * 0.09,
                          margin: EdgeInsets.symmetric(horizontal: width * 0.025),
                          decoration: BoxDecoration(
                            color: orange,
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            border: Border.all(
                                color: darkOrange, width: width * 0.015),
                          ),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: width * 0.04, right: width * 0.025),
                                height: height * 0.0425,
                                width: height * 0.0425,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: ImageIcon(
                                    AssetImage(
                                        "assets/images/signUpScreenIcons/skills.png"),
                                    color: backgroundColor,
                                  ),
                                ),
                              ),
                              Container(
                                height: height * 0.06,
                                width: width * 0.65,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(),
                                    ),
                                    Container(
                                        height: height * 0.045,
                                        child: FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: Text(
                                            "Edit Class Info",
                                            style: GoogleFonts.fredoka(
                                                color: backgroundColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        )),
                                    Expanded(
                                      child: Container(),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(child: Container()),
                              Container(
                                height: height * 0.035,
                                width: height * 0.035,
                                margin: EdgeInsets.only(right: width * 0.025),
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: ImageIcon(
                                      AssetImage(
                                          "assets/images/openSettings.png"),
                                      color: backgroundColor),
                                ),
                              )
                            ],
                          ),
                        ),
                      ), 
                      Container(height: width * 0.025),
                      InkWell(
                        onTap: () async {
                          var t = Navigator.of(context).push(
                            MaterialPageRoute(builder: (c){
                              return EditClubScreen();
                            })
                          );
                          setState(() {});
                        },
                        child: Container(
                          width: width * 0.95,
                          height: height * 0.09,
                          margin: EdgeInsets.symmetric(horizontal: width * 0.025),
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            border: Border.all(
                                color: darkGreen, width: width * 0.015),
                          ),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: width * 0.04, right: width * 0.025),
                                height: height * 0.04,
                                width: height * 0.04,
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: ImageIcon(
                                    AssetImage(
                                        "assets/images/signUpScreenIcons/trophy.png"),
                                    color: backgroundColor,
                                  ),
                                ),
                              ),
                              Container(
                                height: height * 0.06,
                                width: width * 0.65,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(),
                                    ),
                                    Container(
                                        height: height * 0.045,
                                        child: FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: Text(
                                            "Edit Club/Skill Info",
                                            style: GoogleFonts.fredoka(
                                                color: backgroundColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        )),
                                    Expanded(
                                      child: Container(),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(child: Container()),
                              Container(
                                height: height * 0.035,
                                width: height * 0.035,
                                margin: EdgeInsets.only(right: width * 0.025),
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: ImageIcon(
                                      AssetImage(
                                          "assets/images/openSettings.png"),
                                      color: backgroundColor),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ))
              ],
            )));
  }
}
