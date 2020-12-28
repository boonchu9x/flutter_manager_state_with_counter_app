import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  //func sign in với google form login default
  Future<FirebaseUser> signInWithGoogle() async{
    final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    //xác thực 2 lớp của firebase
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.getCredential(
      idToken: googleSignInAuthentication.accessToken,
      accessToken: googleSignInAuthentication.idToken
    );
    await _firebaseAuth.signInWithCredential(authCredential);
  }


  //async(bất đồng bộ) nên khi hàm này chạy xong mới chạy các hàm khác
  Future<void> signInWithMailAndPass(String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(), password: password); // password không nên trim()
  }

  //async(bất đồng bộ)
  Future<void> createUserRegister(String email, String pass) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(), password: pass); // password không nên trim()
  }

  //async(bất đồng b ộ)
  Future<void> signOut() async {
    return await Future.wait(
        [_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }

  Future<bool> isSignIn() async {
    return await _firebaseAuth.currentUser != null;
  }

  Future<FirebaseUser> getUser() async {
    return await _firebaseAuth.currentUser;
  }
}
