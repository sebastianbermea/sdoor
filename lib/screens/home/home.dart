import 'package:flutter/material.dart';
import 'package:sdoor/screens/home/door.dart';
import 'package:sdoor/services/auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  int _currentIndex=0;
  List<Widget> _widgets = <Widget>[
    Door(),
    Center(child: Text('Data')),
    Center(child: Text('Registration')),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('SDOOR', style: TextStyle(fontSize: 28),),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              onPressed: () async{
                await _auth.signOut();
                //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> Authenticate()));
              }, 
              icon: Icon(Icons.settings), 
            ),]
    ),
    body: _widgets[_currentIndex],
    bottomNavigationBar: BottomNavigationBar(
      backgroundColor: Colors.blueGrey[700],
      selectedItemColor: Colors.lightBlue,
      currentIndex: _currentIndex,
      items:[
         BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            title:Text('Door'),
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.date_range),
            title:Text('Data'),
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.fingerprint),
            title:Text('Registration'),
          ),
      ],
       onTap: (index){
         setState(() {
           _currentIndex = index;
         });
       },
      ),
    );
  }
}