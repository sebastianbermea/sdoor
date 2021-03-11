
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sdoor/models/user.dart';
import 'package:sdoor/services/db.dart';


class AuthService{
   final FirebaseAuth _auth = FirebaseAuth.instance;

  NewUser _userfromFirebase(User user){
    return user != null ? NewUser(uid: user.uid, verified: user.emailVerified) : null;
  }
  User currentUser(){
    return _auth.currentUser;
  }
  Stream<NewUser> get user{
    return _auth.authStateChanges()
    .map(_userfromFirebase);
  }
  //sign anonymous
  Future singInAnon() async{
    
    try{
      UserCredential credential = await _auth.signInAnonymously();
      User user = credential.user;
      return _userfromFirebase(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  
  Future signInEmail(String email, String pass) async{
    try{
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: pass);
      User user = credential.user;
      return _userfromFirebase(user);

    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future singUpEmail(String email, String pass, String username, String idiom) async{
    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      User user = credential.user;
      await DBService(uid: user.uid).updateUserData(username, idiom, false, "", false, false);
      return _userfromFirebase(user);

    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future signOut() async{
    try{
      await _auth.signOut();
    }catch(e){
      print(e.toString());
    }
  }
}