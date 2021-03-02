import 'package:flutter/material.dart';
import 'package:sdoor/services/auth.dart';
import 'package:sdoor/shared/constant.dart';
import 'package:sdoor/shared/loading.dart';

class SignUp extends StatefulWidget {
  final Function setSignView;
  SignUp({this.setSignView});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String pass = '';
  String confirmPass = '';
  String error = '';
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading? Loading(): Scaffold(
      
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        /*elevation: 5.0,
         actions: <Widget>[
          FlatButton.icon(
            onPressed: (){
              Navigator.pop(context);
            }, 
            icon: Icon(Icons.person), 
            label: Text('Sign in')),
        ],*/
      ),
      body: Container(
        alignment: Alignment.center,
        padding : EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: SingleChildScrollView(
            child: Form(
            key: _formKey,
            child: Column(children: <Widget>[
              Text('Sign Up', style: TextStyle(fontSize: 30),),
              SizedBox(height: 30.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Username'),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Email'),
                validator: (val)=> val.isEmpty ? 'Please provide an email': null,
                onChanged: (val){
                  setState(() => email = val);
                },
              ),
             SizedBox(height: 20.0),
             TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
                obscureText: true,
                validator: (val)=> val.length < 6 ? 'Please provide a password wit 6+ characters': null,
                onChanged: (val){
                  setState(() => pass = val);
                },
              ),
              SizedBox(height: 20.0),
             TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Confirm Password'),
                obscureText: true,
                validator: (val)=> val != pass ? 'Passwords must be the same': null,
                onChanged: (val){
                  setState(() => confirmPass = val);
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
                     setState(() {
                       loading=true;
                     });
                     dynamic result = await _auth.singUpEmail(email, pass);
                    
                     if(result==null){
                        setState((){ 
                         error = 'Please provide a valid email';
                         });
                     }else{
                       Navigator.pop(context);
                     }
                   }
                  
                 },
                    color: Colors.lightBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                    child: Text('Register', style: TextStyle(color: Colors.white, fontSize: 18)),
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