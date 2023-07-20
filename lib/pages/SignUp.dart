import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/models/user.dart';
import 'package:highschoolhub/pages/SignUpScreen/AccountInfo.dart';
import 'package:highschoolhub/pages/SignUpScreen/Club.dart';
import 'package:highschoolhub/pages/SignUpScreen/EducationInfo.dart';
import 'package:highschoolhub/pages/SignUpScreen/SkillSpecifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with TickerProviderStateMixin{
  @override
  List<Color> normalColorList = [blue, puprle, orange, mainColor];
  List<Color> darkColorList = [darkblue, darkPurple, darkOrange, darkGreen];
  List<bool> pageCompleted = [true, true, true, true];
  late TabController _tabController;
  bool loadingState = false;
  bool keyboardUp = false;
  void setLoadingState() => setState(() => loadingState = loadingState == false);
  void initState(){
    _tabController = TabController(length : 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        currentScreen = _tabController.index;
      });
    });
    super.initState();
  }

  int currentScreen = 0;
  Widget build(BuildContext context) {
    keyboardUp = MediaQuery.of(context).viewInsets.bottom != 0;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List arguments = ModalRoute.of(context)!.settings.arguments as List;
    AppUser currentUser = arguments[0];
    return Scaffold(
        body: SingleChildScrollView(
          physics: keyboardUp ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
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
                          SizedBox(
                            width: width * 0.05,
                          ),
                          Container(
                            height: height * 0.0725,
                            width: height * 0.0725,
                            child: FloatingActionButton(
                                onPressed: () async {
                                  if (currentScreen != 0) {
                                    currentScreen--;
                                    _tabController.animateTo(currentScreen, duration: Duration(milliseconds: 300));
                                  }else{
                                    try{
                                      await Supabase.instance.client.auth.signOut();
                                    }on Exception catch(_){};
                                    Navigator.of(context).popAndPushNamed("authenticationScreen");
                                  }
                                  setState(() {});
                                },
                                elevation: 3,
                                backgroundColor: currentScreen == 0 ? red:normalColorList[currentScreen],
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  side: BorderSide(
                                      width: width * 0.0125,
                                      color: currentScreen == 0 ? darkRed: darkColorList[currentScreen]),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    currentScreen == 0 ? width * 0.042: width * 0.03,
                                  ),
                                  child: RotatedBox(
                                    quarterTurns: 2,
                                    child: Image.asset(currentScreen == 0 ? "assets/images/back.png" : "assets/images/arrow.png"),
                                  ),
                                )),
                          ),
                          Expanded(child: Container()),
                          Container(
                            height: height * 0.0725,
                            child: FittedBox(
                              child: Text(
                                "Sign Up",
                                style: GoogleFonts.fredoka(
                                    fontWeight: FontWeight.w800,
                                    color: normalColorList[currentScreen]),
                              ),
                            ),
                          ),
                          Expanded(child: Container()),
                          Container(
                            height: height * 0.0725,
                            width: height * 0.0725,
                            child: FloatingActionButton(
                                onPressed: () async {
                                  if (currentScreen != 3) {
                                    currentScreen++;
                                    _tabController.animateTo(currentScreen, duration: Duration(milliseconds: 300));
                                  }else{
                                    
                                  }
                                  setState(() {});
                                },
                                elevation: 3,
                                backgroundColor: normalColorList[currentScreen],
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  side: BorderSide(
                                      width: width * 0.0125,
                                      color: darkColorList[currentScreen]),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    currentScreen == 3 ? width * 0.035: width * 0.03,
                                  ),
                                  child: RotatedBox(
                                    quarterTurns: 0,
                                    child: Image.asset(currentScreen == 3 ? "assets/images/done.png" : "assets/images/arrow.png"),
                                  ),
                                )),
                          ),
                          SizedBox(
                            width: width * 0.05,
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: Container(
                      width: width, 
                      child: TabBarView(
                        controller: _tabController, 
                        children: [
                          AccountInfoScreen(currentUser, setLoadingState), 
                          EducationInfoScreen(), 
                          SkillInfoScreen(), 
                          ClubInfoScreen()
                        ],
                      ),
                    )),
                    Container(
                      width: width * 0.9,
                      height: height * 0.08,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                           NavigationIcon("assets/images/signUpScreenIcons/user.png", pageCompleted, normalColorList, currentScreen, 0),
                    NavigationIcon("assets/images/signUpScreenIcons/school.png", pageCompleted, normalColorList, currentScreen, 1),
                    NavigationIcon("assets/images/signUpScreenIcons/skills.png", pageCompleted, normalColorList, currentScreen, 2),
                    NavigationIcon("assets/images/signUpScreenIcons/trophy.png", pageCompleted, normalColorList, currentScreen, 3),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ), 
            loadingState ? 
            Container(
              height: height,
              width: width, 
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child : LoadingAnimationWidget.threeRotatingDots(color: normalColorList[currentScreen], size: height * 0.1)
              ),
            ):Container()
          ],
              ),
            ),
        ));
  }
}

class NavigationIcon extends StatefulWidget {
  List pageCompleted;
  List normalColorList;
  int navigationIconScreen;
  int currentScreen;
  String imageAdress;
  NavigationIcon(this.imageAdress, this.pageCompleted, this.normalColorList,
      this.currentScreen, this.navigationIconScreen);

  @override
  State<NavigationIcon> createState() => _NavitionIconState();
}

class _NavitionIconState extends State<NavigationIcon> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return AnimatedOpacity(
      duration: Duration(milliseconds: 300),
      opacity: widget.pageCompleted[widget.navigationIconScreen] ? 1 : 0.8,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: height * 0.068,
        width: height * 0.068,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
              width: width * 0.011,
              color: widget.currentScreen >= widget.navigationIconScreen
                  ? widget.normalColorList[widget.navigationIconScreen]
                  : Colors.grey.shade300),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Container(
            margin: EdgeInsets.all(height * 0.0125),
            foregroundDecoration: BoxDecoration(
              color: widget.pageCompleted[widget.navigationIconScreen]
                  ? Colors.transparent
                  : Colors.grey.shade300,
              backgroundBlendMode: BlendMode.saturation,
            ),
            child: Image.asset(
              widget.imageAdress,
              fit: BoxFit.contain,
            )),
      ),
    );
  }
}
