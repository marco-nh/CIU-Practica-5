import java.text.Normalizer;
//Autor: Marco Nehuen Hernández Abba
//OBJETIVOS
//1. Separar por fechas los orbes (CANCELADO)

Table tabla;
Lugar[] lugar;
float tam;

//porcentaje
float por;

float musX;
float musY;
float maxX;
float minX;
//almacen min
float[] m;

//revisión datos
boolean done;
//sumar
boolean sumar;
boolean sumar2;
//restablece
boolean rest;
//evitar solape de botones
boolean fboton;

//textura boton
PShape boton;

//color
color[] colores;

//filtros (cantidad minima rentas, tiempo y fecha)
float[] filtro;

//datos
String[][] datos;


//PShape imagenes
PShape lrarrow;
PShape lclick;
PShape s;

//click boton
Boton bCargar;
Boton bSum1;
Boton bRes;
Boton bSum2;
Boton bFil;
Boton bHelp;
Boton bMapa;

//cambiar mapa
int mapa;

//desplazar
boolean desp;
PVector lastM;

//ayuda
boolean ayuda;

void setup(){
   size(1200,700,P3D);
   background(255);
   
   
   //botones
   done = false;
   sumar = false;
   tabla = loadTable("SÍTYCLETA-2021.csv","header,csv");
   
   //imagenes
   lclick = loadShape("lclick.svg");
   lrarrow = loadShape("lrarrow.svg");
   lclick.scale(0.2);
   lrarrow.scale(6);
   //ayuda
   ayuda = false;
   fboton = false;
   
   //revision tabla
   println(tabla.getRowCount() + " total rows in table");
   por = 0;
   tam = Math.round(tabla.getRowCount()*por);
   lugar = new Lugar[20000];
   colores = new color[20000];
   
   //desplazar
   lastM = new PVector();
   minX = 80;
   //almacen min
   m = new float[2];
   //filtro (tiempo, cantidad,fecha)
   filtro = new float[4];
   for (int i = 0; i < filtro.length; i++) filtro[i] = 0;
   
   //datos
   datos = new String[20000][4];
   
   bCargar = new Boton("Cargar",100,60,0);
   bSum1 = new Boton("Sumar %",200,100,0);
   bRes = new Boton("Restablecer",100,140,0);
   bSum2 = new Boton("Sumar +",100,100,0);
   bFil = new Boton("Sumar tiempo",100,180,0);
   bHelp = new Boton("Ayuda",100,400,0);
   bMapa = new Boton("Cambiar mapa", 100, 360,0);
   
   //generacion aleatoria de colores
   
   for(int i = 0; i < colores.length; i++){
     colores[i] = color(random(255),random(255),random(255));
   }
   
   mapa = 0;
   //cargar XML
   datos = cargarXML(mapa);
   
   //crear mapa
   cargarImagen(mapa);
   //dibujo mapa
   dibujaMapayEstaciones(mapa);
   
   
}

void draw(){
  background(255);
  verImagen(mapa);
  iluminacion();
  
  
  //columna roja
  pushMatrix();
  translate(width/4,height/4,-20);
  fill(255,80,80);
  box(width/2+20,height/2+265,20);
  fill(0);
  popMatrix();
  
  //columna celeste de fondo
  pushMatrix();
  translate(width/2,height/2,-200);
  fill(100,240,245);
  box(2000,2000,0);
  fill(0);
  popMatrix();
  
  if(done){
    calcular();
    done = false;
  }
  
  //posicion raton
  musX = mouseX;
  musY = mouseY;
  
  if(!desp){ lastM.x = mouseX; lastM.y = mouseY;}
  
  
  
  //texto datos 1
  fill(0);
  text("% Datos: " + por + " datos: " + tam,400, 20);
  
  
  //filtro
  textSize(15);
  text("Tiempo renta: ",200,height/2+100);
  textSize(12);
  
  //mapa
  text("Mapa: " + mapa, 160,365);
  
  
  //viscicleta
  textSize(20);
  text("Viscicleta",40,20);
  textSize(12);
  
  text(">" +filtro[0] + " min",200,height/2+120);
 
  //cargar esferas (fila inferior)
  m = visualizar(minX,maxX,lugar,filtro);
  minX = m[0];
  maxX = m[1];
  
  bCargar.dibujar();
  bSum1.dibujar();
  bRes.dibujar();
  bSum2.dibujar();
  bFil.dibujar();
  bHelp.dibujar();
  bMapa.dibujar();
  
  done = bCargar.interaccion();
  sumar = bSum1.interaccion();
  
  
  if(bRes.interaccion()){ 
    minX = 80; 
    maxX = 0; 
    tam = 1; 
    por = 0; 
    done = true;
    for(int i = 0; i < filtro.length; i++){
      filtro[i] = 0;  
    }
    //limpiar lienzo
    limpiar(mapa);
  }
  sumar2 = bSum2.interaccion();
  if(bFil.interaccion()){ filtro[0] += 20;}
  if(sumar2){
    tam += 5;
    sumar2 = false;
  }
  
  //ayuda
  if(bHelp.interaccion()){
    if(ayuda == false){
      ayuda = true;  
    } else{
      ayuda = false; 
    }
  }
  
  //cambio de mapa (al menos 10 mapas?)
  if(bMapa.interaccion()){
    datos = new String[20000][4];
    nest = 0;
    mapa++;
    if(mapa > 1){
      mapa = 0;
    }
    
    datos = cargarXML(mapa);
    limpiar(mapa);
    //crear mapa
    cargarImagen(mapa);
    //dibujo mapa
    dibujaMapayEstaciones(mapa);
  }
  
  if(sumar && por < 1){
    por = por + 0.125; 
    tam = Math.round(tabla.getRowCount()*por);
    sumar = false;
  }
  
  if(desp) desplazamiento();
  if(ayuda) ayuda();
}

// Carga los lugares con la cantidad de datos seleccionada
// Si es un lugar nuevo, se crea un Lugar y se almacena en el array, si es un lugar que ya existe, se mete en Lugar creado anteriormente y aumenta su valor de cantidad de rentas
void calcular(){
  limpiar(mapa);
  lugar = new Lugar[200000];
  int id = 0;
  
  for (TableRow row : tabla.rows()) {
    if(id < tam){
      id++;
      String start = row.getString("Start");
      String end = row.getString("End");
      String minutos = row.getString("Minutos");
      String renta = row.getString("Rental place");
      
      //borrar tildes y parentesis
      //https://stackoverflow.com/questions/15190656/easy-way-to-remove-accents-from-a-unicode-string
      //https://stackoverflow.com/questions/56375850/how-to-remove-parentheses-from-string
      renta = Normalizer.normalize(renta,Normalizer.Form.NFD);
      renta = renta.replace('(',' ').replace(')',' ');
      renta = renta.replaceAll("[\\p{InCombiningDiacriticalMarks}]", "");
      
      String devuelta = row.getString("Return place");
      
      for(int i = 0; i < id; i++){
        if(lugar[i] == null){
          
          lugar[i] = new Lugar(renta,i);
          
          //comprobarDatos es el que dibuja los circulos
          comprobarDatos(datos,lugar[i],colores);
          lugar[i].addReturnPlace(devuelta,parseFloat(minutos));
          break;
        } else{  
          if (lugar[i].getString().matches(renta)){
             lugar[i].addReturnPlace(devuelta,parseFloat(minutos));
             break;
          }
        }
      }
    }
    
  }
}

//Clase Lugar
//num = numero de rentas
//minutos = tiempo de renta
//sitio = lugar origen
//id = identificador
//sitiodev = lugares que se repite (tamaño de array igual a num)
class Lugar{
  int num;
  float minutos;
  String sitio;
  int id;
  ArrayList<String> sitioDev = new ArrayList<String>();
  Lugar(String s, int i){
    sitio = s;
    num = 0;
    minutos = 0;
    id = i;
  }
  
  //comprueba si la string coincide
  boolean matches(String s){
    if(sitio == s){
      return true;
    }
    return false;
  }
  //Si se visualiza cuales son el lugar de devolución, evita repeticiones
  void addReturnPlace(String dev,float min){
    num++;
    minutos += min;
    boolean coin = false;
    for(String sit : sitioDev){
      if(dev.equals(sit)){
        coin = true;
        
        break;
      }
    }
    if(!coin) sitioDev.add(dev);
  }
  int getNumber(){
    return num;  
  }
  String getString(){
    return sitio;  
  }
  float getMinutos(){
    return minutos;  
  }
  int getId(){
    return id;  
  }
  ArrayList<String> getDevs(){
    return sitioDev;
  }
}

//Clase boton: crea un boton y su interaccion
//posX,posY,posZ localizacion
//pulsado: verifica si esta pulsado el boton

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
    pushMatrix();
    translate(posX,posY,posZ);
    fill(200,0,0);
    if (pulsado) box(100,30,5);
    else box(100,30,10);
    fill(0);
    textAlign(CENTER);
    if (pulsado) text(texto,-4,6,5);
    else text(texto,-2,4,10);
    textAlign(LEFT);
    fill(255);
    popMatrix();
  }
  //comprubea si se itera
  boolean interaccion(){
    if (musX > posX-50 && musX < posX+50 && musY > posY-15 && musY < posY+15 && mousePressed == true && pulsado == false && fboton == false){
    /* comprobacion
    pushMatrix();
    fill(255,0,0);
    translate(posX,posY);
    box(10);
    fill(0);
    popMatrix();*/
    pulsado = true;
    return true;
    }
    if(mousePressed == false) pulsado = false;
    return false;
  }
  
}
void iluminacion(){
  lights();  
}
void desplazamiento(){
  
  if(maxX < 1200){
    minX = 0;  
  }
  if(maxX - (lastM.x - mouseX)/20 > width){
    minX -= (int) (lastM.x - mouseX)/20;
  } 
  
  if(minX > 0){
    minX = 0;  
  }
  
}


void mousePressed(){
  if (mouseButton == LEFT && done == false && rest == false && sumar == false){
      desp = true;
  }
}

void mouseDragged(){
  fboton = true;
}
void mouseReleased(){
  /* Siempre que el click sea soltado, se podrá pulsar otros botones (si se habia pulsado alguno), y el desplazamiento dejara de suceder */
  
  desp = false;
  fboton = false;
}
