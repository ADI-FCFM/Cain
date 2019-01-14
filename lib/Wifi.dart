
import 'package:flutter/material.dart';
import 'package:wifi/wifi.dart';

class wifi extends StatefulWidget{
  wifiApp createState() => new wifiApp();
}

class wifiApp extends State<wifi>{
  String wifiName;
  String ip;
  String intensidad;
  Future<Null> _getIP()async{
    String _ip= await Wifi.ip;
    setState(() {
      ip=_ip;
    });
  }
  Future<Null> _getWifiName()async{
    String _wifiName = await Wifi.ssid;
    setState(() {
      wifiName =_wifiName;
    });
  }
  Future<Null> _getWifiLevel()async{
  String _wifiLevel = await Wifi.level.toString();
  setState(() {
    intensidad = _wifiLevel;
  });
  }

  getData(){
    print(1);
    child: new Column(
      children: <Widget>[
        new Text(wifiName),
        new Text(ip),
        new Text(intensidad),

      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wifi'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('get wifi info'),
              onPressed: getData,
            ),

          ],
        ),
      ),
    );
  }

}