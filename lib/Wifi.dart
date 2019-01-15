
import 'package:flutter/material.dart';
import 'package:wifi/wifi.dart';

class wifi extends StatefulWidget{
  wifiApp createState() => new wifiApp();
}

class wifiApp extends State<wifi>{
  String wifiName='';
  String ip='';
  int intensidad=0;
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
  int _wifiLevel = await Wifi.level;
  setState(() {
    intensidad = _wifiLevel;
  });
  }

  getData()async{
    _getWifiName();
    _getWifiLevel();
    _getIP();
    print(wifiName);
    print(ip);
    print('$intensidad');

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

            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                      "Nombre Wifi",
                    style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.5),),

                ),
                Expanded(
                  child: Text("IP",style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.5),),
                ),
                Expanded(
                  child: Text("Intensidad",style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.5),),
                ),



              ],
            ),

            Row(
              children: <Widget>[
                Expanded(
                  child:Text(wifiName),
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
    );
  }

}