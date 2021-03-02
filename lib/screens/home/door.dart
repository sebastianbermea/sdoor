import 'package:flutter/material.dart';

class Door extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
       children: [
         SizedBox(height: 20.0),
         RichText(text: TextSpan(
           style: TextStyle(fontSize: 22),
           children: <TextSpan>[
             TextSpan(text: 'Temperatura actual:   '),
              TextSpan(text: '36°', style: TextStyle(color: Colors.lightGreen, fontWeight: FontWeight.bold)),
           ]
         )),
         SizedBox(height: 20.0),
         Image(image: AssetImage('assets/images/CameraNot.png')),
         SizedBox(height: 20.0),
         Text('Last person to enter:', style: TextStyle(fontSize: 18)),
          SizedBox(height: 5.0),
         Text('xxxxxx xxxxxx xxxxx', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
         SizedBox(height: 30.0),
          RaisedButton(
            elevation: 5.0,
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 40),
            onPressed: (){},
            color: Colors.lightBlue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
            child: Text('Open', style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
       ],
      ),
    );
  }
}