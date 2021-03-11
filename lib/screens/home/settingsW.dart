import 'package:flutter/material.dart';
import 'package:sdoor/models/user.dart';
import 'package:sdoor/services/auth.dart';
import 'package:sdoor/services/db.dart';

class SettingsW extends StatefulWidget {

  final NewUser user;
  SettingsW({this.user});
  @override
  _SettingsState createState() => _SettingsState(user: user);
}

class _SettingsState extends State<SettingsW> {

 final NewUser user;
  _SettingsState({this.user});

  final AuthService _auth = AuthService();
  String dropdownValue = 'English';
  @override
  Widget build(BuildContext context) {
    
  print(user.idiom);
    
    dropdownValue = user.idiom;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            (user.idiom == "English") ? 'Settings' : 'Configuracion',
            style: TextStyle(fontSize: 28),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Column(children: <Widget>[
          SizedBox(height: 50.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text((user.idiom == "English") ? "Username: " : "Usuario: ",
                  style: TextStyle(fontSize: 20)),
              Text(user.username,  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 30.0),
          // ignore: deprecated_member_use
          RaisedButton(
            elevation: 5.0,
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
            onPressed: () async {
              await _auth.signOut();
              Navigator.of(context).pop();
            },
            color: Colors.lightBlue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
            child: Text((user.idiom == "English") ? 'Log Out' : 'Cerrar sesion',
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
          SizedBox(height: 40.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 20.0),
              Text(
                (user.idiom == "English") ?"Idiom: ": "Idioma: ",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(width: 80.0),
              DropdownButton<String>(
                value: dropdownValue,
                icon: Icon(Icons.keyboard_arrow_down),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.white, fontSize: 18),
                underline: Container(
                  height: 0,
                ),
                onChanged: (String newValue) async{
                  setState(() {
                    dropdownValue = newValue;
                  });
                  user.idiom = newValue;
                  await DBService(uid: user.uid).updateUserData(user.username, user.idiom, user.hasDoor, user.doorId, user.viewData, user.register);
                },
                items: <String>['English', 'Español']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
        ]));
  }
}
