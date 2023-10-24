import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/pages/mentor/createMentorPostScreen.dart';
import 'package:highschoolhub/pages/mentor/menteeScreen.dart';
import 'package:highschoolhub/pages/mentor/mentorsSearchScreen.dart';
import 'package:highschoolhub/pages/mentor/myMentorsScreen.dart';
import 'package:highschoolhub/pages/mentor/viewMyPosts.dart';

class MentorScreen extends StatefulWidget {
  const MentorScreen({super.key});

  @override
  State<MentorScreen> createState() => _MentorScreenState();
}

class _MentorScreenState extends State<MentorScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: height,
      color: backgroundColor,
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
            child: Column(
              children: [
                Container(
                  height: height * 0.06,
                  width: width,
                  child: Row(
                    children: [
                      SizedBox(
                        width: width * 0.055,
                      ),
                      Builder(builder: (context) {
                        return InkWell(
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                          child: Container(
                            height: height * 0.052,
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: ImageIcon(
                                AssetImage(
                                  "assets/images/menus.png",
                                ),
                                color: orange,
                              ),
                            ),
                          ),
                        );
                      }),
                      SizedBox(
                        width: width * 0.06,
                      ),
                      Container(
                        height: height * 0.06,
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(
                            "Mentor Screen",
                            style: GoogleFonts.fredoka(
                                color: orange, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                      return MentorsSearchScreen();
                    }));
                  },
                  child: Container(
                    height: height * 0.092,
                    width: width * 0.94,
                    margin: EdgeInsets.only(top: height * 0.02),
                    decoration: BoxDecoration(
                        color: orange,
                        border: Border.all(
                            color: darkOrange.withOpacity(0.5),
                            width: width * 0.018),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: height * 0.043,
                            child: FittedBox(
                              child: ImageIcon(
                                AssetImage("assets/images/browse.png"),
                                color: backgroundColor,
                              ),
                              fit: BoxFit.fitHeight,
                            )),
                        SizedBox(
                          width: width * 0.025,
                        ),
                        Container(
                          height: height * 0.05,
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text(
                              "Search Mentors",
                              style: GoogleFonts.fredoka(
                                  color: backgroundColor,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (c){
                        return MyMentorScreen();
                      })
                    );
                  },
                  child: Container(
                    height: height * 0.092,
                    width: width * 0.94,
                    margin: EdgeInsets.only(top: height * 0.0125),
                    decoration: BoxDecoration(
                        color: orange,
                        border: Border.all(
                            color: darkOrange.withOpacity(0.5), width: width * 0.018),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: height * 0.043,
                            child: FittedBox(
                              child: ImageIcon(
                                AssetImage("assets/images/mentorIcon.png"),
                                color: backgroundColor,
                              ),
                              fit: BoxFit.fitHeight,
                            )),
                        SizedBox(
                          width: width * 0.025,
                        ),
                        Container(
                          height: height * 0.05,
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text(
                              "My Mentors",
                              style: GoogleFonts.fredoka(
                                  color: backgroundColor,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (builder){
                      return MyMenteeScreen();
                    }));
                  },
                  child: Container(
                    height: height * 0.092,
                    width: width * 0.94,
                    margin: EdgeInsets.only(top: height * 0.0125),
                    decoration: BoxDecoration(
                        color: orange,
                        border: Border.all(
                            color: darkOrange.withOpacity(0.5), width: width * 0.018),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: height * 0.043,
                            child: FittedBox(
                              child: ImageIcon(
                                AssetImage("assets/images/mentor.png"),
                                color: backgroundColor,
                              ),
                              fit: BoxFit.fitHeight,
                            )),
                        SizedBox(
                          width: width * 0.025,
                        ),
                        Container(
                          height: height * 0.05,
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text(
                              "My Mentees",
                              style: GoogleFonts.fredoka(
                                  color: backgroundColor,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                      return CreateMentorPostScreen();
                    }));
                  },
                  child: Container(
                    height: height * 0.092,
                    width: width * 0.94,
                    margin: EdgeInsets.only(top: height * 0.0125),
                    decoration: BoxDecoration(
                        color: orange,
                        border: Border.all(
                            color: darkOrange.withOpacity(0.5),
                            width: width * 0.018),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: height * 0.035,
                            child: FittedBox(
                              child: ImageIcon(
                                AssetImage("assets/images/add_school.png"),
                                color: backgroundColor,
                              ),
                              fit: BoxFit.fitHeight,
                            )),
                        SizedBox(
                          width: width * 0.03,
                        ),
                        Container(
                          height: height * 0.045,
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text(
                              "Create Mentor Post",
                              style: GoogleFonts.fredoka(
                                  color: backgroundColor,
                                  fontWeight: FontWeight.w700),
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
                        .push(MaterialPageRoute(builder: (builder) {
                      return ViewMyMentorPostsScreen();
                    }));
                  },
                  child: Container(
                    height: height * 0.092,
                    width: width * 0.94,
                    margin: EdgeInsets.only(top: height * 0.015),
                    decoration: BoxDecoration(
                        color: orange,
                        border: Border.all(
                            color: darkOrange.withOpacity(0.5),
                            width: width * 0.018),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: height * 0.038,
                            child: FittedBox(
                              child: ImageIcon(
                                AssetImage("assets/images/post.png"),
                                color: backgroundColor,
                              ),
                              fit: BoxFit.fitHeight,
                            )),
                        SizedBox(
                          width: width * 0.025,
                        ),
                        Container(
                          height: height * 0.045,
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text(
                              "My Mentor Posts",
                              style: GoogleFonts.fredoka(
                                                                  
                                  color: backgroundColor,
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
          ),
        ],
      ),
    );
  }
}
