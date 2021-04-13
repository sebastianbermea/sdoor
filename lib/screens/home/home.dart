import 'package:flutter/material.dart';
import 'package:sdoor/models/user.dart';
import 'package:sdoor/screens/home/door.dart';
import 'package:sdoor/screens/home/registration.dart';
import 'package:sdoor/screens/home/settingsW.dart';
import 'package:provider/provider.dart';
import 'package:sdoor/services/db.dart';
import 'package:sdoor/shared/loading.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  /*List<Widget> _widgets = <Widget>[
    Door(user: newUser),
    Center(child: Text('Data')),
    Center(child: Text('Registration')),
  ];*/

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<NewUser>(context);
    return StreamBuilder<NewUser>(
        stream: DBService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            NewUser newUser = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                  title: Text(
                    'SDOOR',
                    style: TextStyle(fontSize: 28),
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  actions: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SettingsW(user: newUser)));
                        //await _auth.signOut();
                        //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> Authenticate()));
                      },
                      icon: Icon(Icons.settings),
                    ),
                  ]),
              //ody: _widgets[_currentIndex],
              body: (_currentIndex == 0)
                  ? Door(user: newUser)
                  : ((_currentIndex == 1)
                      ? Center(child: Text('Data'))
                      : ((newUser.doorId.isNotEmpty)
                          ? Registration(user: newUser)
                          : Center(child: Text( (newUser.idiom == "English") ?'No door available':
                          (newUser.idiom == "Español") ?'No hay puerta disponible':'Sem porta disponível')))),
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Colors.blueGrey[700],
                selectedItemColor: Colors.lightBlue,
                currentIndex: _currentIndex,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.camera),
                    label: (newUser.idiom == "English") ? 'Door' : (newUser.idiom == "Español") ?'Puerta':'Porta',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.date_range),
                    label: (newUser.idiom == "English") ? 'Data' : (newUser.idiom == "Español") ?'Datos':'Dados',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.fingerprint),
                    label: (newUser.idiom == "English")
                        ? 'Registration'
                        : 'Registro',
                  ),
                ],
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
