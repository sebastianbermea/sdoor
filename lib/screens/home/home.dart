import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:sdoor/models/newdoor.dart';
import 'package:sdoor/models/user.dart';
import 'package:sdoor/screens/home/data.dart';
import 'package:sdoor/screens/home/door.dart';
import 'package:sdoor/screens/home/registerScreen.dart';
import 'package:sdoor/screens/home/settingsW.dart';
import 'package:provider/provider.dart';
import 'package:sdoor/services/db.dart';
import 'package:sdoor/shared/loading.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  // Initializing the Bluetooth connection state to be unknown
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  // Initializing a global key, as it would help us in showing a SnackBar later
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Get the instance of the Bluetooth
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  // Track the Bluetooth connection with the remote device
  BluetoothConnection connection;

  int _deviceState;

  bool isDisconnecting = false;
  NewUser huser;
  Map<String, Color> colors = {
    'onBorderColor': Colors.green,
    'offBorderColor': Colors.red,
    'neutralBorderColor': Colors.transparent,
    'onTextColor': Colors.green[700],
    'offTextColor': Colors.red[700],
    'neutralTextColor': Colors.blue,
  };

  // To track whether the device is still connected to Bluetooth
  bool get isConnected => connection != null && connection.isConnected;

  // Define some variables, which will be required later
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice _device;
  bool _connected = false;
  bool _isButtonUnavailable = false;

  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    _deviceState = 0; // neutral

    // If the bluetooth of the device is not enabled,
    // then request permission to turn on bluetooth
    // as the app starts up
    enableBluetooth();

    // Listen for further state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          _isButtonUnavailable = true;
        }
        getPairedDevices();
      });
    });
  }

  @override
  void dispose() {
    // Avoid memory leak and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }

  // Request Bluetooth permission from the user
  Future<void> enableBluetooth() async {
    // Retrieving the current Bluetooth state
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    // If the bluetooth is off, then turn it on first
    // and then retrieve the devices that are paired.
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  // For retrieving and storing the paired devices
  // in a list.
  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    // It is an error to call [setState] unless [mounted] is true.
    if (!mounted) {
      return;
    }

    // Store the [devices] list in the [_devicesList] for accessing
    // the list outside this class
    setState(() {
      _devicesList = devices;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<NewUser>(context);
    return StreamBuilder<NewUser>(
        stream: DBService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            NewUser newUser = snapshot.data;
            huser = newUser;
            return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                  title: Text(
                    'SDOOR',
                    style: TextStyle(fontSize: 28),
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  actions: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SettingsW(user: newUser)));
                        //await _auth.signOut();
                        //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> Authenticate()));
                      },
                      icon: Icon(Icons.settings),
                    ),
                  ]),
              //ody: _widgets[_currentIndex],
              body: (newUser.hasDoor ?? false) ? StreamBuilder<NewDoor>(
                initialData: NewDoor(doorId: newUser.doorId, waitlist: [], dataList: []),
                stream: DBService(uid: newUser.uid, doorId: newUser.doorId).doorStrem,
                builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        NewDoor door = snapshot.data;
                        return(_currentIndex == 0) ?Door(user: newUser, door: door,):
                        (_currentIndex==1)?DataScreen(user: newUser, door: door,):RegisterScreen(user: newUser);
                      }else{
                        return Loading();
                      }}
                ):
               (_currentIndex == 0) ? Container(
                          child: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Visibility(
                                  visible: _isButtonUnavailable &&
                                      _bluetoothState ==
                                          BluetoothState.STATE_ON,
                                  child: LinearProgressIndicator(
                                    backgroundColor: Colors.lightBlue,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          (newUser.idiom == "English")?'Enable Bluetooth':'Habilitar Bluetooth',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Switch(
                                        value: _bluetoothState.isEnabled,
                                        activeColor: Colors.lightBlue,
                                        onChanged: (bool value) {
                                          future() async {
                                            if (value) {
                                              await FlutterBluetoothSerial
                                                  .instance
                                                  .requestEnable();
                                            } else {
                                              await FlutterBluetoothSerial
                                                  .instance
                                                  .requestDisable();
                                            }

                                            await getPairedDevices();
                                            _isButtonUnavailable = false;

                                            if (_connected) {
                                              _disconnect();
                                            }
                                          }

                                          future().then((_) {
                                            setState(() {});
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Stack(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            (newUser.idiom == "English")?"PAIRED DEVICES":
                                            (newUser.idiom == "Español")? "DISPOSITIVOS CONECTADOS":
                                            "DISPOSITIVOS PAREADOS",
                                            style: TextStyle(
                                                fontSize: 24,
                                                color: Colors.blue),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        SizedBox(height: 50),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 100),
                                          child: DropdownButton(
                                            isExpanded: true,
                                                  items: _getDeviceItems(),
                                                  onChanged: (value) => setState(
                                                      () => _device = value),
                                                  value: _devicesList.isNotEmpty
                                                      ? _device
                                                      : null,
                                                ),
                                        ),
                                        SizedBox(height: 20),
                                        Container(
                                           width: 120,    
                                         // ignore: deprecated_member_use
                                          child: RaisedButton(
                                            
                                                  onPressed: _isButtonUnavailable
                                                      ? null
                                                      : _connected
                                                          ? _disconnect
                                                          : _connect,
                                                  child: Text(_connected
                                                      ? (newUser.idiom == "English")?'Disconnect':'Desconectar'
                                                      : (newUser.idiom == "English")?'Connect':'Conectar'),
                                                ),
                                        ),
                                       /* Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              side: new BorderSide(
                                                color: _deviceState == 0
                                                    ? colors[
                                                        'neutralBorderColor']
                                                    : _deviceState == 1
                                                        ? colors[
                                                            'onBorderColor']
                                                        : colors[
                                                            'offBorderColor'],
                                                width: 3,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            elevation:
                                                _deviceState == 0 ? 4 : 0,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Text(
                                                      "DEVICE 1",
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: _deviceState == 0
                                                            ? colors[
                                                                'neutralTextColor']
                                                            : _deviceState == 1
                                                                ? colors[
                                                                    'onTextColor']
                                                                : colors[
                                                                    'offTextColor'],
                                                      ),
                                                    ),
                                                  ),
                                                  // ignore: deprecated_member_use
                                                  FlatButton(
                                                    onPressed: _connected
                                                        ? _sendOnMessageToBluetooth
                                                        : null,
                                                    child: Text("ON"),
                                                  ),
                                                  // ignore: deprecated_member_use
                                                  FlatButton(
                                                    onPressed: _connected
                                                        ? _sendOffMessageToBluetooth
                                                        : null,
                                                    child: Text("OFF"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),*/
                                      ],
                                    ),
                                    Container(
                                      color: Colors.blue,
                                    ),
                                  ],
                                ),
                               /* Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "NOTE: If you cannot find the device in the list, please pair the device by going to the bluetooth settings",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          // ignore: deprecated_member_use
                                          RaisedButton(
                                            elevation: 2,
                                            child: Text("Bluetooth Settings"),
                                            onPressed: () {
                                              FlutterBluetoothSerial.instance
                                                  .openSettings();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )*/
                              ],
                            ),
                          ),
                        )
                      :
                      Center(
                              child: Text((newUser.idiom == "English")
                                  ? 'No door available'
                                  : (newUser.idiom == "Español")
                                      ? 'No hay puerta disponible'
                                      : 'Sem porta disponível')),
                
                          
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Colors.blueGrey[700],
                selectedItemColor: Colors.lightBlue,
                currentIndex: _currentIndex,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.camera),
                    label: (newUser.idiom == "English")
                        ? 'Door'
                        : (newUser.idiom == "Español")
                            ? 'Puerta'
                            : 'Porta',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.date_range),
                    label: (newUser.idiom == "English")
                        ? 'Data'
                        : (newUser.idiom == "Español")
                            ? 'Datos'
                            : 'Dados',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.fingerprint),
                    label: (newUser.idiom == "English")
                        ? 'Registration'
                        : 'Registro',
                  ),
                ],
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            );
          } else {
            return Loading();
          }
        });
  }

  // Create the List of devices to be shown in Dropdown Menu
  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  // Method to connect to bluetooth
  void _connect() async {
    setState(() {
      _isButtonUnavailable = true;
    });
    if (_device == null) {
      show('No device selected');
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(_device.address)
            .then((_connection) {
          print('Connected to the device');
          connection = _connection;
          setState(() {
            _connected = true;
          });

          connection.input.listen(null).onDone(() {
            if (isDisconnecting) {
              print('Disconnecting locally!');
            } else {
              print('Disconnected remotely!');
            }
            if (this.mounted) {
              setState(() {});
            }
          });
        }).catchError((error) {
          print('Cannot connect, exception occurred');
          print(error);
        });
        show('Door added');
        if(huser!=null){
            huser.doorId = 'Door1';
            huser.hasDoor = true;
            huser.viewData = true;
            huser.register = true;
            print('DoorAdded');
            await DBService(uid: huser.uid).updateUserData(huser.username, huser.idiom,
            huser.hasDoor, huser.doorId, huser.viewData, huser.register, huser.admin);
        }
       

        setState(() => _isButtonUnavailable = false);
      }
    }
  }

  // Method to disconnect bluetooth
  void _disconnect() async {
    setState(() {
      _isButtonUnavailable = true;
      _deviceState = 0;
    });

    await connection.close();
    show('Device disconnected');
    if (!connection.isConnected) {
      setState(() {
        _connected = false;
        _isButtonUnavailable = false;
      });
    }
  }

  // Method to send message,
  // for turning the Bluetooth device on
  void _sendOnMessageToBluetooth() async {
    connection.output.add(utf8.encode("1" + "\r\n"));
    await connection.output.allSent;
    show('Device Turned On');
    setState(() {
      _deviceState = 1; // device on
    });
  }

  // Method to send message,
  // for turning the Bluetooth device off
  void _sendOffMessageToBluetooth() async {
    connection.output.add(utf8.encode("0" + "\r\n"));
    await connection.output.allSent;
    show('Device Turned Off');
    setState(() {
      _deviceState = -1; // device off
    });
  }

  // Method to show a Snackbar,
  // taking message as the text
  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    // ignore: deprecated_member_use
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: new Text(
          message,
        ),
        duration: duration,
      ),
    );
  }
}
