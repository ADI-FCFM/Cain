import 'dart:async';
import 'package:beacons_manage/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';


//widget para el bluetooth
class FlutterBlueApp extends StatefulWidget {
  @override
  _FlutterBlueAppState createState() => new _FlutterBlueAppState();
}

class _FlutterBlueAppState extends State<FlutterBlueApp> {
  FlutterBlue _flutterBlue = FlutterBlue.instance;

  ///Characteristics
  BluetoothCharacteristic characteristic= new BluetoothCharacteristic();
  /// Scanning
  StreamSubscription _scanSubscription;
  Map<DeviceIdentifier, ScanResult> scanResults = new Map();
  bool isScanning = false; /// verifica si se esta escaneando o no actualmente

  /// State
  StreamSubscription _stateSubscription; /// Detecta cambios de estado del Bluetooth
  BluetoothState state = BluetoothState.unknown; /// Establece el estado en que se encuentra el bluetooth del dispositivo, empieza con un estado desconocido

  /// Device
  BluetoothDevice device;
  bool get isConnected => (device != null);
  StreamSubscription deviceConnection;
  StreamSubscription deviceStateSubscription;

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
/// Inicia el escaneo de dispositivos en rango
  _startScan() {
    _scanSubscription = _flutterBlue
        .scan(
      timeout: const Duration(seconds: 10),
    )
        .listen((scanResult) {
      setState(() {
        if (scanResult.advertisementData.localName != "") {
          scanResults[scanResult.device.id] = scanResult; /// si encuentra alguno, lo agregara al mapa y lo listara

        }
      });
    }, onDone: _stopScan); /// cuando se termine el tiempo de escaneo, detiene el escaneo.
    setState(() {
      isScanning = true;
    });
  }
/// maneja el termino de el escaneo
  _stopScan() {
    _scanSubscription?.cancel();
    _scanSubscription = null;
    setState(() {
      isScanning = false;
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

  /// widget que muestra la alerta de bluetooth apagado.
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


  /// Barra superior para demostrar que que el escaneo esta en proceso
  _buildProgressBarTile() {
    return new LinearProgressIndicator();
  }

  @override
  Widget build(BuildContext context) {
    print(characteristic.serviceUuid);
    print(characteristic.descriptors);
    print(characteristic.properties);
    print(characteristic.secondaryServiceUuid);
    print(characteristic.uuid);
    print(characteristic.value);


    var tiles = new List<Widget>();
    if (state != BluetoothState.on) {
      tiles.add(_buildAlertTile());
    }
    tiles.addAll(_buildScanResultTiles());
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
