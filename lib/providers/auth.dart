import 'package:flutter/material.dart';
import 'package:foodorderingadmin/models/user.dart';
import 'package:foodorderingadmin/services/pocketbase_service.dart';

class Auth extends ChangeNotifier {
  final _pocketBase = PocketBaseService.client;

  User loggedInUser = User();

  Future<User> fetchUserDetails() async {
    if (loggedInUser.uid.isEmpty && _pocketBase.authStore.record != null) {
      final record = _pocketBase.authStore.record;
      if (record != null) {
        loggedInUser = User.fromMap(record.id, record.data);
      }
      notifyListeners();
    }

    return loggedInUser;
  }

  Future<bool> login(String email, String password) async {
    loggedInUser = User();
    final auth = await _pocketBase
        .collection('users')
        .authWithPassword(email.trim(), password);
    loggedInUser = User.fromMap(auth.record.id, auth.record.data);
    notifyListeners();
    return true;
  }

  Future<bool> register(String name, String email, String password) async {
    final record = await _pocketBase.collection('users').create(body: {
      'email': email.trim(),
      'password': password,
      'passwordConfirm': password,
      'name': name,
      'role': 'admin',
    });

    loggedInUser = User.fromMap(record.id, record.data);
    notifyListeners();
    return true;
  }

  Future<bool> signOut() async {
    _pocketBase.authStore.clear();
    loggedInUser = User();
    notifyListeners();
    return true;
  }
}
