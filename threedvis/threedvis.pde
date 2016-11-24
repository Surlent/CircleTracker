
float centerDistance=sqrt(pow(width/2,2)+pow(height/2,2));
float cameraYAngle=0;
float camX=centerDistance*cos(cameraYAngle),camY=height/2,camZ=centerDistance*sin(cameraYAngle);

boolean mouseDown=false;

void setup() {
  size(640, 360, P3D);  
}

float mouseXPrev;

void draw() {
  background(0);
  if(mousePressed){    
    if(!mouseDown)
    {
      mouseDown=true;
      mouseXPrev=mouseX;
    }
    cameraYAngle=(mouseX-mouseXPrev);
    mouseXPrev=mouseX;
    camX=centerDistance*cos(cameraYAngle);
    camZ=centerDistance*sin(cameraYAngle);
    
  }
  else{
    mouseDown=false;
  }  
  camera(camX, camY, camZ, width/2, height/2, 0, 0, 1, 0);
  translate(width/2, height/2, -100);
  stroke(255);
  noFill();
  box(200);
}