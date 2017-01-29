/**
 * First Person Camera.
 * by Jean Pierre Charalambos.
 * 
 * This example illustrates how to set up mouse bindings to control the camera
 * as in first-person mode.
 * 
 * Press 'h' to display the key shortcuts and mouse bindings in the console.
 */

import remixlab.proscene.*;
import remixlab.dandelion.geom.*;

class P3DWindow extends PApplet {

  Scene scene;
  InteractiveFrame iFrame;
  boolean firstPerson=false;
  Vec eyePosition=new Vec(); // camera position
  Vec eyeDirection=new Vec(); // where camera is looking at from position
  Vec baseVector=new Vec(0,0,-1); // standard rotation direction
  
  P3DWindow(){
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }
  
  public void settings() {
    size(800, 600, "processing.opengl.PGraphics3D");
  }

  void setup() {      
    scene = new Scene(this);  
    iFrame = new InteractiveFrame(scene);
    iFrame.translate(30, 30);
    toggleFirstPerson();
  }

  void draw() {
    background(0);
    fill(204, 102, 0, 150);
    scene.drawTorusSolenoid(20);

    // Save the current model view matrix
    pushMatrix();
    // Multiply matrix to get in the frame coordinate system.
    // applyMatrix(Scene.toPMatrix(iFrame.matrix())); //is possible but inefficient
    iFrame.applyTransformation();//very efficient        
    
    // Draw an axis using the Scene static function
    scene.drawAxes(20);

    // Draw a second torus
    if (scene.motionAgent().defaultGrabber() == iFrame) {
      fill(0, 255, 255);
      scene.drawTorusSolenoid();
    } else if (iFrame.grabsInput()) {
      fill(255, 0, 0);
      scene.drawTorusSolenoid(20);
    } else {
      fill(0, 0, 255, 150);
      scene.drawTorusSolenoid();
    }  

    popMatrix();
    
    //Vec baseVector=new Vec(0,0,-1);
    //Vec dir=new Vec(0,0,0.05);
    //float rx=Vec.angleBetween(baseVector,new Vec(0,dir.y(),dir.z()));
    //float ry=Vec.angleBetween(baseVector,new Vec(dir.x(),0,dir.z()));
    //float rz=Vec.angleBetween(baseVector,new Vec(dir.x(),dir.y(),0));
    //Vec rot=new Vec(rx,ry,rz);        
    //if (keyPressed){
    //  Quat prev=new Quat();      
    //  if(key=='p'){        
    //    prev.fromEulerAngles(rot);      
    //    scene.eyeFrame().rotate(prev);
    //  }
    //  if(key=='o'){
    //    rot.multiply(-1);
    //    prev.fromEulerAngles(rot);      
    //    scene.eyeFrame().rotate(prev);
    //  }
    //  println(rot);
    //}
  }

  public void toggleFirstPerson() {
    firstPerson = !firstPerson;
    if (firstPerson) {
      scene.eyeFrame().setMotionBinding(MouseAgent.NO_BUTTON, "lookAround");
      scene.eyeFrame().setMotionBinding(LEFT, "moveForward");
      scene.eyeFrame().setMotionBinding(RIGHT, "moveBackward");
    } else {
      scene.eyeFrame().removeMotionBinding(MouseAgent.NO_BUTTON);
      scene.eyeFrame().setMotionBinding(LEFT, "rotate");
      scene.eyeFrame().setMotionBinding(RIGHT, "translate");
    }
  }

  public void keyPressed() {
    if ( key == 'i')
      scene.inputHandler().shiftDefaultGrabber(scene.eyeFrame(), iFrame);
    if ( key == ' ')
      toggleFirstPerson();
    if (key == '+')
      scene.eyeFrame().setFlySpeed(scene.eyeFrame().flySpeed() * 1.1);
    if (key == '-')
      scene.eyeFrame().setFlySpeed(scene.eyeFrame().flySpeed() / 1.1); 
        
    if ((key=='p')||(key=='o')){
      PVector dir=new PVector(0,0,-1);
      if(key=='p'){                          
      }
      if(key=='o'){
        dir.mult(-1);        
      }
      setEyeDirection(dir);        
    }
    
    if (key=='b'){
      setEyePosition(new PVector(0,0,100),1);
      setEyeDirection(new PVector(0,0,-1));
    }
  }
  public void setEyePosition(PVector pos,float alphaEWMA){
    pos.normalize();
    pos.mult(200);
    pos.x-=100;
    pos.x=-pos.x;
    pos.z=-pos.z;
    pos.x=round(pos.x);
    pos.y=round(pos.y);
    pos.z=round(pos.z);
    PVector previousPosition=PVectorFromVec(this.eyePosition);
    pos=EWMA(previousPosition,pos,alphaEWMA);    
    this.eyePosition=VecFromPVector(pos);
    println("pos:"+pos);
    updatePosition();
  }
  
  public void setEyeDirection(PVector dir){  
    PVector previousDirection=PVectorFromVec(this.eyeDirection);
    dir=EWMA(previousDirection,dir,0.4);
    this.eyeDirection=VecFromPVector(dir);    
    updateRotation();    
  }
  
  public Quat directionToRotation(Vec dir){
    float rx=Vec.angleBetween(baseVector,new Vec(0,dir.y(),dir.z()));
    float ry=Vec.angleBetween(baseVector,new Vec(dir.x(),0,dir.z()));
    float rz=Vec.angleBetween(baseVector,new Vec(dir.x(),dir.y(),0));
    Quat prev=new Quat(); 
    Vec rot=new Vec(rx,ry,rz); 
    prev.fromEulerAngles(rot);
    return prev;
  }
  public void updatePosition(){
    scene.eyeFrame().setPosition(this.eyePosition);
  }
  
  public void updateRotation(){
    Quat eyeRotation=directionToRotation(this.eyeDirection);
    scene.eyeFrame().setRotation(eyeRotation);
  }
}