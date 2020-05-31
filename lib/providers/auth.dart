import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class Auth extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Firebase user one-time fetch
  Future<FirebaseUser> get getUser => _auth.currentUser();

  Future<bool> isAuthenticated() async {
    var user = await getUser;
    return (user.displayName != null);
  }

  //Method to handle user sign in using email and password
  Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  //Method to handle user sign in using email and password
  Future<bool> register(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Sign out
  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}
