import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sdoor/models/doorData.dart';
import 'package:sdoor/models/newdoor.dart';
import 'package:sdoor/models/user.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class DataScreen extends StatefulWidget {
  final NewUser user;
  final NewDoor door;
  bool updated;
  DataScreen({this.user, this.door}){
    updated=true;
  }

  @override
  _DataScreenState createState() => _DataScreenState(door: door);
}

class _DataScreenState extends State<DataScreen> {
  final NewDoor door;
  List<DoorData> _dataList = [];
  List<DoorData> _filteredList = [];
  final _debouncer = Debouncer(milliseconds: 1000);
  int sortIndex;
  bool ascending;
  _DataScreenState({this.door});
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setTable();
  }
  void setTable(){
    _dataList = widget.door.dataList;
   _filteredList = _dataList;
  }
  SingleChildScrollView _dataBody() {
    // Both Vertical and Horozontal Scrollview for the DataTable to
    // scroll both Vertical and Horizontal...
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          sortColumnIndex: sortIndex,
          sortAscending: ascending??false,
          columns: [
            DataColumn(
              label: Text((widget.user.idiom=='English')?'Name':(widget.user.idiom=='Español')?'Nombre':'Nome'),
              onSort: onSort,
            ),
            DataColumn(
              label: Text((widget.user.idiom=='English')?'Finger':(widget.user.idiom=='Español')?'Huella':'Dedo'),
            ),
            DataColumn(
              label: Text((widget.user.idiom=='English')?'Date':(widget.user.idiom=='Español')?'Fecha':'Data'),
              onSort: onSort,
            ),
            // Lets add one more column to show a delete button
          ],
          // the list should show the filtered list now
          rows: _filteredList
              .map(
                (employee) => DataRow(cells: [
                  DataCell(
                    Text(employee.username),
                  ),
                  DataCell(
                    Text(
                     (employee.finger)? ((widget.user.idiom=='English')?'Yes':'Si'):('No'),
                    ),
                  ),
                  DataCell(
                    Text(DateFormat('kk:mm  dd-MM-yyyy')
                        .format(employee.dateTime)),
                  ),
                ]),
              )
              .toList(),
        ),
      ),
    );
  }

  searchField() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(5.0),
          hintText: 'Filter by Name',
        ),
        onChanged: (string) {
          // We will start filtering when the user types in the textfield.
          // Run the debouncer and start searching
          _debouncer.run(() {
            // Filter the original List and update the Filter list
            setState(() {
              _filteredList = _dataList
                  .where((u) => (u.username
                          .toLowerCase()
                          .contains(string.toLowerCase()))).toList();
            });
          });
        },
      ),
    );
  }
  void onSort(int index, bool asc){
    if(index==0){
      _filteredList.sort((user1, user2)=>
       compareString(asc, user1.username, user2.username));
    }

    if(index==2){
      _filteredList.sort((user1, user2)=>
       compareString(asc, user1.dateTime.toString(), user2.dateTime.toString()));
    }
    setState(() {
      sortIndex = index;
      ascending = asc;
    });
  }
  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  @override
  Widget build(BuildContext context) {
    if(widget.updated){
      setTable();
      widget.updated=false;
    }
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Data'),
          SizedBox(height: 20),
          searchField(),
          Expanded(
            child: _dataBody(),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer
          .cancel(); // when the user is continuosly typing, this cancels the timer
    }
    // then we will start a new timer looking for the user to stop
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
