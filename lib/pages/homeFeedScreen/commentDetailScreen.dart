import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/main.dart';
import 'package:highschoolhub/models/publicPost.dart';
import 'package:highschoolhub/models/reply.dart';
import 'package:highschoolhub/pages/AuthenticationPage.dart';

class CommentDetailScreen extends StatefulWidget {
  commentThread comments;
  PublicPost post;
  CommentDetailScreen(this.comments, this.post);

  @override
  State<CommentDetailScreen> createState() => _CommentDetailScreenState();
}

class _CommentDetailScreenState extends State<CommentDetailScreen> {
  @override
  TextEditingController replyTec = TextEditingController();
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        color: blue,
        child: Stack(
          children: [
            Container(
              height: height,
              width: width,
              child: Opacity(
                opacity: 0.1,
                child: Image.asset(
                  "assets/images/backdrop.png",
                  fit: BoxFit.cover,
                ),
              )
            ),
            SafeArea(
              bottom: false,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: width * 0.95,
                  margin: EdgeInsets.only(
                    left: width * 0.025,
                    bottom: width * 0.025
                  ),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(45),
                      bottomRight: Radius.circular(45)
                    )
                  ),
                  child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(45),
                        bottomRight: Radius.circular(45)
                      ),
                      child: Column(
                        
                        children: [
                          SizedBox(
                            height: height * 0.008,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: height * 0.008,
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
                                          BorderRadius.circular(10)),
                                  padding: EdgeInsets.all(width * 0.015),
                                  child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: ImageIcon(
                                        AssetImage(
                                            "assets/images/back.png"),
                                        color: backgroundColor,
                                      )),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            margin : EdgeInsets.only(
                              left: width * 0.02,
                              right: width * 0.02, 
                            ),
                            child : 
                              Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        right: width * 0.015,
                                        bottom: width * 0.015,
                                        top: width * 0.025,
                                        left: width * 0.025),
                                    margin: EdgeInsets.only(
                                        left: width * 0.02,
                                        top: height * 0.015,),
                                    decoration: BoxDecoration(
                                        color: blue,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Opacity(
                                            opacity: 0.55,
                                            child: Text(
                                                "posted by ${allUsers[widget
                                                            .comments
                                                            .mainComment!
                                                            .email]!
                                                        .firstName} ${allUsers[widget
                                                            .comments
                                                            .mainComment!
                                                            .email]!
                                                        .lastName} at ${DateFormat("MM/dd/yyyy")
                                                        .format(widget
                                                            .comments
                                                            .mainComment!
                                                            .sentTime!)}",
                                                style: GoogleFonts.fredoka(
                                                    color: backgroundColor,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    fontSize: 16)),
                                          ),
                                          Text(
                                              widget.comments.mainComment!
                                                  .content,
                                              maxLines: 4,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.fredoka(
                                                  color: backgroundColor,
                                                  height: 1.1,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 19)),
                                          SizedBox(height: height * 0.005),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: width * 0.00),
                                            padding: EdgeInsets.symmetric(
                                                vertical: width * 0.0125),
                                            decoration: BoxDecoration(
                                                color:
                                                    darkblue.withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Row(children: [
                                              SizedBox(width: width * 0.02),
                                              InkWell(
                                                onTap: () async {
                                                  if (widget.comments.likes
                                                      .contains(currentUser
                                                          .email)) {
                                                    widget.comments.likes
                                                        .remove(currentUser
                                                            .email);
                                                  } else {
                                                    widget.comments.likes.add(
                                                        currentUser.email);
                                                  }
                                                  await supaBase
                                                      .from("Posts")
                                                      .update(widget.post
                                                          .toJson())
                                                      .eq("id",
                                                          widget.post.id);
                                                  setState(() {});
                                                },
                                                child: Container(
                                                    child: Row(children: [
                                                  Container(
                                                      height: height * 0.018,
                                                      child: FittedBox(
                                                          fit: BoxFit
                                                              .fitHeight,
                                                          child: ImageIcon(
                                                              AssetImage(
                                                                  "assets/images/like.png"),
                                                              color: widget
                                                                      .comments
                                                                      .likes
                                                                      .contains(currentUser
                                                                          .email)
                                                                  ? Colors
                                                                      .yellow
                                                                  : backgroundColor))),
                                                  Container(
                                                      height: height * 0.028,
                                                      margin: EdgeInsets.only(
                                                          top: height * 0.001,
                                                          left: width * 0.01),
                                                      child: FittedBox(
                                                          fit: BoxFit
                                                              .fitHeight,
                                                          child: Text(
                                                              "Like (${widget.comments.likes.length})",
                                                              style: GoogleFonts.fredoka(
                                                                  color: widget
                                                                          .comments
                                                                          .likes
                                                                          .contains(currentUser
                                                                              .email)
                                                                      ? Colors
                                                                          .yellow
                                                                      : backgroundColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700)))),
                                                ])),
                                              ),
                                              Container(width: width * 0.2),
                                            ]),
                                          ),
                                          SizedBox(height: height * 0.005),
                                        ]
                                      )
                                    ),
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: Container(
                                      height: height * 0.032,
                                      width: height * 0.032,
                                      decoration: BoxDecoration(
                                          color: blue,
                                          borderRadius:
                                              BorderRadius.circular(3)),
                                      padding:
                                          EdgeInsets.all(width * 0.005),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(2),
                                        child: Image.network(
                                          allUsers[widget.comments
                                                  .mainComment!.email]!
                                              .image,
                                          fit: BoxFit.cover,
                                        )
                                      )
                                    )
                                  ),
                                ]
                              )
                          ), 
                          SizedBox(
                            height: height * 0.015,
                          ),
                          Container(
                            padding : EdgeInsets.all(
                              width * 0.015
                            ), 
                            margin: EdgeInsets.symmetric(
                              horizontal: width * 0.03
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300.withOpacity(0.5), 
                              borderRadius: BorderRadius.circular(5)
                            ),
                            child : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: height * 0.04,
                                  margin : EdgeInsets.only(left : width * 0.015),
                                  child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Text("Replies (${widget.comments.replies.length})",
                                          style: GoogleFonts.fredoka(
                                              color: blue,
                                              fontWeight:
                                                  FontWeight.w700))),
                                ),
                                SizedBox(height: height * 0.005),
                                Container(
                                  height: height * 0.575,
                                  child : Column(
                                    children: [
                                      Container(
                                        height: height * 0.05,
                                        width: width * 0.9,
                                        padding: EdgeInsets.only(
                                            left: width * 0.015,
                                            right: width * 0.015),
                                        decoration: BoxDecoration(
                                            color: backgroundColor,
                                            border: Border.all(
                                                color: blue,
                                                width: width * 0.01),
                                            borderRadius:
                                                BorderRadius.all(
                                                    Radius.circular(
                                                        10))),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: height * 0.054,
                                              width: width * 0.74,
                                              child:
                                                  SingleChildScrollView(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                child: TextField(
                                                  controller:
                                                      replyTec,
                                                  textAlignVertical:
                                                      TextAlignVertical
                                                          .center,
                                                  decoration:
                                                      InputDecoration(
                                                    border:
                                                        InputBorder
                                                            .none,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            left: width *
                                                                0.0,
                                                            right: 0,
                                                            top: 0,
                                                            bottom: height *
                                                                0.025),
                                                    hintText:
                                                        "Enter Reply",
                                                    hintStyle: GoogleFonts.fredoka(
                                                        color: blue,
                                                        fontWeight:
                                                            FontWeight
                                                                .w600,
                                                        fontSize: 25),
                                                  ),
                                                  cursorHeight:
                                                      height * 0.032,
                                                  cursorWidth:
                                                      width * 0.01,
                                                  cursorColor:
                                                      darkblue,
                                                  maxLines: 1,
                                                  style: GoogleFonts
                                                      .fredoka(
                                                          color: blue,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w600,
                                                          fontSize:
                                                              25),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                commentThread tempComment = commentThread(
                                                    likes: [],
                                                    mainComment: comment(
                                                        content:
                                                            replyTec
                                                                .text,
                                                        email:
                                                            currentUser
                                                                .email,
                                                        sentTime:
                                                            DateTime
                                                                .now()));
                                                widget.comments.replies.add(comment(content: replyTec.text, email: currentUser.email, sentTime: DateTime.now()));
                                                await supaBase
                                                    .from("Posts")
                                                    .update(widget
                                                        .post
                                                        .toJson())
                                                    .eq(
                                                        "id",
                                                        widget
                                                            .post.id);
                                                replyTec.text = "";
                                                setState(() {});
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    bottom: height *
                                                        0.005,
                                                    top: height *
                                                        0.005,
                                                    left: width *
                                                        0.012),
                                                child: FittedBox(
                                                  fit: BoxFit
                                                      .fitHeight,
                                                  child: ImageIcon(
                                                      AssetImage(
                                                          "assets/images/send.png"),
                                                      color: blue),
                                                )
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: height * 0.005),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            left: width * 0.005,
                                            right: width * 0.005,
                                          ),
                                          child : ListView(
                                            padding: EdgeInsets.zero,
                                            children: [
                                              ...widget.comments.replies.map((e){
                                                return Container(
                                                  margin : EdgeInsets.only(
                                                    bottom : height * 0.0
                                                  ),
                                                  child: Stack(
                                                    children : [
                                                      Container(
                                                    padding: EdgeInsets.only(
                                                        right: width * 0.015,
                                                        bottom: width * 0.015,
                                                        top: width * 0.025,
                                                        left: width * 0.025),
                                                    margin: EdgeInsets.only(
                                                        left: width * 0.02,
                                                        top: height * 0.015),
                                                    decoration: BoxDecoration(
                                                        color: blue,
                                                        borderRadius:
                                                            BorderRadius.circular(10)),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          Opacity(
                                                            opacity: 0.55,
                                                            child: Text(
                                                                "posted by ${allUsers[e.email]!
                                                                        .firstName} ${allUsers[e
                                                                            .email]!
                                                                        .lastName} at ${DateFormat("MM/dd/yyyy")
                                                                        .format(e.sentTime!)}",
                                                                style: GoogleFonts.fredoka(
                                                                    color: backgroundColor,
                                                                    fontWeight:
                                                                        FontWeight.w600,
                                                                    fontSize: 16)),
                                                          ),
                                                          Text(
                                                              e
                                                                  .content,
                                                              maxLines: 4,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: GoogleFonts.fredoka(
                                                                  color: backgroundColor,
                                                                  height: 1.1,
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize: 19)),
                                                          
                                                          SizedBox(height: height * 0.005),
                                                        ]
                                                      )
                                                    ),
                                                    Positioned(
                                                      top: 0,
                                                      left: 0,
                                                      child: Container(
                                                        height: height * 0.032,
                                                        width: height * 0.032,
                                                        decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(3)),
                                                        padding: EdgeInsets.all(width * 0.005),
                                                        child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(2),
                                                            child: Image.network(
                                                              allUsers[e.email]!.image,
                                                              fit: BoxFit.cover,
                                                            )
                                                          )
                                                        )
                                                      ),
                                                    ]
                                                  ),
                                                );
                                                
                                              }).toList()
                                            ],
                                          )
                                        ),
                                      ),
                                    ],
                                  )
                                )
                              ],
                            )
                          ),
                          SizedBox(
                            height : height * 0.005
                          ),
                      ]
                    )
                  )
                )
              )
            )
          ]
        )
      )
    );
  }
}
