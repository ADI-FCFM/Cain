# Disclaimer:
Todas las implementaciones estan basadas en los ejemplos de las librerias que estan siendo utilizadas
, se han realizado pequeños cambios con el objetivo de mostrar de forma mas clara lo que se ha pedido.


Se especificara cuando haya que inicializar objetos de la libreria para usarla.

## Bluetooth
[Pagina de la libreria](https://pub.dartlang.org/packages/flutter_blue)

Boton para iniciar escaneo de los dispositivos.
 De cada dispositivo muestra nombre, uuid, mac, rssi
### Observaciones
Beacons **deben** tener un nombre.


## GPS

[Pagina de la libreria](https://pub.dartlang.org/packages/location)
Entregar longitud, latitud, ademas de entregar la precision del calculo.

Metodos usados a continuacion:

* __location = new Location()__: Inicializa un objeto para usar la libreria.
* __location.onLocationChanged().listen((Map<String,double> result)__: usando
el objeto location, detecta los cambios de posicion y los guarda en un mapa
(result en este caso del tipo String-double).Se debe tener el metodo setState para actualizar cada
vez que se recibe un cambio, ademas de que el resultado del metodo debe estar
en un objeto de tipo StreamSubscription( similar a un observer) para que se
pueda mantenere un seguimiento de la posicion
* __location.hasPermission__: chequea que la aplicacion tenga permisos para
usar el GPS. Entrega un booleano
* __location.getLocation__: pide una sola vez la informacion del GPS

Como toda la informacion se guarda en un mapa, se especifica a continuacion
los nombres con los que se guardan la informacion:
* Altitude
* Latitude
* Speed
* Longitud
* Acurracy

### Observaciones
se demora entre 5-10 segundos en actualizar la locacion segun testeos
### Permisos 
En AndroidManifest.xml dentro de la capeta android/app/src/main 
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```
En Info.plist dentro de la carpeta ios/Runner

     <key>NSLocationAlwaysUsageDescription</key>
     <string>Needed to access location</string>
     <key>NSLocationWhenInUseUsageDescription</key>
     <string>Needed to access location</string>

## QR
[Pagina de la libreria](https://pub.dartlang.org/packages/barcode_scan)

Escanea imagen, entrega en pantalla la informacion obtenida del QR. Es un
wrapper de 2 librerias QR de android y de iOS

Metodos usados a continuacion:

* __BarcodeScanner.scan()__: funcion de la libreria para iniciar el escaneo,
devuelve un string con la informacion sacada del QR. Usada dentro de la
funcion  _scanQR_

### Permisos
En AndroidManifest.xml dentro de la capeta android/app/src/main
```xml
<uses-permission android:name="android.permission.CAMERA" />
```

En Info.plist dentro de la carpeta ios/Runner

    <key>NSCameraUsageDescription</key>
    <string>Camera permission is required for barcode scanning.</string>

## Wifi
[Pagina de la libreria](https://pub.dartlang.org/packages/wifi)

Muestra nombre red, IP y la intensidad escalada, mas cerca del 0 mas potente.
* 1=rssi entre -80 y -100
* 2=rssi entre -55 y -80
* 3=rssi entre 0 y -55

Los metodos usados a continuacion:
* __Wifi.ssid__ : devuelve  el nombre del wifi al que esta conectado. Usado en _getWifiName()_
* __Wifi.ip__ : devuelve IP del wifi al que esta conectado. Usado en _getIP()_
* __Wifi.level__ : devuleve un valor numerico entre 1-3, arriba la descripcion. Usado en _getWifiLevel_()


## Funciones utiles de conocer

#### Para navegar entre vistas
onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context)=>FirstScreen()));}

#### Para devolverse segun el contexto que tiene ( Contexto == lista con las vistas recorridas en la app)
onPressed: () {Navigator.pop(context);}
