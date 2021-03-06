#  Proyecto Caín
El objetivo de este proyecto de investigación es conocer las capacidades que tiene el framework Flutter para usarlo en posicionamiento indoor. 

La motivación detrás de este proyecto es poder integrar las capacidades de posicionamiento indoor en la aplicación [Hades](https://github.com/ADI-FCFM/Hades) con la finalidad de filtrar los accesos que se disponibilizan al usuario basado en su ubicación dentro de la facultad.

Para esto, la investigación se centrará en 4 tecnologías presentes en la mayoría los dispositivos móviles actuales:
Bluetooth, GPS, QR y Wifi

##  Disclaimer:

Las herramientas usadas para la investigación usadas fueron:
- Una beacon Estimote con protocolo de iBeacon
- Una tablet Lenovo con Android 7.1.1
- Android Studio

Por temas de disponibilidad de materiales, no fue posible contar con mas beacons,
tanto iBeacon como de los otros protocolos disponibles, además de no tener
acceso a un dispositivo Apple para realizar las pruebas correspondientes
en esa plataforma.

Todas las implementaciones están basadas en los ejemplos de las librerías que están siendo utilizadas,
se han realizado pequeños cambios con el objetivo de mostrar de forma más clara lo que se ha pedido.

El razonamiento para la elección de librerías se basó en 2 puntos principales,
primero que cumpliera con lo mínimo necesario para poder analizar el potencial
para posicionamiento indoor y segundo, que el ejemplo provisto por esta fuera simple para entender y trabajar
 debido a la poca experiencia utilizando Flutter al momento de
realizar la investigación.

Asegurarse que en el archivo [build.gradle](../master/android/app/build.gradle),
__compileSdkVersion__ y __targetSdkVersion__ sea 28 y que __minSdkVersion__ sea 19. Esto puede variar
dependiendo la versión del SDK de android y de a la velocidad que se actualizen las librerías

Se especificará cuando haya que inicializar objetos de la librería para usarla.

El proceso de investigación fue realizado entre el 2 y el 24 de enero de 2019, por lo que pueden existir actualizaciones de las librerías al momento de consultar este repositorio.


## GPS

[Página de la librería location](https://pub.dartlang.org/packages/location)

Entregar longitud, latitud, además de entregar la precisión del cálculo.

Métodos usados a continuación

* __new Location()__: Inicializa objeto para usar la librería.
* __hasPermission__:usando el objeto location chequea que la aplicación tenga permisos para
usar el GPS. Entrega un booleano.
* __getLocation__: pide una sola vez la información del GPS al objeto location.
* __onLocationChanged().listen((Map<String,double> result)__: usando
el objeto location, detecta los cambios de posición y los guarda en un mapa
(result en este caso del tipo String-double).Se debe tener el método __setState__ para actualizar cada
vez que se recibe un cambio, además de que el resultado del método debe estar
en un objeto de tipo StreamSubscription( similar a un observer) para que se
pueda mantenere un seguimiento de la posición.


Como toda la información se guarda en un mapa, se especifica a continuación
los nombres con los que se guardan la información:
* Altitude
* Latitude
* Speed
* Longitud
* Acurracy


### Permisos 
En el archivo [AndroidManifest.xml](../master/android/app/src/main/AndroidManifest.xml)
agregar lo siguiente
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```
En el archivo [Info.plist](../master/ios/Runner/Info.plist) agregar lo siguiente
dentro del tag dict

     <key>NSLocationAlwaysUsageDescription</key>
     <string>Needed to access location</string>
     <key>NSLocationWhenInUseUsageDescription</key>
     <string>Needed to access location</string>

### Observaciones
 Se demora entre 5-10 segundos en actualizar la locación según testeos


 Factibilidad para posicionamiento indoor esta muy limitada por las capacidades
de la tecnología GPS para funcionar en situaciones bajo techo o similares.
Se recomienda que se use para asegurarse que la persona este dentro del área
de la facultad al momento de usar la aplicación.


## QR
[Página de la librería barcode_scan](https://pub.dartlang.org/packages/barcode_scan)

Escanea imagen, entrega en pantalla la información obtenida del QR. Es un
wrapper de 2 librerias QR de android y de iOS.

Métodos usados a continuación:

* __BarcodeScanner.scan()__: función de la librería para iniciar el escaneo,
devuelve un string con la información sacada del QR. Usada dentro de la
función  _scanQR_

### Permisos
En el archivo [AndroidManifest.xml](../master/android/app/src/main/AndroidManifest.xml)
agregar lo siguiente
```xml
<uses-permission android:name="android.permission.CAMERA" />
```

En el archivo [Info.plist](../master/ios/Runner/Info.plist) agregar lo siguiente
dentro del tag dict

    <key>NSCameraUsageDescription</key>
    <string>Camera permission is required for barcode scanning.</string>



## Wifi
[Página de la librería](https://pub.dartlang.org/packages/wifi)

Muestra nombre red, IP y la intensidad escalada, mas cerca del 0 mas potente.
* 1 = rssi entre -80 y -100
* 2 = rssi entre -55 y -80
* 3 = rssi entre 0 y -55

Los métodos usados a continuacion:
* __Wifi.ssid__ : devuelve  el nombre del wifi al que esta conectado. Usado en _getWifiName()_
* __Wifi.ip__ : devuelve IP del wifi al que esta conectado. Usado en _getIP()_
* __Wifi.level__ : devuelve un valor numerico entre 1-3, arriba la descripción. Usado en _getWifiLevel_()

### Observaciones

Existen ejemplos de la vida real que usan Wifi para posicionamiento indoor,
pero debido a limitaciones  respecto a la información que puede conseguir
una aplicación desde un dispositivo Apple, se limita bastante la factibilidad
de usarlo como alternativa para posicionamiento indoor.

## Bluetooth
[Página de la librería flutter_blue](https://pub.dartlang.org/packages/flutter_blue)

Busca los dispositivos bluetooth en las cercanías, y obtiene la información de los
dispositivos detectados (rrsi, uuid, mac entre otros elementos de interés).
Recomendado fuertemente utilizarlo en conjunto con Beacons para realizar
el posicionamiento indoor.

Métodos y objetos usados a continuación:
* __ScanResult__: objeto que almacena la información resultante del escaneo
realizado. Tiene los siguientes métodos

        advertisementData: informacion del dispositivo
        device: dispositivo obtenido
        rrsi: intensidad de la señal

* __device__: identifica el dispositivo bluetooth que se
 está detectando. Usado para comprobar el estado del dispositivo inicializandolo
 previamente con BluetoothDevice.
  Tiene los siguientes métodos:

        id: entrega el MAC del dispositivo.
        nombre: Nombre con el que se identifica el dispositivo.
        type: numeració n para detectar el tipo de dispositivo que fue detectado
        segun la tecnología ocupadad por este. Tiene 4 estados posibles
        (unknown, classic, le, dual)

* __advertisementData__: método que expone las características obtenidas
de los dispositivos escaneados en rango. Tiene los siguientes métodos que
entregan la información del dispositivo:

      String local name
      int txPowerLevel
      bool connectable
      Map<int,List<int>> manufacturerData
      Map<String, List<int>> serviceData
      List<String> serviceUuids

* __FlutterBlue.instance__: Inicializa objeto para usar la funcionalidad de la librería.

* __state__: Reconoce el estado del bluetooth del dispositivo.
BluetoothState.unknown es una enumeración y se inicializa en unknow.
 Además de eso tiene como estados posibles __unknown,unavailable,
unauthorized, turningOn, turningOff, on, off__ .

* __onStateChanged()__: se activa cuando detecta un cambio en la instancia de la librería.

* __listen(algo)__: cuando ocurre un cambio, entrega el valor actualizado como una variable
(algo en este caso) para trabajar con ella.

* __scan()__: empieza el escaneo de los dispositivos bluetooth de su cercanía.
Se le puede colocar un tiempo máximo de duración del escaneo con el parámetro
timeout: const Duration(seconds minutes).




### Observaciones
Beacons **deben** tener un nombre (local name), de lo contrario empezara a
listar a todos los dispositivos que esten a su alcance visibles. No tengo
claridad sobre si identifica solo las direcciones MAC de los dispositivos
Bluetooth o si es sobre otros dispositivos emitiendo señal.

En el archivo [widgets.dart](../master/lib/widgets.dart) se encuentran clases para
presentar de una forma limpia y ordenada la información obtenida de los
dispositivos escaneados, por lo que se mantiene con pocos cambios en
relación a su implementación original.

Se desconoce la capacidad de la librería respecto los protocolos que no fueron
testeados durante la investigación (AltBeacon y EddyStone),

## Librería Adicional de Bluetooth
[Página de librería flutter_beacon](https://pub.dartlang.org/packages/flutter_beacon)

Librería para manejo de iBeacons exclusivamente.
Entrega uuid, rssi, mayor, minor, txPower, MAC y un aproximado de la precisión
Funciona con iOS8+

Utiles de la librería usados a continuación:

* __Beacon__ tipo de objeto que almacena las características de cada una de las
beacons encontradas, métodos para obtener su información a continuación

        proximityUUID
        major
        minor
        acurracy
        rssi
        txPower
        macAddress


### Permisos
En el archivo [Info.plist](../master/ios/Runner/Info.plist) agregar lo siguiente
dentro del tag dict

    <key>NSLocationWhenInUseUsageDescription</key>
    <string>Reason why app needs location</string>

### Observaciones

Funciona solo con iBeacons, debido a la forma en que maneja la información
que recibe de la señal detectada.
