import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<void> signOut();

  Future<FirebaseUser> getCurentUser();
}

class Auth extends BaseAuth {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Future<FirebaseUser> getCurentUser() async {
    FirebaseUser user = await firebaseAuth.currentUser();
    return user;
  }

  @override
  Future<String> signIn(String email, String password) async {
    var result = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    FirebaseUser user = result.user;
    return user.uid;
  }

  @override
  Future<void> signOut() {
    return firebaseAuth.signOut();
  }

  @override
  Future<String> signUp(String email, String password) async {
    var result = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    FirebaseUser user = result.user;
    return user.uid;
  }
}
