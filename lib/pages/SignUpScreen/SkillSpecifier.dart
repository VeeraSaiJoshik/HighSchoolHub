import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/models/user.dart';

class SkillInfoScreen extends StatefulWidget {
  AppUser currentUser;
  Function enableBlackScreen;
  Function showClassPickerVisibility;
  Function showChooseSchoolForClass;
  Function setSchoolChossingClass;
  SkillInfoScreen(
      this.currentUser, this.enableBlackScreen, this.showClassPickerVisibility, this.showChooseSchoolForClass, this.setSchoolChossingClass);
  @override
  State<SkillInfoScreen> createState() => _SkillInfoScreenState();
}

class _SkillInfoScreenState extends State<SkillInfoScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: height * 0.015,
          ),
          Container(
            height: height * 0.06,
            margin: EdgeInsets.only(left: width * 0.05 + 10),
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Text(
                "Classes",
                style: GoogleFonts.fredoka(
                    color: orange, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Container(
            height: height * 0.65,
            width: width * 0.9,
            margin: EdgeInsets.symmetric(
                horizontal: width * 0.05, vertical: height * 0.004),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: ListView(
              padding: EdgeInsets.all(0),
              children: [
                ...widget.currentUser.classes.map((e) {
                  return Stack(
                    children: [
                      Container(
                          width: width * 0.9,
                          height: height * 0.159,
                          margin: EdgeInsets.only(bottom: height * 0.01),
                          padding:
                              EdgeInsets.symmetric(horizontal: height * 0.008),
                          decoration: BoxDecoration(
                              color: e.classInfo!.getColor(),
                              border: Border.all(
                                  color: e.classInfo!.getDColor(), width: width * 0.01),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: height * 0.008,
                              ),
                              Container(
                                width: width * 0.9 - height * 0.025,
                                height: height * 0.06,
                                child: Row(
                                  children: [
                                    Container(
                                      height: height * 0.06,
                                      width: height * 0.06,
                                      decoration: BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.grey.shade300,
                                            width: width * 0.008),
                                      ),
                                      padding: EdgeInsets.all(width * 0.02),
                                      child: ImageIcon(
                                        AssetImage(e.classInfo!.getImageAddy()),
                                        color: e.classInfo!.getColor(),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.025,
                                    ),
                                    Container(
                                      width: width * 0.55,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              e.classInfo!.className,
                                              style: GoogleFonts.fredoka(
                                                  color: backgroundColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: e
                                                              .classInfo!
                                                              .className
                                                              .length <=
                                                          23
                                                      ? MediaQuery.of(context)
                                                              .textScaleFactor *
                                                          28
                                                      : MediaQuery.of(context)
                                                              .textScaleFactor *
                                                          22,
                                                  height: 1),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: SizedBox(),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          widget.currentUser.removeClass(e);
                                        });
                                      },
                                      child: Container(
                                        height: height * 0.035,
                                        child: FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: Icon(
                                            Icons.delete,
                                            color: backgroundColor,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height * 0.007,
                              ),
                              Container(
                                height: height * 0.017,
                                margin: EdgeInsets.only(
                                    top: height * 0.005,
                                    left: height * 0.009 / 2),
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Text(
                                    "class taken at :",
                                    style: GoogleFonts.fredoka(
                                        color: backgroundColor,
                                        fontWeight: FontWeight.w600,
                                        height: 1),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: width * 0.002,
                                  ),
                                  Container(
                                    height: height * 0.0325, 
                                    width: height * 0.0325,
                                    decoration: BoxDecoration(
                                        color: e.classTakenAt == null ? backgroundColor : Colors.white,
                                        border: Border.all(
                                            color: Colors.grey.shade300,
                                            width: width * 0.005),
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(5))),
                                    padding: EdgeInsets.all(
                                      width * 0.005
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5)
                                      ),
                                      child: e.classTakenAt == null ? ImageIcon(
                                        AssetImage(
                                          "assets/images/classImage/school.png"
                                        ),
                                        color: e.classInfo!.getColor(),
                                      ) : Image.network(
                                        e.classTakenAt!.image
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * 0.01,
                              )
                            ],
                          )),Positioned(
                          bottom: height * 0.02,
                          right: width * 0.105,
                          child: InkWell(
                            onTap: (){
                          widget.showChooseSchoolForClass();
                          widget.enableBlackScreen();
                          widget.setSchoolChossingClass(e);
                        },
                            child: Container(
                              height: height * 0.036,
                              width: width * 0.68,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          e.classTakenAt == null ? "Click to choose school" : e.classTakenAt!.name,
                                          maxLines: 1, 
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.fredoka(
                                            color: backgroundColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: MediaQuery.of(context)
                                                    .textScaleFactor *
                                                17,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }).toList(),
                InkWell(
                  onTap: () {
                    widget.enableBlackScreen();
                    widget.showClassPickerVisibility();
                  },
                  child: Container(
                    width: width * 0.9,
                    height: height * 0.09,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        border: Border.all(
                            color: Colors.grey.shade500, width: width * 0.015),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: height * 0.03,
                          child: Image.asset(
                            "assets/images/add_school.png",
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.025,
                        ),
                        Container(
                          height: height * 0.05,
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text(
                              "Add Class",
                              style: GoogleFonts.fredoka(
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w600),
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
