import 'package:flutter/material.dart';
import 'package:sdoor/models/newdoor.dart';
import 'package:sdoor/models/user.dart';
import 'package:sdoor/services/db.dart';

class Door extends StatefulWidget {
  final NewUser user;
  Door({this.user});

  @override
  _DoorState createState() => _DoorState();
}

class _DoorState extends State<Door> {
  String lastPerson = "xxxx xxxx xxxx";

  createAlertDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text((widget.user.idiom == "English") ? 'Door ID' :(widget.user.idiom == "Español") ?  'ID Puerta':'ID porta'),
            content: TextField(
              controller: controller,
            ),
            actions: <Widget>[
              MaterialButton(
                  elevation: 5.0,
                  child: Text((widget.user.idiom == "English") ? 'Submit' : (widget.user.idiom == "Español") ?'Aceptar':'Aceitar'),
                  onPressed: () async {
                    if (controller.text.toString().isNotEmpty) {
                      NewDoor door = await DBService(
                              doorId: controller.text.toString(), uid: widget.user.uid)
                          .getDoor;
                      if (door == null) {
                        print("New Owner");
                        await DBService(
                                doorId: controller.text.toString(),
                                uid: widget.user.uid)
                            .addDoor();                 
                        widget.user.doorId = controller.text.toString();
                        widget.user.hasDoor = true;
                        widget.user.viewData = true;
                        widget.user.register = true;
                      } else {
                         await DBService(
                                doorId: controller.text.toString(),
                                uid: widget.user.uid)
                            .registerToDoor();
                        print("Permision");
                        widget.user.hasDoor = true;
                      }
                      await DBService(uid: widget.user.uid).updateUserData(widget.user.username, widget.user.idiom, widget.user.hasDoor, widget.user.doorId, widget.user.viewData, widget.user.register, widget.user.admin);
                    }

                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return (widget.user.doorId.isNotEmpty)
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20.0),
                RichText(
                    text: TextSpan(
                        style: TextStyle(fontSize: 22),
                        children: <TextSpan>[
                      TextSpan(
                          text: (widget.user.idiom == "English")
                              ? 'Current temperature:   '
                              :(widget.user.idiom == "Español") ? 'Temperatura actual:   ':
                              'Temperatura real:   '),
                      TextSpan(
                          text: '36°',
                          style: TextStyle(
                              color: Colors.lightGreen,
                              fontWeight: FontWeight.bold)),
                    ])),
                SizedBox(height: 20.0),
                Image(image: AssetImage('assets/images/CameraNot.png')),
                SizedBox(height: 20.0),
                Text(
                    (widget.user.idiom == "English")
                        ? 'Last person to enter:'
                        :(widget.user.idiom == "Español") ?  'Ultima persona en entrar:'
                        :'Última pessoa a entrar:',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 5.0),
                Text(lastPerson,
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 30.0),
                // ignore: deprecated_member_use
                RaisedButton(
                  elevation: 5.0,
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 40),
                  onPressed: () async{
                    await DBService(
                                doorId: widget.user.doorId,
                                uid: widget.user.uid)
                            .updateDoorData(name: widget.user.username, finger: false);
                    setState(() {
                       lastPerson = widget.user.username;
                    });
                   
                  },
                  color: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3)),
                  child: Text((widget.user.idiom == "English") ? 'Open' : 'Abrir',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ],
            ),
          )
        : (Center(
            child: (!widget.user.hasDoor)
                // ignore: deprecated_member_use
                ? RaisedButton(
                    elevation: 5.0,
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 40),
                    onPressed: () {
                      createAlertDialog(context);
                    },
                    color: Colors.lightBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)),
                    child: Text(
                        (widget.user.idiom == "English") ? 'Add Door'
                        :(widget.user.idiom == "Español") ? 'Añadir Puerta'
                        :'Adicionar porta',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  )
                : Text(
                    (widget.user.idiom == "English") ? 'Waiting for admin...'
                    : (widget.user.idiom == "Español") ?'Esperando al admin...'
                    :'Esperando pelo admin ...',
                    style: TextStyle(fontSize: 18)),
          ));
  }
}
