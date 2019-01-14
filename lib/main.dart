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
      body: Center (
        child: Column(
          children: <Widget>[
            RaisedButton(
              color: Colors.blue,
              onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>FlutterBlueApp()));},
              child: Text("Bluetooth"),
            ),
            RaisedButton(
              onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>gps()));},
              child: Text("GPS"),
            ),
            RaisedButton(
              onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>wifi()));},
              child: Text("WIFI"),
            ),
            RaisedButton(
              onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>qr()));},
              child: Text("QR"),
            ),
          ],
        )
      ),
    );
  }
}



class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HUB'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Launch screen'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondScreen()),
            );
          },
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (context)=> ThirdScreen()));
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
class ThirdScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('IntrinsicWidth')),
      body: Center(
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new FlutterBlueApp(),
              RaisedButton(
                onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context)=>FirstScreen()));},
                child: Text('Short'),
              ),
              RaisedButton(
                onPressed: () {Navigator.pop(context);},
                child: Text('A bit Longer'),
              ),
              RaisedButton(
                onPressed: () {Navigator.pop(context);},
                child: Text('The Longest text button'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}