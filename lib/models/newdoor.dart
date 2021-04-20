import 'package:sdoor/models/doorData.dart';

class NewDoor{
  final String doorId;
  final String owner;
  final List<String> waitlist;
  final List<DoorData> dataList;
  NewDoor({this.doorId, this.owner, this.waitlist, this.dataList});
}