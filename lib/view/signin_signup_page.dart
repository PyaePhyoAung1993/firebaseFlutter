import 'package:firebase_todo/services/authentication.dart';
import 'package:flutter/material.dart';

class SignInSignUpPage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback siginCallBack;

  SignInSignUpPage({Key key, this.auth, this.siginCallBack}) : super(key: key);

  @override
  _SignInSignUpPageState createState() => _SignInSignUpPageState();
}

class _SignInSignUpPageState extends State<SignInSignUpPage> {
  final formKey = GlobalKey<FormState>();
  bool _isLoading;
  bool _isSigninForm;
  String _email;
  String _password;
  String _errorMessage;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (_isSigninForm) {
          userId = await widget.auth.signIn(_email, _password);
        } else {
          userId = await widget.auth.signUp(_email, _password);
        }
        setState(() {
          _isLoading = false;
        });
        if (userId.length > 0 && userId != null && _isSigninForm != null)
          widget.siginCallBack;
      } catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          formKey.currentState.reset();
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _errorMessage = "";
    _isLoading = false;
    _isSigninForm = true;
  }

  void resetForm() {
    formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleForm() {
    resetForm();
    setState(() {
      _isSigninForm = !_isSigninForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter ToDo"),
      ),
      body: Stack(
        children: [showCircularProgress(), showForm()],
      ),
    );
  }

  Widget showForm() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Form(
        child: ListView(
          children: [
            showEmailInput(),
            showPasswordInput(),
            showPrimaryButton(),
            showSecondaryButton(),
            showErrorMessage(),
          ],
        ),
      ),
    );
  }

  Widget showCircularProgress() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Container(
        width: 0,
        height: 0,
      );
    }
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return Text(
        _errorMessage,
        style: TextStyle(
          color: Colors.red,
          fontSize: 12,
        ),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  Widget showEmailInput() {
    return Padding(
      padding: EdgeInsets.only(top: 100),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
            hintText: 'Email',
            icon: Icon(
              Icons.mail,
              color: Colors.green,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
            hintText: 'Password',
            icon: Icon(
              Icons.lock,
              color: Colors.green,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showPrimaryButton() {
    return Padding(
      padding: EdgeInsets.only(top: 30),
      child: RaisedButton(
        onPressed: validateAndSubmit,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        color: Colors.blue,
        child: Text(
          _isSigninForm ? 'Sign in' : 'Create account',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget showSecondaryButton() {
    return FlatButton(
      onPressed: () {
        setState(() {});
      },
      child: Text(
        _isSigninForm ? 'Create account' : 'Already created? Sign in',
        style: TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }
}
