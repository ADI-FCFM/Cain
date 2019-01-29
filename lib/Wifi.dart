import 'package:flutter/material.dart';
import 'package:wifi/wifi.dart';

class WifiHub extends StatefulWidget {
  WifiApp createState() => new WifiApp();
}

class WifiApp extends State<WifiHub> {
  /// Declaracion de variables para guardar la informacion
  String wifiName = '';
  String ip = '';
  int intensidad = 0;

  /// Obtiene la direccion ip de la red a la que esta conectada
  Future<void> _getIP() async {
    String _ip = await Wifi.ip;
    setState(() {
      ip = _ip;
    });
  }

  /// Obtiene el nombre de la red a la que esta conectada
  Future<void> _getWifiName() async {
    String _wifiName = await Wifi.ssid;
    setState(() {
      wifiName = _wifiName;
    });
  }

  /// Obtiene intensidad del Wifi, valores detallados en el README
  Future<void> _getWifiLevel() async {
    int _wifiLevel = await Wifi.level;
    setState(() {
      intensidad = _wifiLevel;
    });
  }

  /// Metodo para llamar a las funciones anteriores.
  getData() async {
    _getWifiName();
    _getWifiLevel();
    _getIP();
  }

  /// Constructor de la Vista del WIFI
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('Wifi'),
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                /// boton que actualiza la informacion
                RaisedButton(
                  child: Text('get wifi info'),
                  onPressed: getData,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "Nombre Wifi",
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontSizeFactor: 0.5),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "IP",
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontSizeFactor: 0.5),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Intensidad",
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontSizeFactor: 0.5),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(wifiName),
                    ),
                    Expanded(
                      child: Text(ip),
                    ),
                    Expanded(
                      child: Text('$intensidad'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
