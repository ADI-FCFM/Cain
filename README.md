# beacons_manage

# Funciones utiles de conocer

## Para navegar entre vistas
onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context)=>FirstScreen()));}

## Para devolverse segun el contexto que tiene ( Contexto == lista con las vistas recorridas en la app)
onPressed: () {Navigator.pop(context);}


## Consideraciones
libreria funciona con la version de kotlin= 1.2.41, hay que cambiarlo a mano en build.graddle