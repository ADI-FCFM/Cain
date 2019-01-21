import 'dart:async';
import 'package:flutter/material.dart';

import 'package:location/location.dart';
//TODO refactor y clarificacion del codigo

class gps extends StatefulWidget{
  gpsApp createState()=> new gpsApp();
}

class gpsApp extends State<gps>{
  Map<String, double> _startLocation; /// mapa que guarda los datos de localizacion original
  Map<String, double> _currentLocation; /// mapa que guarda los datos de localizacion actual
  StreamSubscription<Map<String, double>> _locationSubscription;
  Location _location = new Location(); /// inicializa el objeto locacion de la libreria para obtener la informacion
  bool _permission = false;
  String error;
  bool currentWidget = true;


  /// metodo para inicializar el registro de informacion.
  @override
  void initState() {
    super.initState();
    initPlatformState();
    _locationSubscription =
        _location.onLocationChanged().listen((Map<String,double> result) {
          setState(() {
            _currentLocation = result;
          });
        });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    Map<String, double> location; /// mapa auxiliar para guardar las locaciones dentro del metodo
      _permission = await _location.hasPermission(); /// checkea que la app tenga acceso al gps
      location = await _location.getLocation(); /// funcion para obtener la locacion
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
                    Expanded(child: Text(""),),
                    Expanded(child: Text("Latitud"),),
                    Expanded(child: Text("Longitud"),),
                    Expanded(child: Text("Altura"),),
                    Expanded(child: Text("Precision"),),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("Posicion Inicial"),),
                    Expanded(child: Text('$Olatitude'),),
                    Expanded(child: Text('$Olongitude'),),
                    Expanded(child: Text('$Oaltitude'),),
                    Expanded(child: Text('$Oaccuracy'),),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("Posicion Actual"),),
                    Expanded(child: Text('$latitude'),),
                    Expanded(child: Text('$longitude'),),
                    Expanded(child: Text('$altitude'),),
                    Expanded(child: Text('$accuracy'),),
                  ],
                ),
              ],
            )));
  }

}