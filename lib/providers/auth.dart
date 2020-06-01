import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodorderingadmin/models/user.dart';

class Auth extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _fireStore = Firestore.instance;

  // Firebase user one-time fetch
  Future<FirebaseUser> get getUser => _auth.currentUser();

  // Firebase user a realtime stream
  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;

  //Streams the firestore user from the firestore collection
  Stream<User> streamFirestoreUser(FirebaseUser firebaseUser) {
    if (firebaseUser?.uid != null) {
      return _fireStore
          .document('/users/${firebaseUser.uid}')
          .snapshots()
          .map((snapshot) => User.fromMap(snapshot.data));
    }
    return null;
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
  Future<bool> register(String name, String email, String password) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        final newUser = User(
          uid: value.user.uid,
          email: value.user.email,
          name: name,
        );

        _updateUserFirestore(newUser, value.user);
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  // Sign out
  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      var user = await getUser;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  //updates the firestore users collection
  void _updateUserFirestore(User user, FirebaseUser firebaseUser) {
    _fireStore
        .document('/users/${firebaseUser.uid}')
        .setData(user.toJson(), merge: true);
  }
}
