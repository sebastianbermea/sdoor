import 'package:flutter/material.dart';
import 'package:sdoor/models/user.dart';
import 'package:sdoor/services/db.dart';

class WaitTile extends StatefulWidget {
  final NewUser user, mainUser;
  final Function destroy;
  WaitTile({this.user, this.mainUser, this.destroy});

  @override
  _WaitTileState createState() => _WaitTileState();
}

class _WaitTileState extends State<WaitTile> {
  bool viewData=false;
  bool registerUsers=false;

  createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
       builder: (context, setState) { 
          return AlertDialog(
              title: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      (widget.mainUser.idiom == "English")
                          ? "Add User:   "
                          : "Añadir usuario: ",
                      style: TextStyle(fontSize: 20)),
                  Text(widget.user.username,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              content: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  //position
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text( (widget.mainUser.idiom == "English")
                          ?'View Data': 'Ver datos'),
                        Switch(
                          value: viewData,
                          onChanged: (value) {
                            setState(() {
                              viewData = value;
                              print(viewData);
                            });
                          },
                          activeTrackColor: Colors.lightBlue[400],
                          activeColor: Colors.lightBlue[600],
                        ),
                      ],
                    ),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text( (widget.mainUser.idiom == "English")
                          ?'Register users': 'Registrar usuarios'),
                        Switch(
                          value: registerUsers,
                          onChanged: (value) {
                            setState(() {
                              registerUsers = value;
                              print(registerUsers);
                            });
                          },
                          activeTrackColor: Colors.lightBlue[400],
                          activeColor: Colors.lightBlue[600],
                        ),
                      ],
                    ),
                  ]),
              actions: <Widget>[
                  MaterialButton(
                    elevation: 5.0,
                    child: Text((widget.mainUser.idiom == "English") ? 'Cancel' : 'Cancelar'),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    }),
                MaterialButton(
                    elevation: 5.0,
                    child: Text((widget.mainUser.idiom == "English") ? 'Accept' : 'Aceptar'),
                    onPressed: () async {
                      await DBService(uid: widget.user.uid, doorId: widget.mainUser.doorId).deleteFromDoor();
                      await DBService(uid: widget.user.uid).updateUserData(widget.user.username, widget.user.idiom, widget.user.hasDoor, widget.mainUser.doorId, viewData, registerUsers);
                      widget.destroy(widget.user);
                      Navigator.of(context).pop();
                    }),
                   
              ],
            );
        },
           
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          title: Text(widget.user.username),
          onTap: () {
            createAlertDialog(context);
            
          },
        ),
      ),
    );
  }
}
