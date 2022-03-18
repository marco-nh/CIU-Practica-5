//En base al minX (extremo izquierdo) y maxX (extremo derecho), cargar cada figura con los filtros
//devuelve los extremos para ser usados posteriormente


float[] visualizar(float minX, float maxX, Lugar[] lugar, float[] filtro){
  float posY = height-100;
  float posX = minX;
  int s = 0;
  int count = 0;
   //visual
  textSize(14);
  for(Lugar l : lugar){
    if(l == null){
      
    } else{
      if(l.getMinutos() > filtro[0]){
        //optimizacion: s divide 1200px que se desplacen y borrar esferas (s=1, borra los 6 primeros)
        s = round(-minX/1200);
       
        pushMatrix();
        //circulos de colores
        translate(posX,posY,-80);

        
        if(count < s*6+20 && count > s*6-20){
          noStroke();
          fill(colores[l.getId()]);
          pushMatrix();
          translate(0,-height/4,0);
          box(20+(0.005*l.getNumber()),height,-20);
          popMatrix();
        
          fill(0);
          stroke(0);
        //texto por encima
          text(l.getString(),40,-50);
          text(l.getMinutos() + "min",40,0);
        }
        
        
        
        //texto por debajo
        translate(0,50);
        if(count < s*6+20 && count > s*6-20){
          text(l.getNumber(),40,0);
        }
        
        float posF = 20;
        /*for(String sitiosD : l.getDevs()){
          if(count < s*6+20 && count > s*6-20){
            text(sitiosD,0,posF);
          }
          
          posF += 20;
        }*/
        popMatrix();
        
        posX += 200;
        maxX = posX;
        //solo texto
        //text(l.getString() + ": " + l.getNumber(),posX, posY);
        /*for(String devols : l.getDevs()){
          posX += 200;
          text(devols,posX, posY);
        }*/
        count++;
      }
    }
    
  }
  textSize(12);
  float[] r = new float[2];
  r[0] = minX;
  r[1] = maxX;
  return r;
}
//Visualizacion de la parte de ayuda
void ayuda(){

  
  //configuracion estandar
  noFill();
  textSize(14);
  stroke(255);
  strokeWeight(3);
  
  pushMatrix();
  //cuadrado 1
  
  
  rect(0,0,width/2,height/2+130);
  rect(width/6-10,height/2+80,width/4+width/12+10,50);
  
  //textos
  text("Operador",10,20,0);
  text("Visualizar lugares de renta",180,70,10);
  text("Aumentar datos para visualizar",270,105,10);
  text("Filtros",width/6-10,height/2+75,0);
  
  popMatrix();
  
  pushMatrix();
  translate(width/2,0);
  //cuadrado 2
  rect(0,0,width/2,height/2+130);
  fill(35);
  text("Mapa",10,20,0);
  text("Estacion Sitycleta",55,55,0);
  stroke(35);
  shape(s,20,40,20,20);
  stroke(255);
  noFill();
  
  popMatrix();
  
  pushMatrix();
  translate(0,height/2+130);
  //cuadrado 3
  stroke(color(255,0,0));
  rect(120,0,1,height/2-130);
  rect(100,0,1,height/2-130);
  stroke(255);
  
  rect(0,0,width,height/2-130);
  
  //texto
  text("Visualizacion",10,20,0);
  text("Lugar de renta",140,35);
  text("Tiempo de renta total",140,55);
  text("Cantidad rentas",140,75);
  
  shape(lclick,width/2+21,40);
  shape(lrarrow,width/2-30,0);
  popMatrix();
  
  
  strokeWeight(1);
  stroke(0);
  textSize(12);
  fill(0);
}
