import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sdoor/screens/home/home.dart';
import 'package:sdoor/services/auth.dart';

class NotVerfied extends StatefulWidget {
  final String idiom;
  NotVerfied({this.idiom});
  @override
  _NotVerfiedState createState() => _NotVerfiedState(idiom: idiom);
}

class _NotVerfiedState extends State<NotVerfied> {
  final AuthService _auth = AuthService();
  User user;
  Timer timer;
  final String idiom;
  _NotVerfiedState({this.idiom});
  @override
  void initState() {
   
    user= _auth.currentUser();
    user.sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 5), (timer) { 
      checkEmailVerified();
    });
    super.initState();
  }
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(child: Text((idiom=='English')?'Waiting for verfication...':(idiom=='Español')? 'Esperando verificacion...'
          :'Aguardando verificação ...', style: TextStyle(color: Colors.white, fontSize: 24))),
          // ignore: deprecated_member_use
          RaisedButton(onPressed: () async{
                await _auth.signOut();
              },
               color: Colors.pinkAccent[400],
               child: Text(((idiom=='English')?'Log out':(idiom=='Español')?'Cerrar Sesion':'Fechar Sessão'), style: TextStyle(color: Colors.white),), )
        ]
      ),
    );
  }

  Future <void> checkEmailVerified() async{
    user = _auth.currentUser();
    await user.reload();
    if(user.emailVerified){
       timer.cancel();
       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> Home()));
    }
      
  }
}