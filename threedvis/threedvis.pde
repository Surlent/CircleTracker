float centerDistance=300;
float cameraYAngle=0;
float cameraXAngle=0;
float camX=centerDistance*cos(cameraYAngle),camY=centerDistance*cos(cameraXAngle),camZ=centerDistance*sin(cameraYAngle);
float objWidth=200,objHeight=200,objDepth=200;
float rotationY=0,rotationX=0;
boolean mouseDown=false;
PShape s;
PShape xAxis,yAxis,zAxis;

void setup() {
  size(1000, 600, P3D); 
  s=loadShape("boeing/boeing.obj");
  xAxis=createShape();
  yAxis=createShape();
  zAxis=createShape();
  //s.rotateZ(PI);
  //s.rotateY(PI);
  //s.translate(width/2, height/2, -s.width);
  
}

float mouseXPrev,mouseYPrev;

void draw() {
  if(mousePressed){    
    if(!mouseDown)
    {
      mouseDown=true;
      mouseXPrev=mouseX;
      mouseYPrev=mouseY;
    }
    rotationY=-0.01*(mouseX-mouseXPrev);
    rotationX=-0.01*(mouseY-mouseYPrev);
    //cameraYAngle-=0.1*(mouseX-mouseXPrev);
    //cameraXAngle-=0.1*(mouseY-mouseYPrev);
    //println(cameraYAngle);
    
    //camX=centerDistance*cos(cameraYAngle);
    //camZ=centerDistance*sin(cameraYAngle);
    //camY=centerDistance*cos(cameraXAngle);
    mouseXPrev=mouseX;
    mouseYPrev=mouseY;
  }
  else{
    mouseDown=false;
    rotationY=0;
    rotationX=0;
  }  
  
  background(0);

  //translate(width/2, height/2, -objDepth);
  
  //stroke(255);
  //camera(camX, camY, camZ, 0, 0, 0, 0, 1, 0);
  translate(width/2, height/2, -s.width);
  //s.rotateY(rotationY);
  //s.rotateX(rotationX);
    
  s.setFill(color(255));
  
  shape(s);
  //perspective();
  /*
  xAxis.setStroke(color(255,0,0));
  xAxis.beginShape();
  xAxis.vertex(0,0,0);
  xAxis.vertex(1000,0,0);
  xAxis.endShape();
  shape(xAxis);
  
  yAxis.setStroke(color(0,255,0));
  yAxis.beginShape();
  yAxis.vertex(0,0,0);
  yAxis.vertex(0,1000,0);
  yAxis.endShape();
  shape(yAxis);
  
  zAxis.setStroke(color(0,255,255));
  zAxis.beginShape();
  zAxis.vertex(0,0,0);
  zAxis.vertex(0,0,1000);
  zAxis.endShape();
  shape(zAxis);
  */
  
  //noFill();
  //box(objWidth);
  //box(objWidth/2);
  sphere(3);
  //camera(camX, camY, camZ, 0, 0, 0, 0, 1, 0);
}