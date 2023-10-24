import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/home/postDetailScreen.dart';
import 'package:highschoolhub/main.dart';
import 'package:highschoolhub/models/publicPost.dart';
import 'package:highschoolhub/pages/profileScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../globalInfo.dart';
import '../AuthenticationPage.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({super.key});

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  @override
  List<PublicPost> allPublicPost = [];
  void initStateFunction() {
    print("here");
    supaBase
        .from('Posts')
        .stream(primaryKey: ['id']).listen((List<Map<String, dynamic>> data) {
      allPublicPost = [];
      for (Map dataPoints in data) {
        PublicPost temp = PublicPost();
        temp.fromJson(dataPoints);
        allPublicPost.add(temp);
      }
      print(allPublicPost);
      setState(() {});
    });
  }

  void initState() {
    initStateFunction();
    super.initState();
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextEditingController poastNameTec = TextEditingController();

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
                    SizedBox(width: width * 0.035),
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
              SizedBox(height: height * 0.005),
              Container(
                height: height * 0.064,
                width: width * 0.94,
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
                        child: Icon(
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
              SizedBox(height: height * 0.007),
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
                          border:
                              Border.all(color: darkblue, width: width * 0.01)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(),
                          ),
                          Container(
                            margin:
                                EdgeInsets.symmetric(vertical: height * 0.005),
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
                                    color: backgroundColor,
                                    fontWeight: FontWeight.w600),
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
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Expanded(
                child: Container(
                    width: width * 0.94,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Container(
                          width: width * 0.94,
                          height: height * 0.09,
                          decoration: BoxDecoration(
                              color: blue,
                              border: Border.all(
                                  color: darkblue, width: width * 0.0175),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: height * 0.0425,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: ImageIcon(
                                    AssetImage("assets/images/createPost.png"),
                                    color: backgroundColor,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              Container(
                                height: height * 0.053,
                                child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      "Create Post",
                                      style: GoogleFonts.fredoka(
                                          color: backgroundColor,
                                          fontWeight: FontWeight.w700),
                                    )),
                              )
                            ],
                          ),
                        ),
                        ...allPublicPost.map((e) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (c) {
                                return PostDetailScreen(e);
                              }));
                            },
                            child: Container(
                              width: width * 0.94,
                              padding: EdgeInsets.all(width * 0.008),
                              margin: EdgeInsets.only(top: height * 0.005),
                              decoration: BoxDecoration(
                                  color: blue,
                                  border: Border.all(
                                      width: width * 0.015, color: darkblue),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: width * 0.01,
                                      ),
                                      InkWell(
                                        onTap: () => Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (builder) {
                                          return MyProfileScreen(currentUser);
                                        })),
                                        child: Container(
                                            height: height * 0.04,
                                            width: height * 0.04,
                                            decoration: BoxDecoration(
                                                color: blue,
                                                border: Border.all(
                                                    color: darkblue,
                                                    width: width * 0.008),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                                child: Image.network(
                                                  e.author!.image,
                                                  fit: BoxFit.cover,
                                                ))),
                                      ),
                                      SizedBox(
                                        width: width * 0.01,
                                      ),
                                      Container(
                                        height: height * 0.045,
                                        width: width * 0.5,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              top: 0,
                                              child: InkWell(
                                                onTap: () =>
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (builder) {
                                                  return MyProfileScreen(
                                                      currentUser);
                                                })),
                                                child: Container(
                                                  height: height * 0.032,
                                                  child: FittedBox(
                                                    fit: BoxFit.fitHeight,
                                                    child: Text(
                                                      e.author!.firstName +
                                                          " " +
                                                          e.author!.lastName,
                                                      style: GoogleFonts.fredoka(
                                                          color:
                                                              backgroundColor,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              left: width * 0.003,
                                              child: Container(
                                                height: height * 0.02,
                                                child: FittedBox(
                                                  fit: BoxFit.fitHeight,
                                                  child: Text(
                                                    "Posted on ${DateFormat('MM/dd/yyyy').format(e.DatePosted)}",
                                                    style: GoogleFonts.fredoka(
                                                        color: backgroundColor,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(),
                                      ),
                                      currentUser.userEmailInMyConnectionList(
                                              e.author!.email)
                                          ? Container()
                                          : Container(
                                              height: height * 0.025,
                                              child: FittedBox(
                                                fit: BoxFit.fitHeight,
                                                child: ImageIcon(
                                                    AssetImage(
                                                        "assets/images/link.png"),
                                                    color: backgroundColor),
                                              ),
                                            ),
                                      SizedBox(
                                        width: width * 0.045,
                                      )
                                    ],
                                  ),
                                  SizedBox(height: height * 0.005),
                                  Container(
                                    width: width * 0.87,
                                    child: Text(e.postTitle,
                                        maxLines: 2,
                                        overflow: TextOverflow.fade,
                                        style: GoogleFonts.fredoka(
                                            height: 1.15,
                                            color: backgroundColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 24)),
                                  ),
                                  SizedBox(
                                    height: height * 0.001,
                                  ),
                                  Container(
                                    width: width * 0.87,
                                    child: Text(
                                      e.postDescription,
                                      style: TextStyle(
                                          color: backgroundColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.2,
                                          height: 1.35),
                                    ),
                                  ),
                                  e.imageAddress == ""
                                      ? Container()
                                      : Container(
                                          height: height * 0.25,
                                          width: width,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: width * 0.008, 
                                              vertical: height * 0.004),
                                          decoration: BoxDecoration(
                                              color: blue,
                                              border: Border.all(
                                                  color: darkblue,
                                                  width: width * 0.0125),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            child: Image.network(e.imageAddress,
                                                fit: BoxFit.cover),
                                          )),
                                  SizedBox(height: height * 0.005),
                                  SizedBox(
                                    width: width * 0.01,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        
                                        left: width * 0.005,
                                        right: width * 0.005,
                                        bottom: width * 0.005),
                                    padding: EdgeInsets.all(width * 0.015),
                                    decoration: BoxDecoration(
                                        color: darkblue.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: width * 0.025,
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            if (e.likes
                                                .contains(currentUser.email)) {
                                              e.likes.remove(currentUser.email);
                                            } else {
                                              e.likes.add(currentUser.email);
                                            }
                                            await supaBase
                                                .from("Posts")
                                                .update(e.toJson())
                                                .eq('id', e.id);
                                            setState(() {});
                                          },
                                          child: SizedBox(
                                            child: Row(children: [
                                              Container(
                                                  height: height * 0.02,
                                                  child: FittedBox(
                                                    fit: BoxFit.fitHeight,
                                                    child: ImageIcon(
                                                      AssetImage(
                                                          "assets/images/like.png"),
                                                      color: e.likes.contains(
                                                              currentUser.email)
                                                          ? Colors.yellow
                                                          : backgroundColor,
                                                    ),
                                                  )),
                                              Container(
                                                height: height * 0.03,
                                                margin: EdgeInsets.only(
                                                    left: width * 0.01),
                                                child: FittedBox(
                                                  fit: BoxFit.fitHeight,
                                                  child: Text(
                                                    "Like",
                                                    style: GoogleFonts.fredoka(
                                                      color: e.likes.contains(
                                                              currentUser.email)
                                                          ? Colors.yellow
                                                          : backgroundColor,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                          ),
                                        ),
                                        const Expanded(child: SizedBox()),
                                        InkWell(
                                          onTap: () async {
                                            if (e.celebrate
                                                .contains(currentUser.email)) {
                                              e.celebrate
                                                  .remove(currentUser.email);
                                            } else {
                                              e.celebrate
                                                  .add(currentUser.email);
                                            }
                                            await supaBase
                                                .from("Posts")
                                                .update(e.toJson())
                                                .eq('id', e.id);
                                            setState(() {});
                                          },
                                          child: SizedBox(
                                            child: Row(
                                              children: [
                                                Container(
                                                    height: height * 0.022,
                                                    child: FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: ImageIcon(
                                                          AssetImage(
                                                              "assets/images/cellebrate.png"),
                                                          color: e.celebrate
                                                                  .contains(
                                                                      currentUser
                                                                          .email)
                                                              ? Colors.yellow
                                                              : backgroundColor),
                                                    )),
                                                Container(
                                                  height: height * 0.03,
                                                  margin: EdgeInsets.only(
                                                      left: width * 0.01),
                                                  child: FittedBox(
                                                    fit: BoxFit.fitHeight,
                                                    child: Text(
                                                      "Celebrate",
                                                      style:
                                                          GoogleFonts.fredoka(
                                                        color: e.celebrate
                                                                .contains(
                                                                    currentUser
                                                                        .email)
                                                            ? Colors.yellow
                                                            : backgroundColor,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Expanded(child: SizedBox()),
                                        SizedBox(
                                          child: Row(children: [
                                            Container(
                                                height: height * 0.022,
                                                margin: EdgeInsets.only(
                                                    top: height * 0.005),
                                                child: FittedBox(
                                                  fit: BoxFit.fitHeight,
                                                  child: ImageIcon(
                                                    AssetImage(
                                                        "assets/images/chat.png"),
                                                    color: backgroundColor,
                                                  ),
                                                )),
                                            Container(
                                              height: height * 0.03,
                                              margin: EdgeInsets.only(
                                                  left: width * 0.01),
                                              child: FittedBox(
                                                fit: BoxFit.fitHeight,
                                                child: Text(
                                                  "Comments",
                                                  style: GoogleFonts.fredoka(
                                                    color: backgroundColor,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ]),
                                        ),
                                        SizedBox(
                                          width: width * 0.025,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList()
                      ],
                    )),
              ),
              SizedBox(
                height: height * 0.005,
              ),
            ],
          ),
        ));
  }
}
