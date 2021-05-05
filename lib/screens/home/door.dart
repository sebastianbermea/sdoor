import 'package:flutter/material.dart';
import 'package:sdoor/models/newdoor.dart';
import 'package:sdoor/models/user.dart';
import 'package:sdoor/services/db.dart';
import 'package:sdoor/services/fireStorage.dart';

class Door extends StatefulWidget {
  final NewUser user;
  final NewDoor door;
  Door({this.user, this.door});

  @override
  _DoorState createState() => _DoorState();
}

class _DoorState extends State<Door> {
  String lastPerson = "xxxx xxxx xxxx";
  String lastImageUrl = "";
  double lastTemp = 36;
  @override
  Widget build(BuildContext context) {
    if (widget.door != null) {
      if (widget.door.dataList.length > 0){
        lastPerson = widget.door.dataList[widget.door.dataList.length - 1].username;
        lastImageUrl = widget.door.dataList[widget.door.dataList.length - 1].imageUrl ?? "";
        lastTemp = widget.door.dataList[widget.door.dataList.length - 1].temperature ?? 36;
      }
        
    }
    Future<Widget> _getImage(BuildContext context, String image) async {
      Image m;
      await FireStorageService.loadFromStorage(context, image)
          .then((downloadUrl) {
        m = Image.network(
          downloadUrl.toString(),
          fit: BoxFit.scaleDown,
        );
      });

      return m;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20.0),
          RichText(
              text:
                  TextSpan(style: TextStyle(fontSize: 22), children: <TextSpan>[
            TextSpan(
                text: (widget.user.idiom == "English")
                    ? 'Current temperature:   '
                    : (widget.user.idiom == "Español")
                        ? 'Temperatura actual:   '
                        : 'Temperatura real:   '),
            TextSpan(
                text: lastTemp.toString() + '°',
                style: TextStyle(
                    color: (lastTemp<37.5)?Colors.lightGreen: Colors.red, fontWeight: FontWeight.bold)),
          ])),
          SizedBox(height: 20.0),
          (lastImageUrl == "")
              ? Image(image: AssetImage('assets/images/CameraNot.png'))
              : FutureBuilder(
                  future: _getImage(context, lastImageUrl),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done)
                      return Container(
                        height: 256,
                        width: 256,
                        child: snapshot.data,
                      );

                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Container(
                          height: 256,
                          width:256
                          ,
                          child: CircularProgressIndicator());

                    return Container();
                  },
                ),

          SizedBox(height: 20.0),
          Text(
              (widget.user.idiom == "English")
                  ? 'Last person to enter:'
                  : (widget.user.idiom == "Español")
                      ? 'Ultima persona en entrar:'
                      : 'Última pessoa a entrar:',
              style: TextStyle(fontSize: 18)),
          SizedBox(height: 5.0),
          Text(lastPerson,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 30.0),
          // ignore: deprecated_member_use
          RaisedButton(
            elevation: 5.0,
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 40),
            onPressed: () async {
              await DBService(doorId: widget.user.doorId, uid: widget.user.uid)
                  .updateDoorData(name: widget.user.username, finger: false);
            },
            color: Colors.lightBlue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
            child: Text((widget.user.idiom == "English") ? 'Open' : 'Abrir',
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
