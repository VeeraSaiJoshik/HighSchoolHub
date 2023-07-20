import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:highschoolhub/models/school.dart';
import 'package:highschoolhub/main.dart';
import 'package:supabase/supabase.dart';
import 'package:google_sign_in/google_sign_in.dart';



import 'dart:io' show Platform;

class AppUser {
  String email;
  School school = School();
  String image;
  fa.User? userData;

  AppUser({this.email = "", this.image = ""});
  String _generateRandomString() {
    final random = Random.secure();
    return base64Url.encode(List<int>.generate(16, (_) => random.nextInt(256)));
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
}
