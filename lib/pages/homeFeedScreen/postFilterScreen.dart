import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/models/club.dart';
import 'package:highschoolhub/models/filter.dart';
import 'package:highschoolhub/pages/homeFeedScreen/createPostScreen.dart';

class PostFilterScreen extends StatefulWidget {
  PostFilter globalFilter;
  PostFilterScreen(this.globalFilter);
  @override
  State<PostFilterScreen> createState() => _PostFilterScreenState();
}

class _PostFilterScreenState extends State<PostFilterScreen> {
  @override
  PostFilter filter = PostFilter();
  void initState(){
    filter = widget.globalFilter;
    super.initState();
  }
  void pickDateTo() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2050))
        .then((value) {
      filter.toDate = value;
      setState(() {});
    });
  }

  void pickDateFrom() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2050))
        .then((value) {
      filter.fromDate = value;
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    Color darkGrey = const Color.fromARGB(255, 186, 185, 185);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
          height: height,
          width: width,
          color: blue,
          child: Stack(children: [
            Opacity(
              opacity: 0.15,
              child: Container(
                height: height,
                width: width,
                child: Image.asset(
                  "assets/images/backdrop.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
                width: width,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: width * 0.04,
                      ),
                      Container(
                          width: width * 0.96,
                          height: height - width * 0.06,
                          decoration: BoxDecoration(
                              color: backgroundColor,
                              border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: width * 0.01),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(35))),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: height * 0.025,
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: height * 0.02,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          height: height * 0.065,
                                          width: height * 0.065,
                                          decoration: BoxDecoration(
                                              color: red,
                                              border: Border.all(
                                                  color: darkRed,
                                                  width: width * 0.015),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10))),
                                          padding: EdgeInsets.all(width * 0.02),
                                          child: FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: ImageIcon(
                                              const AssetImage(
                                                  "assets/images/back.png"),
                                              color: backgroundColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(),
                                      ),
                                      Container(
                                        height: height * 0.07,
                                        child: FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: Text(
                                            "Filters",
                                            style: GoogleFonts.fredoka(
                                                color: blue,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(),
                                      ),
                                      Container(
                                        height: height * 0.07,
                                        width: height * 0.07,
                                      ),
                                      Container(
                                        width: height * 0.0,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: width * 0.015),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: height * 0.038,
                                                margin: EdgeInsets.only(
                                                    left: width * 0.035,
                                                    top: width * 0.02),
                                                child: FittedBox(
                                                  fit: BoxFit.fitHeight,
                                                  child: Text(
                                                    "Grade Limit : ",
                                                    style: GoogleFonts.fredoka(
                                                      color: blue,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(child: Container()),
                                              Container(
                                                height: height * 0.038,
                                                margin: EdgeInsets.only(
                                                    right: width * 0.035,
                                                    top: width * 0.02),
                                                child: FittedBox(
                                                  fit: BoxFit.fitHeight,
                                                  child: Text(
                                                    (filter.grades!.lowerBound -
                                                                filter.grades!
                                                                    .upperBound ==
                                                            -11)
                                                        ? "All Grades"
                                                        : "${filter.grades!.lowerBound} - ${filter.grades!.upperBound}${filter.grades!.upperBound == 1 ? "st" : filter.grades!.upperBound == 2 ? "nd" : filter.grades!.upperBound == 3 ? "rd" : "th"} grade",
                                                    style: GoogleFonts.fredoka(
                                                      color: blue,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Stack(
                                            children: [
                                              Container(
                                                height: height * 0.05,
                                              ),
                                              Positioned(
                                                left: width * 0.0325,
                                                bottom: 0.05,
                                                child: Container(
                                                  width: width * 0.78,
                                                  child: SliderTheme(
                                                    data: SliderThemeData(
                                                        trackHeight:
                                                            height * 0.01,
                                                        activeTickMarkColor:
                                                            Colors.transparent,
                                                        inactiveTickMarkColor:
                                                            Colors.transparent,
                                                        rangeTickMarkShape:
                                                            RoundRangeSliderTickMarkShape(
                                                                tickMarkRadius:
                                                                    0)),
                                                    child: RangeSlider(
                                                      values: RangeValues(
                                                          filter.grades!
                                                              .lowerBound
                                                              .toDouble(),
                                                          filter.grades!
                                                              .upperBound
                                                              .toDouble()),
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          filter.grades = Range(
                                                              newValue.start
                                                                  .toInt(),
                                                              newValue.end
                                                                  .toInt());
                                                        });
                                                      },
                                                      divisions: 11,
                                                      min: 1,
                                                      max: 12,
                                                      activeColor: blue,
                                                      inactiveColor:
                                                          backgroundColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                  bottom: height * 0.008,
                                                  left: width * 0.026,
                                                  child: Container(
                                                    height: height * 0.038,
                                                    child: FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: Text(
                                                        "1",
                                                        style:
                                                            GoogleFonts.fredoka(
                                                                color: blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                      ),
                                                    ),
                                                  )),
                                              Positioned(
                                                  bottom: height * 0.008,
                                                  right: width * 0.012,
                                                  child: Container(
                                                    height: height * 0.038,
                                                    child: FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: Text(
                                                        "12",
                                                        style:
                                                            GoogleFonts.fredoka(
                                                                color: blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                      ),
                                                    ),
                                                  ))
                                            ],
                                          ),
                                          SizedBox(
                                            height: height * 0.005,
                                          ),
                                        ])),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: width * 0.015),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.all(width * 0.015),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: width * 0.01,
                                          ),
                                          Container(
                                            height: height * 0.038,
                                            child: FittedBox(
                                              fit: BoxFit.fitHeight,
                                              child: Text(
                                                "Post Type",
                                                style: GoogleFonts.fredoka(
                                                    color: blue,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height * 0.0025,
                                      ),
                                      Container(
                                        width: width * 0.88,
                                        height: height * 0.135,
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          padding: EdgeInsets.zero,
                                          children: [
                                            PostTypeWidget(
                                              isActive: filter.type
                                                  .contains(PostType.Other),
                                              imageAddress: "other",
                                              postName: "Other",
                                              onClickFunction: () {
                                                setState(() {
                                                  if (filter.type
                                                      .contains(PostType.Other))
                                                    filter.type
                                                        .remove(PostType.Other);
                                                  else
                                                    filter.type
                                                        .add(PostType.Other);
                                                });
                                              },
                                            ),
                                            PostTypeWidget(
                                              isActive: filter.type.contains(
                                                  PostType.Tournament),
                                              imageAddress: "tournament",
                                              postName: "Tournament",
                                              onClickFunction: () {
                                                setState(() {
                                                  if (filter.type.contains(
                                                      PostType.Tournament))
                                                    filter.type.remove(
                                                        PostType.Tournament);
                                                  else
                                                    filter.type.add(
                                                        PostType.Tournament);
                                                });
                                              },
                                            ),
                                            PostTypeWidget(
                                              isActive: filter.type.contains(
                                                  PostType.Collaborate),
                                              imageAddress: "collaborate",
                                              postName: "Collaborate",
                                              onClickFunction: () {
                                                setState(() {
                                                  if (filter.type.contains(
                                                      PostType.Collaborate))
                                                    filter.type.remove(
                                                        PostType.Collaborate);
                                                  else
                                                    filter.type.add(
                                                        PostType.Collaborate);
                                                });
                                              },
                                            ),
                                            PostTypeWidget(
                                              isActive: filter.type
                                                  .contains(PostType.Volunteer),
                                              imageAddress: "volunteer",
                                              postName: "Volunteer",
                                              onClickFunction: () {
                                                setState(() {
                                                  if (filter.type.contains(
                                                      PostType.Volunteer))
                                                    filter.type.remove(
                                                        PostType.Volunteer);
                                                  else
                                                    filter.type.add(
                                                        PostType.Volunteer);
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: width * 0.015),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: height * 0.038,
                                                margin: EdgeInsets.only(
                                                    left: width * 0.035,
                                                    top: width * 0.02),
                                                child: FittedBox(
                                                  fit: BoxFit.fitHeight,
                                                  child: Text(
                                                    "Post Field : ",
                                                    style: GoogleFonts.fredoka(
                                                      color: blue,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              
                                            ],
                                          ),
                                          SizedBox(height: height * 0.008),
                                          Container(
                                            height: height * 0.13,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: width * 0.02),
                                            child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              padding: EdgeInsets.zero,
                                              children: [
                                                ...subjectList.map((e) {
                                                  return InkWell(
                                                    onTap: () {
                                                      if (filter
                                                          .topicContains(e))
                                                        filter.removeTopic(e);
                                                      else
                                                        filter.subjects.add(e);
                                                      setState(() {});
                                                    },
                                                    child: AnimatedContainer(
                                                      duration: Duration(
                                                          milliseconds: 50),
                                                      height: height * 0.08,
                                                      width: height * 0.12,
                                                      margin: EdgeInsets.only(
                                                          right: width * 0.01),
                                                      decoration: BoxDecoration(
                                                          color: filter.topicContains(
                                                                  e)
                                                              ? blue
                                                              : backgroundColor,
                                                          border: Border.all(
                                                              color: filter
                                                                      .topicContains(
                                                                          e)
                                                                  ? darkblue
                                                                      .withOpacity(
                                                                          0.5)
                                                                  : darkGrey,
                                                              width: width *
                                                                  0.015),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10))),
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height:
                                                                height * 0.0125,
                                                          ),
                                                          Container(
                                                            height:
                                                                height * 0.06,
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                              child: ImageIcon(
                                                                AssetImage(
                                                                    e.image),
                                                                color: filter
                                                                        .topicContains(
                                                                            e)
                                                                    ? backgroundColor
                                                                    : darkGrey,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                              child:
                                                                  Container()),
                                                          Container(
                                                            width: height * 0.1,
                                                            child: Text(
                                                              e.clubTypeString ==
                                                                      "none"
                                                                  ? e.clubType
                                                                      .toReadableString()
                                                                      .substring(
                                                                          9)
                                                                  : e.clubTypeString
                                                                      .replaceAll(
                                                                          "_",
                                                                          " "),
                                                              maxLines: 2,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts.fredoka(
                                                                  color: filter
                                                                          .topicContains(
                                                                              e)
                                                                      ? backgroundColor
                                                                      : darkGrey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      (e.clubTypeString == "none" ? e.clubType.toReadableString().substring(9) : e.clubTypeString.replaceAll("_", " ")).length >
                                                                              8
                                                                          ? 16
                                                                          : 20,
                                                                  height: 1),
                                                            ),
                                                          ),
                                                          Expanded(
                                                              child:
                                                                  Container()),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }).toList()
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: height * 0.008),
                                        ])),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                AnimatedContainer(
                                    duration: Duration(milliseconds: 150),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: width * 0.015),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: height * 0.038,
                                                margin: EdgeInsets.only(
                                                    left: width * 0.035,
                                                    top: width * 0.02),
                                                child: FittedBox(
                                                  fit: BoxFit.fitHeight,
                                                  child: Text(
                                                    "Date Range : ",
                                                    style: GoogleFonts.fredoka(
                                                      color: blue,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: SizedBox(),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: height * 0.005,
                                                    right: width * 0.015),
                                                child: Switch(
                                                  value: filter.chooseDateRange,
                                                  onChanged: (bool val) {
                                                    setState(() {
                                                      filter.chooseDateRange =
                                                          val;
                                                    });
                                                  },
                                                  activeColor: darkblue,
                                                  activeTrackColor: blue,
                                                  inactiveThumbColor: darkblue,
                                                  inactiveTrackColor:
                                                      backgroundColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: height * 0.008),
                                          AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 300),
                                            child: filter.chooseDateRange
                                                ? Column(
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            height:
                                                                height * 0.038,
                                                            margin:
                                                                EdgeInsets.only(
                                                              left:
                                                                  width * 0.055,
                                                            ),
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                              child: Text(
                                                                "From Date : ",
                                                                style:
                                                                    GoogleFonts
                                                                        .fredoka(
                                                                  color: blue,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                              child:
                                                                  Container()),
                                                          filter.fromDate !=
                                                                  null
                                                              ? InkWell(
                                                                  onTap: () {
                                                                    pickDateFrom();
                                                                  },
                                                                  child: Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal: width *
                                                                              0.015),
                                                                      height: height *
                                                                          0.038,
                                                                      child: FittedBox(
                                                                          fit: BoxFit
                                                                              .fitHeight,
                                                                          child: Text(
                                                                              DateFormat('MM-dd-yyyy').format(filter.fromDate!),
                                                                              style: GoogleFonts.fredoka(color: blue, fontWeight: FontWeight.w700)))))
                                                              : InkWell(
                                                                  onTap: () {
                                                                    pickDateFrom();
                                                                  },
                                                                  child: Container(
                                                                      padding: EdgeInsets.symmetric(horizontal: width * 0.015),
                                                                      height: height * 0.038,
                                                                      decoration: BoxDecoration(color: blue, border: Border.all(color: darkblue, width: width * 0.01), borderRadius: BorderRadius.circular(5)),
                                                                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                        Container(
                                                                            height:
                                                                                height * 0.018,
                                                                            child: FittedBox(
                                                                                fit: BoxFit.fitHeight,
                                                                                child: ImageIcon(
                                                                                    AssetImage(
                                                                                      "assets/images/calendar.png",
                                                                                    ),
                                                                                    color: backgroundColor))),
                                                                        SizedBox(
                                                                            width:
                                                                                width * 0.01),
                                                                        Container(
                                                                            height: height *
                                                                                0.029,
                                                                            child:
                                                                                FittedBox(fit: BoxFit.fitHeight, child: Text("Pick Date", style: GoogleFonts.fredoka(color: backgroundColor, fontWeight: FontWeight.w700)))),
                                                                      ])),
                                                                ),
                                                          SizedBox(
                                                              width:
                                                                  width * 0.015)
                                                        ],
                                                      ),
                                                      SizedBox(
                                                          height:
                                                              height * 0.008),
                                                    ],
                                                  )
                                                : Container(),
                                          ),
                                          SizedBox(
                                            height: height * 0.005,
                                          ),
                                          AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 300),
                                            child: filter.chooseDateRange
                                                ? Column(
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            height:
                                                                height * 0.038,
                                                            margin:
                                                                EdgeInsets.only(
                                                              left:
                                                                  width * 0.055,
                                                            ),
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                              child: Text(
                                                                "To Date : ",
                                                                style:
                                                                    GoogleFonts
                                                                        .fredoka(
                                                                  color: blue,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                              child:
                                                                  Container()),
                                                          filter.toDate != null
                                                              ? InkWell(
                                                                  onTap: () {
                                                                    pickDateTo();
                                                                  },
                                                                  child: Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal: width *
                                                                              0.015),
                                                                      height: height *
                                                                          0.038,
                                                                      child: FittedBox(
                                                                          fit: BoxFit
                                                                              .fitHeight,
                                                                          child: Text(
                                                                              DateFormat('MM-dd-yyyy').format(filter.toDate!),
                                                                              style: GoogleFonts.fredoka(color: blue, fontWeight: FontWeight.w700)))))
                                                              : InkWell(
                                                                  onTap: () {
                                                                    pickDateTo();
                                                                  },
                                                                  child: Container(
                                                                      padding: EdgeInsets.symmetric(horizontal: width * 0.015),
                                                                      height: height * 0.038,
                                                                      decoration: BoxDecoration(color: blue, border: Border.all(color: darkblue, width: width * 0.01), borderRadius: BorderRadius.circular(5)),
                                                                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                        Container(
                                                                            height:
                                                                                height * 0.018,
                                                                            child: FittedBox(
                                                                                fit: BoxFit.fitHeight,
                                                                                child: ImageIcon(
                                                                                    AssetImage(
                                                                                      "assets/images/calendar.png",
                                                                                    ),
                                                                                    color: backgroundColor))),
                                                                        SizedBox(
                                                                            width:
                                                                                width * 0.01),
                                                                        Container(
                                                                            height: height *
                                                                                0.029,
                                                                            child:
                                                                                FittedBox(fit: BoxFit.fitHeight, child: Text("Pick Date", style: GoogleFonts.fredoka(color: backgroundColor, fontWeight: FontWeight.w700)))),
                                                                      ])),
                                                                ),
                                                          SizedBox(
                                                              width:
                                                                  width * 0.015)
                                                        ],
                                                      ),
                                                      SizedBox(
                                                          height:
                                                              height * 0.008),
                                                    ],
                                                  )
                                                : Container(),
                                          ),
                                        ])),
                                SizedBox(
                                  height : height * 0.01
                                ),
                                Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: width * 0.015),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: height * 0.038,
                                                margin: EdgeInsets.only(
                                                    left: width * 0.035,
                                                    top: width * 0.02),
                                                child: FittedBox(
                                                  fit: BoxFit.fitHeight,
                                                  child: Text(
                                                    "Meeting Type :",
                                                    style: GoogleFonts.fredoka(
                                                      color: blue,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(child: SizedBox())
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: width * 0.025,
                                                vertical: height * 0.002),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap: (){
                                                    setState(() {
                                                      filter.location = 0;
                                                    });
                                                  },
                                                  child: PostLocationWidget(
                                                    filter.location == 0, 
                                                    "virtual",
                                                    "Virtual"
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: (){
                                                    setState(() {
                                                      filter.location = 1;
                                                    });
                                                  },
                                                  child : PostLocationWidget(
                                                    filter.location == 1,
                                                    "both",
                                                    "Both",
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: (){
                                                    setState(() {
                                                      filter.location = 2;
                                                    });
                                                  },
                                                  child: PostLocationWidget(
                                                    filter.location == 2,
                                                    "inperson",
                                                    "Live",
                                                  ),
                                                ),
                                                
                                                
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: width * 0.025,
                                          ),
                                        ])),
                              ])),
                    ]))
          ])),
    );
  }
}

class PostLocationWidget extends StatefulWidget {
  bool selected;
  String imageName;
  String name;
  PostLocationWidget(this.selected, this.imageName, this.name);

  @override
  State<PostLocationWidget> createState() => PostLocationWidgetState();
}

class PostLocationWidgetState extends State<PostLocationWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return AnimatedContainer(
      duration: Duration(microseconds: 150),
      height: height * 0.1,
      width: width * 0.25,
      decoration: BoxDecoration(
          color: widget.selected ? blue : Colors.grey.shade200,
          border: Border.all(
              color: widget.selected == false
                  ? Color.fromARGB(255, 186, 185, 185)
                  : darkblue,
              width: width * 0.0125),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: height * 0.005,
          ),
          Container(
            height: height * 0.05,
            padding: EdgeInsets.only(top: height * 0.005),
            child: FittedBox(
                child: ImageIcon(
              AssetImage("assets/images/${widget.imageName}.png"),
              color: widget.selected
                  ? Colors.grey.shade200
                  : Color.fromARGB(255, 186, 185, 185),
            )),
          ),
          SizedBox(
            height: height * 0.001,
          ),
          SizedBox(
            height: height * 0.03,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Text(
                widget.name,
                style: GoogleFonts.fredoka(
                  color: widget.selected
                      ? Colors.grey.shade200
                      : Color.fromARGB(255, 186, 185, 185),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
