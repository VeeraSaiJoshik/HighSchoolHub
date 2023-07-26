import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:highschoolhub/models/school.dart';
import 'package:highschoolhub/main.dart';
import 'package:highschoolhub/pages/SignUpScreen/AccountInfo.dart';
import 'package:supabase/supabase.dart';
import 'package:google_sign_in/google_sign_in.dart';



import 'dart:io' show Platform;

class AppUser {
  String email;
  List<School> schools = [];
  String image;
  DateOfBirth dateOfBirth = DateOfBirth(0, 0, Months.None);
  USStates userState = USStates.None;
  fa.User? userData;
  void setAlData(String email, School school, String image, DateOfBirth dateOfBirth){
    this.email = email;
    this.schools = schools;
    this.image = image;
    this.dateOfBirth = dateOfBirth;
  }
  AppUser({this.email = "", this.image = "", this.schools = const [], this.userData });
  String _generateRandomString() {
    final random = Random.secure();
    return base64Url.encode(List<int>.generate(16, (_) => random.nextInt(256)));
  }
  void setSchoolData(){
  }
  void setGeneralData(){

  }
  Future<int> authenticationUser() async {
    /**
     * Legend 
     * 1 = Succesful
     * 2 = Not Signed Up
     * -1 = failed
     */
    final GoogleSignInAccount? temp = await GoogleSignIn().signIn();
    print(temp);
    if(temp != null){
      final GoogleSignInAuthentication gAuth = await temp!.authentication;
      final credential = fa.GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken, 
        idToken: gAuth.idToken
      );
      userData = (await fa.FirebaseAuth.instance.signInWithCredential(credential)).user!;
      print("user data has been completed : ");
      print(userData);
      email = userData!.email!;
      if (await findUserInDatabase()) return 1;
      return 2;
    }
    
    return -1;
  }
  void signOut() {}
  Future<bool> findUserInDatabase() async {
    final userData = await supaBase.from('user_auth_table').select("email");
    for(int i = 0; i < userData.length; i++){
      if(userData[i]["email"] == email) return true;
    }
    return false;
  }
  void addSchool(School school){
    schools.add(school);
    
  }
  void removeSchool(String schoolName){
    for(School school in schools){
      if(school.name == schoolName){
        schools.remove(school);
        break;
      }
    }
  }
  School getSchool(String schoolName){
    for(School school in schools){
      if(school.name == schoolName){
        return school;
      }
    }
    return schools[0];
  }
}

class DateOfBirth{
  int day;
  int year;
  Months month;
  DateOfBirth(this.day, this.year, this.month);
}
