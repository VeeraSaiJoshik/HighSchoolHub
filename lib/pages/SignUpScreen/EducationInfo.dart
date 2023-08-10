import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/models/user.dart';
import 'package:fl_geocoder/fl_geocoder.dart';


class EducationInfoScreen extends StatefulWidget {
  @override
  Function toggleBlackScreen;
  Function showSearchSchool;
  AppUser currentUser;  
  EducationInfoScreen(this.toggleBlackScreen, this.showSearchSchool, this.currentUser);
  State<EducationInfoScreen> createState() => _EducationInfoScreenState();
}

class _EducationInfoScreenState extends State<EducationInfoScreen> {
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
                "Schools",
                style: GoogleFonts.fredoka(
                    color: puprle, fontWeight: FontWeight.w700),
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
                ...widget.currentUser.schools.map((e){
                  return Container(
                    width: width * 0.9, 
                    height: height * 0.11,
                    margin: EdgeInsets.only(
                      bottom: height * 0.01
                    ),
                    decoration: BoxDecoration(
                      color: puprle, 
                      border: Border.all(
                        color: darkPurple, 
                        width: width * 0.01
                      ), 
                      borderRadius: BorderRadius.all(
                        Radius.circular(15)
                      )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, 
                      children: [
                        SizedBox(
                          width : width * 0.02
                        ),
                        Container(
                          height: height * 0.08,
                          width: height * 0.08, 
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10)
                            ), 
                            border: Border.all(
                              color: backgroundColor, 
                              width: width * 0.01
                            )
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5)
                            ),
                            child: Image.network(
                              e.image, 
                              fit: BoxFit.cover,
                            ),
                          ),
                        ), 
                        SizedBox(
                          width : width * 0.02
                        ),
                        Expanded(
                          child: Container(
                            height: height * 0.088,
                            child: Column(
                              children: [
                               
                                Container(
                                  height: height * 0.045,
                                  width: width * 0.8,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          e.name, 
                                          style: GoogleFonts.fredoka(
                                            color: backgroundColor,
                                            fontWeight: FontWeight.w600, 
                                            fontSize: e.name.length <= 20 ? MediaQuery.of(context).textScaleFactor * 25:MediaQuery.of(context).textScaleFactor * 20, 
                                            height: 1
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Container(
                                  height: height * 0.03,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.zero,
                                    children: [
                                      ...e.grades.map((grade){
                                        return InkWell(
                                          onTap: (){
                                            if(e.attendedGrades.contains(grade)){
                                              e.attendedGrades.remove(grade);
                                            }else{
                                              e.attendedGrades.add(grade);
                                            }
                                            setState(() {
                                            });
                                          },
                                          child: Container(
                                            height: height * 0.028, 
                                            width: height *0.028,
                                            padding: EdgeInsets.all(
                                              width * 0.00
                                            ),
                                            margin: EdgeInsets.only(
                                              right: width * 0.01
                                            ),
                                            decoration: BoxDecoration(
                                              color: (e.attendedGrades.contains(grade))?puprle:backgroundColor, 
                                              border: Border.all(
                                                color: darkPurple, 
                                                width: width * 0.008
                                              ), 
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5)
                                              )
                                            ),
                                            child: Center(
                                              child: FittedBox(
                                                fit: BoxFit.fitHeight,
                                                child: Text(
                                                  grade.toString(), 
                                                  style: GoogleFonts.fredoka(
                                                    color: (e.attendedGrades.contains(grade))?backgroundColor : darkPurple, 
                                                    fontWeight: FontWeight.w600, 
                                                  ),
                                                ),
                                              ) ,
                                            ),
                                          ),
                                        );
                                      }).toList()
                                    ],
                                  ),
                                )
                              ],
                            ),    
                          ),
                        ), 
                        SizedBox(
                          width : width * 0.02
                        ),
                      ],
                    ),
                  );
                }).toList(),
                InkWell(
                  onTap: (){
                    widget.toggleBlackScreen();
                    widget.showSearchSchool();
                  },
                  child: Container(
                    width: width * 0.9,
                    height: height * 0.09,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100 ,
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
                              "Add School",
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
