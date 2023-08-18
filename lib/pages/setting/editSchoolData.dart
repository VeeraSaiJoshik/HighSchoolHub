import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';

class EditSchoolScreen extends StatefulWidget {
  const EditSchoolScreen({super.key});

  @override
  State<EditSchoolScreen> createState() => _EditSchoolScreenState();
}

class _EditSchoolScreenState extends State<EditSchoolScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    int currentScreen = 0;
    bool keyboardUp = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      body: SingleChildScrollView(
        physics: keyboardUp
            ? BouncingScrollPhysics()
            : NeverScrollableScrollPhysics(),
        child: Container(
          height: height,
          width: width,
          color: backgroundColor,
          child: Stack(
            children: [
              Opacity(
                opacity: 0.5,
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
                child: Container(
                  width: width,
                  child: Column(
                    children: [
                      Container(
                        width: width,
                        height: height * 0.0725,
                        child: Row(
                          children: [
                            SizedBox(width: width * 0.05),
                            Container(
                              height: height * 0.0725,
                              width: height * 0.0725,
                              child: FloatingActionButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                },
                                elevation: 2,
                                backgroundColor: red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  side: BorderSide(
                                    width: width * 0.0125,
                                    color:darkRed
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    currentScreen == 0
                                        ? width * 0.042
                                        : width * 0.03,
                                  ),
                                  child: RotatedBox(
                                    quarterTurns: 2,
                                    child: Image.asset(
                                      "assets/images/back.png"
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                            InkWell(
                              child: Container(
                                height: height * 0.0725,
                                child: FittedBox(
                                  child: Text(
                                    "Account",
                                    style: GoogleFonts.fredoka(
                                      fontWeight: FontWeight.w800,
                                      color: blue,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                            Container(
                              height: height * 0.0725,
                              width: height * 0.0725,
                              child: FloatingActionButton(
                                onPressed: () async {},
                                elevation: 2,
                                backgroundColor: mainColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  side: BorderSide(
                                    width: width * 0.0125,
                                    color: darkGreen,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    currentScreen == 3
                                        ? width * 0.035
                                        : width * 0.03,
                                  ),
                                  child: RotatedBox(
                                    quarterTurns: 0,
                                    child: Image.asset(
                                      "assets/images/done.png"
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: width * 0.05),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}