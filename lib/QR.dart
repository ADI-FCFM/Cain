import 'package:beacons_manage/Bluetooth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class qr extends StatefulWidget{
  @override
  qrAppState createState() => new qrAppState();
}

class qrAppState extends State<qr>{
  String result = "Apriete el icono para escanear !";

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Permiso de Camara denegado ";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    }
  }

   _check(result){
     var aux = result.substring(0,4);
     if(aux=='http')
       return true;
     return false;
   }
  _launch(result)async{
    if(await canLaunch(result)){
      await launch(result, forceSafariVC: true, forceWebView: true);
    }
    else{
      throw 'no funca';
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("QR Scanner"),
      ),
      body: Center(
        child:
        Text(
          result,
          style: new TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("Empezar el escaneo"),
        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
