// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/main.dart';
import 'package:highschoolhub/models/class.dart';
import 'package:highschoolhub/models/club.dart';
import 'package:highschoolhub/models/filter.dart';
import 'package:highschoolhub/models/publicPost.dart';
import 'package:highschoolhub/models/school.dart';
import 'package:highschoolhub/pages/AuthenticationPage.dart';
import 'package:highschoolhub/pages/SignUp.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:lottie/lottie.dart';
import 'package:convert/convert.dart';
import 'package:highschoolhub/models/user.dart';
import 'package:image_picker/image_picker.dart';

enum PostType { Tournament, Volounteer, Collaborate, Other, None }

List<topicSubjects> subjectList = [
    topicSubjects(
        clubType : ClubType.Academics, clubTypeString : "none", image: "assets/images/clubIcons/Academics.png"),
    topicSubjects(
        clubType: ClubType.Art, clubTypeString: "Art", image: "assets/images/clubIcons/Art.png"),
    topicSubjects(
        clubType: ClubType.Buisness, clubTypeString: "Buisness", image: "assets/images/clubIcons/Buisness.png"),
    topicSubjects(
        clubType: ClubType.Culture, clubTypeString: "none", image: "assets/images/clubIcons/Culture.png"),
    topicSubjects(
        clubType: ClubType.Engineering, clubTypeString: "none", image: "assets/images/clubIcons/Engineering.png"),
    topicSubjects(
        clubType: ClubType.Math, clubTypeString: "Math", image: "assets/images/clubIcons/Math.png"),
    topicSubjects(
        clubType: ClubType.Media, clubTypeString: "none", image: "assets/images/clubIcons/Media.png"),
    topicSubjects(
        clubType: ClubType.Music, clubTypeString: "Music", image: "assets/images/clubIcons/Music.png"),
    topicSubjects(
        clubType: ClubType.Science, clubTypeString: "Science", image: "assets/images/clubIcons/Science.png"),
    topicSubjects(
        clubType: ClubType.Service, clubTypeString: "none", image: "assets/images/clubIcons/Service.png"),
    topicSubjects(
        clubType: ClubType.Speech, clubTypeString: "none", image: "assets/images/clubIcons/Speech.png"),
    topicSubjects(
        clubType: ClubType.Sports,
        clubTypeString:  "Sports", image: "assets/images/clubIcons/Sports.png"),
    topicSubjects(
        clubType: ClubType.Technology, clubTypeString: "Computers", image: "assets/images/clubIcons/Technology.png"),
    topicSubjects(
        clubType: ClubType.None, clubTypeString: "Electives", image: "assets/images/classImage/Electives.png"),
    topicSubjects(
       clubType:  ClubType.None, clubTypeString: "English", image: "assets/images/classImage/English.png"),
    topicSubjects(
        clubType: ClubType.None, clubTypeString: "Language", image: "assets/images/classImage/Language.png"),
    topicSubjects(
        clubType: ClubType.None, clubTypeString: "Social_Studies", image: "assets/images/classImage/Social_Studies.png"),
  ];

class Range {
  int lowerBound;
  int upperBound;
  Range(this.lowerBound, this.upperBound);
  List<int> returnNumberInRange() {
    List<int> answer = [];

    for (int i = lowerBound; i <= upperBound; i++) {
      answer.add(i);
    }
    return answer;
  }
}

PostType PostTypeFromJson(String postType) {
  
  if (postType == "PostType.Tournament") return PostType.Tournament;
  if (postType == "PostType.Volounteer") return PostType.Volounteer;
  if (postType == "PostType.Collaborate") return PostType.Collaborate;
  return PostType.Other;
}

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  @override
  TextEditingController volunteerWebsiteLinkTec = TextEditingController();
  TextEditingController tournamentWebsiteLinkTec = TextEditingController();
  PublicPost thisPost = PublicPost(author : currentUser);
  bool fromTimeChosen = false;
  bool toTimeChosen = false;
  TextEditingController postNameTEC = TextEditingController();
  TextEditingController postDescriptionTEC = TextEditingController();
  String imageAddress = "";
  File? currentChosenImage;
  int tab = 0;
  bool showBlackScreen = false;
  bool showSearchLocationVolunteer = false;
  bool showSearchLocationTournament = false;
  Color darkGrey = Color.fromARGB(255, 186, 185, 185);
  bool showClassesScreen = false;
  bool showPeopleScreen = false;
  bool showSchoolsScreen = false;
  List<AppUser> appUsers = [];
  List appUsersQueryList = [];

  void toggleClassesScreen() {
    setState(() {
      showClassesScreen = !showClassesScreen;
    });
  }

  List classesQueryList = [];
  bool datePickedForVolunteer = false;
  bool datePickedForTournament = false;
  
  void pickDateTournament() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2050))
        .then((value) {
      if (value != null) {
        if (thisPost.type == PostType.Tournament) {
          datePickedForTournament = true;
          thisPost.tournamentDate = value;
        }
        setState(() {});
      }
    });
  }
  
  void pickDate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2050))
        .then((value) {
      if (value != null) {
        if (thisPost.type == PostType.Volounteer) {
          datePickedForVolunteer = true;
          thisPost.volunteerDate = value;
        }
        setState(() {});
      }
    });
  }

  void toggleSchoolsScreen() {
    setState(() {
      showSchoolsScreen = !showSchoolsScreen;
    });
  }

  void togglePeopleScreen() {
    setState(() => setState(() {
          showPeopleScreen = !showPeopleScreen;
        }));
  }

  void toggleShowSearchLocationVolunteerScreen() {
    setState(() {
      showSearchLocationVolunteer = !showSearchLocationVolunteer;
      placeRecommendations = [];
      volunteerLocationTec.text = "";
    });
  }

  void toggleShowSearchLocationTournamentScreen() {
    setState(() {
      showSearchLocationTournament = !showSearchLocationTournament;
      placeRecommendations = [];
      volunteerLocationTec.text = "";
    });
  }

  void toggleBlackScreen() {
    setState(() {
      if (showBlackScreen) {
        showClassesScreen = false;
        showPeopleScreen = false;
        showSchoolsScreen = false;
        showSearchLocationVolunteer = false;
        showSearchLocationTournament = false;
      }
      showBlackScreen = !showBlackScreen;
    });
  }

  TextEditingController volunteerLocationTec = TextEditingController();
  TextEditingController tournamentLocationTec = TextEditingController();
  void pickTime(bool forToTime) {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) {
      setState(() {
        if (value != null) {
          if (forToTime)
            thisPost.volunteerToTime = value;
          else
            thisPost.volunteerFromTime = value;
          if (forToTime)
            toTimeChosen = true;
          else
            fromTimeChosen = true;
        }
      });
    });
  }

  String apiKey = "AIzaSyC3m6IXVamhaEiU4DpBxaCX9ePSoNPGi3Q";
  Future<List<double>> performGeoCoding(String address) async{
    double lat = 0;
    double lon = 0;
    Uri uri = Uri.https(
      "maps.googleapis.com", 
      "maps/api/geocode/json", 
      {
        "address" : address.replaceAll(" ", "%20"), 
        "key" : apiKey
      }
    );
    try{
      final response = await http.get(uri, headers: {});
      if(response.statusCode == 200){
        String data = response.body;
        Map undecodedData = json.decode(data)["results"][0]["geometry"]["location"];
        lat = undecodedData["lat"];
        lon = undecodedData["lng"];
        print("${lat} ${lon}");
      }
    } catch (e){
      print(e.toString());
    }
    return [lat, lon];
  }
  void getLocationAutoCompleteVolunteer() async {
    Uri uri = Uri.https(
        "maps.googleapis.com",
        "maps/api/place/autocomplete/json",
        {"input": volunteerLocationTec.text, "key": apiKey});
    try {
      final response = await http.get(uri, headers: {});
      if (response.statusCode == 200) {
        String data = response.body;
        print("location autocomplete : ");
        print(data);
        List undecodedData = json.decode(data)["predictions"];
        setState(() {
          placeRecommendations = undecodedData;
        });
        print(placeRecommendations);
      } else {
        print("Response Status Code - " + response.statusCode.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void getLocationAutoCompleteTournament() async {
    Uri uri = Uri.https(
        "maps.googleapis.com",
        "maps/api/place/autocomplete/json",
        {"input": tournamentLocationTec.text, "key": apiKey});
    try {
      final response = await http.get(uri, headers: {});
      if (response.statusCode == 200) {
        String data = response.body;
        print("location autocomplete Tournament : ");
        print(data);
        List undecodedData = json.decode(data)["predictions"];
        setState(() {
          placeRecommendations = undecodedData;
        });
        print(placeRecommendations);
      } else {
        print("Response Status Code - " + response.statusCode.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  bool searchResultsLoading = false;
  Future<School> getFullSchoolData(
      String schoolName, String formattedName) async {
    String ogName = schoolName;
    String tempSchoolName = schoolName.replaceAll(" ", "+");
    schoolName = "${schoolName.replaceAll(" ", "+")}+Crest";
    String searchUrl =
        "https://www.google.com/search?q=$schoolName&tbm=isch&ved=2ahUKEwiCvdaK3KWAAxXwPN4AHW6nCg8Q2-cCegQIABAA&oq=$schoolName&gs_lcp=CgNpbWcQAzoECCMQJzoFCAAQgAQ6CAgAEIAEELEDOggIABCxAxCDAToHCAAQigUQQzoLCAAQgAQQsQMQgwE6BAgAEAM6BwgjEOoCECc6BwgAEBgQgAQ6BggAEAgQHjoECAAQHlDqgQFYg7YBYLG3AWgCcAB4AIABYIgBthOSAQI0NJgBAKABAaoBC2d3cy13aXotaW1nsAEKwAEB&sclient=img&ei=YZS9ZMKIAvD5-LYP7s6qeA&bih=1047&biw=1241";
    Uri url = Uri.parse(searchUrl);
    var response = await http.get(url);
    var document = parser.parse(response.body);
    List<dom.Element> images = document.getElementsByTagName("img");
    String imageURL = images[1].attributes["src"] as String;
    searchUrl =
        "https://nces.ed.gov/ccd/schoolsearch/school_list.asp?Search=1&InstName=$tempSchoolName&SchoolID=&Address=&City=&State=&Zip=&Miles=&County=&PhoneAreaCode=&Phone=&DistrictName=&DistrictID=&SchoolType=1&SchoolType=2&SchoolType=3&SchoolType=4&SpecificSchlTypes=all&IncGrade=-1&LoGrade=-1&HiGrade=-1";
    url = Uri.parse(searchUrl);
    response = await http.get(url);
    document = parser.parse(response.body);
    List<dom.Element> actualLinkList = document.getElementsByTagName("a");
    for (dom.Element link in actualLinkList) {
      try {
        if (link.attributes["href"]!.contains("school_detail.asp")) {
          searchUrl =
              "https://nces.ed.gov/ccd/schoolsearch/${link.attributes["href"]!}";
          break;
        }
      } catch (e) {}
    }
    for (dom.Element link in actualLinkList) {
      try {
        if (link.attributes["title"]!.contains("Map latest data")) {
          break;
        }
      } catch (e) {}
    }
    url = Uri.parse(searchUrl);
    response = await http.get(url);
    document = parser.parse(response.body);
    List<dom.Element> gradeProspects = document.getElementsByTagName("font");
    late Range gradeRange;
    for (dom.Element element in gradeProspects) {
      if (element.text.contains("(grades")) {
        List<String> gradeRateText =
            element.text.replaceAll("(", "").replaceAll(")", "").split(" ");
        int lowerBound, upperBound;
        if (gradeRateText[gradeRateText.indexOf("-") - 1] == "KG") {
          lowerBound = 1;
        } else {
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
    String tempAddress = "";
    for (dom.Element link in actualLinkList) {
      try {
        if (link.attributes["title"]!.contains("Map latest data")) {
          List<dom.Element> elements = link.children;
          searchUrl = link.attributes["href"]!;
          tempAddress = link.text;
          print(link.children[0].outerHtml);
        }
      } catch (e) {}
    }
    String apiKey = googleMpasApiKey;
    final encodedAddress = Uri.encodeQueryComponent(tempAddress);
    final url2 =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$encodedAddress&key=$apiKey';
    http.Response results = await http.get(Uri.parse(url2));

    final data = json.decode(results.body);
    finalAnswer.address.fromJson(data["results"][0]);
    return finalAnswer;
  }

  TextEditingController schoolTec = TextEditingController();
  Future<List> getWebsiteData() async {
    setState(() {
      searchResultsLoading = true;
      print("yeah");
    });
    List finalAnswersList = [];
    String enteredSchool = schoolTec.text;
    String stringUrl =
        "https://nces.ed.gov/ccd/schoolsearch/school_list.asp?Search=1&InstName=${enteredSchool.replaceAll(" ", "+")}&SchoolID=&Address=&City=&State=&Zip=&Miles=&County=&PhoneAreaCode=&Phone=&DistrictName=&DistrictID=&SchoolType=1&SchoolType=2&SchoolType=3&SchoolType=4&SpecificSchlTypes=all&IncGrade=-1&LoGrade=-1&HiGrade=-1";
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
    if (actualStringRecommendationList.isEmpty) {
      return ["none"];
    }
    return actualStringRecommendationList;
  }

  List recList = [];
  TextEditingController classesTec = new TextEditingController();
  void getSchoolData() async {
    recList = await getWebsiteData();
    setState(() {
      recList;
    });
  }

  List<schoolClassDatabase> classes = [];
  File? selectedImage;
  void pickImage() async {
    // write code to pick image
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      selectedImage = File(returnedImage!.path);
    });
  }

  Future<int> getClassOptions() async {
    final result = await supaBase.from("Classes").select();
    classes = [];
    for (Map data in result) {
      schoolClassDatabase value = schoolClassDatabase();
      value.fromJson(data);
      if (value.schoolAssociatedWith.isEmpty) {
        classes.add(value);
      } else {
        for (Map data2 in data["Schools"]) {
          bool contains = false;
          for (School schoolData in currentUser.schools) {
            if (data2["name"] == schoolData.name && contains == false) {
              classes.add(value);
              contains = true;
            }
          }
          if (contains) break;
        }
      }
    }
    return 1;
  }

  List sortListByQuery(List corpus, String query) {
    List<List> tempList = [];
    print(corpus.length);
    for (String key in allUsers.keys) {
      appUsers.add(allUsers[key]!);
    }
    List finalStringList = [];
    for (var value in corpus) {
      value.getCorpusRatingFromQuery(query);
    }
    corpus.sort((a, b) {
      if (a.gScore.compareTo(b.gScore) != 0)
        return a.gScore.compareTo(b.gScore);
      return a.className.compareTo(b.className);
    });
    int i = 0;

    for (var value in corpus.reversed) {
      if (value.gScore != 0 && i <= 6) {
        finalStringList.add(value);
      }
      i++;
    }
    return finalStringList;
  }

  List sortUsersByQuery(List corpus, String query) {
    List<List> tempList = [];
    print(corpus.length);
    for (String key in allUsers.keys) {
      appUsers.add(allUsers[key]!);
    }
    List finalStringList = [];
    for (var value in corpus) {
      value.getCorpusRatingFromQuery(query);
    }
    corpus.sort((a, b) {
      if (a.gScore.compareTo(b.gScore) != 0)
        return a.gScore.compareTo(b.gScore);
      return 0;
    });
    int i = 0;

    for (var value in corpus.reversed) {
      if (value.gScore != 0 && i <= 6) {
        finalStringList.add(value);
      }
      i++;
    }
    return finalStringList;
  }

  TextEditingController chooseUserTagTec = TextEditingController();
  List placeRecommendations = [];
  void initStateFunction() async {
    await getClassOptions();
    await getWebsiteData();
    classesQueryList = classes;
  }

  void initState() {
    initStateFunction();
    volunteerLocationTec.text = "Bentonville Community Center";
    classesTec.addListener(() {
      setState(() {
        classesQueryList = sortListByQuery(classes, classesTec.text);
      });
    });
    chooseUserTagTec.addListener(() {
      setState(() {
        appUsersQueryList = sortUsersByQuery(appUsers, chooseUserTagTec.text);
      });
    });
    postNameTEC.addListener(() {
      thisPost.postTitle = postNameTEC.text;
    });
    postDescriptionTEC.addListener(() {
      thisPost.postDescription = postDescriptionTEC.text;
    });
    volunteerWebsiteLinkTec.addListener(() {
      thisPost.volunteerWebsite = volunteerWebsiteLinkTec.text;
    });
    tournamentWebsiteLinkTec.addListener(() {
      thisPost.tournamentWebsite = tournamentWebsiteLinkTec.text;
    });
    super.initState();
  }

  bool keyboardUp = false;
  Widget build(BuildContext context) {
    keyboardUp = MediaQuery.of(context).viewInsets.bottom != 0;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        color: blue,
        child: Stack(
          children: [
            Opacity(
              opacity: 0.1,
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
                width: width,
                child: Column(children: [
                  Container(
                    height: width * 0.04,
                  ),
                  Container(
                      width: width * 0.94,
                      height: height - width * 0.08,
                      decoration: BoxDecoration(
                          color: backgroundColor,
                          border: Border.all(
                              color: Colors.grey.shade300, width: width * 0.01),
                          borderRadius: BorderRadius.all(Radius.circular(35))),
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Container(
                            width: width,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: width * 0.03,
                                ),
                                InkWell(
                                  onTap: (){
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    height: height * 0.062,
                                    width: height * 0.062,
                                    decoration: BoxDecoration(
                                        color: red,
                                        border: Border.all(
                                            color: darkRed,
                                            width: width * 0.015),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    padding: EdgeInsets.all(width * 0.015),
                                    child: FittedBox(
                                      fit: BoxFit.cover,
                                      child: ImageIcon(
                                        AssetImage("assets/images/back.png"),
                                        color: backgroundColor,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.055,
                                ),
                                Container(
                                  height: height * 0.063,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      "Create Post",
                                      style: GoogleFonts.fredoka(
                                          color: blue,
                                          fontWeight: FontWeight.w700),
                                    ),
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
                              width: width * 0.88,
                              child: ListView(
                                padding: EdgeInsets.zero,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: width * 0.02,
                                      ),
                                      Container(
                                        height: height * 0.035,
                                        child: FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: Text(
                                            "Post Name",
                                            style: GoogleFonts.fredoka(
                                                color: blue,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: height * 0.062,
                                    width: width * 0.88,
                                    padding: EdgeInsets.only(
                                        left: width * 0.015,
                                        right: width * 0.015),
                                    decoration: BoxDecoration(
                                        color: backgroundColor,
                                        border: Border.all(
                                            color: blue, width: width * 0.015),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: height * 0.062,
                                          width: width * 0.82,
                                          child: TextField(
                                            controller: postNameTEC,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.only(
                                                  left: width * 0.0,
                                                  right: 0,
                                                  top: 0,
                                                  bottom: height * 0.006),
                                              hintText: " Enter Post Name",
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
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.003,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: width * 0.02,
                                      ),
                                      Container(
                                        height: height * 0.035,
                                        child: FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: Text(
                                            "Post Description",
                                            style: GoogleFonts.fredoka(
                                                color: blue,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: height * 0.2,
                                    width: width * 0.83,
                                    padding: EdgeInsets.all(width * 0.02),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                        color:
                                            blue, // Use Colors.orange for the orange color
                                        width: width * 0.015,
                                      ),
                                    ),
                                    child: TextField(
                                      maxLines: null,
                                      controller: postDescriptionTEC,
                                      textAlignVertical: TextAlignVertical.top,
                                      cursorColor: blue,
                                      decoration: InputDecoration(
                                        isCollapsed: true,
                                        hintText:
                                            "You can use this space to share your expertise, prerequisites for mentees, weekly availability, and any other relevant details.",
                                        hintMaxLines: 10,
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                        hintStyle: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15),
                                      ),
                                      style: TextStyle(
                                          color: blue,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.003,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: width * 0.02,
                                      ),
                                      Container(
                                        height: height * 0.035,
                                        child: FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: Text(
                                            "Image",
                                            style: GoogleFonts.fredoka(
                                                color: blue,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                      onTap: () {
                                        pickImage();
                                      },
                                      child: selectedImage == null
                                          ? Container(
                                              height: height * 0.08,
                                              width: width * 0.88,
                                              decoration: BoxDecoration(
                                                  color: blue,
                                                  border: Border.all(
                                                      color: darkblue,
                                                      width: width * 0.015),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: height * 0.048,
                                                    child: FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: ImageIcon(
                                                        AssetImage(
                                                            "assets/images/addImage.png"),
                                                        color: backgroundColor,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.01,
                                                  ),
                                                  Container(
                                                    height: height * 0.05,
                                                    child: FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: Text(
                                                        "Add Image",
                                                        style: GoogleFonts.fredoka(
                                                            color:
                                                                backgroundColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          : Container(
                                              width: width * 0.88,
                                              height: height * 0.2,
                                              child: Stack(children: [
                                                Container(
                                                  width: width * 0.88,
                                                  height: height * 0.2,
                                                  decoration: BoxDecoration(
                                                      color: blue,
                                                      border: Border.all(
                                                          color: darkblue,
                                                          width: width * 0.015),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      child: Image.file(
                                                        selectedImage!,
                                                        fit: BoxFit.cover,
                                                      )),
                                                ),
                                                Positioned(
                                                    bottom: width * 0.025,
                                                    right: width * 0.025,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      child: InkWell(
                                                        onTap: () {
                                                          pickImage();
                                                        },
                                                        child: Container(
                                                            height:
                                                                height * 0.035,
                                                            width: width * 0.35,
                                                            child: Stack(
                                                              children: [
                                                                BackdropFilter(
                                                                    filter: ImageFilter.blur(
                                                                        sigmaX:
                                                                            5,
                                                                        sigmaY:
                                                                            5),
                                                                    child:
                                                                        Container()),
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          border: Border.all(
                                                                              color: Colors.white.withOpacity(
                                                                                  0.15)),
                                                                          borderRadius: BorderRadius.circular(
                                                                              5),
                                                                          gradient: LinearGradient(
                                                                              begin: Alignment.topLeft,
                                                                              end: Alignment.bottomRight,
                                                                              colors: [
                                                                                Colors.white.withOpacity(0.15),
                                                                                Colors.white.withOpacity(0.05),
                                                                              ])),
                                                                ),
                                                                Center(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Container(
                                                                        height: height *
                                                                            0.024,
                                                                        child:
                                                                            FittedBox(
                                                                          fit: BoxFit
                                                                              .fitHeight,
                                                                          child:
                                                                              ImageIcon(
                                                                            AssetImage("assets/images/addImage.png"),
                                                                            color:
                                                                                backgroundColor,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width: width *
                                                                            0.01,
                                                                      ),
                                                                      Container(
                                                                        height: height *
                                                                            0.025,
                                                                        child:
                                                                            FittedBox(
                                                                          fit: BoxFit
                                                                              .fitHeight,
                                                                          child:
                                                                              Text(
                                                                            "Change Image",
                                                                            style:
                                                                                GoogleFonts.fredoka(color: backgroundColor, fontWeight: FontWeight.w600),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            )),
                                                      ),
                                                    ))
                                              ]),
                                            )),
                                  SizedBox(
                                    height: height * 0.003,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: width * 0.02,
                                      ),
                                      Container(
                                        height: height * 0.035,
                                        child: FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: Text(
                                            "Post Type",
                                            style: GoogleFonts.fredoka(
                                                color: blue,
                                                fontWeight: FontWeight.w700),
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
                                          isActive:
                                              thisPost.type == PostType.Other,
                                          imageAddress: "other",
                                          postName: "Other",
                                          onClickFunction: () {
                                            setState(() {
                                              thisPost.type = PostType.Other;
                                            });
                                          },
                                        ),
                                        PostTypeWidget(
                                          isActive: thisPost.type ==
                                              PostType.Tournament,
                                          imageAddress: "tournament",
                                          postName: "Tournament",
                                          onClickFunction: () {
                                            setState(() {
                                              thisPost.type =
                                                  PostType.Tournament;
                                            });
                                          },
                                        ),
                                        PostTypeWidget(
                                          isActive: thisPost.type ==
                                              PostType.Collaborate,
                                          imageAddress: "collaborate",
                                          postName: "Collaborate",
                                          onClickFunction: () {
                                            setState(() {
                                              thisPost.type =
                                                  PostType.Collaborate;
                                            });
                                          },
                                        ),
                                        PostTypeWidget(
                                          isActive: thisPost.type ==
                                              PostType.Volounteer,
                                          imageAddress: "volunteer",
                                          postName: "Volounteer",
                                          onClickFunction: () {
                                            setState(() {
                                              thisPost.type =
                                                  PostType.Volounteer;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  //! volunteer parameters
                                  thisPost.type == PostType.Volounteer
                                      ? Container(
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: height * 0.01,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: width * 0.02,
                                                  ),
                                                  Container(
                                                    height: height * 0.035,
                                                    child: FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: Text(
                                                        "Website Link : ",
                                                        style:
                                                            GoogleFonts.fredoka(
                                                                color: blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                height: height * 0.062,
                                                width: width * 0.88,
                                                padding: EdgeInsets.only(
                                                    left: width * 0.015,
                                                    right: width * 0.015),
                                                decoration: BoxDecoration(
                                                    color: backgroundColor,
                                                    border: Border.all(
                                                        color: blue,
                                                        width: width * 0.015),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: height * 0.062,
                                                      width: width * 0.82,
                                                      child: TextField(
                                                        controller:
                                                            volunteerWebsiteLinkTec,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  left: width *
                                                                      0.0,
                                                                  right: 0,
                                                                  top: 0,
                                                                  bottom:
                                                                      height *
                                                                          0.006),
                                                          hintText:
                                                              "Organization's Website Link",
                                                          hintStyle: GoogleFonts
                                                              .fredoka(
                                                                  color: blue,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 25),
                                                        ),
                                                        cursorHeight:
                                                            height * 0.036,
                                                        cursorWidth:
                                                            width * 0.01,
                                                        cursorColor: darkblue,
                                                        maxLines: 1,
                                                        style:
                                                            GoogleFonts.fredoka(
                                                                color: blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 25),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: height * 0.01),
                                              Container(
                                                  width: width * 0.87,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              height: height *
                                                                  0.038,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: width *
                                                                          0.035,
                                                                      top: width *
                                                                          0.02),
                                                              child: FittedBox(
                                                                fit: BoxFit
                                                                    .fitHeight,
                                                                child: Text(
                                                                  "Grade Limit : ",
                                                                  style: GoogleFonts
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
                                                            Container(
                                                              height: height *
                                                                  0.038,
                                                              margin: EdgeInsets.only(
                                                                  right: width *
                                                                      0.035,
                                                                  top: width *
                                                                      0.02),
                                                              child: FittedBox(
                                                                fit: BoxFit
                                                                    .fitHeight,
                                                                child: Text(
                                                                  (thisPost.grades!.lowerBound -
                                                                              thisPost
                                                                                  .grades!.upperBound ==
                                                                          -11)
                                                                      ? "All Grades"
                                                                      : thisPost
                                                                              .grades!
                                                                              .lowerBound
                                                                              .toString() +
                                                                          " - " +
                                                                          thisPost
                                                                              .grades!
                                                                              .upperBound
                                                                              .toString() +
                                                                          (thisPost.grades!.upperBound == 1
                                                                              ? "st"
                                                                              : thisPost.grades!.upperBound == 2
                                                                                  ? "nd"
                                                                                  : thisPost.grades!.upperBound == 3
                                                                                      ? "rd"
                                                                                      : "th") +
                                                                          " grade",
                                                                  style: GoogleFonts
                                                                      .fredoka(
                                                                    color: blue,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Stack(
                                                          children: [
                                                            Container(
                                                              height:
                                                                  height * 0.05,
                                                            ),
                                                            Positioned(
                                                              left: width *
                                                                  0.0325,
                                                              bottom: 0.05,
                                                              child: Container(
                                                                width: width *
                                                                    0.78,
                                                                child:
                                                                    SliderTheme(
                                                                  data: SliderThemeData(
                                                                      trackHeight:
                                                                          height *
                                                                              0.01,
                                                                      activeTickMarkColor:
                                                                          Colors
                                                                              .transparent,
                                                                      inactiveTickMarkColor:
                                                                          Colors
                                                                              .transparent,
                                                                      rangeTickMarkShape:
                                                                          RoundRangeSliderTickMarkShape(
                                                                              tickMarkRadius: 0)),
                                                                  child:
                                                                      RangeSlider(
                                                                    values: RangeValues(
                                                                        thisPost
                                                                            .grades!
                                                                            .lowerBound
                                                                            .toDouble(),
                                                                        thisPost
                                                                            .grades!
                                                                            .upperBound
                                                                            .toDouble()),
                                                                    onChanged:
                                                                        (newValue) {
                                                                      setState(
                                                                          () {
                                                                        thisPost.grades = Range(
                                                                            newValue.start.toInt(),
                                                                            newValue.end.toInt());
                                                                      });
                                                                    },
                                                                    divisions:
                                                                        11,
                                                                    min: 1,
                                                                    max: 12,
                                                                    activeColor:
                                                                        blue,
                                                                    inactiveColor:
                                                                        backgroundColor,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                                bottom: height *
                                                                    0.008,
                                                                left: width *
                                                                    0.026,
                                                                child:
                                                                    Container(
                                                                  height:
                                                                      height *
                                                                          0.038,
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .fitHeight,
                                                                    child: Text(
                                                                      "1",
                                                                      style: GoogleFonts.fredoka(
                                                                          color:
                                                                              blue,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    ),
                                                                  ),
                                                                )),
                                                            Positioned(
                                                                bottom: height *
                                                                    0.008,
                                                                right: width *
                                                                    0.012,
                                                                child:
                                                                    Container(
                                                                  height:
                                                                      height *
                                                                          0.038,
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .fitHeight,
                                                                    child: Text(
                                                                      "12",
                                                                      style: GoogleFonts.fredoka(
                                                                          color:
                                                                              blue,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    ),
                                                                  ),
                                                                ))
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              height * 0.005,
                                                        ),
                                                      ])),
                                              SizedBox(
                                                height: height * 0.01,
                                              ),
                                              Container(
                                                  width: width * 0.87,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              height: height *
                                                                  0.038,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: width *
                                                                          0.035,
                                                                      top: width *
                                                                          0.02),
                                                              child: FittedBox(
                                                                fit: BoxFit
                                                                    .fitHeight,
                                                                child: Text(
                                                                  "Time : ",
                                                                  style: GoogleFonts
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
                                                            fromTimeChosen &&
                                                                    toTimeChosen
                                                                ? Container(
                                                                    height:
                                                                        height *
                                                                            0.038,
                                                                    margin: EdgeInsets.only(
                                                                        right: width *
                                                                            0.035,
                                                                        top: width *
                                                                            0.02),
                                                                    child:
                                                                        FittedBox(
                                                                      fit: BoxFit
                                                                          .fitHeight,
                                                                      child:
                                                                          Text(
                                                                        (thisPost.volunteerToTime.hour + thisPost.volunteerToTime.minute / 60) - (thisPost.volunteerFromTime.hour + thisPost.volunteerFromTime.minute / 60) <
                                                                                1
                                                                            ? "<1 Hour"
                                                                            : ((thisPost.volunteerToTime.hour + thisPost.volunteerToTime.minute / 60) - (thisPost.volunteerFromTime.hour + thisPost.volunteerFromTime.minute / 60)).toInt() == 1
                                                                                ? "1 Hour"
                                                                                : ((thisPost.volunteerToTime.hour + thisPost.volunteerToTime.minute / 60) - (thisPost.volunteerFromTime.hour + thisPost.volunteerFromTime.minute / 60)).toInt().toString() + " Hours",
                                                                        style: GoogleFonts
                                                                            .fredoka(
                                                                          color:
                                                                              blue,
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Container()
                                                          ],
                                                        ),
                                                        SizedBox(
                                                            height:
                                                                height * 0.005),
                                                        Container(
                                                          height: height * 0.04,
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                fromTimeChosen
                                                                    ? InkWell(
                                                                        onTap:
                                                                            () {
                                                                          pickTime(
                                                                              false);
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              height * 0.04,
                                                                          child: FittedBox(
                                                                              fit: BoxFit.fitHeight,
                                                                              child: Text(thisPost.volunteerFromTime.format(context).toString(), style: GoogleFonts.fredoka(color: blue, fontWeight: FontWeight.w600))),
                                                                        ),
                                                                      )
                                                                    : InkWell(
                                                                        onTap:
                                                                            () {
                                                                          pickTime(
                                                                              false);
                                                                        },
                                                                        child: Container(
                                                                            height: height * 0.04,
                                                                            width: width * 0.325,
                                                                            decoration: BoxDecoration(color: blue, border: Border.all(color: darkblue, width: width * 0.01), borderRadius: BorderRadius.circular(5)),
                                                                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                              Container(
                                                                                  height: height * 0.02,
                                                                                  child: FittedBox(
                                                                                      fit: BoxFit.fitHeight,
                                                                                      child: ImageIcon(
                                                                                          AssetImage(
                                                                                            "assets/images/time.png",
                                                                                          ),
                                                                                          color: backgroundColor))),
                                                                              SizedBox(width: width * 0.01),
                                                                              Container(height: height * 0.03, child: FittedBox(fit: BoxFit.fitHeight, child: Text("From Time", style: GoogleFonts.fredoka(color: backgroundColor, fontWeight: FontWeight.w700))))
                                                                            ])),
                                                                      ),
                                                                Container(
                                                                    width:
                                                                        width *
                                                                            0.05,
                                                                    margin: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            height *
                                                                                0.015,
                                                                        horizontal:
                                                                            width *
                                                                                0.01),
                                                                    decoration: BoxDecoration(
                                                                        color:
                                                                            blue,
                                                                        borderRadius:
                                                                            BorderRadius.circular(4))),
                                                                toTimeChosen
                                                                    ? InkWell(
                                                                        onTap:
                                                                            () {
                                                                          pickTime(
                                                                              true);
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              height * 0.04,
                                                                          child: FittedBox(
                                                                              fit: BoxFit.fitHeight,
                                                                              child: Text(thisPost.volunteerToTime.format(context).toString(), style: GoogleFonts.fredoka(color: blue, fontWeight: FontWeight.w600))),
                                                                        ),
                                                                      )
                                                                    : InkWell(
                                                                        onTap:
                                                                            () {
                                                                          pickTime(
                                                                              true);
                                                                        },
                                                                        child: Container(
                                                                            height: height * 0.04,
                                                                            width: width * 0.325,
                                                                            decoration: BoxDecoration(color: blue, border: Border.all(color: darkblue, width: width * 0.01), borderRadius: BorderRadius.circular(5)),
                                                                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                              Container(
                                                                                  height: height * 0.02,
                                                                                  child: FittedBox(
                                                                                      fit: BoxFit.fitHeight,
                                                                                      child: ImageIcon(
                                                                                          AssetImage(
                                                                                            "assets/images/time.png",
                                                                                          ),
                                                                                          color: backgroundColor))),
                                                                              SizedBox(width: width * 0.01),
                                                                              Container(height: height * 0.03, child: FittedBox(fit: BoxFit.fitHeight, child: Text("To Time", style: GoogleFonts.fredoka(color: backgroundColor, fontWeight: FontWeight.w700))))
                                                                            ])),
                                                                      )
                                                              ]),
                                                        ),
                                                        SizedBox(
                                                            height:
                                                                height * 0.015),
                                                      ])),
                                              SizedBox(
                                                height: height * 0.01,
                                              ),
                                              Container(
                                                  width: width * 0.87,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              height: height *
                                                                  0.038,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: width *
                                                                          0.035,
                                                                      top: width *
                                                                          0.02),
                                                              child: FittedBox(
                                                                fit: BoxFit
                                                                    .fitHeight,
                                                                child: Text(
                                                                  "Date : ",
                                                                  style: GoogleFonts
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
                                                            datePickedForVolunteer
                                                                ? InkWell(
                                                                    onTap: () {
                                                                      pickDate();
                                                                    },
                                                                    child: Container(
                                                                        margin: EdgeInsets.only(
                                                                            top: height *
                                                                                0.008),
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal: width *
                                                                                0.015),
                                                                        height: height *
                                                                            0.038,
                                                                        child: FittedBox(
                                                                            fit:
                                                                                BoxFit.fitHeight,
                                                                            child: Text(DateFormat('MM-dd-yyyy').format(thisPost.volunteerDate!), style: GoogleFonts.fredoka(color: blue, fontWeight: FontWeight.w700)))))
                                                                : InkWell(
                                                                    onTap: () {
                                                                      pickDate();
                                                                    },
                                                                    child: Container(
                                                                        margin: EdgeInsets.only(top: height * 0.008),
                                                                        padding: EdgeInsets.symmetric(horizontal: width * 0.015),
                                                                        height: height * 0.038,
                                                                        decoration: BoxDecoration(color: blue, border: Border.all(color: darkblue, width: width * 0.01), borderRadius: BorderRadius.circular(5)),
                                                                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                          Container(
                                                                              height: height * 0.018,
                                                                              child: FittedBox(
                                                                                  fit: BoxFit.fitHeight,
                                                                                  child: ImageIcon(
                                                                                      AssetImage(
                                                                                        "assets/images/calendar.png",
                                                                                      ),
                                                                                      color: backgroundColor))),
                                                                          SizedBox(
                                                                              width: width * 0.01),
                                                                          Container(
                                                                              height: height * 0.029,
                                                                              child: FittedBox(fit: BoxFit.fitHeight, child: Text("Pick Date", style: GoogleFonts.fredoka(color: backgroundColor, fontWeight: FontWeight.w700)))),
                                                                        ])),
                                                                  ),
                                                            SizedBox(
                                                                width: width *
                                                                    0.015)
                                                          ],
                                                        ),
                                                        SizedBox(
                                                            height:
                                                                height * 0.008),
                                                      ])),
                                              SizedBox(
                                                height: height * 0.01,
                                              ),
                                              Container(
                                                  width: width * 0.87,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              height: height *
                                                                  0.038,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: width *
                                                                          0.035,
                                                                      top: width *
                                                                          0.02),
                                                              child: FittedBox(
                                                                fit: BoxFit
                                                                    .fitHeight,
                                                                child: Text(
                                                                  "Volunteer Field : ",
                                                                  style: GoogleFonts
                                                                      .fredoka(
                                                                    color: blue,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                            height:
                                                                height * 0.008),
                                                        Container(
                                                          width: width * 0.88,
                                                          height: height * 0.13,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      width *
                                                                          0.02),
                                                          child: ListView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            padding:
                                                                EdgeInsets.zero,
                                                            children: [
                                                              ...subjectList
                                                                  .map((e) {
                                                                return InkWell(
                                                                  onTap: () {
                                                                    if (thisPost
                                                                        .volunteerTopicsContains(
                                                                            e))
                                                                      thisPost
                                                                          .removeVolunteerTopics(
                                                                              e);
                                                                    else
                                                                      thisPost
                                                                          .volunteerTopics
                                                                          .add(
                                                                              e);
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  child:
                                                                      AnimatedContainer(
                                                                    duration: Duration(
                                                                        milliseconds:
                                                                            50),
                                                                    height:
                                                                        height *
                                                                            0.08,
                                                                    width:
                                                                        height *
                                                                            0.12,
                                                                    margin: EdgeInsets.only(
                                                                        right: width *
                                                                            0.015),
                                                                    decoration: BoxDecoration(
                                                                        color: thisPost.volunteerTopicsContains(e)
                                                                            ? blue
                                                                            : backgroundColor,
                                                                        border: Border.all(
                                                                            color: thisPost.volunteerTopicsContains(e)
                                                                                ? darkblue.withOpacity(
                                                                                    0.5)
                                                                                : darkGrey,
                                                                            width: width *
                                                                                0.015),
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10))),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        SizedBox(
                                                                          height:
                                                                              height * 0.0125,
                                                                        ),
                                                                        Container(
                                                                          height:
                                                                              height * 0.06,
                                                                          child:
                                                                              FittedBox(
                                                                            fit:
                                                                                BoxFit.fitHeight,
                                                                            child:
                                                                                ImageIcon(
                                                                              AssetImage(e.image),
                                                                              color: thisPost.volunteerTopicsContains(e) ? backgroundColor : darkGrey,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                            child:
                                                                                Container()),
                                                                        Container(
                                                                          width:
                                                                              height * 0.1,
                                                                          child:
                                                                              Text(
                                                                            e.clubTypeString == "none"
                                                                                ? e.clubType.toReadableString().substring(9)
                                                                                : e.clubTypeString.replaceAll("_", " "),
                                                                            maxLines:
                                                                                2,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: GoogleFonts.fredoka(
                                                                                color: thisPost.volunteerTopicsContains(e) ? backgroundColor : darkGrey,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: (e.clubTypeString == "none" ? e.clubType.toReadableString().substring(9) : e.clubTypeString.replaceAll("_", " ")).length > 8 ? 16 : 20,
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
                                                        SizedBox(
                                                            height:
                                                                height * 0.008),
                                                      ])),
                                              SizedBox(
                                                height: height * 0.01,
                                              ),
                                              Container(
                                                  width: width * 0.87,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            InkWell(
                                                              onTap : () async {
                                                                //await performGeoCoding(thisPost.volunteerLocation.address);
                                                              },
                                                              child: Container(
                                                                height: height *
                                                                    0.038,
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left: width *
                                                                            0.035,
                                                                        top: width *
                                                                            0.02),
                                                                child: FittedBox(
                                                                  fit: BoxFit
                                                                      .fitHeight,
                                                                  child: Text(
                                                                    "Location : ",
                                                                    style: GoogleFonts
                                                                        .fredoka(
                                                                      color: blue,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                                child:
                                                                    Container()),
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() => thisPost
                                                                    .volunteerLocation
                                                                    .isVirtual = true);
                                                              },
                                                              child:
                                                                  AnimatedContainer(
                                                                      duration: Duration(
                                                                          milliseconds:
                                                                              150),
                                                                      margin: EdgeInsets.only(
                                                                          top: height *
                                                                              0.008),
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal: width *
                                                                              0.015),
                                                                      height: height *
                                                                          0.038,
                                                                      decoration: BoxDecoration(
                                                                          color: thisPost.volunteerLocation.isVirtual
                                                                              ? blue
                                                                              : Colors
                                                                                  .grey.shade200,
                                                                          border: Border.all(
                                                                              color: thisPost.volunteerLocation.isVirtual ? darkblue : const Color.fromARGB(255, 212, 211, 211),
                                                                              width: width * 0.01),
                                                                          borderRadius: BorderRadius.circular(5)),
                                                                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                        Container(
                                                                          height: height *0.029,
                                                                          child: FittedBox(
                                                                            fit: BoxFit.fitHeight,
                                                                            child: Text(
                                                                              "Virtual",
                                                                              textAlign : TextAlign.center,
                                                                              style: GoogleFonts.fredoka(color: thisPost.volunteerLocation.isVirtual ? backgroundColor : Colors.grey.shade400, fontWeight: FontWeight.w700)
                                                                            )
                                                                          )
                                                                        ),
                                                                      ])),
                                                            ),
                                                            SizedBox(
                                                                width: width *
                                                                    0.015),
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() => thisPost
                                                                    .volunteerLocation
                                                                    .isVirtual = false);
                                                              },
                                                              child:
                                                                  AnimatedContainer(
                                                                      duration: Duration(
                                                                          milliseconds:
                                                                              150),
                                                                      margin: EdgeInsets.only(
                                                                          top: height *
                                                                              0.008),
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal: width *
                                                                              0.015),
                                                                      height: height *
                                                                          0.038,
                                                                      decoration: BoxDecoration(
                                                                          color: !thisPost.volunteerLocation.isVirtual
                                                                              ? blue
                                                                              : Colors
                                                                                  .grey.shade200,
                                                                          border: Border.all(
                                                                              color: !thisPost.volunteerLocation.isVirtual ? darkblue : const Color.fromARGB(255, 212, 211, 211),
                                                                              width: width * 0.01),
                                                                          borderRadius: BorderRadius.circular(5)),
                                                                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                        Container(
                                                                            height: height *
                                                                                0.029,
                                                                            child:
                                                                                FittedBox(fit: BoxFit.fitHeight, child: Text("In-Person", style: GoogleFonts.fredoka(color: !thisPost.volunteerLocation.isVirtual ? backgroundColor : Colors.grey.shade400, fontWeight: FontWeight.w700)))),
                                                                      ])),
                                                            ),
                                                            SizedBox(
                                                                width: width *
                                                                    0.015)
                                                          ],
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            toggleBlackScreen();
                                                            toggleShowSearchLocationVolunteerScreen();
                                                          },
                                                          child:
                                                              AnimatedContainer(
                                                                duration: Duration(
                                                                    milliseconds:
                                                                        300),
                                                                height: thisPost.volunteerLocation.isVirtual
                                                                    ? height * 0
                                                                    : height * 0.08,
                                                                child: thisPost.volunteerLocation.isVirtual
                                                                    ? Container()
                                                                    : Container(
                                                                        width: width * 0.83,
                                                                        margin: EdgeInsets.only(
                                                                            top: height *
                                                                                0.005,
                                                                            bottom: height *
                                                                                0.002,
                                                                            left: width *
                                                                                0.02,
                                                                            right: width *
                                                                                0.02),
                                                                        decoration: BoxDecoration(
                                                                            color: blue,
                                                                            border: Border.all(color: darkblue, width: width * 0.015),
                                                                            borderRadius: BorderRadius.circular(10)),
                                                                        child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: thisPost.volunteerLocation.address.isEmpty
                                                                                ? [
                                                                                    Container(height: height * 0.035, child: FittedBox(fit: BoxFit.fitHeight, child: ImageIcon(AssetImage("assets/images/place.png"), color: backgroundColor))),
                                                                                    Container(
                                                                                        height: height * 0.045,
                                                                                        margin: EdgeInsets.only(left: width * 0.02),
                                                                                        child: FittedBox(
                                                                                            fit: BoxFit.fitHeight,
                                                                                            child: Text("Pick Location",
                                                                                                style: GoogleFonts.fredoka(
                                                                                                  color: backgroundColor,
                                                                                                  fontWeight: FontWeight.w600,
                                                                                                ))))
                                                                                  ]
                                                                                : [
                                                                                    Container(width: width * 0.75, child: Text(thisPost.volunteerLocation.address, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.fredoka(color: backgroundColor, fontWeight: FontWeight.w600, fontSize: 19.5, height: 1.1)))
                                                                                  ]
                                                              )
                                                            )
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height:
                                                                height * 0.008),
                                                      ])),
                                              SizedBox(
                                                height: height * 0.006,
                                              ),
                                            ],
                                          ),
                                        )
                                        // tournament post
                                      : thisPost.type == PostType.Tournament
                                          ? Container(
                                              child: Column(children: [
                                              SizedBox(
                                                height: height * 0.01,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: width * 0.02,
                                                  ),
                                                  Container(
                                                    height: height * 0.035,
                                                    child: FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: Text(
                                                        "Website Link : ",
                                                        style:
                                                            GoogleFonts.fredoka(
                                                                color: blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                height: height * 0.062,
                                                width: width * 0.88,
                                                padding: EdgeInsets.only(
                                                    left: width * 0.015,
                                                    right: width * 0.015),
                                                decoration: BoxDecoration(
                                                    color: backgroundColor,
                                                    border: Border.all(
                                                        color: blue,
                                                        width: width * 0.015),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: height * 0.062,
                                                      width: width * 0.82,
                                                      child: TextField(
                                                        controller:
                                                            tournamentWebsiteLinkTec,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  left: width *
                                                                      0.0,
                                                                  right: 0,
                                                                  top: 0,
                                                                  bottom:
                                                                      height *
                                                                          0.006),
                                                          hintText:
                                                              "Tournament's Website Link",
                                                          hintStyle: GoogleFonts
                                                              .fredoka(
                                                                  color: blue,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 25),
                                                        ),
                                                        cursorHeight:
                                                            height * 0.036,
                                                        cursorWidth:
                                                            width * 0.01,
                                                        cursorColor: darkblue,
                                                        maxLines: 1,
                                                        style:
                                                            GoogleFonts.fredoka(
                                                                color: blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 25),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: height * 0.01),
                                              Container(
                                                  width: width * 0.87,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              height: height *
                                                                  0.038,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: width *
                                                                          0.035,
                                                                      top: width *
                                                                          0.02),
                                                              child: FittedBox(
                                                                fit: BoxFit
                                                                    .fitHeight,
                                                                child: Text(
                                                                  "Grade Limit : ",
                                                                  style: GoogleFonts
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
                                                            Container(
                                                              height: height *
                                                                  0.038,
                                                              margin: EdgeInsets.only(
                                                                  right: width *
                                                                      0.035,
                                                                  top: width *
                                                                      0.02),
                                                              child: FittedBox(
                                                                fit: BoxFit
                                                                    .fitHeight,
                                                                child: Text(
                                                                  (thisPost.tournamentGradeLimit!.lowerBound -
                                                                              thisPost
                                                                                  .tournamentGradeLimit!.upperBound ==
                                                                          -11)
                                                                      ? "All Grades"
                                                                      : thisPost
                                                                              .tournamentGradeLimit!
                                                                              .lowerBound
                                                                              .toString() +
                                                                          " - " +
                                                                          thisPost
                                                                              .tournamentGradeLimit!
                                                                              .upperBound
                                                                              .toString() +
                                                                          (thisPost.tournamentGradeLimit!.upperBound == 1
                                                                              ? "st"
                                                                              : thisPost.tournamentGradeLimit!.upperBound == 2
                                                                                  ? "nd"
                                                                                  : thisPost.tournamentGradeLimit!.upperBound == 3
                                                                                      ? "rd"
                                                                                      : "th") +
                                                                          " grade",
                                                                  style: GoogleFonts
                                                                      .fredoka(
                                                                    color: blue,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Stack(
                                                          children: [
                                                            Container(
                                                              height:
                                                                  height * 0.05,
                                                            ),
                                                            Positioned(
                                                              left: width *
                                                                  0.0325,
                                                              bottom: 0.05,
                                                              child: Container(
                                                                width: width *
                                                                    0.78,
                                                                child:
                                                                    SliderTheme(
                                                                  data: SliderThemeData(
                                                                      trackHeight:
                                                                          height *
                                                                              0.01,
                                                                      activeTickMarkColor:
                                                                          Colors
                                                                              .transparent,
                                                                      inactiveTickMarkColor:
                                                                          Colors
                                                                              .transparent,
                                                                      rangeTickMarkShape:
                                                                          RoundRangeSliderTickMarkShape(
                                                                              tickMarkRadius: 0)),
                                                                  child:
                                                                      RangeSlider(
                                                                    values: RangeValues(
                                                                        thisPost
                                                                            .tournamentGradeLimit!
                                                                            .lowerBound
                                                                            .toDouble(),
                                                                        thisPost
                                                                            .tournamentGradeLimit!
                                                                            .upperBound
                                                                            .toDouble()),
                                                                    onChanged:
                                                                        (newValue) {
                                                                      setState(
                                                                          () {
                                                                        thisPost.tournamentGradeLimit = Range(
                                                                            newValue.start.toInt(),
                                                                            newValue.end.toInt());
                                                                      });
                                                                    },
                                                                    divisions:
                                                                        11,
                                                                    min: 1,
                                                                    max: 12,
                                                                    activeColor:
                                                                        blue,
                                                                    inactiveColor:
                                                                        backgroundColor,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                                bottom: height *
                                                                    0.008,
                                                                left: width *
                                                                    0.026,
                                                                child:
                                                                    Container(
                                                                  height:
                                                                      height *
                                                                          0.038,
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .fitHeight,
                                                                    child: Text(
                                                                      "1",
                                                                      style: GoogleFonts.fredoka(
                                                                          color:
                                                                              blue,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    ),
                                                                  ),
                                                                )),
                                                            Positioned(
                                                                bottom: height *
                                                                    0.008,
                                                                right: width *
                                                                    0.012,
                                                                child:
                                                                    Container(
                                                                  height:
                                                                      height *
                                                                          0.038,
                                                                  child:
                                                                      FittedBox(
                                                                    fit: BoxFit
                                                                        .fitHeight,
                                                                    child: Text(
                                                                      "12",
                                                                      style: GoogleFonts.fredoka(
                                                                          color:
                                                                              blue,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    ),
                                                                  ),
                                                                ))
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              height * 0.005,
                                                        ),
                                                        
                                                     
                                                      ]
                                                    )
                                                  ),
                                                  SizedBox(height : height * 0.008), 
                                                  Container(
                                                  width: width * 0.87,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              height: height *
                                                                  0.038,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: width *
                                                                          0.035,
                                                                      top: width *
                                                                          0.02),
                                                              child: FittedBox(
                                                                fit: BoxFit
                                                                    .fitHeight,
                                                                child: Text(
                                                                  "Location : ",
                                                                  style: GoogleFonts
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
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() => thisPost
                                                                    .volunteerLocation
                                                                    .isVirtual = true);
                                                              },
                                                              child:
                                                                  AnimatedContainer(
                                                                      duration: Duration(
                                                                          milliseconds:
                                                                              150),
                                                                      margin: EdgeInsets.only(
                                                                          top: height *
                                                                              0.008),
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal: width *
                                                                              0.015),
                                                                      height: height *
                                                                          0.038,
                                                                      decoration: BoxDecoration(
                                                                          color: thisPost.volunteerLocation.isVirtual
                                                                              ? blue
                                                                              : Colors
                                                                                  .grey.shade200,
                                                                          border: Border.all(
                                                                              color: thisPost.volunteerLocation.isVirtual ? darkblue : const Color.fromARGB(255, 212, 211, 211),
                                                                              width: width * 0.01),
                                                                          borderRadius: BorderRadius.circular(5)),
                                                                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                        Container(
                                                                            height: height *
                                                                                0.029,
                                                                            child:
                                                                                FittedBox(fit: BoxFit.fitHeight, child: Text("Virtual", style: GoogleFonts.fredoka(color: thisPost.volunteerLocation.isVirtual ? backgroundColor : Colors.grey.shade400, fontWeight: FontWeight.w700)))),
                                                                      ])),
                                                            ),
                                                            SizedBox(
                                                                width: width *
                                                                    0.015),
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() => thisPost
                                                                    .volunteerLocation
                                                                    .isVirtual = false);
                                                              },
                                                              child:
                                                                  AnimatedContainer(
                                                                      duration: Duration(
                                                                          milliseconds:
                                                                              150),
                                                                      margin: EdgeInsets.only(
                                                                          top: height *
                                                                              0.008),
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal: width *
                                                                              0.015),
                                                                      height: height *
                                                                          0.038,
                                                                      decoration: BoxDecoration(
                                                                          color: !thisPost.volunteerLocation.isVirtual
                                                                              ? blue
                                                                              : Colors
                                                                                  .grey.shade200,
                                                                          border: Border.all(
                                                                              color: !thisPost.volunteerLocation.isVirtual ? darkblue : const Color.fromARGB(255, 212, 211, 211),
                                                                              width: width * 0.01),
                                                                          borderRadius: BorderRadius.circular(5)),
                                                                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                        Container(
                                                                            height: height *
                                                                                0.029,
                                                                            child:
                                                                                FittedBox(fit: BoxFit.fitHeight, child: Text("In-Person", style: GoogleFonts.fredoka(color: !thisPost.volunteerLocation.isVirtual ? backgroundColor : Colors.grey.shade400, fontWeight: FontWeight.w700)))),
                                                                      ])),
                                                            ),
                                                            SizedBox(
                                                                width: width *
                                                                    0.015)
                                                          ],
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            toggleBlackScreen();
                                                            toggleShowSearchLocationTournamentScreen();
                                                          },
                                                          child:
                                                              AnimatedContainer(
                                                                duration: Duration(
                                                                    milliseconds:
                                                                        300),
                                                                height: thisPost.volunteerLocation.isVirtual
                                                                    ? height * 0
                                                                    : height * 0.08,
                                                                child: thisPost.volunteerLocation.isVirtual
                                                                    ? Container()
                                                                    : Container(
                                                                        width: width * 0.83,
                                                                        margin: EdgeInsets.only(
                                                                            top: height *
                                                                                0.005,
                                                                            bottom: height *
                                                                                0.002,
                                                                            left: width *
                                                                                0.02,
                                                                            right: width *
                                                                                0.02),
                                                                        decoration: BoxDecoration(
                                                                            color: blue,
                                                                            border: Border.all(color: darkblue, width: width * 0.015),
                                                                            borderRadius: BorderRadius.circular(10)),
                                                                        child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: thisPost.tournamentLocation.address.isEmpty
                                                                                ? [
                                                                                    Container(height: height * 0.035, child: FittedBox(fit: BoxFit.fitHeight, child: ImageIcon(AssetImage("assets/images/place.png"), color: backgroundColor))),
                                                                                    Container(
                                                                                        height: height * 0.045,
                                                                                        margin: EdgeInsets.only(left: width * 0.02),
                                                                                        child: FittedBox(
                                                                                            fit: BoxFit.fitHeight,
                                                                                            child: Text("Pick Location",
                                                                                                style: GoogleFonts.fredoka(
                                                                                                  color: backgroundColor,
                                                                                                  fontWeight: FontWeight.w600,
                                                                                                ))))
                                                                                  ]
                                                                                : [
                                                                                    Container(width: width * 0.75, child: Text(thisPost.tournamentLocation.address,textAlign: TextAlign.center,maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.fredoka(color: backgroundColor, fontWeight: FontWeight.w600, fontSize: 19.5, height: 1.1)))
                                                                                  ]
                                                              )
                                                            )
                                                          ),
                                                        ),
                                                        
                                                        SizedBox(
                                                            height:
                                                                height * 0.008),
                                                      ])),
                                              SizedBox(
                                                height: height * 0.01,
                                              ),
                                              Container(
                                                width: width * 0.87,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10)),
                                                ),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            height: height *
                                                                0.038,
                                                            margin: EdgeInsets
                                                                .only(
                                                                    left: width *
                                                                        0.035,
                                                                    top: width *
                                                                        0.02),
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                              child: Text(
                                                                "Date : ",
                                                                style: GoogleFonts
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
                                                          datePickedForTournament
                                                              ? InkWell(
                                                                  onTap: () {
                                                                    pickDateTournament();
                                                                  },
                                                                  child: Container(
                                                                      margin: EdgeInsets.only(
                                                                          top: height *
                                                                              0.008),
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal: width *
                                                                              0.015),
                                                                      height: height *
                                                                          0.038,
                                                                      child: FittedBox(
                                                                          fit:
                                                                              BoxFit.fitHeight,
                                                                          child: Text(DateFormat('MM-dd-yyyy').format(thisPost.tournamentDate!), style: GoogleFonts.fredoka(color: blue, fontWeight: FontWeight.w700)))))
                                                              : InkWell(
                                                                  onTap: () {
                                                                    pickDateTournament();
                                                                  },
                                                                  child: Container(
                                                                      margin: EdgeInsets.only(top: height * 0.008),
                                                                      padding: EdgeInsets.symmetric(horizontal: width * 0.015),
                                                                      height: height * 0.038,
                                                                      decoration: BoxDecoration(color: blue, border: Border.all(color: darkblue, width: width * 0.01), borderRadius: BorderRadius.circular(5)),
                                                                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                        Container(
                                                                            height: height * 0.018,
                                                                            child: FittedBox(
                                                                                fit: BoxFit.fitHeight,
                                                                                child: ImageIcon(
                                                                                    AssetImage(
                                                                                      "assets/images/calendar.png",
                                                                                    ),
                                                                                    color: backgroundColor))),
                                                                        SizedBox(
                                                                            width: width * 0.01),
                                                                        Container(
                                                                            height: height * 0.029,
                                                                            child: FittedBox(fit: BoxFit.fitHeight, child: Text("Pick Date", style: GoogleFonts.fredoka(color: backgroundColor, fontWeight: FontWeight.w700)))),
                                                                      ])),
                                                                ),
                                                          SizedBox(
                                                              width: width *
                                                                  0.015)
                                                        ],
                                                      ),
                                                      SizedBox(
                                                          height:
                                                              height * 0.008),
                                                    ]
                                                  )
                                                ),
                                              SizedBox(
                                                height : height * 0.01
                                              ),
                                              Container(
                                                  width: width * 0.87,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              height: height *
                                                                  0.038,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: width *
                                                                          0.035,
                                                                      top: width *
                                                                          0.02),
                                                              child: FittedBox(
                                                                fit: BoxFit
                                                                    .fitHeight,
                                                                child: Text(
                                                                  "Tournament Field : ",
                                                                  style: GoogleFonts
                                                                      .fredoka(
                                                                    color: blue,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                            height:
                                                                height * 0.008),
                                                        Container(
                                                          width: width * 0.88,
                                                          height: height * 0.13,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      width *
                                                                          0.02),
                                                          child: ListView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            padding:
                                                                EdgeInsets.zero,
                                                            children: [
                                                              ...subjectList
                                                                  .map((e) {
                                                                return InkWell(
                                                                  onTap: () {
                                                                    if (thisPost
                                                                        .volunteerTopicsContainsTournament(
                                                                            e))
                                                                      thisPost
                                                                          .removeVolunteerTopicsTournament(
                                                                              e);
                                                                    else
                                                                      thisPost
                                                                          .tournamentTopics
                                                                          .add(
                                                                              e);
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  child:
                                                                      AnimatedContainer(
                                                                    duration: Duration(
                                                                        milliseconds:
                                                                            50),
                                                                    height:
                                                                        height *
                                                                            0.08,
                                                                    width:
                                                                        height *
                                                                            0.12,
                                                                    margin: EdgeInsets.only(
                                                                        right: width *
                                                                            0.015),
                                                                    decoration: BoxDecoration(
                                                                        color: thisPost.volunteerTopicsContainsTournament(e)
                                                                            ? blue
                                                                            : backgroundColor,
                                                                        border: Border.all(
                                                                            color: thisPost.volunteerTopicsContainsTournament(e)
                                                                                ? darkblue.withOpacity(
                                                                                    0.5)
                                                                                : darkGrey,
                                                                            width: width *
                                                                                0.015),
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10))),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        SizedBox(
                                                                          height:
                                                                              height * 0.0125,
                                                                        ),
                                                                        Container(
                                                                          height:
                                                                              height * 0.06,
                                                                          child:
                                                                              FittedBox(
                                                                            fit:
                                                                                BoxFit.fitHeight,
                                                                            child:
                                                                                ImageIcon(
                                                                              AssetImage(e.image),
                                                                              color: thisPost.volunteerTopicsContainsTournament(e) ? backgroundColor : darkGrey,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                            child:
                                                                                Container()),
                                                                        Container(
                                                                          width:
                                                                              height * 0.1,
                                                                          child:
                                                                              Text(
                                                                            e.clubTypeString == "none"
                                                                                ? e.clubType.toReadableString().substring(9)
                                                                                : e.clubTypeString.replaceAll("_", " "),
                                                                            maxLines:
                                                                                2,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: GoogleFonts.fredoka(
                                                                                color: thisPost.volunteerTopicsContainsTournament(e) ? backgroundColor : darkGrey,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: (e.clubTypeString == "none" ? e.clubType.toReadableString().substring(9) : e.clubTypeString.replaceAll("_", " ")).length > 8 ? 16 : 20,
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
                                                        SizedBox(
                                                            height:
                                                                height * 0.008),
                                                      ])),
                                            ]
                                          )
                                        ):
                                        thisPost.type == PostType.Collaborate ?Container(
                                          child : Column(
                                            children : [
                                              SizedBox(
                                                height: height * 0.01,
                                              ),
                                              Container(
                                                  width: width * 0.87,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              height: height *
                                                                  0.038,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: width *
                                                                          0.035,
                                                                      top: width *
                                                                          0.02),
                                                              child: FittedBox(
                                                                fit: BoxFit
                                                                    .fitHeight,
                                                                child: Text(
                                                                  "Collaboration Field : ",
                                                                  style: GoogleFonts
                                                                      .fredoka(
                                                                    color: blue,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                            height:
                                                                height * 0.008),
                                                        Container(
                                                          width: width * 0.88,
                                                          height: height * 0.13,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      width *
                                                                          0.02),
                                                          child: ListView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            padding:
                                                                EdgeInsets.zero,
                                                            children: [
                                                              ...subjectList
                                                                  .map((e) {
                                                                return InkWell(
                                                                  onTap: () {
                                                                    if (thisPost
                                                                        .collaborationTopicsContains(
                                                                            e))
                                                                      thisPost
                                                                          .removeVolunteerTopicsCollaboration(
                                                                              e);
                                                                    else
                                                                      thisPost
                                                                          .collaborationTopic
                                                                          .add(
                                                                              e);
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  child:
                                                                      AnimatedContainer(
                                                                    duration: Duration(
                                                                        milliseconds:
                                                                            50),
                                                                    height:
                                                                        height *
                                                                            0.08,
                                                                    width:
                                                                        height *
                                                                            0.12,
                                                                    margin: EdgeInsets.only(
                                                                        right: width *
                                                                            0.015),
                                                                    decoration: BoxDecoration(
                                                                        color: thisPost.collaborationTopicsContains(e)
                                                                            ? blue
                                                                            : backgroundColor,
                                                                        border: Border.all(
                                                                            color: thisPost.collaborationTopicsContains(e)
                                                                                ? darkblue.withOpacity(
                                                                                    0.5)
                                                                                : darkGrey,
                                                                            width: width *
                                                                                0.015),
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10))),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        SizedBox(
                                                                          height:
                                                                              height * 0.0125,
                                                                        ),
                                                                        Container(
                                                                          height:
                                                                              height * 0.06,
                                                                          child:
                                                                              FittedBox(
                                                                            fit:
                                                                                BoxFit.fitHeight,
                                                                            child:
                                                                                ImageIcon(
                                                                              AssetImage(e.image),
                                                                              color: thisPost.collaborationTopicsContains(e) ? backgroundColor : darkGrey,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                            child:
                                                                                Container()),
                                                                        Container(
                                                                          width:
                                                                              height * 0.1,
                                                                          child:
                                                                              Text(
                                                                            e.clubTypeString == "none"
                                                                                ? e.clubType.toReadableString().substring(9)
                                                                                : e.clubTypeString.replaceAll("_", " "),
                                                                            maxLines:
                                                                                2,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: GoogleFonts.fredoka(
                                                                                color: thisPost.collaborationTopicsContains(e) ? backgroundColor : darkGrey,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: (e.clubTypeString == "none" ? e.clubType.toReadableString().substring(9) : e.clubTypeString.replaceAll("_", " ")).length > 8 ? 16 : 20,
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
                                                        SizedBox(
                                                            height:
                                                                height * 0.008),
                                                      ])),
                                            ]
                                          )
                                        ):Container(
                                          child : Column(
                                            children : [
                                              SizedBox(
                                                height: height * 0.01,
                                              ),
                                              Container(
                                                  width: width * 0.87,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              height: height *
                                                                  0.038,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: width *
                                                                          0.035,
                                                                      top: width *
                                                                          0.02),
                                                              child: FittedBox(
                                                                fit: BoxFit
                                                                    .fitHeight,
                                                                child: Text(
                                                                  "Post Field : ",
                                                                  style: GoogleFonts
                                                                      .fredoka(
                                                                    color: blue,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                            height:
                                                                height * 0.008),
                                                        Container(
                                                          width: width * 0.88,
                                                          height: height * 0.13,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      width *
                                                                          0.02),
                                                          child: ListView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            padding:
                                                                EdgeInsets.zero,
                                                            children: [
                                                              ...subjectList
                                                                  .map((e) {
                                                                return InkWell(
                                                                  onTap: () {
                                                                    if (thisPost
                                                                        .generalTopicContains(
                                                                            e))
                                                                      thisPost
                                                                          .removeotherTopic(
                                                                              e);
                                                                    else
                                                                      thisPost
                                                                          .otherTopic
                                                                          .add(
                                                                              e);
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  child:
                                                                      AnimatedContainer(
                                                                    duration: Duration(
                                                                        milliseconds:
                                                                            50),
                                                                    height:
                                                                        height *
                                                                            0.08,
                                                                    width:
                                                                        height *
                                                                            0.12,
                                                                    margin: EdgeInsets.only(
                                                                        right: width *
                                                                            0.015),
                                                                    decoration: BoxDecoration(
                                                                        color: thisPost.generalTopicContains(e)
                                                                            ? blue
                                                                            : backgroundColor,
                                                                        border: Border.all(
                                                                            color: thisPost.generalTopicContains(e)
                                                                                ? darkblue.withOpacity(
                                                                                    0.5)
                                                                                : darkGrey,
                                                                            width: width *
                                                                                0.015),
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10))),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        SizedBox(
                                                                          height:
                                                                              height * 0.0125,
                                                                        ),
                                                                        Container(
                                                                          height:
                                                                              height * 0.06,
                                                                          child:
                                                                              FittedBox(
                                                                            fit:
                                                                                BoxFit.fitHeight,
                                                                            child:
                                                                                ImageIcon(
                                                                              AssetImage(e.image),
                                                                              color: thisPost.generalTopicContains(e) ? backgroundColor : darkGrey,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                            child:
                                                                                Container()),
                                                                        Container(
                                                                          width:
                                                                              height * 0.1,
                                                                          child:
                                                                              Text(
                                                                            e.clubTypeString == "none"
                                                                                ? e.clubType.toReadableString().substring(9)
                                                                                : e.clubTypeString.replaceAll("_", " "),
                                                                            maxLines:
                                                                                2,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: GoogleFonts.fredoka(
                                                                                color: thisPost.generalTopicContains(e) ? backgroundColor : darkGrey,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: (e.clubTypeString == "none" ? e.clubType.toReadableString().substring(9) : e.clubTypeString.replaceAll("_", " ")).length > 8 ? 16 : 20,
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
                                                        SizedBox(
                                                            height:
                                                                height * 0.008),
                                                      ])),
                                            ]
                                          )
                                        ),
                                  SizedBox(
                                    height: height * 0.003,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: width * 0.02,
                                      ),
                                      Container(
                                        height: height * 0.035,
                                        child: FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: Text(
                                            "Tags : ",
                                            style: GoogleFonts.fredoka(
                                                color: blue,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.002,
                                  ),
                                  Container(
                                    width: width * 0.88,
                                    height: height * 0.45,
                                    decoration: BoxDecoration(
                                        color: blue,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      children: [
                                        Container(height: width * 0.02),
                                        Container(
                                            width: width * 0.845,
                                            height: height * 0.04,
                                            decoration: BoxDecoration(
                                              color: backgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Stack(
                                              children: [
                                                Row(
                                                  children: [
                                                    AnimatedContainer(
                                                      duration: Duration(
                                                          milliseconds: 300),
                                                      width: tab *
                                                          width *
                                                          0.845 /
                                                          3,
                                                    ),
                                                    Container(
                                                      height: height * 0.04,
                                                      width: width * 0.845 / 3,
                                                      decoration: BoxDecoration(
                                                          color: blue,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          tab = 0;
                                                        });
                                                      },
                                                      child: Container(
                                                          height: height * 0.04,
                                                          width:
                                                              width * 0.845 / 3,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                height: height *
                                                                    0.02,
                                                                child:
                                                                    FittedBox(
                                                                  fit: BoxFit
                                                                      .fitHeight,
                                                                  child:
                                                                      ImageIcon(
                                                                    AssetImage(
                                                                        "assets/images/signUpScreenIcons/school.png"),
                                                                    color: tab ==
                                                                            0
                                                                        ? backgroundColor
                                                                        : blue,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: width *
                                                                    0.01,
                                                              ),
                                                              Container(
                                                                height: height *
                                                                    0.033,
                                                                child:
                                                                    FittedBox(
                                                                  fit: BoxFit
                                                                      .fitHeight,
                                                                  child: Text(
                                                                    "Schools",
                                                                    style: GoogleFonts.fredoka(
                                                                        color: tab ==
                                                                                0
                                                                            ? backgroundColor
                                                                            : blue,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          )),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          tab = 1;
                                                        });
                                                      },
                                                      child: Container(
                                                          height: height * 0.04,
                                                          width:
                                                              width * 0.845 / 3,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                height: height *
                                                                    0.02,
                                                                child:
                                                                    FittedBox(
                                                                  fit: BoxFit
                                                                      .fitHeight,
                                                                  child:
                                                                      ImageIcon(
                                                                    AssetImage(
                                                                        "assets/images/mentorIcons/classes.png"),
                                                                    color: tab ==
                                                                            1
                                                                        ? backgroundColor
                                                                        : blue,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: width *
                                                                    0.01,
                                                              ),
                                                              Container(
                                                                height: height *
                                                                    0.033,
                                                                child:
                                                                    FittedBox(
                                                                  fit: BoxFit
                                                                      .fitHeight,
                                                                  child: Text(
                                                                    "Classes",
                                                                    style: GoogleFonts.fredoka(
                                                                        color: tab ==
                                                                                1
                                                                            ? backgroundColor
                                                                            : blue,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          )),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          tab = 2;
                                                        });
                                                      },
                                                      child: Container(
                                                          height: height * 0.04,
                                                          width:
                                                              width * 0.845 / 3,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                height: height *
                                                                    0.02,
                                                                child:
                                                                    FittedBox(
                                                                  fit: BoxFit
                                                                      .fitHeight,
                                                                  child:
                                                                      ImageIcon(
                                                                    AssetImage(
                                                                        "assets/images/suggestedConnectionsImages/user.png"),
                                                                    color: tab ==
                                                                            2
                                                                        ? backgroundColor
                                                                        : blue,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: width *
                                                                    0.01,
                                                              ),
                                                              Container(
                                                                height: height *
                                                                    0.033,
                                                                child:
                                                                    FittedBox(
                                                                  fit: BoxFit
                                                                      .fitHeight,
                                                                  child: Text(
                                                                    "People",
                                                                    style: GoogleFonts.fredoka(
                                                                        color: tab ==
                                                                                2
                                                                            ? backgroundColor
                                                                            : blue,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          )),
                                                    )
                                                  ],
                                                )
                                              ],
                                            )),
                                        Container(height: width * 0.02),
                                        Expanded(
                                          child: Container(
                                            width: width * 0.845,
                                            padding:
                                                EdgeInsets.all(width * 0.015),
                                            decoration: BoxDecoration(
                                                color: backgroundColor,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: ListView(
                                              padding: EdgeInsets.zero,
                                              children: tab == 0
                                                  ? [
                                                      // schools tab
                                                      InkWell(
                                                        onTap: () {
                                                          toggleBlackScreen();
                                                          toggleSchoolsScreen();
                                                        },
                                                        child: Container(
                                                          height: height * 0.08,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      0.015),
                                                          decoration: BoxDecoration(
                                                              color: blue,
                                                              border: Border.all(
                                                                  color:
                                                                      darkblue,
                                                                  width: width *
                                                                      0.015),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                height: height *
                                                                    0.05,
                                                                child:
                                                                    FittedBox(
                                                                  fit: BoxFit
                                                                      .fitHeight,
                                                                  child:
                                                                      ImageIcon(
                                                                    AssetImage(
                                                                      "assets/images/addSchoolv2.png",
                                                                    ),
                                                                    color:
                                                                        backgroundColor,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: width *
                                                                    0.015,
                                                              ),
                                                              Container(
                                                                height: height *
                                                                    0.05,
                                                                child:
                                                                    FittedBox(
                                                                  fit: BoxFit
                                                                      .fitHeight,
                                                                  child: Text(
                                                                    "Tag School",
                                                                    style: GoogleFonts.fredoka(
                                                                        color:
                                                                            backgroundColor,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      ...thisPost.taggedSchools
                                                          .map((e) {
                                                        return InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              thisPost
                                                                  .taggedSchools
                                                                  .remove(e);
                                                            });
                                                          },
                                                          child: Container(
                                                            height:
                                                                height * 0.085,
                                                            decoration: BoxDecoration(
                                                                color: blue,
                                                                border: Border.all(
                                                                    color:
                                                                        darkblue,
                                                                    width: width *
                                                                        0.015),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: height *
                                                                        0.004),
                                                            child: Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: width *
                                                                      0.01,
                                                                ),
                                                                Container(
                                                                  height:
                                                                      height *
                                                                          0.063,
                                                                  width:
                                                                      height *
                                                                          0.063,
                                                                  decoration: BoxDecoration(
                                                                      color:
                                                                          blue,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      border: Border.all(
                                                                          width: width *
                                                                              0.01,
                                                                          color:
                                                                              darkblue)),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(2),
                                                                    child: Image
                                                                        .network(
                                                                      e.image,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: width *
                                                                      0.015,
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        height *
                                                                            0.055,
                                                                    child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Text(
                                                                            e.name,
                                                                            style: GoogleFonts.fredoka(
                                                                                color: backgroundColor,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: e.name.length <= 25 ? MediaQuery.of(context).textScaleFactor * 23 : MediaQuery.of(context).textScaleFactor * 20,
                                                                                height: 1),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: width *
                                                                      0.015,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }).toList()
                                                    ]
                                                  : tab == 1
                                                      ? [
                                                          // classes tab
                                                          InkWell(
                                                            onTap: () {
                                                              toggleBlackScreen();
                                                              toggleClassesScreen();
                                                            },
                                                            child: Container(
                                                              height:
                                                                  height * 0.08,
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          0.015),
                                                              decoration: BoxDecoration(
                                                                  color: blue,
                                                                  border: Border.all(
                                                                      color:
                                                                          darkblue,
                                                                      width: width *
                                                                          0.015),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Container(
                                                                    height:
                                                                        height *
                                                                            0.04,
                                                                    child:
                                                                        FittedBox(
                                                                      fit: BoxFit
                                                                          .fitHeight,
                                                                      child:
                                                                          ImageIcon(
                                                                        AssetImage(
                                                                          "assets/images/addClass.png",
                                                                        ),
                                                                        color:
                                                                            backgroundColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width:
                                                                        width *
                                                                            0.02,
                                                                  ),
                                                                  Container(
                                                                    height:
                                                                        height *
                                                                            0.05,
                                                                    child:
                                                                        FittedBox(
                                                                      fit: BoxFit
                                                                          .fitHeight,
                                                                      child:
                                                                          Text(
                                                                        "Tag Class",
                                                                        style: GoogleFonts.fredoka(
                                                                            color:
                                                                                backgroundColor,
                                                                            fontWeight:
                                                                                FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          ...thisPost
                                                              .taggedClasses
                                                              .map((e) {
                                                            return Stack(
                                                              children: [
                                                                Container(
                                                                    height:
                                                                        height *
                                                                            0.08,
                                                                    margin: EdgeInsets.only(
                                                                        top: width *
                                                                            0.015),
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            width *
                                                                                0.01),
                                                                    decoration: BoxDecoration(
                                                                        color: e
                                                                            .getColor(),
                                                                        border: Border.all(
                                                                            color: e
                                                                                .getDColor(),
                                                                            width: width *
                                                                                0.015),
                                                                        borderRadius:
                                                                            const BorderRadius.all(Radius.circular(10))),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                            height: height *
                                                                                0.053,
                                                                            width: height *
                                                                                0.053,
                                                                            margin:
                                                                                EdgeInsets.only(right: width * 0.015, left: width * 0.01),
                                                                            decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.all(Radius.circular(8)), border: Border.all(color: e.getDColor(), width: width * 0.01)),
                                                                            padding: EdgeInsets.all(height * 0.005),
                                                                            child: ImageIcon(
                                                                              AssetImage(e.getImageAddy()),
                                                                              color: e.getColor(),
                                                                            )),
                                                                        SizedBox(
                                                                          width:
                                                                              width * 0.6,
                                                                          child: Text(
                                                                              e.className,
                                                                              textAlign: TextAlign.left,
                                                                              style: GoogleFonts.fredoka(
                                                                                fontWeight: FontWeight.w600,
                                                                                color: backgroundColor,
                                                                                height: 1,
                                                                                fontSize: e.className.length <= 22 ? MediaQuery.of(context).textScaleFactor * 24 : MediaQuery.of(context).textScaleFactor * 18,
                                                                              )),
                                                                        )
                                                                      ],
                                                                    )),
                                                              ],
                                                            );
                                                          }).toList()
                                                        ]
                                                      : [
                                                          // people tab
                                                          InkWell(
                                                            onTap: () {
                                                              toggleBlackScreen();
                                                              togglePeopleScreen();
                                                            },
                                                            child: Container(
                                                              height:
                                                                  height * 0.08,
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          0.015),
                                                              decoration: BoxDecoration(
                                                                  color: blue,
                                                                  border: Border.all(
                                                                      color:
                                                                          darkblue,
                                                                      width: width *
                                                                          0.015),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Container(
                                                                    height:
                                                                        height *
                                                                            0.04,
                                                                    child:
                                                                        FittedBox(
                                                                      fit: BoxFit
                                                                          .fitHeight,
                                                                      child:
                                                                          ImageIcon(
                                                                        AssetImage(
                                                                          "assets/images/add-user.png",
                                                                        ),
                                                                        color:
                                                                            backgroundColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width:
                                                                        width *
                                                                            0.02,
                                                                  ),
                                                                  Container(
                                                                    height:
                                                                        height *
                                                                            0.05,
                                                                    child:
                                                                        FittedBox(
                                                                      fit: BoxFit
                                                                          .fitHeight,
                                                                      child:
                                                                          Text(
                                                                        "Tag Person",
                                                                        style: GoogleFonts.fredoka(
                                                                            color:
                                                                                backgroundColor,
                                                                            fontWeight:
                                                                                FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          ...thisPost
                                                              .taggedPeople
                                                              .map((e) {
                                                            AppUser
                                                                recommendedUser =
                                                                e;
                                                            return InkWell(
                                                              onTap: () {
                                                                thisPost
                                                                    .taggedPeople
                                                                    .remove(e);
                                                                setState(() {});
                                                              },
                                                              child: Container(
                                                                width: width *
                                                                    0.93,
                                                                height: height *
                                                                    0.1,
                                                                margin:
                                                                    EdgeInsets
                                                                        .only(
                                                                  top: height *
                                                                      0.005,
                                                                ),
                                                                decoration: BoxDecoration(
                                                                    color: blue,
                                                                    border: Border.all(
                                                                        color:
                                                                            darkblue,
                                                                        width: width *
                                                                            0.015),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10))),
                                                                child: Stack(
                                                                  children: [
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              width * 0.0125,
                                                                        ),
                                                                        Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Container(
                                                                                height: height * 0.075,
                                                                                width: height * 0.075,
                                                                                decoration: BoxDecoration(border: Border.all(color: darkblue, width: width * 0.0125), borderRadius: BorderRadius.circular(10)),
                                                                                child: ClipRRect(
                                                                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                                                                  child: Image.network(
                                                                                    recommendedUser.image,
                                                                                    fit: BoxFit.cover,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ]),
                                                                        SizedBox(
                                                                          width:
                                                                              width * 0.025,
                                                                        ),
                                                                        Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: height * 0.008,
                                                                            ),
                                                                            Container(
                                                                                height: height * 0.045,
                                                                                child: FittedBox(
                                                                                  fit: BoxFit.fitHeight,
                                                                                  child: Text(
                                                                                    recommendedUser.firstName + " " + recommendedUser.lastName,
                                                                                    textAlign: TextAlign.start,
                                                                                    style: GoogleFonts.fredoka(color: backgroundColor, fontWeight: FontWeight.w600),
                                                                                  ),
                                                                                )),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Positioned(
                                                                      bottom:
                                                                          height *
                                                                              0.01,
                                                                      left: width *
                                                                          0.2,
                                                                      child:
                                                                          Container(
                                                                        height: height *
                                                                            0.029,
                                                                        width: width *
                                                                            0.55,
                                                                        child:
                                                                            Text(
                                                                          (e as AppUser).currentGrade.toString().substring(6) +
                                                                              " at " +
                                                                              (e as AppUser).getCurrentSchool().name,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                          style: GoogleFonts.fredoka(
                                                                              fontSize: 18,
                                                                              color: backgroundColor,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          }).toList()
                                                        ],
                                            ),
                                          ),
                                        ),
                                        Container(height: width * 0.02),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height : height * 0.01),
                                  InkWell(
                                    onTap : () async {
                                      // get lat lng points of location
                                      if(thisPost.type == PostType.Tournament && thisPost.tournamentLocation.address != ""){
                                        List coordinates = await  performGeoCoding(thisPost.tournamentLocation.address);
                                        thisPost.tournamentLocation.lat = coordinates[0];
                                        thisPost.tournamentLocation.lon = coordinates[1];
                                      }else if(thisPost.type == PostType.Volounteer && thisPost.volunteerLocation.address != ""){
                                        List coordinates = await  performGeoCoding(thisPost.volunteerLocation.address);
                                        thisPost.volunteerLocation.lat = coordinates[0];
                                        thisPost.tournamentLocation.lon = coordinates[1];
                                      }
                                      // upload image to database
                                      if(selectedImage != null){
                                        final imageBytes = await selectedImage!.readAsBytes();
                                        await supaBase.storage.from('PostImages').uploadBinary("/${currentUser.email}/${thisPost.postTitle}.png", imageBytes);
                                        final imageAddress = supaBase.storage.from('PostImages').getPublicUrl("/${currentUser.email}/${thisPost.postTitle}.png");
                                        thisPost.imageAddress = imageAddress;
                                      }else{
                                        thisPost.imageAddress = "";
                                      }
                                      thisPost.DatePosted = DateTime.now();
                                      await supaBase.from("Posts").insert(thisPost.toJson()).select();
                                      Navigator.of(context).pop();
                                      print(thisPost.toJson());
                                    },
                                    child: Container(
                                      width : width * 0.88, 
                                      height : height * 0.085, 
                                      decoration : BoxDecoration(
                                        color : blue, 
                                        borderRadius : BorderRadius.all(
                                          Radius.circular(10)
                                        ), 
                                        border : Border.all(
                                          color : darkblue, 
                                          width : width * 0.015
                                        )
                                      ), 
                                      child : Row(
                                        mainAxisAlignment : MainAxisAlignment.center,
                                        children : [
                                          Container(
                                            height : height * 0.04, 
                                            child : FittedBox(
                                              fit : BoxFit.fitHeight, 
                                              child : ImageIcon(
                                                AssetImage("assets/images/post.png"), 
                                                color : backgroundColor
                                              )
                                            )
                                          ), 
                                          SizedBox(width : width * 0.015),
                                          Container(
                                            height : height * 0.065, 
                                            child : FittedBox(
                                              fit : BoxFit.fitHeight, 
                                              child : Text(
                                                "Post", 
                                                style : GoogleFonts.fredoka(
                                                  color : backgroundColor, 
                                                  fontWeight : FontWeight.w700
                                                )
                                              )
                                            )
                                          )
                                        ]
                                      )
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.015,
                                  ),
                                ],
                              ),
                            ),
                          ), 

                        ],
                      )),
                ])),
            showBlackScreen
                ? InkWell(
                    child: Container(
                      height: height,
                      width: width,
                      color: Colors.black.withOpacity(0.8),
                    ),
                    onTap: () {
                      setState(() {
                        showBlackScreen = false;
                      });
                    },
                  )
                : Container(),
            showSchoolsScreen
                ? SingleChildScrollView(
                    child: InkWell(
                      onTap: () {
                        toggleBlackScreen();
                      },
                      child: SizedBox(
                          height: height,
                          width: width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AnimatedContainer(
                                duration: Duration(milliseconds: 150),
                                height:
                                    keyboardUp ? height * 0.25 : height * 0.3,
                              ),
                              SearchSChoolTextField(
                                  height * 0.08,
                                  width * 0.9,
                                  blue,
                                  darkblue,
                                  "",
                                  0,
                                  schoolTec,
                                  getSchoolData),
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
                                        color: blue, width: width * 0.015),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                padding: EdgeInsets.all(width * 0.015),
                                child: searchResultsLoading
                                    ? Center(
                                        child: Stack(children: [
                                          Positioned(
                                            bottom: height * 0.03,
                                            left: width * 0.12,
                                            child: SizedBox(
                                              height: height * 0.2,
                                              child: Lottie.asset(
                                                  "assets/animations/loading.json",
                                                  fit: BoxFit.fitHeight),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: height * 0.015,
                                            left: width * 0.17,
                                            child: SizedBox(
                                              height: height * 0.04,
                                              child: FittedBox(
                                                fit: BoxFit.fitHeight,
                                                child: Text(
                                                  "Fetching Results...",
                                                  style: GoogleFonts.fredoka(
                                                      color: blue,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                            ),
                                          )
                                        ]),
                                      )
                                    : recList.isNotEmpty && recList[0] == "none"
                                        ? Center(
                                            child: Stack(children: [
                                              Positioned(
                                                bottom: height * 0.06,
                                                left: width * 0.25,
                                                child: SizedBox(
                                                  height: height * 0.16,
                                                  child: Image.asset(
                                                      "assets/images/empty.png",
                                                      fit: BoxFit.fitHeight),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: height * 0.01,
                                                left: width * 0.18,
                                                child: SizedBox(
                                                  height: height * 0.04,
                                                  child: FittedBox(
                                                    fit: BoxFit.fitHeight,
                                                    child: Text(
                                                      "No Results Found",
                                                      style:
                                                          GoogleFonts.fredoka(
                                                              color: blue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ]),
                                          )
                                        : ListView(
                                            padding: EdgeInsets.all(0),
                                            children: [
                                              ...recList.map((e) {
                                                String showSchoolString =
                                                    e as String;
                                                String finalString =
                                                    showSchoolString
                                                        .substring(0, 1)
                                                        .toUpperCase();
                                                for (int i = 1;
                                                    i < showSchoolString.length;
                                                    i++) {
                                                  if (showSchoolString
                                                          .substring(
                                                              i - 1, i) ==
                                                      " ") {
                                                    finalString = finalString +
                                                        showSchoolString
                                                            .substring(i, i + 1)
                                                            .toUpperCase();
                                                  } else {
                                                    finalString = finalString +
                                                        showSchoolString
                                                            .substring(i, i + 1)
                                                            .toLowerCase();
                                                  }
                                                }
                                                return InkWell(
                                                  onTap: () async {
                                                    setState(() {
                                                      searchResultsLoading =
                                                          true;
                                                    });
                                                    School data =
                                                        await getFullSchoolData(
                                                            e, finalString);
                                                    setState(() {
                                                      thisPost.taggedSchools
                                                          .add(data);
                                                      searchResultsLoading =
                                                          false;
                                                    });
                                                  },
                                                  child: Container(
                                                      width: width * 0.85,
                                                      height: height * 0.07,
                                                      margin: EdgeInsets.only(
                                                          bottom: width *
                                                              0.015),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  width * 0.02,
                                                              vertical:
                                                                  width * 0.01),
                                                      decoration: BoxDecoration(
                                                          color: const Color
                                                                  .fromARGB(
                                                              255, 226, 225, 225),
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius.circular(
                                                                      5))),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              finalString,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts.fredoka(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: blue,
                                                                  fontSize:
                                                                      MediaQuery.of(context)
                                                                              .textScaleFactor *
                                                                          18),
                                                            ),
                                                          )
                                                        ],
                                                      )),
                                                );
                                              }).toList()
                                            ],
                                          ),
                              )
                            ],
                          )),
                    ),
                  )
                : Container(),
            showClassesScreen
                ? SingleChildScrollView(
                    child: InkWell(
                      onTap: () {
                        toggleBlackScreen();
                      },
                      child: SizedBox(
                          height: height,
                          width: width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AnimatedContainer(
                                duration: Duration(milliseconds: 150),
                                height:
                                    keyboardUp ? height * 0.25 : height * 0.3,
                              ),
                              SearchSChoolTextField(
                                height * 0.08,
                                width * 0.9,
                                blue,
                                darkblue,
                                "",
                                0,
                                classesTec,
                                getSchoolData,
                                showButton: false,
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              InkWell(
                                onTap: () {},
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  height: height * 0.3,
                                  width: width * 0.9,
                                  decoration: BoxDecoration(
                                      color: backgroundColor,
                                      border: Border.all(
                                          color: blue, width: width * 0.015),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  padding: EdgeInsets.all(width * 0.015),
                                  child: ListView(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    children: [
                                      ...classesQueryList.isEmpty
                                          ? classes.map((e) {
                                              return InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      thisPost.taggedClasses
                                                          .add(e);
                                                    });
                                                  },
                                                  child: ClassDisplayWidget(e));
                                            }).toList()
                                          : classesQueryList.map((e) {
                                              return InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      thisPost.taggedClasses
                                                          .add(e);
                                                    });
                                                  },
                                                  child: ClassDisplayWidget(e));
                                            }).toList(),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )),
                    ),
                  )
                : Container(),
            showPeopleScreen
                ? SingleChildScrollView(
                    child: InkWell(
                      onTap: () {
                        toggleBlackScreen();
                      },
                      child: SizedBox(
                          height: height,
                          width: width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AnimatedContainer(
                                duration: Duration(milliseconds: 150),
                                height:
                                    keyboardUp ? height * 0.25 : height * 0.3,
                              ),
                              SearchSChoolTextField(
                                height * 0.07,
                                width * 0.9,
                                blue,
                                darkblue,
                                "",
                                0,
                                chooseUserTagTec,
                                () {},
                                showButton: false,
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              InkWell(
                                onTap: () {},
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  height: height * 0.3,
                                  width: width * 0.9,
                                  decoration: BoxDecoration(
                                      color: backgroundColor,
                                      border: Border.all(
                                          color: blue, width: width * 0.015),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  padding: EdgeInsets.all(width * 0.015),
                                  child: ListView(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    children: [
                                      ...(appUsersQueryList.isEmpty
                                              ? appUsers
                                              : appUsersQueryList)
                                          .map((e) {
                                        print(e.firstName);
                                        return InkWell(
                                          onTap: () {
                                            thisPost.taggedPeople.add(e);
                                            setState(() {});
                                          },
                                          child: Container(
                                              height: height * 0.08,
                                              width: width * 0.15,
                                              margin: EdgeInsets.only(
                                                  bottom: height * 0.005),
                                              decoration: BoxDecoration(
                                                  color: blue,
                                                  border: Border.all(
                                                      color: darkblue,
                                                      width: width * 0.015),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Row(children: [
                                                SizedBox(width: width * 0.01),
                                                Container(
                                                    height: height * 0.058,
                                                    width: height * 0.058,
                                                    decoration: BoxDecoration(
                                                        color: blue,
                                                        border: Border.all(
                                                            color: darkblue,
                                                            width:
                                                                width * 0.012),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(1),
                                                        child: Image.network(
                                                            e.image,
                                                            fit:
                                                                BoxFit.cover))),
                                                SizedBox(width: width * 0.025),
                                                Expanded(
                                                    child: Container(
                                                        child: Text(
                                                            e.firstName +
                                                                " " +
                                                                e.lastName,
                                                            style: GoogleFonts.fredoka(
                                                                color:
                                                                    backgroundColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: (e.firstName +
                                                                                " " +
                                                                                e.lastName)
                                                                            .length <=
                                                                        25
                                                                    ? 28
                                                                    : 25)))),
                                                SizedBox(width: width * 0.015),
                                              ])),
                                        );
                                      }).toList()
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )),
                    ),
                  )
                : Container(),
            showSearchLocationVolunteer
                ? SingleChildScrollView(
                    child: InkWell(
                      onTap: () {
                        toggleBlackScreen();
                      },
                      child: SizedBox(
                          height: height,
                          width: width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AnimatedContainer(
                                duration: Duration(milliseconds: 150),
                                height:
                                    keyboardUp ? height * 0.25 : height * 0.3,
                              ),
                              SearchSChoolTextField(
                                height * 0.075,
                                width * 0.9,
                                blue,
                                darkblue,
                                "",
                                0,
                                volunteerLocationTec,
                                getLocationAutoCompleteVolunteer,
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
                                        color: blue, width: width * 0.015),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                padding: EdgeInsets.all(width * 0.015),
                                child: searchResultsLoading
                                    ? Center(
                                        child: Stack(children: [
                                          Positioned(
                                            bottom: height * 0.03,
                                            left: width * 0.12,
                                            child: SizedBox(
                                              height: height * 0.2,
                                              child: Lottie.asset(
                                                  "assets/animations/loading.json",
                                                  fit: BoxFit.fitHeight),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: height * 0.015,
                                            left: width * 0.17,
                                            child: SizedBox(
                                              height: height * 0.04,
                                              child: FittedBox(
                                                fit: BoxFit.fitHeight,
                                                child: Text(
                                                  "Fetching Results...",
                                                  style: GoogleFonts.fredoka(
                                                      color: blue,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                            ),
                                          )
                                        ]),
                                      )
                                    : ListView(
                                        padding: EdgeInsets.all(0),
                                        children: [
                                          ...placeRecommendations.map((e) {
                                            return InkWell(
                                              onTap: () {
                                                thisPost.volunteerLocation
                                                    .locationFromJson(e);
                                                setState(() {});
                                              },
                                              child: Container(
                                                  height: height * 0.067,
                                                  width: width * 0.7,
                                                  margin: EdgeInsets.only(
                                                      bottom: height * 0.005),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade300,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: width * 0.04),
                                                  child: Center(
                                                      child: Text(
                                                          e["description"],
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: GoogleFonts.fredoka(
                                                              color: blue,
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              fontSize: 17,
                                                              height: 1)))),
                                            );
                                          }).toList()
                                        ],
                                      ),
                              )
                            ],
                          )),
                    ),
                  )
                : Container(),
            showSearchLocationTournament
                ? SingleChildScrollView(
                    child: InkWell(
                      onTap: () {
                        toggleBlackScreen();
                      },
                      child: SizedBox(
                          height: height,
                          width: width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AnimatedContainer(
                                duration: Duration(milliseconds: 150),
                                height:
                                    keyboardUp ? height * 0.25 : height * 0.3,
                              ),
                              SearchSChoolTextField(
                                height * 0.075,
                                width * 0.9,
                                blue,
                                darkblue,
                                "",
                                0,
                                tournamentLocationTec,
                                getLocationAutoCompleteTournament,
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
                                        color: blue, width: width * 0.015),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                padding: EdgeInsets.all(width * 0.015),
                                child: searchResultsLoading
                                    ? Center(
                                        child: Stack(children: [
                                          Positioned(
                                            bottom: height * 0.03,
                                            left: width * 0.12,
                                            child: SizedBox(
                                              height: height * 0.2,
                                              child: Lottie.asset(
                                                  "assets/animations/loading.json",
                                                  fit: BoxFit.fitHeight),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: height * 0.015,
                                            left: width * 0.17,
                                            child: SizedBox(
                                              height: height * 0.04,
                                              child: FittedBox(
                                                fit: BoxFit.fitHeight,
                                                child: Text(
                                                  "Fetching Results...",
                                                  style: GoogleFonts.fredoka(
                                                      color: blue,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                            ),
                                          )
                                        ]),
                                      )
                                    : ListView(
                                        padding: EdgeInsets.all(0),
                                        children: [
                                          ...placeRecommendations.map((e) {
                                            return InkWell(
                                              onTap: () {
                                                thisPost.tournamentLocation
                                                    .locationFromJson(e);
                                                setState(() {});
                                              },
                                              child: Container(
                                                  height: height * 0.067,
                                                  width: width * 0.7,
                                                  margin: EdgeInsets.only(
                                                      bottom: height * 0.005),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade300,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: width * 0.04),
                                                  child: Center(
                                                      child: Text(
                                                          e["description"],
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: GoogleFonts.fredoka(
                                                              color: blue,
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              fontSize: 17,
                                                              height: 1)))),
                                            );
                                          }).toList()
                                        ],
                                      ),
                              )
                            ],
                          )),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class PostTypeWidget extends StatefulWidget {
  bool isActive = false;
  String imageAddress = "";
  String postName;
  Function onClickFunction;
  PostTypeWidget(
      {required this.isActive,
      required this.imageAddress,
      required this.postName,
      required this.onClickFunction});
  @override
  State<PostTypeWidget> createState() => _PostTypeWidgetState();
}

class _PostTypeWidgetState extends State<PostTypeWidget> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        widget.onClickFunction();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        width: width * 0.25,
        decoration: BoxDecoration(
            color: widget.isActive ? blue : Colors.grey.shade300,
            border: Border.all(
                color: widget.isActive
                    ? darkblue
                    : Colors.grey.shade400.withOpacity(0.5),
                width: width * 0.015),
            borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.only(right: width * 0.015),
        child: Column(
          children: [
            SizedBox(
              height: height * 0.015,
            ),
            Container(
              height: height * 0.06,
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: ImageIcon(
                  AssetImage(
                      "assets/images/PostTypeImages/${widget.imageAddress}.png"),
                  color: widget.isActive
                      ? backgroundColor
                      : Colors.grey.shade500.withOpacity(0.8),
                ),
              ),
            ),
            SizedBox(
              height:
                  widget.postName == "Other" ? height * 0.005 : height * 0.01,
            ),
            Container(
              height:
                  widget.postName == "Other" ? height * 0.03 : height * 0.023,
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(
                  widget.postName,
                  style: GoogleFonts.fredoka(
                      color: widget.isActive
                          ? backgroundColor
                          : Colors.grey.shade500.withOpacity(0.8),
                      fontWeight: FontWeight.w600),
                ),
              ),
            )
          ],
        ),
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
  bool showButton;
  bool numbersOnly;
  SearchSChoolTextField(
      this.wantedHeight,
      this.wantedWidth,
      this.mainColor,
      this.darkColor,
      this.textFieldName,
      this.textFieldNameWidth,
      this.tec,
      this.searchButtonOnTap,
      {this.showButton = true,
      this.numbersOnly = false});
  @override
  State<SearchSChoolTextField> createState() => SearchSChoolTextFieldState();
}

class SearchSChoolTextFieldState extends State<SearchSChoolTextField> {
  @override
  bool tapped = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
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
            padding: EdgeInsets.only(
                right: width * 0.05,
                left: widget.showButton ? width * 0.12 : width * 0.05),
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
              keyboardType: widget.numbersOnly
                  ? TextInputType.number
                  : TextInputType.text,
              cursorColor: widget.mainColor,
              cursorHeight: widget.wantedHeight * 0.5,
              decoration: InputDecoration(border: InputBorder.none),
            ),
          ),
          widget.showButton == false
              ? Container()
              : Positioned(
                  left: width * 0.025,
                  top: height * 0.022,
                  child: InkWell(
                    onTap: () {
                      widget.searchButtonOnTap();
                    },
                    child: SizedBox(
                      height: widget.wantedHeight * 0.55,
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Icon(
                          Icons.search_rounded,
                          color: widget.darkColor,
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

class GlassMorphicContainer extends StatelessWidget {
  double height;
  double width;
  GlassMorphicContainer(this.height, this.width);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        child: Stack(children: [
          BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 4,
                sigmaY: 4,
              ),
              child: Container()),
          Opacity(
              opacity: 0.5,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.13),
                    ),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.15),
                          Colors.white.withOpacity(0.05)
                        ])),
              ))
        ]));
  }
}
