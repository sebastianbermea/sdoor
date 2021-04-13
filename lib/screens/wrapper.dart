import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sdoor/models/user.dart';
import 'package:sdoor/screens/home/home.dart';
import 'package:sdoor/screens/home/notverified.dart';

import 'authenticate/authenticate.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<NewUser>(context);
    if(user==null)
      return Authenticate();
    else{
      return Home();
      /*print("User verified ${user.verified}");
      if(user.verified)
       return Home();
       else
       return NotVerfied(idiom: user.idiom);*/
    }
     
  }
}