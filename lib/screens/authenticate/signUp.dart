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
  bool admin = true;
  String dropdownRol = 'Admin';
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
               SizedBox(height: 10.0),
               DropdownButton<String>(
                  value: dropdownRol,
                  icon: Icon(Icons.arrow_drop_down_outlined),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.white, fontSize:17),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownRol = newValue;
                      if(newValue == 'Admin')
                          admin=true;
                      print(admin);
                    });
                  },
                  isExpanded: true,
                  items: <String>['Admin', (idiom=="English")?'Employee':(idiom=="Español")? 'Empleado': 'Empregada']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  ),
                  SizedBox(height: 15.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: (idiom=="English" ? 'Username': 
                (idiom=="Español"?'Nombre de usuario':'Nome de usuário'))),
                 validator: (val)=> val.isEmpty ? (idiom=="English" ? 'Please provide an username':
                  (idiom=="Español"? 'Por favor ingresa un nombre de usuario':'Forneça um nome de usuário')): null,
                onChanged: (val){
                  setState(() => username = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Email'),
                validator: (val)=> val.isEmpty ? (idiom=="English" ? 'Please provide an email':
                (idiom=="Español"? 'Por favor ingresa un email':'Por favor, forneça um e-mail')): null,
                onChanged: (val){
                  setState(() => email = val);
                },
              ),
             SizedBox(height: 20.0),
             TextFormField(
                decoration: textInputDecoration.copyWith(hintText: (idiom=="English" ? 'Password': idiom=="Español"?'Contraseña':'Senha')),
                obscureText: true,
                validator: (val)=> val.length < 6 ?  (idiom=="English" ? 'Please provide a password with 6+ characters':
                (idiom=="Español"? 'Por favor ingresa una contraseña con 6+ caracteres':'Digite uma senha com mais de 5 caracteres')): null,
                onChanged: (val){
                  setState(() => pass = val);
                },
              ),
              SizedBox(height: 20.0),
             TextFormField(
                decoration: textInputDecoration.copyWith(hintText: (idiom=="English" ? 'Confirm Password': 
                (idiom=="Español"?'Confirmar Contraseña':'Confirmar senha'))),
                obscureText: true,
                validator: (val)=> val != pass ? (idiom=="English" ? 'Passwords must match':
                (idiom=="Español"? 'Las contraseñas deben coincidir':'As senhas devem corresponder')): null,
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
                     dynamic result = await _auth.singUpEmail(email, pass, username, idiom, admin);
                    
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