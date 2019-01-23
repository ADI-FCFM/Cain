import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';



class Beacons extends StatefulWidget {
  @override
  _BeaconsState createState() => _BeaconsState();
}

class _BeaconsState extends State<Beacons> {
  StreamSubscription<RangingResult> _streamRanging;
  final _regionBeacons = <Region, List<Beacon>>{};  ///almacena las "regiones" en las que se encuentras los beacons
  final _beacons = <Beacon>[]; ///para tener en una "lista cada" beacon que este en el rango

  /// metodo que se ejecuta al iniciar el objeto BeaconsState
  @override
  void initState() {
    super.initState();
    initBeacon();
  }

  initBeacon() async {
    try {
      await flutterBeacon.initializeScanning; ///llama a objeto de la libreria para que maneje el escaneo
      print('Beacon scanner initialized');
    } on PlatformException catch (e) {
      print(e);
    }

    final regions = <Region>[];
/// diferencia como inicializa las plataformas
    if (Platform.isIOS ) {
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

    _streamRanging = flutterBeacon.ranging(regions).listen((result) { ///busca beacons dentro de las regiones almacenadas, guarda los resultados del ranging
      ///dentro de la variable result
      if (result != null && mounted) { /// mounted aparentemente implica si esta encendido bluetooh y si esta corriendo la app
        setState(() {
          _regionBeacons[result.region] = result.beacons;
          _beacons.clear();
          _regionBeacons.values.forEach((list) {
            _beacons.addAll(list);
          });
          _beacons.sort(_compareParameters); ///ordena las beacons encontradas
        });
      }
    });
  }

  ///estable un orden en el que aparecen las beacons en la lista
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


  /// metodo para cancelar subscripciones y evitar que siga leyendo informacion
  @override
  void dispose() {
    if (_streamRanging != null) {
      _streamRanging.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Beacon'),
        ),
        body:  ListView(
          children: ListTile.divideTiles(
              context: context,
              tiles: _beacons.map((beacon) {  ///Ordena los beacons en un mapa, y usa  beacon variable
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
                        child: Text('txPower: ${beacon.txPower}\n MAC: ${beacon.macAddress}',
                            style: TextStyle(fontSize: 13.0)
                        ),
                        flex: 3,
                        fit: FlexFit.tight,
                      )
                    ],
                  ),
                );
              })).toList(),
        ),
      ),
    );
  }
}
