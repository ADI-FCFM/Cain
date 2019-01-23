# Disclaimer:
Todas las implementaciones estan basadas en los ejemplos de las librerias que estan siendo utilizadas
, se han realizado pequeños cambios con el objetivo de mostrar de forma mas clara lo que se ha pedido.

Asegurarse que en el archivo [build.gradle](../master/android/app/build.gradle) ,
compileSdkVersion y targetSdkVersion sea  28 y que minSdkVersion sea 19. Esto puede variar
dependiendo la version del SDK de android y de a la velocidad que se actualizen las librerias


Se especificara cuando haya que inicializar objetos de la libreria para usarla.

## Bluetooth
[Pagina de la libreria flutter_blue](https://pub.dartlang.org/packages/flutter_blue)

Busca los dispositivos bluetooth en las cercanias, y obtiene la informacion de los
dispositivos( rrsi, uuid, mac entre otros elementos de interes.

Metodos usados a continuacion:

* __FlutterBlue.instance__: Inicializa objeto para usar la funcionalidad de la libreria

* __state__: Reconoce el estado del bluetooth del dispositivo.
BluetoothState.unknown es una enumeracion y se inicializa en unknow. Ademas de eso tiene unknown,unavailable,
unauthorized, turningOn, turningOff, on, off como estados posibles

* __BluetoothDevice device__: identifica el dispositivo que se esta usando.
Usado para comprobar el estado del dispositivo.

* __onStateChanged()__: se activa cuando detecta un cambio en la instancia de la libreria.

* __listen(algo)__: cuando ocurre un cambio, entrega el valor actualizado como una variable
(algo en este caso) para trabajar con ella.

* __scan()__: empieza el escaneo de los dispositivos bluetooth de su cercania.
Se le puede colocar un tiempo maximo de duracion del escaneo con el parametro
timeout: const Duration(seconds minutes).

* __advertisementData__: metodo que expone las caracteristicas obtenidas
de los dispositivos escaneados en rango. Tiene los siguientes metodos:

      String local name
      int txPowerLevel
      bool connectable
      Map<int,List<int>> manufacturerData
      Map<String, List<int>> serviceData
      List<String> serviceUuids


### Observaciones
Beacons **deben** tener un nombre.

En el archivo [widgets.dart](../master/lib/widgets.dart) se encuentran clases para
presentar de una forma limpia y ordenada la informacion obtenida de los
dispositivos escaneados, por lo que se mantiene con pocos cambios en
relacion a su implementacion original


## GPS

[Pagina de la libreria location ](https://pub.dartlang.org/packages/location)

Entregar longitud, latitud, ademas de entregar la precision del calculo.

Metodos usados a continuacion:

* __new Location()__: Inicializa objeto para usar la libreria.
* __onLocationChanged().listen((Map<String,double> result)__: usando
el objeto location, detecta los cambios de posicion y los guarda en un mapa
(result en este caso del tipo String-double).Se debe tener el metodo setState para actualizar cada
vez que se recibe un cambio, ademas de que el resultado del metodo debe estar
en un objeto de tipo StreamSubscription( similar a un observer) para que se
pueda mantenere un seguimiento de la posicion
* __hasPermission__:usando el objeto location chequea que la aplicacion tenga permisos para
usar el GPS. Entrega un booleano
* __getLocation__: pide una sola vez la informacion del GPS al objeto location

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
En el archivo [AndroidManifest.xml](../master/android/app/src/main/AndroidManifest.xml)
agregar lo siguiente
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```
En el archivo [Info.plist](../master/ios/Runner/Info.plist) agregar lo siguiente
dentro del tag <dict>

     <key>NSLocationAlwaysUsageDescription</key>
     <string>Needed to access location</string>
     <key>NSLocationWhenInUseUsageDescription</key>
     <string>Needed to access location</string>

## QR
[Pagina de la libreria barcode_scan](https://pub.dartlang.org/packages/barcode_scan)

Escanea imagen, entrega en pantalla la informacion obtenida del QR. Es un
wrapper de 2 librerias QR de android y de iOS

Metodos usados a continuacion:

* __BarcodeScanner.scan()__: funcion de la libreria para iniciar el escaneo,
devuelve un string con la informacion sacada del QR. Usada dentro de la
funcion  _scanQR_

### Permisos
En el archivo [AndroidManifest.xml](../master/android/app/src/main/AndroidManifest.xml)
agregar lo siguiente
```xml
<uses-permission android:name="android.permission.CAMERA" />
```

En el archivo [Info.plist](../master/ios/Runner/Info.plist) agregar lo siguiente
dentro del tag <dict>

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


## Libreria Adicional
[Pagina de libreria flutter_beacon](https://pub.dartlang.org/packages/flutter_beacon)

Libreria para manejo de iBeacons exclusivamente.
Entrega uuid, rssi, mayor, minor y la distancia aproximada al beacon
Funciona con iOS8+

### Permisos
Para iOS
          <key>NSLocationWhenInUseUsageDescription</key>
          <string>Reason why app needs location</string>
