import 'package:firebase_todo/services/authentication.dart';
import 'package:firebase_todo/view/signin_signup_page.dart';
import 'package:flutter/material.dart';

enum AuthStatus { NOT_DETERMINE, NOT_SIGN_IN, SIGN_iN }

class RootPage extends StatefulWidget {
  final BaseAuth auth;

  const RootPage({Key key, this.auth}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINE;

  String userId = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurentUser().then((user) {
      setState(() {
        if (user != null) {
          userId = user.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_SIGN_IN : AuthStatus.SIGN_iN;
      });
    });
  }

  void signInCallBack() {
    widget.auth.getCurentUser().then((value) {
      setState(() {
        userId = value.uid.toString();
        authStatus = AuthStatus.SIGN_iN;
      });
    });
  }

  void signOut() {
    setState(() {
      authStatus = AuthStatus.NOT_SIGN_IN;
      userId = "";
    });
  }

  Widget waitingScreen() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINE:
        return waitingScreen();
        break;

      case AuthStatus.NOT_SIGN_IN:
        return SignInSignUpPage(
          auth: widget.auth,
          siginCallBack: signInCallBack,
        );
        break;
      case AuthStatus.SIGN_iN:
        break;

      default:
        return waitingScreen();
    }
  }
}
