import 'package:beacons_manage/Beacons.dart';
import 'package:beacons_manage/Bluetooth.dart';
import 'package:beacons_manage/GPS.dart';
import 'package:beacons_manage/QR.dart';
import 'package:beacons_manage/Wifi.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: HubScreen(),
  ));
}


class HubScreen extends StatelessWidget{
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Hub"),
      ),
      body:
          new GridView.count(
              padding: const EdgeInsets.all(15.0),
              crossAxisCount: 2,

      children: <Widget>[
        RaisedButton(
          color: Colors.blue,
          onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>FlutterBlueApp()));},
          child: Text("Bluetooth"),
        ),
        RaisedButton(
          color: Colors.redAccent,
          onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>gps()));},
          child: Text("GPS"),
        ),
        RaisedButton(
          color: Colors.lightGreen,
          onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>wifi()));},
          child: Text("WIFI"),
        ),
        RaisedButton(
          color: Colors.deepPurpleAccent,
          onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>qr()));},
          child: Text("QR"),
        ),
        RaisedButton(
          color: Colors.yellow,
          onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>Beacons()));},
          child: Text("Beacons"),
        ),
      ],
          ),
    );
  }
}





