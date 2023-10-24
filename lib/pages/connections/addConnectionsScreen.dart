import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/main.dart';
import 'package:highschoolhub/models/filter.dart';
import 'package:highschoolhub/models/user.dart';
import 'package:highschoolhub/pages/AuthenticationPage.dart';
import 'package:highschoolhub/pages/connections/filtersScreen.dart';
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
  List<AppUser> displayList = [];
  TextEditingController searchCommunityTec = TextEditingController();

  void initStateFunciton() async {
    var data = await supaBase.from("user_auth_table").select();
    print(data);
    for (Map d in data) {
      AppUser temp = AppUser();
      if (d["email"] != currentUser.email) {
        temp.fromJson(d);
        appUsers.add(temp);
      }
      searchList = appUsers;
      displayList = appUsers;
    }
    setState(() {});
  }

  List<AppUser> sortListByQuery(List<AppUser> corpus, String query) {
    print(corpus.length);
    List<AppUser> finalStringList = [];
    for (var value in corpus) {
      value.getCorpusRatingFromQuery(query);
    }
    corpus.sort((a, b) {
      if (a.gScore.compareTo(b.gScore) != 0)
        return a.gScore.compareTo(b.gScore);
      return (a.firstName).compareTo(b.firstName);
    });
    int i = 0;
    print("g scores");
    for (var value in corpus.reversed) {
      print(value.gScore);
      if (value.gScore != 0 || query.length <= 2) {
        print("this got added");
        finalStringList.add(value);
      } else {
        print("this did not get added");
      }
      i++;
    }
    print("final string list");
    print(finalStringList);
    return finalStringList;
  }

  void initState() {
    initStateFunciton();

    setState(() {});
    searchCommunityTec.addListener(() {
      setState(() {
        displayList = sortListByQuery(searchList, searchCommunityTec.text);
        print("search list");
        print(displayList);
      });
    });
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
                                      controller: searchCommunityTec,
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
                        height: height * 0.007,
                      ),
                      InkWell(
                        onTap: () async {
                          var delay = await Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return FilterScreen();
                          }));
                          setState(() {
                            searchList = [];
                            for (AppUser user in appUsers) {
                              print("=" * 20);
                              print(user.firstName);
                              print(currentUser.searchFilterSearchCommunity
                                  .userPassesFilter(user));
                              if (currentUser.searchFilterSearchCommunity
                                  .userPassesFilter(user)) {
                                searchList.add(user);
                              }
                            }
                          });
                          displayList = sortListByQuery(searchList, searchCommunityTec.text);
                        },
                        child: Container(
                          height: height * 0.04,
                          width: width * 0.93,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            children: [
                              Container(
                                height: height * 0.038,
                                width: width * 0.25,
                                margin: EdgeInsets.only(
                                    top: height * 0.001,
                                    bottom: height * 0.001,
                                    right: width * 0.02),
                                decoration: BoxDecoration(
                                    color: mainColor,
                                    border: Border.all(
                                      color: darkGreen,
                                      width: width * 0.01,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ImageIcon(
                                      AssetImage(
                                        "assets/images/add_school.png",
                                      ),
                                      color: backgroundColor,
                                      size: 13.5,
                                    ),
                                    SizedBox(
                                      width: width * 0.015,
                                    ),
                                    Text(
                                      "Filters",
                                      style: GoogleFonts.fredoka(
                                          color: backgroundColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: MediaQuery.of(context)
                                                  .textScaleFactor *
                                              19,
                                          letterSpacing: width * 0.01 / 4.5),
                                    )
                                  ],
                                ),
                              ),
                              currentUser.searchFilterSearchCommunity.classes
                                      .isNotEmpty
                                  ? Container(
                                      height: height * 0.038,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.015),
                                      margin: EdgeInsets.only(
                                          top: height * 0.001,
                                          bottom: height * 0.001,
                                          right: width * 0.02),
                                      decoration: BoxDecoration(
                                          color: mainColor,
                                          border: Border.all(
                                            color: darkGreen,
                                            width: width * 0.01,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8))),
                                      child: Center(
                                        child: Text(
                                          currentUser.searchFilterSearchCommunity
                                                      .classes.length ==
                                                  1
                                              ? "${currentUser.searchFilterSearchCommunity.classes.length} Class"
                                              : "${currentUser.searchFilterSearchCommunity.classes.length} Classes",
                                          style: GoogleFonts.fredoka(
                                              color: backgroundColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: MediaQuery.of(context)
                                                      .textScaleFactor *
                                                  19,
                                              letterSpacing:
                                                  width * 0.01 / 4.5),
                                        ),
                                      ))
                                  : Container(),
                              currentUser.searchFilterSearchCommunity.skills
                                      .isNotEmpty
                                  ? Container(
                                      height: height * 0.038,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.015),
                                      margin: EdgeInsets.only(
                                          top: height * 0.001,
                                          bottom: height * 0.001,
                                          right: width * 0.02),
                                      decoration: BoxDecoration(
                                          color: mainColor,
                                          border: Border.all(
                                            color: darkGreen,
                                            width: width * 0.01,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8))),
                                      child: Center(
                                        child: Text(
                                          currentUser.searchFilterSearchCommunity
                                                      .skills.length ==
                                                  1
                                              ? "${currentUser.searchFilterSearchCommunity.skills.length} Skill"
                                              : "${currentUser.searchFilterSearchCommunity.skills.length} Skills",
                                          style: GoogleFonts.fredoka(
                                              color: backgroundColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: MediaQuery.of(context)
                                                      .textScaleFactor *
                                                  19,
                                              letterSpacing:
                                                  width * 0.01 / 4.5),
                                        ),
                                      ))
                                  : Container(),
                              currentUser.searchFilterSearchCommunity.clubs
                                      .isNotEmpty
                                  ? Container(
                                      height: height * 0.038,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.015),
                                      margin: EdgeInsets.only(
                                          top: height * 0.001,
                                          bottom: height * 0.001,
                                          right: width * 0.02),
                                      decoration: BoxDecoration(
                                          color: mainColor,
                                          border: Border.all(
                                            color: darkGreen,
                                            width: width * 0.01,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8))),
                                      child: Center(
                                        child: Text(
                                          currentUser.searchFilterSearchCommunity
                                                      .clubs.length ==
                                                  1
                                              ? "${currentUser.searchFilterSearchCommunity.clubs.length} Club"
                                              : "${currentUser.searchFilterSearchCommunity.clubs.length} Clubs",
                                          style: GoogleFonts.fredoka(
                                              color: backgroundColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: MediaQuery.of(context)
                                                      .textScaleFactor *
                                                  19,
                                              letterSpacing:
                                                  width * 0.01 / 4.5),
                                        ),
                                      ))
                                  : Container(),
                              ...currentUser
                                  .searchFilterSearchCommunity.schools.schools
                                  .map((e) {
                                if (currentUser.searchFilterSearchCommunity
                                        .schools.type !=
                                    filterTypeSchool.certainSchool) {
                                  return Container();
                                }
                                return Container(
                                    height: height * 0.038,
                                    width: height * 0.038,
                                    margin: EdgeInsets.only(
                                        top: height * 0.001,
                                        bottom: height * 0.001,
                                        right: width * 0.02),
                                    decoration: BoxDecoration(
                                        color: mainColor,
                                        border: Border.all(
                                          color: darkGreen,
                                          width: width * 0.009,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.network(e.image),
                                    ));
                              }), 
                              currentUser.searchFilterSearchCommunity.schools.currentState.isNotEmpty && currentUser.searchFilterSearchCommunity.schools.type == filterTypeSchool.State
                                  ? Container(
                                      height: height * 0.038,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.015),
                                      margin: EdgeInsets.only(
                                          top: height * 0.001,
                                          bottom: height * 0.001,
                                          right: width * 0.02),
                                      decoration: BoxDecoration(
                                          color: mainColor,
                                          border: Border.all(
                                            color: darkGreen,
                                            width: width * 0.01,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8))),
                                      child: Center(
                                        child: Text(
                                          currentUser.searchFilterSearchCommunity.schools.currentState.length ==
                                                  1
                                              ? "${currentUser.searchFilterSearchCommunity.schools.currentState.length} State"
                                              : "${currentUser.searchFilterSearchCommunity.schools.currentState.length} States",
                                          style: GoogleFonts.fredoka(
                                              color: backgroundColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: MediaQuery.of(context)
                                                      .textScaleFactor *
                                                  19,
                                              letterSpacing:
                                                  width * 0.01 / 4.5),
                                        ),
                                      ))
                                  : Container(), 
                              currentUser.searchFilterSearchCommunity.schools.zipcode.isNotEmpty && currentUser.searchFilterSearchCommunity.schools.type == filterTypeSchool.ZipCode
                                  ? Container(
                                      height: height * 0.038,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.015),
                                      margin: EdgeInsets.only(
                                          top: height * 0.001,
                                          bottom: height * 0.001,
                                          right: width * 0.02),
                                      decoration: BoxDecoration(
                                          color: mainColor,
                                          border: Border.all(
                                            color: darkGreen,
                                            width: width * 0.01,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8))),
                                      child: Center(
                                        child: Text(
                                          currentUser.searchFilterSearchCommunity.schools.zipcode.length ==
                                                  1
                                              ? "${currentUser.searchFilterSearchCommunity.schools.zipcode.length} Zip Code"
                                              : "${currentUser.searchFilterSearchCommunity.schools.zipcode.length} Zip Codes",
                                          style: GoogleFonts.fredoka(
                                              color: backgroundColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: MediaQuery.of(context)
                                                      .textScaleFactor *
                                                  19,
                                              letterSpacing:
                                                  width * 0.01 / 4.5),
                                        ),
                                      ))
                                  : Container(), 
                              currentUser.searchFilterSearchCommunity.schools.type == filterTypeSchool.Distance
                                  ? Container(
                                      height: height * 0.038,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.015),
                                      margin: EdgeInsets.only(
                                          top: height * 0.001,
                                          bottom: height * 0.001,
                                          right: width * 0.02),
                                      decoration: BoxDecoration(
                                          color: mainColor,
                                          border: Border.all(
                                            color: darkGreen,
                                            width: width * 0.01,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8))),
                                      child: Center(
                                        child: Text(
                                          "${currentUser.searchFilterSearchCommunity.schools.distance} Miles",
                                          style: GoogleFonts.fredoka(
                                              color: backgroundColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: MediaQuery.of(context)
                                                      .textScaleFactor *
                                                  19,
                                              letterSpacing:
                                                  width * 0.01 / 4.5),
                                        ),
                                      ))
                                  : Container(), 
                            ],
                          ),
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
                            children: displayList.map((e) {
                              print(e.image);
                              return InkWell(
                                onTap: () async {
                                  AppUser tempuser = AppUser();
                                  await tempuser.getDataFromDatabase(e.email);
                                  var temp = await Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (c) {
                                    print(
                                        "we getting out of the app dev with this");
                                    print(e.email);

                                    return MyProfileScreen(tempuser);
                                  }));
                                  setState(() {});
                                },
                                child: Container(
                                  width: width * 0.93,
                                  height: height * 0.1,
                                  margin: EdgeInsets.only(
                                    bottom: height * 0.01
                                  ),
                                  decoration: BoxDecoration(
                                      color: mainColor,
                                      border: Border.all(
                                          color: darkGreen,
                                          width: width * 0.015),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Stack(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                  Radius.circular(5)),
                                              child: Image.network(
                                                e.image,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * 0.025,
                                          ),
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: height * 0.008,
                                              ),
                                              Container(
                                                  height: height * 0.048,
                                                  child: FittedBox(
                                                    fit: BoxFit.fitHeight,
                                                    child: Text(
                                                      e.firstName +
                                                          " " +
                                                          e.lastName,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: GoogleFonts.fredoka(
                                                          color:
                                                              backgroundColor,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        bottom: height * 0.01,
                                        left: width * 0.2,
                                        child: Container(
                                          height: height * 0.03,
                                          width: width * 0.55,
                                          child: Text(
                                            currentGradeToString(
                                                    e.currentGrade) +
                                                " at " +
                                                e.getCurrentSchool().name,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.fredoka(
                                                fontSize: 20,
                                                color: backgroundColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: height * 0.016,
                                        right: width * 0.02,
                                        child: currentUser.findEmailInUserList(
                                                    e.email,
                                                    currentUser.requestsSent) ||
                                                currentUser.findEmailInUserList(
                                                    e.email,
                                                    currentUser.network)
                                            ? Container()
                                            : InkWell(
                                                onTap: () async {
                                                  await currentUser
                                                      .addFriendRequest(
                                                          e.email);
                                                  setState(() {});
                                                },
                                                child: Container(
                                                  child: ImageIcon(
                                                    AssetImage(
                                                      "assets/images/add-user.png",
                                                    ),
                                                    color: backgroundColor,
                                                    size: height * 0.03,
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
                    ]))),
          ],
        ),
      ),
    );
  }
}
