import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/models/school.dart';
import 'package:highschoolhub/models/user.dart';
import 'package:highschoolhub/pages/SignUpScreen/AccountInfo.dart';
import 'package:highschoolhub/pages/SignUpScreen/Club.dart';
import 'package:highschoolhub/pages/SignUpScreen/EducationInfo.dart';
import 'package:highschoolhub/pages/SignUpScreen/SkillSpecifier.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class Range{
  int lowerBound;
  int upperBound;
  Range(this.lowerBound, this.upperBound);
  List<int> returnNumberInRange(){
    List<int> answer = [];

    for(int i = lowerBound; i <= upperBound; i++){
      answer.add(i);
    }
    return answer;
  }
}

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}
class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  @override
  List<Color> normalColorList = [blue, puprle, orange, mainColor];
  List<Color> darkColorList = [darkblue, darkPurple, darkOrange, darkGreen];
  List<bool> pageCompleted = [true, true, true, true];
  late TabController _tabController;
  bool loadingState = false;
  bool keyboardUp = false;
  bool showBlackScreen = false;
  bool searchResultsLoading = false;
  Future<School> getFullSchoolData(String schoolName, String formattedName) async {
    String ogName = schoolName;
    String tempSchoolName = schoolName.replaceAll(" ", "+");
    schoolName = schoolName.replaceAll(" ", "+") + "+Crest";
    String searchUrl = "https://www.google.com/search?q=" + schoolName + "&tbm=isch&ved=2ahUKEwiCvdaK3KWAAxXwPN4AHW6nCg8Q2-cCegQIABAA&oq=" + schoolName + "&gs_lcp=CgNpbWcQAzoECCMQJzoFCAAQgAQ6CAgAEIAEELEDOggIABCxAxCDAToHCAAQigUQQzoLCAAQgAQQsQMQgwE6BAgAEAM6BwgjEOoCECc6BwgAEBgQgAQ6BggAEAgQHjoECAAQHlDqgQFYg7YBYLG3AWgCcAB4AIABYIgBthOSAQI0NJgBAKABAaoBC2d3cy13aXotaW1nsAEKwAEB&sclient=img&ei=YZS9ZMKIAvD5-LYP7s6qeA&bih=1047&biw=1241";
    Uri url = Uri.parse(searchUrl);
    var response = await http.get(url);
    var document = parser.parse(response.body);
    List<dom.Element> images = document.getElementsByTagName("img");
    String imageURL = images[1].attributes["src"] as String;
    searchUrl =
        "https://nces.ed.gov/ccd/schoolsearch/school_list.asp?Search=1&InstName=" +
            tempSchoolName +
            "&SchoolID=&Address=&City=&State=&Zip=&Miles=&County=&PhoneAreaCode=&Phone=&DistrictName=&DistrictID=&SchoolType=1&SchoolType=2&SchoolType=3&SchoolType=4&SpecificSchlTypes=all&IncGrade=-1&LoGrade=-1&HiGrade=-1";
    url = Uri.parse(searchUrl);
    response = await http.get(url);
    document = parser.parse(response.body);
    List<dom.Element> actualLinkList = document.getElementsByTagName("a");
    for(dom.Element link in actualLinkList) {
      try{
        if(link.attributes["href"]!.contains("school_detail.asp")){
          searchUrl = "https://nces.ed.gov/ccd/schoolsearch/" + link.attributes["href"]!;     
          break;
        }
      }catch(e){}
    }
    for(dom.Element link in actualLinkList) {
      try{
        if(link.attributes["title"]!.contains("Map latest data")){
          break;
        }
      }catch(e){}
    } 
    url = Uri.parse(searchUrl);
    response = await http.get(url);
    document = parser.parse(response.body);
    List<dom.Element> gradeProspects = document.getElementsByTagName("font");
    late Range gradeRange;
    for(dom.Element element in gradeProspects){
      if(element.text.contains("(grades")){
        List<String> gradeRateText = element.text.replaceAll("(", "").replaceAll(")", "").split(" ");
        int lowerBound, upperBound;
        if(gradeRateText[gradeRateText.indexOf("-") - 1] == "KG"){
          lowerBound = 1;
        }else{
          lowerBound = int.parse(gradeRateText[gradeRateText.indexOf("-") - 1]);
        }
        upperBound = int.parse(gradeRateText[gradeRateText.indexOf("-") + 1]);
        gradeRange = Range(lowerBound, upperBound);
        break;
      }
    }
    List<dom.Element> address = document.getElementsByTagName("font");
    School finalAnswer = School(image: imageURL, name: formattedName);
    finalAnswer.grades = gradeRange.returnNumberInRange();
    actualLinkList = document.getElementsByTagName("a");
    for(dom.Element link in actualLinkList) {
      try{
        if(link.attributes["title"]!.contains("Map latest data")){
          List<dom.Element> elements = link.children;
          searchUrl = link.attributes["href"]!;
          finalAnswer.address = (link.text);
          print(link.children[0].outerHtml);
          break;
        }
      }catch(e){}
    } 
    url = Uri.parse("https://nces.ed.gov" + searchUrl);
    response = await http.get(url);
    print(url);
    document = parser.parse(response.body);
    List<dom.Element> addressStrings = document.getElementsByClassName("address-data");
    String finalStringAdress = "";
    print(addressStrings);
    for(dom.Element addy in addressStrings){
      print(addy);
      finalStringAdress = finalStringAdress + addy.text + "\n";
    }
    finalAnswer.address = finalStringAdress;
    return finalAnswer;
  }
  Future<List> getWebsiteData() async {
    setState(() {
      searchResultsLoading = true;
      print("yeah");
    });
    List finalAnswersList = [];
    String enteredSchool = schoolTec.text;
    String stringUrl =
        "https://nces.ed.gov/ccd/schoolsearch/school_list.asp?Search=1&InstName=" +
            enteredSchool.replaceAll(" ", "+") +
            "&SchoolID=&Address=&City=&State=&Zip=&Miles=&County=&PhoneAreaCode=&Phone=&DistrictName=&DistrictID=&SchoolType=1&SchoolType=2&SchoolType=3&SchoolType=4&SpecificSchlTypes=all&IncGrade=-1&LoGrade=-1&HiGrade=-1";
    print(stringUrl);
    final url = Uri.parse(stringUrl);
    final response = await http.get(url);
    var document = parser.parse(response.body);
    List<dom.Element> getItems = document.getElementsByTagName("strong");
    List<String> actualStringRecommendationList = [];
    bool startAdding = false;
    for (int i = 0; i < getItems.length; i++) {
      if (startAdding &&
          getItems[i].text.contains("Page 1") == false &&
          getItems[i].text != "") {
        actualStringRecommendationList.add(getItems[i].text);
      } else if (startAdding == true) {
        startAdding = false;
      }
      if (getItems[i].text.contains("Grades")) {
        startAdding = true;
      }
    }
    setState(() {
      searchResultsLoading = false;
      print("yeah");
    });
    if(actualStringRecommendationList.length == 0) {
      return ["none"];
    }
    return actualStringRecommendationList;
  }

  void setLoadingState() =>
      setState(() => loadingState = loadingState == false);
  void toggleShowBlackScreen() {
    setState(() {
      showBlackScreen = showBlackScreen == false;
      if (showBlackScreen == false && searchSchoolVisibility) {
        setState(() {
          showSearchSchool();
        });
      }
    });
  }

  List recList = [];
  TextEditingController schoolTec = new TextEditingController();
  void getSchoolData() async {
    recList = await getWebsiteData();
    print(recList);
    setState(() {
      recList;
    });
  }
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    getWebsiteData();
    _tabController.addListener(() {
      setState(() {
        currentScreen = _tabController.index;
      });
    });
    super.initState();
  }

  bool monthPickerVisbility = false;
  void showMonthPicker() {
    setState(() {
      monthPickerVisbility = monthPickerVisbility == false;
    });
  }
  bool statePickerVisibility = false;
  void showStatePicker(){
    setState(() {
      statePickerVisibility = statePickerVisibility == false;
    });
  }
  bool searchSchoolVisibility = false;
  void showSearchSchool() {
    setState(() {
      searchSchoolVisibility = searchSchoolVisibility == false;
    });
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
      physics:
          keyboardUp ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
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
                                    _tabController.animateTo(currentScreen,
                                        duration: Duration(milliseconds: 300));
                                  } else {
                                    try {
                                      await Supabase.instance.client.auth
                                          .signOut();
                                    } on Exception catch (_) {}
                                    ;
                                    Navigator.of(context).popAndPushNamed(
                                        "authenticationScreen");
                                  }
                                  setState(() {});
                                },
                                elevation: 2,
                                backgroundColor: currentScreen == 0
                                    ? red
                                    : normalColorList[currentScreen],
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  side: BorderSide(
                                      width: width * 0.0125,
                                      color: currentScreen == 0
                                          ? darkRed
                                          : darkColorList[currentScreen]),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    currentScreen == 0
                                        ? width * 0.042
                                        : width * 0.03,
                                  ),
                                  child: RotatedBox(
                                    quarterTurns: 2,
                                    child: Image.asset(currentScreen == 0
                                        ? "assets/images/back.png"
                                        : "assets/images/arrow.png"),
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
                                    _tabController.animateTo(currentScreen,
                                        duration: Duration(milliseconds: 300));
                                  } else {}
                                  setState(() {});
                                },
                                elevation: 2,
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
                                    currentScreen == 3
                                        ? width * 0.035
                                        : width * 0.03,
                                  ),
                                  child: RotatedBox(
                                    quarterTurns: 0,
                                    child: Image.asset(currentScreen == 3
                                        ? "assets/images/done.png"
                                        : "assets/images/arrow.png"),
                                  ),
                                )),
                          ),
                          SizedBox(
                            width: width * 0.05,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Container(
                      width: width,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          AccountInfoScreen(currentUser, setLoadingState,
                              toggleShowBlackScreen, showMonthPicker, showStatePicker),
                          EducationInfoScreen(
                              toggleShowBlackScreen, showSearchSchool, currentUser),
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
                          NavigationIcon(
                              "assets/images/signUpScreenIcons/user.png",
                              pageCompleted,
                              normalColorList,
                              currentScreen,
                              0),
                          NavigationIcon(
                              "assets/images/signUpScreenIcons/school.png",
                              pageCompleted,
                              normalColorList,
                              currentScreen,
                              1),
                          NavigationIcon(
                              "assets/images/signUpScreenIcons/skills.png",
                              pageCompleted,
                              normalColorList,
                              currentScreen,
                              2),
                          NavigationIcon(
                              "assets/images/signUpScreenIcons/trophy.png",
                              pageCompleted,
                              normalColorList,
                              currentScreen,
                              3),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            loadingState
                ? Container(
                    height: height,
                    width: width,
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                        child: LoadingAnimationWidget.threeRotatingDots(
                            color: normalColorList[currentScreen],
                            size: height * 0.1)),
                  )
                : Container(),
            showBlackScreen
                ? InkWell(
                    onTap: () {
                      toggleShowBlackScreen();
                      if (monthPickerVisbility) {
                        showMonthPicker();
                      }
                      if(statePickerVisibility){
                        showStatePicker(); 
                      }
                    },
                    child: AnimatedOpacity(
                      opacity: showBlackScreen ? 1 : 0,
                      duration: Duration(milliseconds: 300),
                      child: Container(
                        height: height,
                        width: width,
                        color: Colors.black.withOpacity(0.75),
                      ),
                    ),
                  )
                : Container(),
            monthPickerVisbility
                ? Center(
                    child: Container(
                      height: height * 0.5,
                      width: width * 0.8,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                      ),
                      padding: EdgeInsets.all(width * 0.025),
                      child: ListView(
                        padding: EdgeInsets.all(0),
                        children: [
                          ...[
                            Months.January,
                            Months.February,
                            Months.March,
                            Months.April,
                            Months.May,
                            Months.June,
                            Months.July,
                            Months.August,
                            Months.September,
                            Months.October,
                            Months.November,
                            Months.December
                          ].map((e) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  currentUser.dateOfBirth!.month = e;
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 150),
                                height: height * 0.08,
                                width: width * 0.75,
                                margin: EdgeInsets.only(bottom: width * 0.025),
                                decoration: BoxDecoration(
                                    color: currentUser.dateOfBirth!.month == e
                                        ? blue
                                        : backgroundColor,
                                    border: Border.all(
                                      color: darkblue,
                                      width: width * 0.015,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Center(
                                    child: Container(
                                        height: height * 0.04,
                                        child: Stack(
                                          children: [
                                            AnimatedOpacity(
                                              duration:
                                                  Duration(milliseconds: 150),
                                              opacity: 1,
                                              child: SizedBox(
                                                height: height * 0.04,
                                                child: FittedBox(
                                                  fit: BoxFit.fitHeight,
                                                  child: Text(
                                                    monthToString(e)[0],
                                                    style: GoogleFonts.fredoka(
                                                        color: darkblue,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            AnimatedOpacity(
                                              duration:
                                                  Duration(milliseconds: 150),
                                              opacity: currentUser
                                                          .dateOfBirth!.month ==
                                                      e
                                                  ? 1
                                                  : 0,
                                              child: SizedBox(
                                                height: height * 0.04,
                                                child: FittedBox(
                                                  fit: BoxFit.fitHeight,
                                                  child: Text(
                                                    monthToString(e)[0],
                                                    style: GoogleFonts.fredoka(
                                                        color: backgroundColor,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ))),
                              ),
                            );
                          }).toList()
                        ],
                      ),
                    ),
                  )
                : Container(),
            statePickerVisibility
                ? Center(
                    child: Container(
                      height: height * 0.5,
                      width: width * 0.8,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                      ),
                      padding: EdgeInsets.all(width * 0.025),
                      child: ListView(
                        padding: EdgeInsets.all(0),
                        children: [
                          ...USStates.values
                          .map((e) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  currentUser.userState = e;
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 150),
                                height: height * 0.08,
                                width: width * 0.75,
                                margin: EdgeInsets.only(bottom: width * 0.025),
                                decoration: BoxDecoration(
                                    color: currentUser.userState == e
                                        ? blue
                                        : backgroundColor,
                                    border: Border.all(
                                      color: darkblue,
                                      width: width * 0.015,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Center(
                                    child: Container(
                                        height: height * 0.04,
                                        child: Stack(
                                          children: [
                                            AnimatedOpacity(
                                              duration:
                                                  Duration(milliseconds: 150),
                                              opacity: 1,
                                              child: SizedBox(
                                                height: height * 0.04,
                                                child: FittedBox(
                                                  fit: BoxFit.fitHeight,
                                                  child: Text(
                                                    stateToString(e),
                                                    style: GoogleFonts.fredoka(
                                                        color: darkblue,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            AnimatedOpacity(
                                              duration:
                                                  Duration(milliseconds: 150),
                                              opacity: currentUser.userState == e
                                                  ? 1
                                                  : 0,
                                              child: SizedBox(
                                                height: height * 0.04,
                                                child: FittedBox(
                                                  fit: BoxFit.fitHeight,
                                                  child: Text(
                                                    stateToString(e),
                                                    style: GoogleFonts.fredoka(
                                                        color: backgroundColor,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ))),
                              ),
                            );
                          }).toList()
                        ],
                      ),
                    ),
                  )
                : Container(),
            searchSchoolVisibility
                ? SingleChildScrollView(
                    child: InkWell(
                      onTap: () {
                        showSearchSchool();
                        toggleShowBlackScreen();
                      },
                      child: Container(
                          height: height,
                          width: width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AnimatedContainer(
                                duration: Duration(milliseconds: 150),
                                height: keyboardUp ? height * 0.25 : height * 0.3,
                              ),
                              SearchSChoolTextField(
                                height * 0.08,
                                width * 0.9,
                                puprle,
                                darkPurple,
                                "",
                                0,
                                schoolTec,
                                getSchoolData
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                height: height * 0.25,
                                width: width * 0.9,
                                decoration: BoxDecoration(
                                    color: backgroundColor,
                                    border: Border.all(
                                        color: puprle, width: width * 0.015),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                padding: EdgeInsets.all(width * 0.015),
                                child: 
                                searchResultsLoading ? 
                                Center(
                                  child: Stack(
                                
                                    children:[ 
                                      Positioned(
                                        bottom: height * 0.03,
                                        left: width * 0.12,
                                        child: Container(
                                          height: height * 0.2, 
                                          child: Lottie.asset(
                                            "assets/animations/loading.json", 
                                            fit: BoxFit.fitHeight
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: height * 0.015,
                                        left: width * 0.17,
                                        child: Container(
                                          height: height * 0.04,
                                          child: FittedBox(
                                            fit: BoxFit.fitHeight, 
                                            child: Text(
                                              "Fetching Results...", 
                                              style: GoogleFonts.fredoka(
                                                color: puprle, 
                                                fontWeight: FontWeight.w700
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ]
                                  ),
                                )
                                : 
                                recList.length > 0 && recList[0] == "none" ? 
                                Center(
                                  child: Stack(
                                
                                    children:[ 
                                      Positioned(
                                        bottom: height * 0.06,
                                        left: width * 0.25,
                                        child: Container(
                                          height: height * 0.16, 
                                          child: Image.asset(
                                            "assets/images/empty.png", 
                                            fit: BoxFit.fitHeight
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: height * 0.01,
                                        left: width * 0.18,
                                        child: Container(
                                          height: height * 0.04,
                                          child: FittedBox(
                                            fit: BoxFit.fitHeight, 
                                            child: Text(
                                              "No Results Found", 
                                              style: GoogleFonts.fredoka(
                                                color: puprle, 
                                                fontWeight: FontWeight.w700
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ]
                                  ),
                                )
                                : 
                                ListView(
                                  padding: EdgeInsets.all(0),
                                  children: [
                                    ...recList.map((e) {
                                      String showSchoolString = e as String;
                                      String finalString = showSchoolString.substring(0, 1).toUpperCase();
                                      for(int i = 1; i < showSchoolString.length; i ++){
                                        if(showSchoolString.substring(i - 1, i) == " "){
                                          finalString = finalString + showSchoolString.substring(i, i + 1).toUpperCase();
                                        }else{
                                          finalString = finalString + showSchoolString.substring(i, i + 1).toLowerCase();
                                        }
                                      }
                                      return InkWell(
                                        onTap: () async {
                                          setState(() {
                                            searchResultsLoading = true;
                                          });
                                          School data = await getFullSchoolData(e, finalString);
                                          setState(() {
                                            currentUser.addSchool(data);
                                            searchResultsLoading = false;
                                            showSearchSchool();
                                            toggleShowBlackScreen();
                                          });
                                        },
                                        child: Container(
                                          width: width * 0.85,
                                          height: height * 0.07,
                                          margin: EdgeInsets.only(
                                            bottom: width * 0.015
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal : width * 0.02, 
                                              vertical: width * 0.01
                                          ),
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(255, 226, 225, 225),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5))),
                                          child : Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  finalString, 
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.fredoka(
                                                    fontWeight: FontWeight.w600, 
                                                    color: puprle, 
                                                    fontSize: MediaQuery.of(context).textScaleFactor * 18
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ),
                                      );
                                    }).toList()
                                  ],
                                ),
                              )
                            ],
                          )),
                    ),
                  )
                : Container()
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

class SearchSChoolTextField extends StatefulWidget {
  double wantedHeight;
  double wantedWidth;
  Color mainColor;
  Color darkColor;
  String textFieldName;
  double textFieldNameWidth;
  TextEditingController tec;
  Function searchButtonOnTap;
  SearchSChoolTextField(this.wantedHeight, this.wantedWidth, this.mainColor,
      this.darkColor, this.textFieldName, this.textFieldNameWidth, this.tec, this.searchButtonOnTap);
  @override
  State<SearchSChoolTextField> createState() => SearchSChoolTextFieldState();
}

class SearchSChoolTextFieldState extends State<SearchSChoolTextField> {
  @override
  bool tapped = false;
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: widget.wantedHeight * 1.02,
      width: widget.wantedWidth,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Container(
                width: widget.wantedWidth,
                height: widget.wantedHeight,
                decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    border: Border.all(
                        color: widget.mainColor, width: width * 0.015)),
                padding:
                    EdgeInsets.only(left: width * 0.032, top: height * 0.008),
                child: Text(
                  widget.textFieldName,
                  style: GoogleFonts.fredoka(
                      fontWeight: FontWeight.w700,
                      color: widget.tec.text == ""
                          ? Colors.grey.shade400
                          : Colors.transparent,
                      fontSize: MediaQuery.of(context).textScaleFactor * 30),
                )),
          ),
          Container(
            child: Positioned(
              left: width * 0.045,
              top: 0,
              child: Container(
                height: height * 0.01,
                width: widget.textFieldNameWidth,
                padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                color: backgroundColor,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    widget.textFieldName,
                    style: GoogleFonts.fredoka(
                        color: widget.darkColor, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: width * 0.05, left: width * 0.12),
            child: TextFormField(
              controller: widget.tec,
              onChanged: (d) {
                setState(() {});
              },
              onTap: () {
                setState(() {
                  tapped = true;
                });
              },
              onTapOutside: (d) {
                setState(() {
                  tapped = false;
                });
              },
              style: GoogleFonts.fredoka(
                  fontWeight: FontWeight.w600,
                  color: widget.mainColor,
                  fontSize: MediaQuery.of(context).textScaleFactor * 30),
              cursorColor: widget.mainColor,
              cursorHeight: widget.wantedHeight * 0.5,
              decoration: InputDecoration(border: InputBorder.none),
            ),
          ),
          Positioned(
            left: width * 0.025,
            top: height * 0.022,
            child: InkWell(
              onTap: (){widget.searchButtonOnTap();},
              child: Container(
                height: widget.wantedHeight * 0.55, 
                child: FittedBox(
                  fit: BoxFit.fitHeight, 
                  child: Icon(
                    Icons.search_rounded, 
                    color: darkPurple, 
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
