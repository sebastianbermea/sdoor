import 'package:flutter/material.dart';
import 'package:sdoor/services/auth.dart';
import 'package:sdoor/shared/constant.dart';
import 'package:sdoor/shared/loading.dart';

class SignUp extends StatefulWidget {
  final Function setSignView;
  final String idiom;
  SignUp({this.setSignView, this.idiom});

  @override
  _SignUpState createState() => _SignUpState(idiom);
}

class _SignUpState extends State<SignUp> {

  _SignUpState(this.idiom);
  final String idiom;
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String pass = '';
  String confirmPass = '';
  String error = '';
  String username = '';
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
              Text((idiom=="English" ? 'Sign Up': 'Registro'), style: TextStyle(fontSize: 30),),
              SizedBox(height: 30.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: (idiom=="English" ? 'Username': 'Nombre de usuario')),
                 validator: (val)=> val.isEmpty ? (idiom=="English" ? 'Please provide an username': 'Por favor ingresa un nombre de usuario'): null,
                onChanged: (val){
                  setState(() => username = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Email'),
                validator: (val)=> val.isEmpty ? (idiom=="English" ? 'Please provide an email': 'Por favor ingresa un email'): null,
                onChanged: (val){
                  setState(() => email = val);
                },
              ),
             SizedBox(height: 20.0),
             TextFormField(
                decoration: textInputDecoration.copyWith(hintText: (idiom=="English" ? 'Password': 'Contraseña')),
                obscureText: true,
                validator: (val)=> val.length < 6 ?  (idiom=="English" ? 'Please provide a password with 6+ characters': 'Por favor ingresa una contraseña con 6+ caracteres'): null,
                onChanged: (val){
                  setState(() => pass = val);
                },
              ),
              SizedBox(height: 20.0),
             TextFormField(
                decoration: textInputDecoration.copyWith(hintText: (idiom=="English" ? 'Confirm Password': 'Confirmar Contraseña')),
                obscureText: true,
                validator: (val)=> val != pass ? (idiom=="English" ? 'Passwords must match': 'Las contraseñas deben coincidir'): null,
                onChanged: (val){
                  setState(() => confirmPass = val);
                },
              ),
              SizedBox(height: 40.0),
              Container(
                  width: double.infinity,      
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    elevation: 5.0,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    onPressed: ()async{
                   if(_formKey.currentState.validate()){
                     setState(() {
                       loading=true;
                     });
                     dynamic result = await _auth.singUpEmail(email, pass, username, idiom);
                    
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
                    child: Text((idiom=="English" ? 'Register': 'Registrarse'), style: TextStyle(color: Colors.white, fontSize: 18)),
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