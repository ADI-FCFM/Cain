import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Qr extends StatefulWidget {
  @override
  QrAppState createState() => new QrAppState();
}

class QrAppState extends State<Qr> {
  /// String para guardar y mostrar la informacion del QR, empieza con
  /// un mensaje por defecto
  String result = "Apriete el icono para escanear !";

  /// Metodo que hace el Escaneo de la imagen, junto con el manejo de
  /// errores en caso que haya
  Future _scanQR() async {
    try {
      ///BarcodeScanner.scan es la funcion que realiza el Scan del QR.
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Permiso de Cámara denegado ";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    }
  }

  /// constructor de la vista.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text("QR Scanner"),
          ),
          body: Center(
            child: Text(
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ));
  }
}
