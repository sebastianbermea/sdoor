import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sdoor/models/doorData.dart';
import 'package:sdoor/models/newdoor.dart';
import 'package:sdoor/models/user.dart';

class DBService {
  final String uid, doorId;
  DBService({this.uid, this.doorId});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("Users");
  final CollectionReference doorCollection =
      FirebaseFirestore.instance.collection("Doors");

  Future updateUserData(
      String name, String idiom, bool hasDoor, String doorId, bool viewData, bool register, bool admin) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'idiom': idiom,
      'hasDoor': hasDoor,
      'doorId': doorId,
      'viewData': viewData,
      'register': register,
      'admin': admin,
    });
  }

  /*List<NewUser> _userListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((e) =>
    NewUser(
      idiom: e['idiom'] ?? '',
      username: e['name'] ?? '',
    )
    );
  }
  Stream<List<NewUser>> get userData {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }*/
  NewUser _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return NewUser(
      uid: uid,
      idiom: snapshot.data()['idiom'],
      username: snapshot.data()['name'],
      hasDoor: snapshot.data()['hasDoor'],
      doorId: snapshot.data()['doorId'],
      viewData: snapshot.data()['viewData'],
      register: snapshot.data()['register'],
      admin:  snapshot.data()['admin'],
    );
  }

  Stream<NewUser> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
  NewDoor _doorDataFromSnapshot(DocumentSnapshot snapshot){
    String owner = snapshot.data()['owner'] ?? "";
    List<String> waitList = snapshot.data()['waitlist'].cast<String>() ?? [];
    List<DoorData> dataList = List<DoorData>.from(snapshot.data()["data"].map((item) {
            return new DoorData(
                username: item["name"],
                finger: item["finger"],
                imageUrl: item["imageUrl"] ?? "",
                temperature: item["temp"] ??36,
                dateTime: DateTime.parse(item["time"].toDate().toString()));
          })) ?? [];
    NewDoor door =NewDoor(doorId: doorId, owner: owner, 
      waitlist: waitList,
      dataList: dataList);
    
    return door;
  }
  Stream<NewDoor> get doorStrem{
    return doorCollection.doc(doorId).snapshots().map(_doorDataFromSnapshot);
  }
  Future<NewUser> get getUser async {
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    if (snapshot.exists)
      return NewUser( uid: uid,
      idiom: snapshot.data()['idiom'],
      username: snapshot.data()['name'],
      hasDoor: snapshot.data()['hasDoor'],
      doorId: snapshot.data()['doorId'],
       viewData: snapshot.data()['viewData'],
      register: snapshot.data()['register'],
      admin:snapshot.data()['admin'], );
    else
      return null;
  }


  Future<NewDoor> get getDoor async {
    DocumentSnapshot snapshot = await doorCollection.doc(doorId).get();
    if (snapshot.exists)
      return NewDoor(doorId: doorId, owner: snapshot.data()['owner'], 
      waitlist: (snapshot.data()['waitlist'].cast<String>()),
      dataList: List<DoorData>.from(snapshot.data()["data"].map((item) {
            return new DoorData(
                username: item["name"],
                finger: item["finger"],
                dateTime: DateTime.parse(item["time"].toDate().toString()));
          })));
    else
      return null;
  }

  Future<void> addDoor() {
    return doorCollection
        .doc(doorId)
        .set({
          'owner': uid,
          'waitlist': [],
          'data': [],
        })
        .then((value) => print("Door Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> registerToDoor() {
    return doorCollection
        .doc(doorId)
        .update({
          'waitlist': FieldValue.arrayUnion([uid]),
        })
        .then((value) => print("Door Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
  Future<void> updateDoorData({String name, bool finger}) {
    return doorCollection
        .doc(doorId)
        .update({
          'open' : true,
          'data': FieldValue.arrayUnion([{
            "name": name,
            "finger":finger,
            "time": DateTime.now(),
            "imageUrl": "example.jpg",
            'temp': 36.5,
             }]),
        })
        .then((value) => print("Door Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
  Future<void> deleteFromDoor() {
    return doorCollection
        .doc(doorId)
        .update({
          'waitlist': FieldValue.arrayRemove([uid]),
        })
        .then((value) => print("Wait removed"))
        .catchError((error) => print("Failed to remove user: $error"));
  }
  
}

