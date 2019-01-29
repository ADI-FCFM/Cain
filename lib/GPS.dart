import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

class Gps extends StatefulWidget {
  GpsApp createState() => new GpsApp();
}

class GpsApp extends State<Gps> {
  Map<String, double> _startLocation;

  /// mapa que guarda los datos de localizacion original
  Map<String, double> _currentLocation;

  /// mapa que guarda los datos de localizacion actual
  StreamSubscription<Map<String, double>> _locationSubscription;
  Location _location = new Location();

  /// inicializa el objeto locacion de la libreria para obtener la informacion
  bool _permission = false;

  /// maneja los permisos que el dispositivo le da a la aplicacion
  String error;
  ///verifica si el widget es el widget actual de la app
  bool currentWidget = true;


  /// metodo cancelar las subscripciones
  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
      currentWidget = false;
    }
    super.dispose();
  }

  /// metodo para inicializar el registro de informacion.
  @override
  void initState() {
    super.initState();
    initPlatformState();
    _locationSubscription =
        _location.onLocationChanged().listen((Map<String, double> result) {
      setState(() {
        _currentLocation = result;
      });
    });
  }

  /// inicializacion de funcionalidades de la plataforma
  initPlatformState() async {
    Map<String, double> location;

    /// mapa auxiliar para guardar las locaciones dentro del metodo
    _permission = await _location.hasPermission();

    /// checkea que la app tenga acceso al gps
    location = await _location.getLocation();

    /// funcion para obtener la locacion
    error = null;

    /// setState() sirve para notificar a la app que se genero un cambio.
    setState(() {
      _startLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    var latitude = _currentLocation["latitude"];
    var longitude = _currentLocation["longitude"];
    var accuracy = _currentLocation["accuracy"];
    var altitude = _currentLocation["altitude"];
    print(_startLocation);
    var Olatitude = _startLocation["latitude"];
    var Olongitude = _startLocation["longitude"];
    var Oaccuracy = _startLocation["accuracy"];
    var Oaltitude = _startLocation["altitude"];

    return new MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text('Location plugin example app'),
            ),
            body: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(""),
                    ),
                    Expanded(
                      child: Text("Latitud"),
                    ),
                    Expanded(
                      child: Text("Longitud"),
                    ),
                    Expanded(
                      child: Text("Altura"),
                    ),
                    Expanded(
                      child: Text("Precision"),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text("Posicion Inicial"),
                    ),
                    Expanded(
                      child: Text('$Olatitude'),
                    ),
                    Expanded(
                      child: Text('$Olongitude'),
                    ),
                    Expanded(
                      child: Text('$Oaltitude'),
                    ),
                    Expanded(
                      child: Text('$Oaccuracy'),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text("Posicion Actual"),
                    ),
                    Expanded(
                      child: Text('$latitude'),
                    ),
                    Expanded(
                      child: Text('$longitude'),
                    ),
                    Expanded(
                      child: Text('$altitude'),
                    ),
                    Expanded(
                      child: Text('$accuracy'),
                    ),
                  ],
                ),
              ],
            )));
  }
}
