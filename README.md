# Cosas Hechas

## Bluetooth
Boton para iniciar escaneo de los dispositivos. De cada dispositivo muestra nombre, uuid, mac, rssi
## GPS
Entregar longitud, latitud, ademas de entregar la precision del calculo.
## QR
Escanea imagen, entrega en pantalla la informacion obtenida del QR
## Wifi
Muestra nombre red, IP y la intensidad escalada
* 1=rssi entre -80 y -100
* 2=rssi entre -55 y -80
* 3=rssi entre 0 y -55

### Funciones utiles de conocer

#### Para navegar entre vistas
onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context)=>FirstScreen()));}

#### Para devolverse segun el contexto que tiene ( Contexto == lista con las vistas recorridas en la app)
onPressed: () {Navigator.pop(context);}
