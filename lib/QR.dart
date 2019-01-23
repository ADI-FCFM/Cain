import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class qr extends StatefulWidget{
  @override
  qrAppState createState() => new qrAppState();
}

class qrAppState extends State<qr>{
  /// String para guardar y mostrar la informacion del QR, empieza con
  /// un mensaje por defecto
  String result = "Apriete el icono para escanear !";

  /// Metodo que hace el Escaneo de la imagen, junto con el manejo de
  /// errores en caso que haya
  Future _scanQR() async {
    try {
      //BarcodeScanner.scan es la funcion que realiza el Scan del QR.
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
/// metodos para el url_launcher en caso de necesitarlo
   _check(result){
     var aux = result.substring(0,4);
     if(aux=='http')
       return true;
     return false;
   }
  /// metodos para el url_launcher en caso de necesitarlo
  _launch(result)async{
    if(await canLaunch(result)){
      await launch(result, forceSafariVC: true, forceWebView: true);
    }
    else{
      throw 'no funca';
    }
  }

  /// constructor de la vista.
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
      home:Scaffold(

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

      ///icono y boton para iniciar el escaneo.
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("Empezar el escaneo"),
        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    )
    );
  }
}
