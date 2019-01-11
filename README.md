# beacons_manage

# Funciones utiles de conocer

## Para navegar entre vistas
onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context)=>FirstScreen()));}

## Para devolverse segun el contexto que tiene ( Contexto == lista con las vistas recorridas en la app)
onPressed: () {Navigator.pop(context);}
