//MAPLoader
//Carga la imagen y los datos DE ESA IMAGEN, SOLO DEL MAPA SELECCIONADO (defecto: map2.osm)

XML[] xml = new XML[10];
XML extremos;

float minlat;
float minlon;
float maxlat;
float maxlon;

HashMap<String, XML> nodes;
HashMap<String, XML> ways;

int nest;

float[] lats,lons;
String[] nombres;


//PASO 1: cargarXML
String[][] cargarXML(int num){
  String[][] store = new String[500][4];
  
  xml[0] = loadXML("map2.osm");
  xml[1] = loadXML("map3.osm");
  
  print("Cargado: " + num);
  extremos = xml[num].getChildren("bounds")[0];
  nodes = new HashMap<String, XML>();
  ways = new HashMap<String, XML>();
  for (XML node : xml[num].getChildren("node")) nodes.put(node.getString("id"), node);
  for (XML way : xml[num].getChildren("way")) ways.put(way.getString("id"), way);
  
  //Creamos estruatura paar almacenar lo que nos interesa
  lats = new float[100];
  lons = new float[100];
  nombres = new String[100];
  
  //Obtiene límites en latitud y ongitud del mapa
  minlat = extremos.getFloat("minlat");
  minlon = extremos.getFloat("minlon");
  maxlat = extremos.getFloat("maxlat");
  maxlon = extremos.getFloat("maxlon");
  println("Mapa con longitud (", minlon + ", " + maxlon + ") y latitud " + "(", minlat + ", " + maxlat + ")");
  println("Obtenidos " + ways.size() + " elementos");
  for (XML node : nodes.values()) {
    for(XML tag : node.getChildren("tag")){
      String tipok = tag.getString("k");
      String tipov = tag.getString("v");
      if(tipov.contains("Sitycleta")){
        String lat = node.getString("lat");
        String lon = node.getString("lon");
  
        print(nest +"\n");  
        store[nest][0] = lat;
        store[nest][1] = lon;
        store[nest][2] = tipov;
        print("Lugar:" + tipov + " Lat:" + lat + " Lon:" + lon + "\n");
        nest++;
        
        break;
      }
      
    }
  }
  store[0][3] = str(nest);
  
  return store;
}

//PASO 2: comprobar si hay alguna coincidencia entre el mapa y los datos
//Datos [0][0] = lat ; [0][1] = lon ; [0][2] palabras
void comprobarDatos(String[][] datos, Lugar lugar, color[] colores){
  
  int nest = int(datos[0][3]);
  float[] f = extremos();
  for(int i = 0; i < nest; i++){
    
    //evitar datos vacios que pueden activar todos los sitios
    if(datos[i][2].contains(lugar.getString()) && !lugar.getString().equals("")){
      
      dibujar(mapa,f[0],f[1],f[2],f[3],datos[i],colores[lugar.getId()]);
    }
    
  }
  
  
}

float[] extremos(){
   //Obtiene límites en latitud y ongitud del mapa
  minlat = extremos.getFloat("minlat");
  minlon = extremos.getFloat("minlon");
  maxlat = extremos.getFloat("maxlat");
  maxlon = extremos.getFloat("maxlon");
  
  float[] f = new float[4];
  f[0] = minlat;
  f[1] = minlon;
  f[2] = maxlat;
  f[3] = maxlon;
  
  //comprobacion
  //for(int i = 0; i < 4; i++) print(f[i] + "\n");
  return f;
}
