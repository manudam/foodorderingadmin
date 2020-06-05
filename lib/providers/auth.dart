import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';

class Auth extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _fireStore = Firestore.instance;
  final _collection = "Users";

  User loggedInUser;

  // Firebase user one-time fetch
  Future<FirebaseUser> get getUser => _auth.currentUser();

  Future<FirebaseUser> getFirebaseUser() async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    if (firebaseUser == null) {
      firebaseUser = await FirebaseAuth.instance.onAuthStateChanged.first;
    }
    return firebaseUser;
  }

  Future<User> fetchUserDetails() async {
    if (loggedInUser == null) {
      var user = await getUser;
      if (user?.uid != null) {
        var document =
            await _fireStore.document('/$_collection/${user.uid}').get();

        loggedInUser = User.fromMap(document.data);
      }
    }

    return loggedInUser;
  }

  //Method to handle user sign in using email and password
  Future<bool> login(String email, String password) async {
    try {
      loggedInUser = null;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await fetchUserDetails();
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

      await fetchUserDetails();
      notifyListeners();

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

  //updates the firestore users collection
  void _updateUserFirestore(User user, FirebaseUser firebaseUser) {
    _fireStore
        .document('/$_collection/${firebaseUser.uid}')
        .setData(user.toJson(), merge: true);
  }
}
