import 'package:beacons_manage/Bluetooth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: HubScreen(),
  ));
}

//TODO agregar direcciones de las pantallas
class HubScreen extends StatelessWidget{
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Hub"),
      ),
      body: Center (
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>BluetoothBeacon()));},
              child: Text("Bluetooth"),
            ),
            RaisedButton(
              onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>ThirdScreen()));},
              child: Text("GPS"),
            ),
            RaisedButton(
              onPressed: (){},
              child: Text("WIFI"),
            ),
            RaisedButton(
              onPressed: (){},
              child: Text("QR"),
            ),
          ],
        )
      ),
    );
  }
}


class BluetoothBeacon extends StatefulWidget{
  @override
  BluetoothBeaconState createState()=> new BluetoothBeaconState();
}
//TODO conectar la funcionalidad de la libreria con la app
class BluetoothBeaconState extends State<BluetoothBeacon>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Beacon "),
      ),
      body: Center(
        child: new FlutterBlueApp(),
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