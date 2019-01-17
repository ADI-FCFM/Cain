import 'dart:async';

import 'package:beacons_manage/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
//TODO refactor y clarificacion del codigo.

//widget para el bluetooth
class FlutterBlueApp extends StatefulWidget {
  @override
  _FlutterBlueAppState createState() => new _FlutterBlueAppState();
}

class _FlutterBlueAppState extends State<FlutterBlueApp> {
  FlutterBlue _flutterBlue = FlutterBlue.instance;

  /// Scanning
  StreamSubscription _scanSubscription;
  Map<DeviceIdentifier, ScanResult> scanResults = new Map();
  bool isScanning = false;

  /// State
  StreamSubscription _stateSubscription; /// Detecta cambios de estado del Bluetooth
  BluetoothState state = BluetoothState.unknown; /// Establece el estado en que se encuentra el bluetooth del dispositivo

  /// Device
  BluetoothDevice device;

  bool get isConnected => (device != null);
  StreamSubscription deviceConnection;
  StreamSubscription deviceStateSubscription;
  List<BluetoothService> services = new List();
  Map<Guid, StreamSubscription> valueChangedSubscriptions = {};
  BluetoothDeviceState deviceState = BluetoothDeviceState.disconnected;


  /// revisa el estado de el bluetooth.
  @override
  void initState() {
    super.initState();
    /// Immediately get the state of FlutterBlue
    _flutterBlue.state.then((s) {
      setState(() {
        state = s;
      });
    });
    /// Subscribe to state changes
    _stateSubscription = _flutterBlue.onStateChanged().listen((s) {
      setState(() {
        state = s;
      });
    });
  }


  /// Maneja el estado del bluetooth cuando se desactiva
  @override
  void dispose() {
    _stateSubscription?.cancel();
    _stateSubscription = null;
    _scanSubscription?.cancel();
    _scanSubscription = null;
    deviceConnection?.cancel();
    deviceConnection = null;
    super.dispose();
  }

  _startScan() {
    _scanSubscription = _flutterBlue
        .scan(
      timeout: const Duration(seconds: 5),
    )
        .listen((scanResult) {
      setState(() {
        if (scanResult.advertisementData.localName != "") {
          scanResults[scanResult.device.id] = scanResult;
        }
      });
    }, onDone: _stopScan);

    setState(() {
      isScanning = true;
    });
  }

  _stopScan() {
    _scanSubscription?.cancel();
    _scanSubscription = null;
    setState(() {
      isScanning = false;
    });
  }



  _readCharacteristic(BluetoothCharacteristic c) async {
    await device.readCharacteristic(c);
    setState(() {});
  }

  _readDescriptor(BluetoothDescriptor d) async {
    await device.readDescriptor(d);
    setState(() {});
  }



  _refreshDeviceState(BluetoothDevice d) async {
    var state = await d.state;
    setState(() {
      deviceState = state;
      print('State refreshed: $deviceState');
    });
  }

  /// Crea el boton para empezar y terminar el escaneo de dispositivos
  _buildScanningButton() {
    if (isConnected || state != BluetoothState.on) {
      return null;
    }
    if (isScanning) {
      return new FloatingActionButton(
        child: new Icon(Icons.stop),
        onPressed: _stopScan,
        backgroundColor: Colors.green,
      );
    } else {
      return new FloatingActionButton(
          child: new Icon(Icons.search), onPressed: _startScan);
    }
  }

  _buildScanResultTiles() {
    return scanResults.values
        .map((r) => ScanResultTile(
              result: r,
            ))
        .toList();
  }

  List<Widget> _buildServiceTiles() {
    return services
        .map(
          (s) => new ServiceTile(
                service: s,
                characteristicTiles: s.characteristics
                    .map(
                      (c) => new CharacteristicTile(
                            characteristic: c,
                            onReadPressed: () => _readCharacteristic(c),
                            descriptorTiles: c.descriptors
                                .map(
                                  (d) => new DescriptorTile(
                                        descriptor: d,
                                        onReadPressed: () => _readDescriptor(d),
                                      ),
                                )
                                .toList(),
                          ),
                    )
                    .toList(),
              ),
        )
        .toList();
  }

  _buildAlertTile() {
    return new Container(
      color: Colors.redAccent,
      child: new ListTile(
        title: new Text(
          'Bluetooth adapter is ${state.toString().substring(15)}',
          style: Theme.of(context).primaryTextTheme.subhead,
        ),
        trailing: new Icon(
          Icons.error,
          color: Theme.of(context).primaryTextTheme.subhead.color,
        ),
      ),
    );
  }

  _buildDeviceStateTile() {
    return new ListTile(
        leading: (deviceState == BluetoothDeviceState.connected)
            ? const Icon(Icons.bluetooth_connected)
            : const Icon(Icons.bluetooth_disabled),
        title: new Text('Device is ${deviceState.toString().split('.')[1]}.'),
        subtitle: new Text('${device.id}'),
        trailing: new IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => _refreshDeviceState(device),
          color: Theme.of(context).iconTheme.color.withOpacity(0.5),
        ));
  }

  /// Barrita arriba para demostrar que que el escaneo esta en proceso
  _buildProgressBarTile() {
    return new LinearProgressIndicator();
  }

  @override
  Widget build(BuildContext context) {
    var tiles = new List<Widget>();
    if (state != BluetoothState.on) {
      tiles.add(_buildAlertTile());
    }
    if (isConnected) {
      tiles.add(_buildDeviceStateTile());
      tiles.addAll(_buildServiceTiles());
    } else {
      tiles.addAll(_buildScanResultTiles());
    }
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Bluetooth'),
          centerTitle: true,
        ),
        floatingActionButton: _buildScanningButton(),
        body: new Stack(
          children: <Widget>[
            (isScanning) ? _buildProgressBarTile() : new Container(),
            new ListView(
              children: tiles,
            )
          ],
        ),
      ),
    );
  }
}
