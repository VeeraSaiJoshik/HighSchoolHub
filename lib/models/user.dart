import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:highschoolhub/models/school.dart';
import 'package:highschoolhub/main.dart';
import 'package:supabase/supabase.dart';

import 'dart:io' show Platform;

class AppUser {
  String email;
  School school = School();
  String image;
  late AuthResponse userData;

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
    final rawNonce = _generateRandomString();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    /// TODO: update the client ID with your own
    ///
    /// Client ID that you registered with Google Cloud.
    /// You will have two different values for iOS and Android.
    String clientId = "";
    if(Platform.isAndroid){
      clientId = '297787439752-ma83pfhh3h7vko9kfk7737c07nsiqqko.apps.googleusercontent.com';
    }else if(Platform.isIOS){
      clientId = '297787439752-esu9hd570qdmbomshm34lq5odpmact7g.apps.googleusercontent.com';
    }

    /// reverse DNS form of the client ID + `:/` is set as the redirect URL
    final redirectUrl = '${clientId.split('.').reversed.join('.')}:/';

    /// Fixed value for google login
    const discoveryUrl =
        'https://accounts.google.com/.well-known/openid-configuration';

    final appAuth = FlutterAppAuth();

    // authorize the user by opening the concent page
    final result = await appAuth.authorize(
      AuthorizationRequest(
        clientId,
        redirectUrl,
        discoveryUrl: discoveryUrl,
        nonce: hashedNonce,
        scopes: [
          'openid',
          'email',
        ],
      ),
    );
    if (result == null) {
      throw 'No result';
    }

    // Request the access and id token to google
    final tokenResult = await appAuth.token(
      TokenRequest(
        clientId,
        redirectUrl,
        authorizationCode: result.authorizationCode,
        discoveryUrl: discoveryUrl,
        codeVerifier: result.codeVerifier,
        nonce: result.nonce,
        scopes: [
          'openid',
          'email',
        ],
      ),
    );

    final idToken = tokenResult?.idToken;

    if (idToken == null) {
      throw 'No idToken';
    }

    userData = await supaBase.auth.signInWithIdToken(
      provider: Provider.google,
      idToken: idToken,
      nonce: rawNonce,
    );
    if(userData.user != null){
      email = userData.user!.email!;
    }else{
      return -1;
    }
    bool userInDatabase = await findUserInDatabase();
    if(userInDatabase == false){
      return 2;
    }
    return 1;
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
