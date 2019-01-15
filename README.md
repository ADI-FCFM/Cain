# Cosas Hechas

## Bluetooth
Boton para iniciar escaneo de los dispositivos. De cada dispositivo muestra nombre, uuid, mac, rssi
## GPS
Falta implementar y verificar la precision
## QR
Escanea imagen, entrega en pantalla la informacion obtenida del QR
## Wifi
Muestra nombre red, IP y la intensidad escalada entre 1 y 3
### Funciones utiles de conocer

#### Para navegar entre vistas
onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context)=>FirstScreen()));}

#### Para devolverse segun el contexto que tiene ( Contexto == lista con las vistas recorridas en la app)
onPressed: () {Navigator.pop(context);}
