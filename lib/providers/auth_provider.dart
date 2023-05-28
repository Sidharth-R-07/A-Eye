import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final String saveStatusKEY = 'SIGN_IN_STATUS_KEY';

  bool isUserSignedIn = false;

  User? get getCurrentUser => _auth.currentUser;

  Future<void> setSignInStatus(bool newValue) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(saveStatusKEY, newValue);

    log('BOOL SAVED BOOL :$newValue');
  }

  Future<bool?> getSignInStatus() async {
    final prefs = await SharedPreferences.getInstance();

    final fetchStatus = await prefs.getBool(saveStatusKEY);

    if (fetchStatus == null) {
      await prefs.setBool(saveStatusKEY, false);
      log('PRINT RESULT: $fetchStatus');
    }

    log('GETTING STATUS BOOL>>>');
    log('STATUS BOOL :$fetchStatus');

    return fetchStatus;
  }

  Future<UserCredential?> signInWithGoogle() async {
    UserCredential userCredential;

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      userCredential = await _auth.signInWithCredential(credential);
      saveUserData();
      return userCredential;
    } catch (err) {
      log('ERROR FOUND IN GOOGLE SIGN IN:$err');
      rethrow;
    }
  }

  Future<void> signOutUser() async {
    try {
      await _auth.signOut();
      await setSignInStatus(false);
    } catch (err) {
      rethrow;
    }
  }

  Future<void> saveUserData() async {
    final currentUser = _auth.currentUser;
    final ref =
        FirebaseFirestore.instance.collection('users').doc(currentUser!.uid);

    await ref.set({
      'name': currentUser.displayName,
      'email': currentUser.email,
      'photo': currentUser.photoURL,
    });
    log('User data saved');
  }
}
