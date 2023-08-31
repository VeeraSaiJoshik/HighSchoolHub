import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/main.dart';
import 'package:highschoolhub/models/user.dart';
import 'package:highschoolhub/pages/AuthenticationPage.dart';
import 'package:highschoolhub/pages/profileScreen.dart';

class AddConnectionsScreen extends StatefulWidget {
  const AddConnectionsScreen({super.key});

  @override
  State<AddConnectionsScreen> createState() => _AddConnectionsScreenState();
}

class _AddConnectionsScreenState extends State<AddConnectionsScreen> {
  @override
  List<AppUser> appUsers = [];
  List<AppUser> searchList = [];
  void rankSearchListByQuery(String query){
    searchList = [];

  }
  void initStateFunciton() async {
    var data = await supaBase.from("user_auth_table").select('email');
    print(data);
    for (Map d in data) {
      AppUser temp = AppUser();
      if (d["email"] != currentUser.email) {
        await temp.getDataFromDatabase(d["email"]);
        appUsers.add(temp);
      }
    }
    setState(() {});
  }

  void initState() {
    initStateFunciton();

    super.initState();
  }
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
            Container(
              height: height,
              width: width,
              child: Opacity(
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
            ),
            SafeArea(
                top: true,
                child: Container(
                    height: height,
                    width: width,
                    child: Column(children: [
                      Container(
                        height: height * 0.018,
                      ),
                      Container(
                        width: width,
                        height: height * 0.066,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: height * 0.066,
                              width: width * 0.93,
                              padding: EdgeInsets.only(
                                  left: width * 0.01, right: width * 0.015),
                              decoration: BoxDecoration(
                                  color: backgroundColor,
                                  border: Border.all(
                                      color: mainColor, width: width * 0.013),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Row(
                                children: [
                                  Container(
                                    width: width * 0.01,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      height: height * 0.027,
                                      child: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: ImageIcon(
                                          AssetImage(
                                              "assets/images/backArrow.png"),
                                          color: mainColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: height * 0.04,
                                    width: width * 0.73,
                                    child: TextField(
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.only(
                                            left: width * 0.01,
                                            right: 0,
                                            top: 0,
                                            bottom: height * 0.006),
                                        hintText: " Search Community",
                                        hintStyle: GoogleFonts.fredoka(
                                            color: mainColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 30),
                                      ),
                                      cursorHeight: height * 0.035,
                                      cursorWidth: width * 0.01,
                                      cursorColor: darkGreen,
                                      maxLines: 1,
                                      textAlignVertical:
                                          TextAlignVertical.center,
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
                      Container(
                        height: height * 0.01,
                      ),
                      Expanded(
                        child: Container(
                          width: width * 0.93,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: appUsers.map((e) {
                              print(e.image);
                              return InkWell(
                                onTap: () async {
                                  var temp = await Navigator.of(context).push(MaterialPageRoute(builder: (c){
                                    return MyProfileScreen(e.email, );
                                  }));
                                  setState(() {
                                    
                                  });
                                },
                                child: Container(
                                  width: width * 0.93,
                                  height: height * 0.1,
                                  decoration: BoxDecoration(
                                      color: mainColor,
                                      border: Border.all(
                                          color: darkGreen, width: width * 0.015),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15))),
                                  child: Stack(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: width * 0.02,
                                          ),
                                          Container(
                                            height: height * 0.07,
                                            width: height * 0.07,
                                            margin: EdgeInsets.only(
                                                top: width * 0.02,
                                                bottom: width * 0.02),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: darkGreen,
                                                    width: width * 0.01),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(7)),
                                              child: Image.network(
                                                e.image,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * 0.022,
                                          ),
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: height * 0.0025,
                                              ),
                                              Container(
                                                  height: height * 0.05,
                                                  child: FittedBox(
                                                    fit: BoxFit.fitHeight,
                                                    child: Text(
                                                      e.firstName + " " + e.lastName,
                                                      textAlign: TextAlign.start,
                                                      style: GoogleFonts.fredoka(
                                                          color: backgroundColor,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        bottom: height * 0.008,
                                        left : width * 0.2,
                                        child: Container(
                                              height: height * 0.03,
                                              width: width * 0.55,
                                              child: Text(
                                                currentGradeToString(e.currentGrade) + " at " + e.getCurrentSchool().name,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.start,
                                                style: GoogleFonts.fredoka(
                                                    fontSize: 20,
                                                    color: backgroundColor,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                          ),
                                      ), 
                                      Positioned(
                                        top: height * 0.015,
                                        right : width * 0.02,
                                        child: currentUser.requestsSent.contains(e.email) ? Container() : InkWell(
                                          onTap: () async {
                                            await currentUser.addFriendRequest(e.email);
                                            setState(() {
                                    
                                        });
                                          },
                                          child: Container(
                                                child: ImageIcon(
                                                  AssetImage(
                                                    "assets/images/add-user.png", 
                                                  ),
                                                  color: backgroundColor,
                                                  size: height * 0.035,
                                                ),
                                            ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Container(
                        height: height * 0.01,
                      ),
                    ])))
          ],
        ),
      ),
    );
  }
}
