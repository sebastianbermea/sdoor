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
    
    dropdownValue = user.idiom;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            (user.idiom == "English") ? 'Settings' : (user.idiom == "Español") ? 'Configuracion':'Contexto',
            style: TextStyle(fontSize: 28),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Column(children: <Widget>[
          SizedBox(height: 60.0),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text((user.idiom == "English") ? "Username:  " :(user.idiom == "Español") ? "Usuario:  ":'Do utilizador:  ',
                  style: TextStyle(fontSize: 22)),
              Text(user.username,  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 10.0),
          Text(
                (user.admin) ? 'Admin' : (user.idiom == "English") ? "Employee" :(user.idiom == "Español") ? "Empleado":'Empregada',
                style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
              ),
          SizedBox(height: 60.0),
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
            child: Text((user.idiom == "English") ? 'Log Out' : (user.idiom == "Español") ?'Cerrar sesion': 'Fechar Sessão',
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
          SizedBox(height: 40.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 20.0),
              Text(
                (user.idiom == "English") ?"Idiom: ":(user.idiom == "Español") ? "Idioma: ":'Língua',
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
                  await DBService(uid: user.uid).updateUserData(user.username, user.idiom, user.hasDoor, user.doorId, user.viewData, user.register, user.admin);
                },
                items: <String>['English', 'Español', 'Português']
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
