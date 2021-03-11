import 'package:flutter/material.dart';
import 'package:sdoor/models/newdoor.dart';
import 'package:sdoor/models/user.dart';
import 'package:sdoor/services/db.dart';

class Door extends StatelessWidget {
  final NewUser user;
  Door({this.user});
 
  createAlertDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text((user.idiom == "English") ? 'Door ID' : 'ID Puerta'),
            content: TextField(
              controller: controller,
            ),
            actions: <Widget>[
              MaterialButton(
                  elevation: 5.0,
                  child: Text((user.idiom == "English") ? 'Submit' : 'Aceptar'),
                  onPressed: () async {
                    if (controller.text.toString().isNotEmpty) {
                      NewDoor door = await DBService(
                              doorId: controller.text.toString(), uid: user.uid)
                          .getDoor;
                      if (door == null) {
                        print("New Owner");
                        await DBService(
                                doorId: controller.text.toString(),
                                uid: user.uid)
                            .addDoor();                 
                        user.doorId = controller.text.toString();
                        user.hasDoor = true;
                        user.viewData = true;
                        user.register = true;
                      } else {
                         await DBService(
                                doorId: controller.text.toString(),
                                uid: user.uid)
                            .registerToDoor();
                        print("Permision");
                        user.hasDoor = true;
                      }
                      await DBService(uid: user.uid).updateUserData(user.username, user.idiom, user.hasDoor, user.doorId, user.viewData, user.register);
                    }

                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return (user.doorId.isNotEmpty)
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
                          text: (user.idiom == "English")
                              ? 'Current temperature:   '
                              : 'Temperatura actual:   '),
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
                    (user.idiom == "English")
                        ? 'Last person to enter:'
                        : 'Ultima persona en entrar:',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 5.0),
                Text('xxxxxx xxxxxx xxxxx',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 30.0),
                // ignore: deprecated_member_use
                RaisedButton(
                  elevation: 5.0,
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 40),
                  onPressed: () {},
                  color: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3)),
                  child: Text((user.idiom == "English") ? 'Open' : 'Abrir',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ],
            ),
          )
        : (Center(
            child: (!user.hasDoor)
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
                        (user.idiom == "English")
                            ? 'Add Door'
                            : 'Añadir Puerta',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  )
                : Text(
                    (user.idiom == "English")
                        ? 'Waiting for admin...'
                        : 'Esperando al admin...',
                    style: TextStyle(fontSize: 18)),
          ));
  }
}
