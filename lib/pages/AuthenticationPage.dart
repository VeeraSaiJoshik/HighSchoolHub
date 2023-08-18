// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/models/uploadDataToDatabase.dart';
import 'package:highschoolhub/models/user.dart';
import 'package:highschoolhub/pages/SignUp.dart';
import 'package:highschoolhub/models/uplading.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}
late AppUser currentUser;
class _AuthenticationScreenState extends State<AuthenticationScreen> {
  @override
  
  bool loadingState = false;
  void initState() {
    currentUser = AppUser(schools: []);
    super.initState();
  }

  void setLoadingState() {
    setState(() {
      loadingState = loadingState == false;
    });
  }

  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
              height: height,
              width: width,
              color: backgroundColor,
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  "assets/images/backdrop.png",
                  fit: BoxFit.cover,
                ),
              )),
          SafeArea(
            bottom: false,
            child: Container(
                width: width,
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        InkWell(
                          onTap: (){
                          },
                          child: Lottie.asset(
                            "assets/animations/student.json",
                            height: height * 0.43,
                            width: height * 0.43,
                          ),
                        ),
                        Positioned(
                          bottom: height * 0.005,
                          child: Row(
                            children: [
                              Container(
                                  height: height * 0.025,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      "Curate",
                                      style: GoogleFonts.rubik(
                                          color: Color(0xff9966CC),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              SizedBox(
                                width: width * 0.005,
                              ),
                              CircleAvatar(
                                radius: width * 0.005,
                                backgroundColor: darkGreen,
                              ),
                              SizedBox(
                                width: width * 0.005,
                              ),
                              Container(
                                  height: height * 0.025,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      "Connect",
                                      style: GoogleFonts.rubik(
                                          color: Color(0xffFF7518),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              SizedBox(
                                width: width * 0.005,
                              ),
                              CircleAvatar(
                                radius: width * 0.005,
                                backgroundColor: darkGreen,
                              ),
                              SizedBox(
                                width: width * 0.005,
                              ),
                              Container(
                                  height: height * 0.025,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      "Create",
                                      style: GoogleFonts.rubik(
                                          color: Color(0xff448AFF),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      height: height * 0.15,
                      width: width,
                      child: Stack(
                        children: [
                          Positioned(
                            top: height * 0.01,
                            left: width * 0.05,
                            child: Container(
                              height: height * 0.064,
                              width: width * 0.6,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  "Welcome To",
                                  style: GoogleFonts.fredoka(
                                      color: darkGreen,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: height * 0.055,
                            left: width * 0.07,
                            child: Container(
                                height: height * 0.08,
                                width: width * 0.8,
                                child: Row(
                                  children: [
                                    Container(
                                      height: height * 0.08,
                                      child: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Text(
                                          "Student",
                                          style: GoogleFonts.fredoka(
                                              letterSpacing: 0.5,
                                              color: mainColor,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                                    //SizedBox(width: width * 0.015),
                                    Container(
                                      height: height * 0.08,
                                      child: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Text(
                                          "NET",
                                          style: GoogleFonts.fredoka(
                                              letterSpacing: 0.5,
                                              color: mainColor,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    InkWell(
                      onTap: () async {
                        int status = 0;
                        setLoadingState();
                        try {
                          status = await currentUser.authenticationUser();
                          if (status == 2) {
                            Navigator.of(context).popAndPushNamed(
                                "SignUpScreen",
                                arguments: [currentUser]);
                          }else{
                            print("done");
                            await currentUser.getDataFromDatabase(currentUser.userData!.email!);
                            print("done");
                            Navigator.of(context).popAndPushNamed("HomeScreen");
                          }
                        } on Exception catch (_) {
                          status = -1;
                        }
                      },
                      child: Container(
                        width: width * 0.87,
                        height: height * 0.09,
                        decoration: BoxDecoration(
                            color: blue,
                            border: Border.all(
                                color: darkblue, width: width * 0.015),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Row(
                          children: [
                            SizedBox(
                              width: (height * 0.09 -
                                      height * 0.015 -
                                      height * 0.045) /
                                  2,
                            ),
                            Container(
                              height: height * 0.045,
                              child: Image.asset(
                                "assets/images/google.png",
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            SizedBox(
                              width: width * 0.037,
                            ),
                            Container(
                              height: height * 0.06,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  "Google Log In",
                                  style: GoogleFonts.fredoka(
                                      color: backgroundColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.013,
                    ),
                    Container(
                      height: height * 0.03,
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: height * 0.006,
                            width: width * 0.3,
                            decoration: BoxDecoration(
                                color: orange,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100))),
                          ),
                          SizedBox(
                            width: width * 0.015,
                          ),
                          Container(
                            height: height * 0.03,
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                "OR",
                                style: GoogleFonts.fredoka(
                                    color: orange, fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.015,
                          ),
                          Container(
                            height: height * 0.006,
                            width: width * 0.3,
                            decoration: BoxDecoration(
                                color: orange,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100))),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.013,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).popAndPushNamed("SignUpScreen",
                            arguments: [currentUser]);
                      },
                      child: Container(
                        width: width * 0.87,
                        height: height * 0.09,
                        decoration: BoxDecoration(
                            color: puprle,
                            border: Border.all(
                                color: darkPurple, width: width * 0.015),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Row(
                          children: [
                            SizedBox(
                              width: (height * 0.09 -
                                          height * 0.015 -
                                          height * 0.045) /
                                      2 +
                                  width * 0.01,
                            ),
                            Container(
                              height: height * 0.045,
                              child: Image.asset(
                                "assets/images/signup.png",
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            SizedBox(
                              width: width * 0.037,
                            ),
                            Container(
                              height: height * 0.055,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  "Create Account",
                                  style: GoogleFonts.fredoka(
                                      color: backgroundColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )),
          ),
          loadingState
              ? Container(
                  height: height,
                  width: width,
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                      child: LoadingAnimationWidget.threeRotatingDots(
                          color: mainColor, size: height * 0.1)),
                )
              : Container()
        ],
      ),
    );
  }
}

