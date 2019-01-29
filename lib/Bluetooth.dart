import 'dart:async';
import 'dart:io';

import 'package:beacons_manage/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_blue/flutter_blue.dart';

///widget para el bluetooth
class FlutterBlueApp extends StatefulWidget {
  @override
  _FlutterBlueAppState createState() => new _FlutterBlueAppState();
}

class _FlutterBlueAppState extends State<FlutterBlueApp> {
  FlutterBlue _flutterBlue = FlutterBlue.instance;

  /// Scanning
  StreamSubscription _scanSubscription;
  Map<DeviceIdentifier, ScanResult> scanResults = new Map();
  /// verifica si se esta escaneando o no actualmente
  bool isScanning = false;


  /// State
  StreamSubscription _stateSubscription;

  /// Detecta cambios de estado del Bluetooth
  /// Establece el estado en que se encuentra el bluetooth del dispositivo, empieza con un estado desconocido
  BluetoothState state = BluetoothState.unknown;

  /// Identifica el dispositivo bluetooth detectado.
  BluetoothDevice device;

  bool get isConnected => (device != null);
  StreamSubscription deviceConnection;
  StreamSubscription deviceStateSubscription;

  /// revisa el estado del bluetooth.
  @override
  void initState() {
    super.initState();
    initBeacon();

    /// Obtiene el estado actual del Bluetooth
    _flutterBlue.state.then((s) {
      setState(() {
        state = s;
      });
    });

    /// Inicia la subscripcion para detectar los cambios de estado
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
    if (_streamRanging != null) {
      _streamRanging.cancel();
    }
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
        /// si encuentra alguno, lo agregara al mapa y lo listara
        if (scanResult.advertisementData.localName != "") {
          scanResults[scanResult.device.id] = scanResult;
        }
      });
    }, onDone: _stopScan);

    /// cuando se termine el tiempo de escaneo, detiene el escaneo.
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

  /// Barra superior para demostrar que el escaneo esta en proceso
  _buildProgressBarTile() {
    return new LinearProgressIndicator();
  }

  @override
  Widget build(BuildContext context) {
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

        ///Se sobrelapan la visualizacion de la vista de la informacion generada
        ///por las 2 librerias, habria que cambiar como se visualizan las vistas para arreglarlo
        body: new Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            (isScanning) ? _buildProgressBarTile() : new Container(),

            ///añade barra de progreso durante el escaneo
            new ListView(
              children: tiles,
            ),
            ///datos de la libreria Flutter_beacons, si lo
            ///activo no deja usar el menu desplegable de la libreria inicial, por eso
            ///esta comentado
           // (_extraBuild()),

          ],
        ),
      ),
    );
  }



  /// Funciones de la libreria Flutter_beacons
  StreamSubscription<RangingResult> _streamRanging;
  final _regionBeacons = <Region, List<Beacon>>{};
  final _beacons = <Beacon>[];

  initBeacon() async {
    try {
      await flutterBeacon.initializeScanning;

      ///llama a objeto de la libreria para que maneje el escaneo
      print('Beacon scanner initialized');
    } on PlatformException catch (e) {
      print(e);
    }
    final regions = <Region>[];

    /// diferencia como inicializa las plataformas
    /// los datos presentes fueron provistos por la libreria, y como no tengo
    /// iOS para jugar con ellos preferi dejarlos
    if (Platform.isIOS) {
      regions.add(
        Region(
            identifier: 'Cubeacon',
            proximityUUID: 'CB10023F-A318-3394-4199-A8730C7C1AEC'),
      );
      regions.add(Region(
          identifier: 'Apple Airlocate',
          proximityUUID: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0'));
    } else {
      regions.add(Region(identifier: 'com.beacon'));
    }

    _streamRanging = flutterBeacon.ranging(regions).listen((result) {
      ///busca beacons dentro de las regiones almacenadas, guarda los resultados del ranging
      ///dentro de la variable result
      if (result != null && mounted) {
        /// mounted aparentemente implica si esta encendido bluetooh y si esta corriendo la app
        setState(() {
          _regionBeacons[result.region] = result.beacons;
          _beacons.clear();
          _regionBeacons.values.forEach((list) {
            _beacons.addAll(list);
          });
          _beacons.sort(_compareParameters);

          ///ordena las beacons encontradas
        });
      }
    });
  }

  int _compareParameters(Beacon a, Beacon b) {
    int compare = a.proximityUUID.compareTo(b.proximityUUID);

    if (compare == 0) {
      compare = a.major.compareTo(b.major);
    }

    if (compare == 0) {
      compare = a.minor.compareTo(b.minor);
    }

    return compare;
  }

  _extraBuild() {
    return new ListView(
      children: ListTile.divideTiles(
          context: context,
          tiles: _beacons.map((beacon) {
            ///Ordena los beacons en un mapa, y usa  beacon variable
            /// para trabajar con cada una de las beacons
            return ListTile(
              title: Text(beacon.proximityUUID),
              subtitle: new Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Flexible(
                      child: Text(
                          'Major: ${beacon.major}\nMinor: ${beacon.minor}',
                          style: TextStyle(fontSize: 13.0)),
                      flex: 1,
                      fit: FlexFit.tight),
                  Flexible(
                      child: Text(
                          'Accuracy: ${beacon.accuracy}m\nRSSI: ${beacon.rssi}',
                          style: TextStyle(fontSize: 13.0)),
                      flex: 2,
                      fit: FlexFit.tight),
                  Flexible(
                    child: Text(
                        'txPower: ${beacon.txPower}\n MAC: ${beacon.macAddress}',
                        style: TextStyle(fontSize: 13.0)),
                    flex: 3,
                    fit: FlexFit.tight,
                  )
                ],
              ),
            );
          })).toList(),
    );
  }
}
