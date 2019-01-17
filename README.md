# Disclaimer:
Todas las implementaciones estan basadas en los ejemplos de las librerias que estan siendo utilizadas
, se han realizado pequeños cambios con el objetivo de mostrar de forma mas clara lo que se ha pedido.
Se espera refactorizar los codigos de bluetooth y de GPS para hacerlo mas entendible.


# Cosas Hechas
## Bluetooth
Boton para iniciar escaneo de los dispositivos.
 De cada dispositivo muestra nombre, uuid, mac, rssi
## GPS
Entregar longitud, latitud, ademas de entregar la precision del calculo.
### Observaciones
se demora entre 5-10 segundos en actualizar la locacion segun testeos

### Permisos 
En AndroidManifest.xml dentro de la capeta android => app => src => main 
* <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
En Info.plist dentro de la carpeta ios => Runner
*    <key>NSLocationAlwaysUsageDescription</key>
     <string>Needed to access location</string>
     <key>NSLocationWhenInUseUsageDescription</key>
     <string>Needed to access location</string>
## QR
* Altura de Santiago: 545m.
Escanea imagen, entrega en pantalla la informacion obtenida del QR, metodos usados a continuacion
* _scanQR() async : metodo que realiza el scan de QR y lo guarda en la variable 'result', tambien maneja
errores.
## Wifi
Muestra nombre red, IP y la intensidad escalada, mas cerca del 0 mas potente.
* 1=rssi entre -80 y -100
* 2=rssi entre -55 y -80
* 3=rssi entre 0 y -55

Los metodos usados e implementados se enumeraran a continuacion, junto con una pequeña descripcion:

* Future<void> _getIWifiName() async : devuelve  el nombre del wifi al que esta conectado.
* Future<void> _getIP() async : devuelve IP del wifi al que esta conectado
* Future<void> _getWifiLevel() async : devuleve un valor numerico entre 1-3, arriba la descripcion

### Funciones utiles de conocer

#### Para navegar entre vistas
onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context)=>FirstScreen()));}

#### Para devolverse segun el contexto que tiene ( Contexto == lista con las vistas recorridas en la app)
onPressed: () {Navigator.pop(context);}
