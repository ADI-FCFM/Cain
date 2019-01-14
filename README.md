# Cosas Hechas

## Bluetooth
Done
## GPS
Falta implementar y verificar la precision
## QR
Faltan un par de pruebas.
## Wifi
WIP
### Funciones utiles de conocer

#### Para navegar entre vistas
onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context)=>FirstScreen()));}

#### Para devolverse segun el contexto que tiene ( Contexto == lista con las vistas recorridas en la app)
onPressed: () {Navigator.pop(context);}
