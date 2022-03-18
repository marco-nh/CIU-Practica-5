//Crea el mapa y lo dibuja usando la clase PImage y PGraphics

PGraphics lienzo;
PImage[] img = new PImage[10];
int r = 5;

void cargarImagen(int num){
  
  
  img[0]=loadImage("map2.png");
  img[1]=loadImage("map3.png");
  
  s = loadShape("bike.svg");
  s.disableStyle();
  //Creamos lienzo par el mapa
  lienzo = createGraphics(img[num].width ,img[num].height);
  lienzo.beginDraw();
  lienzo.background(100);
  lienzo.endDraw();
}

void verImagen(int num){
  float wid = width/2;
  float hei = 601*0.8;
  float relX = wid/img[num].width;
  float relY = hei/img[num].height;
  
  pushMatrix();
  translate(width/2,0);
  scale(relX,relY);
  //posicionar imagen
  image(lienzo, 0,0);
  popMatrix();
  
}

void dibujaMapayEstaciones(int num){
  //Dibuja sobre el lienzo
  lienzo.beginDraw();
  
  //Imagen de fondo
  lienzo.image(img[num], 0,0,img[num].width,img[num].height);
  
  lienzo.endDraw();
}

void dibujar(int num,float minlat, float minlon, float maxlat, float maxlon, String[] datos, color colores){
  nest = datos.length-1;
  
  //Dibuja sobre el lienzo
  lienzo.beginDraw();
  //Círculo y etiqueta de cada estación según latitud y longitud
  for (int i=0;i<nest;i++){
    float mlon = map(float(datos[1]), minlon, maxlon, 0, img[num].width);
    //latitud invertida con respecto al eje y de la ventana
    float mlat = map(float(datos[0]), maxlat, minlat, 0, img[num].height);
    //print(datos[2] + ";" + minlon + "\n");
    
    lienzo.fill(colores);
    lienzo.shape(s,mlon, mlat, -r, -r);
    lienzo.fill(0,0,0);
    lienzo.textSize(10);
    lienzo.textAlign(CENTER);
    lienzo.text(datos[2], mlon,mlat+20);
  }   
  lienzo.endDraw();
}

void limpiar(int num){
  lienzo = createGraphics(img[num].width ,img[num].height);
  lienzo.beginDraw();
  lienzo.background(100);
  lienzo.endDraw();
  dibujaMapayEstaciones(num);
}
