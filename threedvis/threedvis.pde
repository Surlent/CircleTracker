float centerDistance=1000;
float cameraYAngle=0;
float cameraXAngle=0;
PVector cameraPosition=new PVector(0,0,1000),cameraCenter;

float rotationY=0,rotationX=0,translationX,translationZ;



boolean mouseDown=false;
PShape s;
PShape xAxis,yAxis,zAxis;

float baseSpeed=15;
PVector objectPosition;
PVector objectSpeed=new PVector(0,0,0);

float mouseXPrev,mouseYPrev;

void keyPressed(){    
    if (key == 'w' || key == 'W') {
       objectSpeed.z-=baseSpeed;
    }
    if (key == 's' || key == 'S') {
       objectSpeed.z+=baseSpeed;
    }
    if (key == 'a' || key == 'A') {           
       objectSpeed.x-=baseSpeed;    
    }
    if (key == 'd' || key == 'D') {
       objectSpeed.x+=baseSpeed; 
    }       
}

void keyReleased(){    
    if (key == 'w' || key == 'W') {
       objectSpeed.z+=baseSpeed;
    }
    if (key == 's' || key == 'S') {
       objectSpeed.z-=baseSpeed;
    }
    if (key == 'a' || key == 'A') {           
       objectSpeed.x+=baseSpeed;    
    }
    if (key == 'd' || key == 'D') {
       objectSpeed.x-=baseSpeed; 
    }        
}

void setup() {
  size(1000, 600, P3D); 
  s=loadShape("wolf/wolf.obj");
  xAxis=createShape();
  yAxis=createShape();
  zAxis=createShape();
  s.rotateZ(PI);
  s.rotateY(PI);
  objectPosition=new PVector(0,-100,0);
  //camera(camX,camY, camZ,objectPosition.x,objectPosition.y,objectPosition.z, 0, 1, 0);
  
}

void draw() {
  if(mousePressed){    
    if(!mouseDown)
    {
      mouseDown=true;
      mouseXPrev=mouseX;
      mouseYPrev=mouseY;
    }
    cameraYAngle+=0.01*(mouseX-mouseXPrev);
    cameraXAngle+=0.01*(mouseY-mouseYPrev);
    //println(cameraYAngle);
    
    cameraPosition.x=objectPosition.x+centerDistance*cos(cameraYAngle);    
    //camY=centerDistance*sin(cameraXAngle);
    cameraPosition.z=objectPosition.z+centerDistance*sin(cameraYAngle); 
    mouseXPrev=mouseX;
    mouseYPrev=mouseY;
  }
  else{
    mouseDown=false;
  }  
  
  background(0);
  
  //stroke(255);
  //camera(camX, camY, camZ, 0, 0, 0, 0, 1, 0);
  
  //s.rotateY(rotationY);
  //s.rotateX(rotationX);
  //camera(camX, camY, camZ, 0,0,0, 0, 1, 0);
  
  s.translate(objectSpeed.x,objectSpeed.y,objectSpeed.z);
  objectPosition.set(objectPosition.x+objectSpeed.x,objectPosition.y+objectSpeed.y,objectPosition.z+objectSpeed.z);
  cameraPosition.set(cameraPosition.x+objectSpeed.x,cameraPosition.y+objectSpeed.y,cameraPosition.z+objectSpeed.z);
  cameraCenter=objectPosition;
  
  s.setFill(color(255));
  
  shape(s);  
  camera(cameraPosition.x,cameraPosition.y, cameraPosition.z,cameraCenter.x,cameraCenter.y,cameraCenter.z, 0, 1, 0);
  //perspective();
  
  xAxis.setStroke(color(255,0,0));
  drawLine(xAxis,new PVector(0,0,0),new PVector(1000,0,0));
  
  yAxis.setStroke(color(0,255,0));
  drawLine(yAxis,new PVector(0,0,0),new PVector(0,1000,0));
  
  zAxis.setStroke(color(0,0,255));
  drawLine(zAxis,new PVector(0,0,0),new PVector(0,0,1000));
  
  pushMatrix();
  translate(objectPosition.x,objectPosition.y,objectPosition.z);
  stroke(255,0,0);
  sphere(3);
  popMatrix();
  // Reset speeds
  //objectSpeed=new PVector(0,0,0);
  //noFill();
  //box(objWidth);
  //box(objWidth/2);
  //sphere(3);
  //camera(camX, camY, camZ, 0, 0, 0, 0, 1, 0);
}

void drawLine(PShape axis,PVector p1,PVector p2){    
    axis.beginShape();
    axis.vertex(p1.x,p1.y,p1.z);
    axis.vertex(p2.x,p2.y,p2.z);
    axis.endShape();
    shape(axis);
}