import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../globalInfo.dart';
import '../AuthenticationPage.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({super.key});

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextEditingController poastNameTec = TextEditingController();
    
    void initState(){
      super.initState();
    }
    return SafeArea(
        top: true,
        bottom: false,
        child: Container(
          width: width,
          child: Column(
            children: [
              Container(
                height: height * 0.06,
                width: width,
                child: Row(
                  children: [
                    SizedBox(
                      width: width * 0.035
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
                              color: blue,
                            ),
                          ),
                        ),
                      );
                    }),
                    Expanded(child: SizedBox()),
                    Container(
                      height: height * 0.053,
                      width: height * 0.053,
                      decoration: BoxDecoration(
                        color: blue,
                        border: Border.all(
                          color: blue,
                          width: width * 0.01,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: Image.network(
                          currentUser.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.035,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height : height * 0.005
              ),
              Container(
                height: height * 0.064,
                width: width * 0.94 ,
                padding:
                    EdgeInsets.only(left: width * 0.015, right: width * 0.015),
                decoration: BoxDecoration(
                    color: backgroundColor,
                    border: Border.all(color: blue, width: width * 0.0125),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  children: [
                    Container(
                      height: height * 0.04,
                      child: FittedBox(
                        fit: BoxFit.fitHeight, 
                        child : Icon(
                          Icons.search_rounded, 
                          color: blue,
                        ),
                      ),
                    ),
                    Container(
                      height: height * 0.062,
                      width: width * 0.78,
                      child: TextField(
                        controller: poastNameTec,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: width * 0.0,
                              right: 0,
                              top: 0,
                              bottom: height * 0.005),
                          hintText: " Search Posts",
                          hintStyle: GoogleFonts.fredoka(
                              color: blue,
                              fontWeight: FontWeight.w600,
                              fontSize: 28),
                        ),
                        cursorHeight: height * 0.036,
                        cursorWidth: width * 0.01,
                        cursorColor: darkblue,
                        maxLines: 1,
                        style: GoogleFonts.fredoka(
                            color: blue,
                            fontWeight: FontWeight.w600,
                            fontSize: 28),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height : height * 0.007),
              Container(
                height: height * 0.037, 
                width: width * 0.94, 
                child: ListView(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      height: height * 0.013,
                      width: width * 0.25,
                      decoration: BoxDecoration(
                        color: blue, 
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: darkblue, 
                          width: width * 0.01
                        )
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: SizedBox(),),
                          Container(
                            margin: EdgeInsets.symmetric(
                              vertical: height * 0.005
                            ),
                            child: FittedBox(
                              fit: BoxFit.fitHeight, 
                              child: ImageIcon(
                                AssetImage("assets/images/add_school.png"), 
                                color: backgroundColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.015,
                          ),
                          Container(
                            height: height * 0.09, 
                            child: FittedBox(
                              fit: BoxFit.fitHeight, 
                              child: Text(
                                "Filters", 
                                style: GoogleFonts.fredoka(
                                  color : backgroundColor, 
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                            ),
                          ), 
                          Expanded(
                            child: SizedBox(),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
