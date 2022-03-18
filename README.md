# Memoria Practica 5 CIU - Viscicleta
 Creado por Marco Nehuen Hernández Abba

![gif5](https://user-images.githubusercontent.com/47418876/159037045-bd1d3f21-ed9d-48a9-b42e-7c6d0281bc5d.gif)

### Contenido
- Trabajo realizado
- Herramientas y Referencias

## Trabajo realizado
Viscicleta es una aplicacion que a partir de los datos de SITYCLETA 2021, se puede conseguir los lugares de rentas que han sido usados, estos incluyen localización, tiempo de renta de cada lugar y "popularidad".

Una aplicación con tres secciones, la roja, selección de datos,la seccion de visualización de paradas en un mapa seleccionado y la azul, visualización de los datos seleccionados (lugar de renta, duracion acumulada y veces rentada en el lugar)

Esta aplicación cuenta con varias partes.
- Interfaz
- Mapa
- Referencia de lugar con figuras

### Interfaz

En la sección roja (selección) se ha optado por usar botones, que responden cuando se le hace click izquierdo en ellos.
El botón es una clase creada de cero.
Una vez creada, se usaba de manera conveniente en las iteraciones.
```
class Boton{
  String texto;
  float posX;
  float posY;
  float posZ;
  boolean pulsado;
  Boton(String t, float pX, float pY, float pZ){
    texto = t;
    posX = pX;
    posY = pY;
    posZ = pZ;
  }
  void dibujar(){
    //dibujar boton
    ...
  }
  //comprubea si se itera
  boolean interaccion(){
    ...
  }
  
}
```

![image](https://user-images.githubusercontent.com/47418876/159038646-cea105cf-5faa-4da4-a874-26887b80fe1f.png)

La secccion que contiene un mapa se ha creado un fichero de codigo a parte para separarlo del codigo principal,
se decidio usar [OpenStreetMap](https://www.openstreetmap.org/#map=13/28.1126/-15.4336).
Con los datos exportados y la foto hecha para uso de esos datos, comparandolos con los lugares de renta dentro de SITYCLETA 2021 se sacan
las localizaciones de las estaciones.

**Tener en cuenta que al usar los datos directos de OpenStreetMap, hay estaciones que existen en la realidad pero no hay sido aportadas en la pagina**

```
//PASO 1: cargarXML
String[][] cargarXML(int num){
  //Inicializacion variables y recoleccion de datos
  ...
  //Creamos estruatura paar almacenar lo que nos interesa
  lats = new float[100];
  lons = new float[100];
  nombres = new String[100];
  
  //Obtiene límites en latitud y ongitud del mapa
  minlat = extremos.getFloat("minlat");
  minlon = extremos.getFloat("minlon");
  maxlat = extremos.getFloat("maxlat");
  maxlon = extremos.getFloat("maxlon");
  ...
  for (XML node : nodes.values()) {
    for(XML tag : node.getChildren("tag")){
      ...
      //busca datos que contengan la palabra Sitycleta, y halla su latitu, longitud y nombre exacto
      if(tipov.contains("Sitycleta")){
        ...
        break;
      }
      ...
    }
  }
  ...
  return store;
}
```
```
//PASO 2: comprobar si hay alguna coincidencia entre el mapa y los datos
//Datos [0][0] = lat ; [0][1] = lon ; [0][2] palabras
void comprobarDatos(String[][] datos, Lugar lugar, color[] colores){
  ...
    //evitar datos vacios que pueden activar todos los sitios
    if(datos[i][2].contains(lugar.getString()) && !lugar.getString().equals("")){
      
      dibujar(mapa,f[0],f[1],f[2],f[3],datos[i],colores[lugar.getId()]);
    }
    
  }
  
  
}
```

Para dibujar en el mapa, se usó parte del ejemplo de [la guía de la Practica 5](https://github.com/otsedom/otsedom.github.io/tree/main/CIU/P5)
Especificamente en la parte de **Vista del mapa OSM**

![image](https://user-images.githubusercontent.com/47418876/159040832-5a0032c9-b3a8-4583-86ba-7cbac992c0b2.png)

Por último, visualización de los datos seleccionados (lugar de renta, duracion acumulada y veces rentada en el lugar) en forma de pilar.
Fue decidido asi para hacer un poco de uso de la iluminacion (aunque los botones hacen uso de ella tambien) y también para poder conocer
casi todos los datos escogidos, ya que recoge todos los lugares de renta.

Itera con el raton para tener un desplazamiento horizontal de las figuras y poder verlas todas sin sobrecargar la pantalla.

**Funcion que se usa para la visualización**
```
//En base al minX (extremo izquierdo) y maxX (extremo derecho), cargar cada figura con los filtros
//devuelve los extremos para ser usados posteriormente
float[] visualizar(float minX, float maxX, Lugar[] lugar, float[] filtro){
  ...
}
```
![image](https://user-images.githubusercontent.com/47418876/159041889-6612c37e-65c2-47fd-8f55-bec2f3c4b593.png)


Esta aplicación cuenta con una ayuda, se explica todo lo que significa cada cosa al hacerle clic.
En esta practica, la ayuda se sobrepone al texto de la aplicación, para especificar su función.

## Herramienta y referencias

**Herramientas**
[EZGif](https://ezgif.com/): Alternativa para hacer gif con facilidad
[OpenStreetMap](https://www.openstreetmap.org/#map=13/28.1126/-15.4336): Datos .osm y extracción de imagenes del mapa

**Referencias**
[Explicación práctica 5](https://github.com/otsedom/otsedom.github.io/tree/main/CIU/P5)

[svg bicicleta](https://svgsilh.com/tag/bicycle-1.html)
[svg click izquierdo](https://www.svgrepo.com/svg/69012/mouse-left-button)
[svg flechas](https://www.svgrepo.com/svg/136829/left-and-right-arrows)

[Borrar tildes](https://stackoverflow.com/questions/15190656/easy-way-to-remove-accents-from-a-unicode-string)
[Borrar parentesis](https://stackoverflow.com/questions/56375850/how-to-remove-parentheses-from-string)
