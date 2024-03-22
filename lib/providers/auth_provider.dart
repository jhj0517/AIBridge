import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

enum AuthStatus {
  uninitialized,
  authenticated,
  authenticating,
  authenticateError,
  authenticateException,
  authenticateCanceled,
  deletingAuth,
  deletionAuthCompleted,
  deletionAuthError,
}

class AuthProvider extends ChangeNotifier {

  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;

  AuthStatus _status = AuthStatus.uninitialized;
  AuthStatus get status => _status;

  User? _currentUser;
  User? get currentUser => _currentUser;

  AuthProvider({
    required this.firebaseAuth,
    required this.googleSignIn,
  }){}


  Future<bool> handleGoogleSignIn() async {
    _status = AuthStatus.authenticating;
    notifyListeners();

    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      _setStatus(AuthStatus.authenticateCanceled);
      return false;
    }

    GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    User? firebaseUser;
    try {
      firebaseUser = (await firebaseAuth.signInWithCredential(
          credential)).user;
    } catch (error, stacktrace) {
      debugPrint('Authentication Error : $error\n$stacktrace');
    }

    if (firebaseUser == null){
      _setStatus(AuthStatus.authenticateError);
      return false;
    }

    _currentUser = firebaseUser;
    _setStatus(_status = AuthStatus.authenticated);
    return true;
  }

  void _setStatus(AuthStatus status){
    _status = status;
    notifyListeners();
  }


}