import 'package:flutter/material.dart';
import 'package:sdoor/screens/authenticate/signUp.dart';
import 'package:sdoor/services/auth.dart';
import 'package:sdoor/shared/constant.dart';
import 'package:sdoor/shared/loading.dart';

class SignIn extends StatefulWidget {

  final Function setSignView;
  SignIn({this.setSignView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String pass = '';
  String error = '';
  String dropdownValue = 'English';

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading? Loading() : Scaffold(
     
      /*appBar: AppBar(
        backgroundColor: Colors.lightBlue[300],
        title: Text('Sdoor'),
        elevation: 5.0,
        actions: <Widget>[
          FlatButton.icon(
            onPressed: (){
              widget.setSignView();
            }, 
            icon: Icon(Icons.person), 
            label: Text('Sign up')),
        ],
      ),*/
      body: Container(
        alignment:Alignment.center,
        padding : EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: SingleChildScrollView(
            child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                
              DropdownButton<String>(
                value: dropdownValue,
                icon: Icon(Icons.keyboard_arrow_down),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.white),
                underline: Container(
                  height: 0,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: <String>['English', 'Español']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
           ),
          SizedBox(height: 30.0),
              Text('SDOOR', style: TextStyle(fontSize: 30),),
              SizedBox(height: 30.0),
              
              TextFormField(
                decoration: textInputDecoration.copyWith(labelText: 'Email',),
                style: TextStyle(color: Colors.white),
                
                validator: (val)=> val.isEmpty ? 'Please provide an email': null,
                onChanged: (val){
                  setState(() => email = val);
                },
              ),
             SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(labelText: 'Password'),
                validator: (val)=> val.length < 6 ? 'Please provide a password wit 6+ characters': null,
                obscureText: true,
                onChanged: (val){
                  setState(() => pass = val);
                },
              ),
              
               SizedBox(height: 40.0),
               Container(
                  width: double.infinity,      
                  child: RaisedButton(
                    elevation: 5.0,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    onPressed: ()async{
                   if(_formKey.currentState.validate()){
                      setState(()=> loading = true);
                     dynamic result = await _auth.signInEmail(email, pass);
                     if(result==null){
                       setState((){ 
                         error = 'The email and/or password are not correct';
                         loading = false;
                         });
                     }
                   }
                 },
                    color: Colors.lightBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                    child: Text('Login', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
                FlatButton(
                    onPressed: (){
                      Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUp()));
                    }, child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
           
                      children: [
                        Text('Dont have an account?  ',style: TextStyle(color: Colors.white70, fontSize: 14)),
                        Text('Register',style: TextStyle(color: Colors.lightBlueAccent, fontSize: 14)),
                      ],
                    ),
                  ),
                 SizedBox(height:12.0),
                 Text(error, style: TextStyle(color: Colors.red, fontSize: 12.0))
            ],),),
        ),
      ),
    );
  }
}