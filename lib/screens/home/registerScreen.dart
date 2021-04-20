import 'package:flutter/material.dart';
import 'package:sdoor/models/user.dart';
import 'package:sdoor/shared/constant.dart';

class RegisterScreen extends StatefulWidget {
  final NewUser user;
  RegisterScreen({this.user});
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String username = "";
  bool waiting = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Visibility(
                        visible: waiting,
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.lightBlue,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      SizedBox(height: 40.0),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            labelText: (widget.user.idiom == "English"
                                ? 'Name'
                                : (widget.user.idiom == "Español"
                                    ? 'Nombre'
                                    : 'Nome'))),
                        validator: (val) => val.length < 3
                            ? (widget.user.idiom == "English"
                                ? 'Please provide a name'
                                : (widget.user.idiom == "Español"
                                    ? 'Por favor ingresa un nombre'
                                    : 'Digite um nome'))
                            : null,
                        onChanged: (val) {
                          setState(() => username = val);
                        },
                      ),
                      SizedBox(height: 40.0),
                      Container(
                        width: double.infinity,
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          elevation: 5.0,
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => waiting = true);
                            }
                          },
                          color:
                              (waiting) ? Colors.grey[400] : Colors.lightBlue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3)),
                          child: Text(
                              (widget.user.idiom == "English"
                                  ? ((!waiting)
                                      ? 'Prepare Fingerprint'
                                      : 'Waiting for confirmation...')
                                  : (widget.user.idiom == "Español"
                                      ? 'Preparar Huella'
                                      : 'Preparar Pegada')),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      (!waiting)
                          ? SizedBox(height: 20.0)
                          : Container(
                              width: 100.0,
                              // ignore: deprecated_member_use
                              child: RaisedButton(
                                elevation: 5.0,
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() => waiting = false);
                                  }
                                },
                                color: Colors.red,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3)),
                                child: Text(
                                    (widget.user.idiom == "English"
                                        ? 'Cancel'
                                        : (widget.user.idiom == "Español"
                                            ? 'Preparar Huella'
                                            : 'Preparar Pegada')),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18)),
                              ),
                            ),
                    ]))));
  }
}
