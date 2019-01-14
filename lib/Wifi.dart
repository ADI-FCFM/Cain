
import 'package:flutter/material.dart';
import 'package:wifi/wifi.dart';

class wifi extends StatefulWidget{
  wifiApp createState() => new wifiApp();
}

class wifiApp extends State<wifi>{
  String wifiName;
  String ip;
  Future<Null> _getIP()async{
    String ip= await Wifi.ip;
    setState(() {
      ip=ip;
    });
  }
  Future<Null> _getWifiName()async{
    String wifiName = await Wifi.ssid;
    setState(() {
      wifiName =wifiName;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wifi'),
      ),
    );
  }

}