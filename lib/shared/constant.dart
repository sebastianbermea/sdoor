import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  
  labelStyle: TextStyle(color: Colors.white70),
  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1.0)),
  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0)),
  errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent, width: 1.0)),
  focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent, width: 1.0)),
);