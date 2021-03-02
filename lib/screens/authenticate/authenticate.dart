import 'package:flutter/material.dart';
import 'package:sdoor/screens/authenticate/signIn.dart';
import 'package:sdoor/screens/authenticate/signUp.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool isSignInState = true;

  void setSignView(){
    setState(() {isSignInState = !isSignInState;});
  }

  @override
  Widget build(BuildContext context) {
    if(isSignInState)
      return SignIn(setSignView: setSignView);
    else
      return SignUp(setSignView: setSignView);
  }
}