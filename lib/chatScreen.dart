import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/main.dart';
import 'package:highschoolhub/pages/AuthenticationPage.dart';
import 'package:supabase/supabase.dart';
import 'models/chat.dart';
import 'package:easy_localization/easy_localization.dart';

class ChatScreen extends StatefulWidget {
  Chat currentChat;
  ChatScreen(this.currentChat);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  int currentChatId = -1;
  TextEditingController messageTec = TextEditingController();
  void initStateFunction() async {
    List<Map> data = await supaBase.from("chats").select();
    print("started this");
    for (Map tempData in data) {
      Chat tempChat = Chat();
      tempChat.fromJson(tempData);
      if ((tempChat.user1Email == widget.currentChat.user1Email &&
              tempChat.user2Email == widget.currentChat.user2Email) ||
          (tempChat.user1Email == widget.currentChat.user2Email &&
              tempChat.user2Email == widget.currentChat.user1Email)) {
        currentChatId = tempData["id"] as int;
        print(tempData["allChats"]);
        widget.currentChat = tempChat;
        break;
      }
    }
    print("started this");
    if (currentChatId == -1) {
      Map data = (await supaBase
          .from("chats")
          .insert(widget.currentChat.toJson())
          .select())[0];
      currentChatId = data["id"] as int;
    }
    print(currentChatId);
    
    setState(() {
      
    });
    supaBase.channel('public:chats:id=eq.${currentChatId}').on(
        RealtimeListenTypes.postgresChanges,
        ChannelFilter(
          event: 'UPDATE',
          schema: 'public',
          table: 'chats',
          filter: 'id=eq.${currentChatId}',
        ), (payload, [ref]) {
      widget.currentChat.fromJson(payload["new"]);
      setState(() {});
      print(widget.currentChat.allChats);
    }).subscribe();
  }

  void initState() {
    initStateFunction();
    super.initState();
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        child: Stack(
          children: [
            Opacity(
              opacity: 0.25,
              child: Container(
                height: height,
                width: width,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Image.asset("assets/images/backdrop.png"),
                ),
              ),
            ),
            Container(
              height: height,
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: width,
                    decoration: BoxDecoration(
                        color: blue,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5))),
                    child: SafeArea(
                      top: true,
                      bottom: false,
                      left: false,
                      right: false,
                      child: Container(
                        height: height * 0.07,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: width * 0.04,
                            ),
                            InkWell(
                              onTap: () {
                                supaBase.removeAllChannels();
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                height: height * 0.04,
                                child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: ImageIcon(
                                      AssetImage(
                                          "assets/images/backArrow2.png"),
                                      color: backgroundColor,
                                    )),
                              ),
                            ),
                            Expanded(child: Container()),
                            Container(
                                height: height * 0.048,
                                width: height * 0.048,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: darkblue, width: width * 0.01),
                                    borderRadius: BorderRadius.circular(8)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: Image.network(
                                    widget.currentChat.getOtherPersonImage(),
                                    fit: BoxFit.cover,
                                  ),
                                )),
                            SizedBox(
                              width: width * 0.015,
                            ),
                            Text(
                              widget.currentChat.getOtherPersonName(),
                              style: GoogleFonts.fredoka(
                                  color: backgroundColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 27),
                            ),
                            Expanded(child: Container()),
                            SizedBox(
                              width: width * 0.04,
                            ),
                            Container(
                              height: height * 0.04,
                              child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: ImageIcon(
                                    AssetImage("assets/images/backArrow2.png"),
                                    color: blue,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01 / 2,
                  ),
                  Expanded(
                      child: Container(
                    width: width,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        ...widget.currentChat.allChats.map((e) {
                          return Column(
                            children: [
                              widget.currentChat.allChats.indexOf(e) == 0 ||
                                      widget
                                          .currentChat
                                          .allChats[widget.currentChat.allChats
                                                  .indexOf(e) -
                                              1]!
                                          .dateSent!
                                          .isBefore(e.dateSent!) && widget
                                          .currentChat
                                          .allChats[widget.currentChat.allChats
                                                  .indexOf(e) -
                                              1]!
                                          .dateSent!.day != e.dateSent!.day
                                  ? Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    bottom: height * 0.0025, 
                                                    top: height * 0.005),
                                                height: height * 0.035,
                                                child: FittedBox(
                                                  fit: BoxFit.fitHeight,
                                                  child: Text(
                                                    DateFormat.yMMMMd()
                                                        .format(e.dateSent!),
                                                    style: GoogleFonts.fredoka(
                                                        color:
                                                            Colors.grey.shade400,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                )
                                              ),
                                              
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(),
                              e.fromEmail == currentUser.email
                                  ? Row(
                                      children: [
                                        Expanded(child: Container()),
                                        Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: blue, 
                                                borderRadius: BorderRadius.circular(8)
                                              ),
                                              constraints: BoxConstraints(
                                                maxWidth: width * 0.8,
                                              ),
                                              margin: widget.currentChat.allChats.indexOf(e) + 1 == widget.currentChat.allChats.length || widget.currentChat.allChats[widget.currentChat.allChats.indexOf(e) + 1].fromEmail != currentUser.email ? EdgeInsets.only(
                                                right: width * 0.015, 
                                                bottom: width * 0.035
                                              ) : EdgeInsets.only(right: width * 0.015, ),
                                              padding:
                                                  EdgeInsets.only(
                                                    left : width * 0.02, 
                                                    top : width * 0.015, 
                                                    bottom : width * 0.015, 
                                                    right : width * 0.025
                                                  ),
                                              child: FittedBox(
                                                fit: BoxFit
                                                    .scaleDown, // This scales down the child to fit within the constraints
                                                child: Text(
                                                  e.content,
                                                  style: GoogleFonts.fredoka(
                                                    color: backgroundColor, 
                                                    fontWeight: FontWeight.w600, 
                                                    fontSize: 18
                                                  ),
                                                  maxLines: null,
                                                ),
                                              ),
                                            ),
                                            widget.currentChat.allChats.indexOf(e) + 1 == widget.currentChat.allChats.length || widget.currentChat.allChats[widget.currentChat.allChats.indexOf(e) + 1].fromEmail != currentUser.email?
                                              Positioned(
                                                bottom: 0, 
                                                right: 0, 
                                                child: Container(
                                                  height: height * 0.025, 
                                                  width: height * 0.025, 
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: blue, 
                                                      width: width * 0.005
                                                    ), 
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(5)
                                                    )
                                                  ),
                                                  
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(3),
                                                    child:  Image.network(
                                                    currentUser.image, 
                                                    fit: BoxFit.cover,
                                                  ),
                                                  )
                                                ),
                                              ) : Container()
                                          ],
                                        ), 
                                        SizedBox(
                                          width: width * 0.025,
                                        )
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        SizedBox(
                                          width: width * 0.025,
                                        ),
                                        Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: mainColor, 
                                                borderRadius: BorderRadius.circular(8)
                                              ),
                                              constraints: BoxConstraints(
                                                maxWidth: width * 0.8,
                                              ),
                                              margin: widget.currentChat.allChats.indexOf(e) + 1 == widget.currentChat.allChats.length || widget.currentChat.allChats[widget.currentChat.allChats.indexOf(e) + 1].fromEmail != e.fromEmail ? EdgeInsets.only(
                                                left: width * 0.015, 
                                                bottom: width * 0.035
                                              ) : EdgeInsets.only(left: width * 0.015, ),
                                              padding:
                                                  EdgeInsets.only(
                                                    right : width * 0.02, 
                                                    top : width * 0.015, 
                                                    bottom : width * 0.015, 
                                                    left : width * 0.025
                                                  ),
                                              child: FittedBox(
                                                fit: BoxFit
                                                    .scaleDown, // This scales down the child to fit within the constraints
                                                child: Text(
                                                  e.content,
                                                  style: GoogleFonts.fredoka(
                                                    color: backgroundColor, 
                                                    fontWeight: FontWeight.w600, 
                                                    fontSize: 18
                                                  ),
                                                  maxLines: null,
                                                ),
                                              ),
                                            ),
                                            widget.currentChat.allChats.indexOf(e) + 1 == widget.currentChat.allChats.length || widget.currentChat.allChats[widget.currentChat.allChats.indexOf(e) + 1].fromEmail != e.fromEmail?
                                              Positioned(
                                                bottom: 0, 
                                                left: 0, 
                                                child: Container(
                                                  height: height * 0.025, 
                                                  width: height * 0.025, 
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: mainColor, 
                                                      width: width * 0.005
                                                    ), 
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(5)
                                                    )
                                                  ),
                                                  
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(3),
                                                    child:  Image.network(
                                                    widget.currentChat.getOtherPersonImage(), 
                                                    fit: BoxFit.cover,
                                                  ),
                                                  )
                                                ),
                                              ) : Container()
                                          ],
                                        ), 
                                        Expanded(child: Container()),
                                      ],
                                    ), 
                                    SizedBox(
                                      height: height * 0.005,
                                    ),
                            ],
                          );
                        }).toList()
                      ],
                    ),
                  )),
                  SizedBox(
                    height: height * 0.01 / 2,
                  ),
                  Container(
                    height: height * 0.11,
                    color: blue,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height * 0.008,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: width * 0.02,
                            ),
                            Container(
                              height: height * 0.065,
                              width: width * 0.8,
                              decoration: BoxDecoration(
                                  color: backgroundColor,
                                  border: Border.all(
                                      color: darkblue, width: width * 0.015),
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.only(
                                left: width * 0.01,
                                right: width * 0.01,
                              ),
                              child: Container(
                                height: height * 0.065,
                                width: width * 0.8,
                                child: TextField(
                                  controller: messageTec,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        left: width * 0.01,
                                        right: 0,
                                        top: 0,
                                        bottom: height * 0.0035),
                                    hintStyle: GoogleFonts.fredoka(
                                        color: blue,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 25),
                                  ),
                                  cursorHeight: height * 0.036,
                                  cursorWidth: width * 0.01,
                                  cursorColor: darkblue,
                                  maxLines: 1,
                                  style: GoogleFonts.fredoka(
                                      color: blue,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 25),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.02,
                            ),
                            InkWell(
                              onTap: () async {
                                widget.currentChat.allChats.add(chatInstance(
                                    fromEmail: currentUser.email,
                                    content: messageTec.text));
                                await supaBase
                                    .from("chats")
                                    .update(widget.currentChat.toJson())
                                    .eq("id", currentChatId);
                                messageTec.text = "";
                                setState(() {});
                              },
                              child: Container(
                                height: height * 0.063,
                                width: height * 0.063,
                                decoration: BoxDecoration(
                                    color: blue,
                                    border: Border.all(
                                        color: darkblue, width: width * 0.015),
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.all(width * 0.017),
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: ImageIcon(
                                    AssetImage("assets/images/send.png"),
                                    color: backgroundColor,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
