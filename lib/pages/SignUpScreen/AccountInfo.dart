import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highschoolhub/globalInfo.dart';
import 'package:highschoolhub/models/user.dart';
import 'package:image_picker/image_picker.dart';

class AccountInfoScreen extends StatefulWidget {
  AppUser currentUser;
  Function loadingScreen;
  @override
  AccountInfoScreen(this.currentUser, this.loadingScreen);
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
      return true;
    } on PlatformException catch (e) {
      return false;
    }
  }

  String imageUrl = "";
  void initState() {
    print(widget.currentUser.userData);
    if (widget.currentUser.userData != null &&
        widget.currentUser.userData!.photoURL != "" &&
        widget.currentUser.userData!.photoURL != null) {
      imagePicked = true;
      imageUrl = widget.currentUser.userData!.photoURL!;
    }
    super.initState();
  }

  bool imagePicked = false;

  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.025,
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
                  width: width * 0.5,
                  height: width * 0.5,
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
                                                fontWeight: FontWeight.w700),
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
                                                fontWeight: FontWeight.w700),
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
              height: height * 0.033,
            ),
            InkWell(
              onTap: () async {
                widget.loadingScreen();
                await widget.currentUser.authenticationUser();
                if (widget.currentUser.userData != null &&
                    widget.currentUser.userData!.photoURL != "" &&
                    widget.currentUser.userData!.photoURL != null) {
                  imagePicked = true;
                  imageUrl = widget.currentUser.userData!.photoURL!;
                }
                setState(() {});
                widget.loadingScreen();
              },
              child: Container(
                width: width * 0.88,
                height: height * 0.08,
                decoration: BoxDecoration(
                    color: blue,
                    border: Border.all(color: darkblue, width: width * 0.015),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100))),
                            child: Center(
                              child: CircleAvatar(
                                  radius: height * 0.02,
                                  backgroundImage: NetworkImage(imageUrl)),
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
                              : widget.currentUser.userData!.email!,
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
            SizedBox(height: height * 0.021,),
            SignUpScreenTextField(height * 0.08, width * 0.88, blue, darkblue, "First Name", width * 0.25, firstNameController), 
            SizedBox(height: height * 0.021,),
            SignUpScreenTextField(height * 0.08, width * 0.88, blue, darkblue, "Last Name", width * 0.25, lastNameController),
            SizedBox(height: height * 0.013,),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.06
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DateOfBirthPicker(height * 0.08, width * 0.25, blue, darkblue, "MO", width * 0.09), 
                  DateOfBirthPicker(height * 0.08, width * 0.25, blue, darkblue, "DAY", width * 0.11), 
                  DateOfBirthPicker(height * 0.08, width * 0.3, blue, darkblue, "YR", width * 0.085)
                ],
              ),
            ),
          ],
        ),
      ),
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
  SignUpScreenTextField(
      this.wantedHeight, this.wantedWidth, this.mainColor, this.darkColor, this.textFieldName, this.textFieldNameWidth, this.tec);
  @override
  State<SignUpScreenTextField> createState() => _SignUpScreenTextFieldState();
}

class _SignUpScreenTextFieldState extends State<SignUpScreenTextField> {
  @override
  bool tapped = false;
  void initState(){
    
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
                  border: Border.all(color: widget.mainColor, width: width * 0.015)),
              padding: EdgeInsets.only(
                left: width * 0.032, 
                top: height * 0.008
              ),
              child : Text(
                widget.textFieldName, 
                style:GoogleFonts.fredoka(
                fontWeight: FontWeight.w700,
                color: widget.tec.text == "" ? Colors.grey.shade400 : Colors.transparent, 
                fontSize: MediaQuery.of(context).textScaleFactor * 30
              ),
              )
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
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05
            ),
            child: TextFormField(
              controller: widget.tec,
              onChanged: (d){
                setState(() {
                });
              },
              onTap: (){
                setState(() {
                  tapped = true;
                });
              },
              onTapOutside: (d){
                setState(() {
                  tapped = false;
                });
              },
               style: GoogleFonts.fredoka(
                fontWeight: FontWeight.w700,
                color: widget.mainColor, 
                fontSize: MediaQuery.of(context).textScaleFactor * 30
              ),
              cursorColor: widget.mainColor, 
              cursorHeight: widget.wantedHeight * 0.5,
              decoration: InputDecoration(
                border : InputBorder.none
              ),
              
            ),
          )
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
  DateOfBirthPicker(
      this.wantedHeight, this.wantedWidth, this.mainColor, this.darkColor, this.textFieldName, this.textFieldNameWidth);
  @override
  State<DateOfBirthPicker> createState() => DateOfBirthPickerState();
}

class DateOfBirthPickerState extends State<DateOfBirthPicker> {
  bool tapped = false;
  void initState(){
    super.initState();
  }
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: widget.wantedHeight * 1.15,
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
                  border: Border.all(color: widget.mainColor, width: width * 0.015)),
              padding: EdgeInsets.only(
                left: width * 0.032, 
                top: height * 0.008
              ),
            ),
          ),
          Container(
            child: Positioned(
              left: width * 0.045,
              top: 0,
              child: Container(
                
                width: widget.textFieldNameWidth,
                padding: EdgeInsets.only(left: width * 0.01),
                color: backgroundColor,
                child:  Text(
                    widget.textFieldName,
                    style: GoogleFonts.fredoka(
                        color: widget.darkColor, fontWeight: FontWeight.w600, fontSize: MediaQuery.of(context).textScaleFactor * 18),
                  
                ),
              ),
            ),
          ), 
          
        ],
      ),
    );
  }
}

