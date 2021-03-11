import 'package:flutter/material.dart';
import 'package:sdoor/models/newdoor.dart';
import 'package:sdoor/models/user.dart';
import 'package:sdoor/models/waitTile.dart';
import 'package:sdoor/services/db.dart';
import 'package:sdoor/shared/loading.dart';

class Registration extends StatefulWidget {
  final NewUser user;
  Registration({this.user});
  @override
  _RegistrationState createState() => _RegistrationState(user: user);
}

class _RegistrationState extends State<Registration> {
  final NewUser user;
  NewDoor door;
  List<NewUser> userList = [];
  _RegistrationState({this.user});
  destroyTile(NewUser userR){
    userList.remove(userR);
      setState(() {});
  }
  setData() async {
    door = await DBService(doorId: user.doorId, uid: user.uid).getDoor;
    for (int i = 0; i < door.waitlist.length; i++) {
      print(door.waitlist[i]);
      NewUser tempUser = await DBService(uid: door.waitlist[i]).getUser ?? null;
      print(tempUser == null);
      if (tempUser != null) userList.add(tempUser);
    }

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (door != null) {
      return ListView.builder(
          itemCount: userList.length,
          itemBuilder: (context, index) {
            return WaitTile(user: userList[index], mainUser: user, destroy: destroyTile,);
          });
    } else {
      return Loading();
    }
  }
}
