import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/models/user.dart';
import 'package:image_picker/image_picker.dart';

enum Months {
  January,
  February,
  March,
  April,
  May,
  June,
  July,
  August,
  September,
  October,
  November,
  December,
  None
}

enum USStates {
  Alabama,
  Alaska,
  Arizona,
  Arkansas,
  California,
  Colorado,
  Connecticut,
  Delaware,
  Florida,
  Georgia,
  Hawaii,
  Idaho,
  Illinois,
  Indiana,
  Iowa,
  Kansas,
  Kentucky,
  Louisiana,
  Maine,
  Maryland,
  Massachusetts,
  Michigan,
  Minnesota,
  Mississippi,
  Missouri,
  Montana,
  Nebraska,
  Nevada,
  New_Hampshire,
  New_Jersey,
  New_Mexico,
  New_York,
  North_Carolina,
  North_Dakota,
  Ohio,
  Oklahoma,
  Oregon,
  Pennsylvania,
  Rhode_Island,
  South_Carolina,
  South_Dakota,
  Tennessee,
  Texas,
  Utah,
  Vermont,
  Virginia,
  Washington,
  West_Virginia,
  Wisconsin,
  Wyoming,
  None
}

String stateToString(USStates state) {
  String stateName;
  switch (state) {
    case USStates.Alabama:
      stateName = 'Alabama';
      break;
    case USStates.Alaska:
      stateName = 'Alaska';
      break;
    case USStates.Arizona:
      stateName = 'Arizona';
      break;
    case USStates.Arkansas:
      stateName = 'Arkansas';
      break;
    case USStates.California:
      stateName = 'California';
      break;
    case USStates.Colorado:
      stateName = 'Colorado';
      break;
    case USStates.Connecticut:
      stateName = 'Connecticut';
      break;
    case USStates.Delaware:
      stateName = 'Delaware';
      break;
    case USStates.Florida:
      stateName = 'Florida';
      break;
    case USStates.Georgia:
      stateName = 'Georgia';
      break;
    case USStates.Hawaii:
      stateName = 'Hawaii';
      break;
    case USStates.Idaho:
      stateName = 'Idaho';
      break;
    case USStates.Illinois:
      stateName = 'Illinois';
      break;
    case USStates.Indiana:
      stateName = 'Indiana';
      break;
    case USStates.Iowa:
      stateName = 'Iowa';
      break;
    case USStates.Kansas:
      stateName = 'Kansas';
      break;
    case USStates.Kentucky:
      stateName = 'Kentucky';
      break;
    case USStates.Louisiana:
      stateName = 'Louisiana';
      break;
    case USStates.Maine:
      stateName = 'Maine';
      break;
    case USStates.Maryland:
      stateName = 'Maryland';
      break;
    case USStates.Massachusetts:
      stateName = 'Massachusetts';
      break;
    case USStates.Michigan:
      stateName = 'Michigan';
      break;
    case USStates.Minnesota:
      stateName = 'Minnesota';
      break;
    case USStates.Mississippi:
      stateName = 'Mississippi';
      break;
    case USStates.Missouri:
      stateName = 'Missouri';
      break;
    case USStates.Montana:
      stateName = 'Montana';
      break;
    case USStates.Nebraska:
      stateName = 'Nebraska';
      break;
    case USStates.Nevada:
      stateName = 'Nevada';
      break;
    case USStates.New_Hampshire:
      stateName = 'New Hampshire';
      break;
    case USStates.New_Jersey:
      stateName = 'New Jersey';
      break;
    case USStates.New_Mexico:
      stateName = 'New Mexico';
      break;
    case USStates.New_York:
      stateName = 'New York';
      break;
    case USStates.North_Carolina:
      stateName = 'North Carolina';
      break;
    case USStates.North_Dakota:
      stateName = 'North Dakota';
      break;
    case USStates.Ohio:
      stateName = 'Ohio';
      break;
    case USStates.Oklahoma:
      stateName = 'Oklahoma';
      break;
    case USStates.Oregon:
      stateName = 'Oregon';
      break;
    case USStates.Pennsylvania:
      stateName = 'Pennsylvania';
      break;
    case USStates.Rhode_Island:
      stateName = 'Rhode Island';
      break;
    case USStates.South_Carolina:
      stateName = 'South Carolina';
      break;
    case USStates.South_Dakota:
      stateName = 'South Dakota';
      break;
    case USStates.Tennessee:
      stateName = 'Tennessee';
      break;
    case USStates.Texas:
      stateName = 'Texas';
      break;
    case USStates.Utah:
      stateName = 'Utah';
      break;
    case USStates.Vermont:
      stateName = 'Vermont';
      break;
    case USStates.Virginia:
      stateName = 'Virginia';
      break;
    case USStates.Washington:
      stateName = 'Washington';
      break;
    case USStates.West_Virginia:
      stateName = 'West Virginia';
      break;
    case USStates.Wisconsin:
      stateName = 'Wisconsin';
      break;
    case USStates.Wyoming:
      stateName = 'Wyoming';
      break;
    default:
      stateName = 'Unknown State';
  }

  return stateName;
}


List<String> monthToString(Months month) {
  List<String> returnVal = [];
  switch (month) {
    case Months.January:
      {
        returnVal = ["January", "JAN"];
      }
      break;

    case Months.February:
      {
        returnVal = ["February", "FEB"];
      }
      break;

    case Months.March:
      {
        returnVal = ["March", "MAR"];
      }
      break;

    case Months.April:
      {
        returnVal = ["April", "APR"];
      }
      break;

    case Months.May:
      {
        returnVal = ["May", "MAY"];
      }
      break;

    case Months.June:
      {
        returnVal = ["June", "JUN"];
      }
      break;

    case Months.July:
      {
        returnVal = ["July", "JUL"];
      }
      break;

    case Months.August:
      {
        returnVal = ["August", "AUG"];
      }
      break;

    case Months.September:
      {
        returnVal = ["September", "SEP"];
      }
      break;

    case Months.October:
      {
        returnVal = ["October", "OCT"];
      }
      break;

    case Months.November:
      {
        returnVal = ["November", "NOV"];
      }
      break;

    case Months.December:
      {
        returnVal = ["December", "DEC"];
      }
      break;
    default:
      {
        returnVal = ["", ""];
      }
      break;
  }
  return returnVal;
}

class AccountInfoScreen extends StatefulWidget {
  AppUser currentUser;
  Function loadingScreen;
  Function toggleBackScreen;
  Function showMonthPicker;
  Function showStatePicker;
  @override
  AccountInfoScreen(this.currentUser, this.loadingScreen, this.toggleBackScreen,
      this.showMonthPicker, this.showStatePicker);
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  File? userProfile;
  Future<bool> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return false;
      final imageTemp = File(image.path);
      setState(() => userProfile = imageTemp);
      widget.currentUser.image = imageTemp;
      return true;
    } on PlatformException catch (e) {
      return false;
    }
  }

  bool imagePicked = false;
  void formatStringValue(TextEditingController tec) {
    setState(() {
      if (tec.text != "") {
        if (int.parse(tec.text) < 10) {
          tec.text = "0" + tec.text;
        }
      }
    });
  }

  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  Months birthMonth = Months.None;
  TextEditingController dayController = new TextEditingController();
  TextEditingController yearController = new TextEditingController();
  String imageUrl = "";
  void initState() {
    print(widget.currentUser.userData);
    if(widget.currentUser.firstName != "") firstNameController.text = widget.currentUser.firstName;
    if(widget.currentUser.lastName != "") lastNameController.text = widget.currentUser.lastName;
    if(widget.currentUser.dateOfBirth.day.toString() != "") dayController.text = widget.currentUser.dateOfBirth.day.toString();
    if(widget.currentUser.dateOfBirth.year.toString() != "") yearController.text = widget.currentUser.dateOfBirth.year.toString();
    if (widget.currentUser.userData != null &&
        widget.currentUser.userData!.photoURL != "" &&
        widget.currentUser.userData!.photoURL != null) {
      widget.currentUser.image = widget.currentUser.userData!.photoURL!;
      imagePicked = true;
      imageUrl = widget.currentUser.userData!.photoURL!;
      widget.currentUser.image = widget.currentUser.userData!.photoURL!;
    }
    firstNameController.addListener(() {
      widget.currentUser.firstName = firstNameController.text;
    });
    lastNameController.addListener(() {
      widget.currentUser.lastName = lastNameController.text;
    });
    dayController.addListener(() {
      try {
        if (dayController.text == "") {
          return;
        } else if (int.parse(dayController.text) > 31) {
          setState(() {
            dayController.text = "31";
            widget.currentUser.dateOfBirth!.day = 31;
          });
        } else if (int.parse(dayController.text) <= 0) {
          setState(() {
            dayController.text = "1";
            widget.currentUser.dateOfBirth!.day = 1;
          });
        } else {
          setState(() {
            widget.currentUser.dateOfBirth!.day = int.parse(dayController.text);
          });
        }
      } on Exception catch (_) {}
    });
    yearController.addListener(() {
      try {
        if (yearController.text == "") {
          return;
        } else if (int.parse(yearController.text) > 2023) {
          setState(() {
            dayController.text = "2023";
            widget.currentUser.dateOfBirth!.year =
                int.parse(yearController.text);
          });
        } else {
          setState(() {
            widget.currentUser.dateOfBirth!.year =
                int.parse(yearController.text);
          });
        }
      } on Exception catch (_) {}
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Center(
          child: Container(
            width: width,
            height: height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.027,
                ),
                InkWell(
                    onTap: () async {
                      bool tempVal = await pickImage();
                      if (imagePicked && tempVal == false) {
                        imagePicked = true;
                      } else {
                        imagePicked = tempVal;
                      }
                      setState(() {
                        imagePicked;
                      });
                    },
                    child: Container(
                      width: width * 0.52,
                      height: width * 0.52,
                      decoration: BoxDecoration(
                          color: backgroundColor,
                          border: Border.all(
                            color: blue,
                            width: width * 0.025,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: imagePicked == false
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    height: width * 0.24,
                                    width: width * 0.24,
                                    child: Image.asset(
                                      "assets/images/add-user.png",
                                      fit: BoxFit.contain,
                                    )),
                                SizedBox(
                                  height: height * 0.005,
                                ),
                                Container(
                                  height: width * 0.144,
                                  margin: EdgeInsets.only(left: width * 0.022),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 0,
                                        left: width * 0.01,
                                        child: Container(
                                            height: width * 0.085,
                                            child: FittedBox(
                                              fit: BoxFit.fitHeight,
                                              child: Text(
                                                "Add a Face To",
                                                style: GoogleFonts.fredoka(
                                                    color: Color(0xffC9C9C9),
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            )),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: width * 0.018,
                                        child: Container(
                                            height: width * 0.08,
                                            child: FittedBox(
                                              fit: BoxFit.fitHeight,
                                              child: Text(
                                                "Your Account",
                                                style: GoogleFonts.fredoka(
                                                    color: Color(0xffC9C9C9),
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          : userProfile != null
                              ? ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: Image(
                                    image: FileImage(userProfile!),
                                    fit: BoxFit.cover,
                                  ))
                              : ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: Image(
                                    image: NetworkImage(
                                      imageUrl,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                    )),
                SizedBox(
                  height: height * 0.035,
                ),
                Expanded(
                  child: Container(
                    width: width,
                    child: Scrollbar(
                      child: ListView(
                        children: [
                          InkWell(
                            onTap: () async {
                              widget.loadingScreen();
                              int status = await widget.currentUser.authenticationUser();
                              if(status == 2){
                                await GoogleSignIn().signOut();
                                // ignore: use_build_context_synchronously
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.scale,
                                  title: 'Account Exists',
                                  desc: 'The google account you ahve connected already exists',
                                  btnOkOnPress: () {},
                                ).show();
                              }else{
                                if (widget.currentUser.userData != null &&
                                  widget.currentUser.userData!.photoURL != "" &&
                                  widget.currentUser.userData!.photoURL != null) {
                                    if(imagePicked = false){
                                      widget.currentUser.image = widget.currentUser.userData!.photoURL!;
                                    }
                                    imagePicked = true;
                                    imageUrl =
                                        widget.currentUser.userData!.photoURL!;
                                    widget.currentUser.image = widget.currentUser.userData!.photoURL!;
                                  }
                              }
                              setState(() {});
                              widget.loadingScreen();
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: width * 0.06),
                              width: width * 0.88,
                              height: height * 0.08,
                              decoration: BoxDecoration(
                                  color: blue,
                                  border: Border.all(
                                      color: darkblue, width: width * 0.015),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: height * 0.012,
                                  ),
                                  imageUrl == ""
                                      ? Container(
                                          height: height * 0.04,
                                          child: Image.asset(
                                            "assets/images/google.png",
                                            fit: BoxFit.fitHeight,
                                          ),
                                        )
                                      : Container(
                                          height: height * 0.047,
                                          width: height * 0.047,
                                          decoration: BoxDecoration(
                                              color: backgroundColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          child: Center(
                                            child: CircleAvatar(
                                                radius: height * 0.02,
                                                backgroundImage:
                                                    NetworkImage(imageUrl)),
                                          ),
                                        ),
                                  SizedBox(
                                    width: width * 0.035,
                                  ),
                                  Container(
                                    width: width * 0.64,
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Text(
                                        imageUrl == ""
                                            ? "Connect Google"
                                            : widget
                                                .currentUser.userData!.email!,
                                        style: GoogleFonts.fredoka(
                                            color: backgroundColor,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.026,
                          ),
                          SignUpScreenTextField(
                              height * 0.08,
                              width * 0.88,
                              blue,
                              darkblue,
                              "First Name",
                              width * 0.25,
                              firstNameController),
                          SizedBox(
                            height: height * 0.026,
                          ),
                          SignUpScreenTextField(
                              height * 0.08,
                              width * 0.88,
                              blue,
                              darkblue,
                              "Last Name",
                              width * 0.25,
                              lastNameController),
                          SizedBox(
                            height: height * 0.023,
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.06
                            ),
                            child: MonthPickerWidget(
                                      height * 0.08,
                                      width * 0.88,
                                      blue,
                                      darkblue,
                                      "State",
                                      width * 0.14,
                                      widget.currentUser.userState,
                                      "State",
                                      0,
                                      widget.toggleBackScreen,
                                      widget.showStatePicker, 
                                      USStates.None, 
                                      stateToString),
                          ),
                          SizedBox(
                            height: height * 0.023,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.06),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MonthPickerWidget(
                                    height * 0.08,
                                    width * 0.25,
                                    blue,
                                    darkblue,
                                    "MO",
                                    width * 0.09,
                                    widget.currentUser.dateOfBirth!.month,
                                    "XXX",
                                    0,
                                    widget.toggleBackScreen,
                                    widget.showMonthPicker,
                                    Months.None, 
                                    monthToString),
                                DateOfBirthPicker(
                                    height * 0.08,
                                    width * 0.25,
                                    blue,
                                    darkblue,
                                    "DAY",
                                    width * 0.11,
                                    dayController,
                                    "XX",
                                    0.075,
                                    formatStringValue),
                                DateOfBirthPicker(
                                    height * 0.08,
                                    width * 0.3,
                                    blue,
                                    darkblue,
                                    "YR",
                                    width * 0.085,
                                    yearController,
                                    "XXXX",
                                    0.05,
                                    formatStringValue)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SignUpScreenTextField extends StatefulWidget {
  double wantedHeight;
  double wantedWidth;
  Color mainColor;
  Color darkColor;
  String textFieldName;
  double textFieldNameWidth;
  TextEditingController tec;

  SignUpScreenTextField(this.wantedHeight, this.wantedWidth, this.mainColor,
      this.darkColor, this.textFieldName, this.textFieldNameWidth, this.tec);
  @override
  State<SignUpScreenTextField> createState() => _SignUpScreenTextFieldState();
}

class _SignUpScreenTextFieldState extends State<SignUpScreenTextField> {
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
      margin: EdgeInsets.symmetric(horizontal: width * 0.06),
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
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
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
        ],
      ),
    );
  }
}

class DateOfBirthPicker extends StatefulWidget {
  double wantedHeight;
  double wantedWidth;
  Color mainColor;
  Color darkColor;
  String textFieldName;
  double textFieldNameWidth;
  TextEditingController tec;
  String insideText;
  double padding;
  Function formattingStringFunction;
  DateOfBirthPicker(
      this.wantedHeight,
      this.wantedWidth,
      this.mainColor,
      this.darkColor,
      this.textFieldName,
      this.textFieldNameWidth,
      this.tec,
      this.insideText,
      this.padding,
      this.formattingStringFunction);
  @override
  State<DateOfBirthPicker> createState() => DateOfBirthPickerState();
}

class DateOfBirthPickerState extends State<DateOfBirthPicker> {
  @override
  bool tapped = false;
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return FocusScope(
      child: Focus(
        onFocusChange: (focus) {
          if (focus == false) {
            widget.formattingStringFunction(widget.tec);
          }
        },
        child: Container(
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
                    padding: EdgeInsets.only(
                        left: widget.textFieldName == "DAY"
                            ? width * 0.056
                            : width * 0.032,
                        top: height * 0.008),
                    child: Text(
                      widget.insideText,
                      style: GoogleFonts.fredoka(
                          fontWeight: FontWeight.w600,
                          color: widget.tec.text == ""
                              ? Colors.grey.shade400
                              : Colors.transparent,
                          fontSize:
                              MediaQuery.of(context).textScaleFactor * 30),
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
                            color: widget.darkColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: width * widget.padding, bottom: height * 0.011),
                child: TextFormField(
                  controller: widget.tec,
                  keyboardType: TextInputType.number,
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
                      fontSize: MediaQuery.of(context).textScaleFactor * 33),
                  cursorColor: widget.mainColor,
                  cursorHeight: widget.wantedHeight * 0.5,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MonthPickerWidget extends StatefulWidget {
  double wantedHeight;
  double wantedWidth;
  Color mainColor;
  Color darkColor;
  String textFieldName;
  double textFieldNameWidth;
  String insideText;
  double padding;
  var birthMonth;
  Function toggleBlackScreen;
  Function showMonthPicker;
  var noneEnum;
  Function toStringFunction;
  MonthPickerWidget(
      this.wantedHeight,
      this.wantedWidth,
      this.mainColor,
      this.darkColor,
      this.textFieldName,
      this.textFieldNameWidth,
      this.birthMonth,
      this.insideText,
      this.padding,
      this.toggleBlackScreen,
      this.showMonthPicker,
      this.noneEnum, 
      this.toStringFunction);
  State<MonthPickerWidget> createState() => MonthPickerWidgetState();
}

class MonthPickerWidgetState extends State<MonthPickerWidget> {
  @override
  bool tapped = false;
  void initState() {
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        print("This is the thing");
        print(widget.birthMonth);
        print(widget.toStringFunction(widget.birthMonth));
        widget.toggleBlackScreen();
        print("show month picker");
        widget.showMonthPicker();
      },
      child: Container(
        height: widget.wantedHeight * 1.02,
        width: widget.wantedWidth,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              child: Opacity(
                opacity: widget.birthMonth == widget.noneEnum ? 1 : 0,
                child: Container(
                    width: widget.wantedWidth,
                    height: widget.wantedHeight,
                    decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        border: Border.all(
                            color: widget.mainColor, width: width * 0.015)),
                    padding: EdgeInsets.only(
                        left: width * 0.032, top: height * 0.008),
                    child: Text(
                      widget.insideText,
                      style: GoogleFonts.fredoka(
                          fontWeight: FontWeight.w600,
                          color: widget.birthMonth == widget.noneEnum
                              ? Colors.grey.shade400
                              : Colors.transparent,
                          fontSize:
                              MediaQuery.of(context).textScaleFactor * 30),
                    )),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Opacity(
                opacity: widget.birthMonth == Months.None ? 0 : 1,
                child: Container(
                    width: widget.wantedWidth,
                    height: widget.wantedHeight,
                    decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        border: Border.all(
                            color: widget.mainColor, width: width * 0.015)),
                    padding: EdgeInsets.only(
                        left: width * 0.032, top: height * 0.008),
                    child: Text(
                      widget.insideText != "State" ? widget.toStringFunction(widget.birthMonth)[1] : widget.toStringFunction(widget.birthMonth),
                      style: GoogleFonts.fredoka(
                          fontWeight: FontWeight.w600,
                          color: widget.birthMonth != widget.noneEnum
                              ? widget.mainColor
                              : Colors.transparent,
                          fontSize:
                              MediaQuery.of(context).textScaleFactor * 30),
                    )),
              ),
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
          ],
        ),
      ),
    );
  }
}


