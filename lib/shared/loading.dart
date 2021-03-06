import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 51, 55, 64),
      child: Center(
        child: SpinKitRotatingCircle(
          color: Colors.white,
          size: 25,
        ),
      ),
    );
  }
}