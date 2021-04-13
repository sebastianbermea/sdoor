import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sdoor/screens/wrapper.dart';
import 'package:sdoor/services/auth.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
   return StreamProvider<NewUser>.value(
     initialData: NewUser(),
      value: AuthService().user,
        child:MaterialApp(
          debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Sfui',
        backgroundColor: Color.fromARGB(255, 51, 55, 64),
        primarySwatch: Colors.lightBlue,
        scaffoldBackgroundColor:Color.fromARGB(255, 51, 55, 64),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        
      ),
      home: Wrapper(),
    ));
  }
}

