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
  //Vec eyeDirection=new Vec(); // where camera is looking at from position
  Vec eyeRotation=new Vec(); // euler angles
  Vec upVector=new Vec(0, -1, 0);
  Vec baseVector=new Vec(0, 0, -1); // standard rotation direction

  P3DWindow() {
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
    //toggleFirstPerson();
  }

  void draw() {
    background(0);
    fill(204, 102, 0, 150);
    scene.drawTorusSolenoid(10, 20f);

    // Save the current model view matrix
    pushMatrix();
    // Multiply matrix to get in the frame coordinate system.
    // applyMatrix(Scene.toPMatrix(iFrame.matrix())); //is possible but inefficient
    iFrame.applyTransformation();//very efficient        

    // Draw an axis using the Scene static function
    //scene.drawAxes(100);

    // Draw a second torus
    //if (scene.motionAgent().defaultGrabber() == iFrame) {
    //  fill(0, 255, 255);
    //  scene.drawTorusSolenoid();
    //} else if (iFrame.grabsInput()) {
    //  fill(255, 0, 0);
    //  scene.drawTorusSolenoid(20);
    //} else {
    //  fill(0, 0, 255, 150);
    //  scene.drawTorusSolenoid();
    //}  

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

    if ((key=='p')||(key=='o')) {
      PVector dir=new PVector(0, 0, -1);
      if (key=='p') {
      }
      if (key=='o') {
        dir.mult(-1);
      }
      setEyeDirection(dir, 1);
    }

    if (key=='b') {
      setEyePosition(new PVector(0, 0, 100), 1);
      setEyeDirection(new PVector(0, 0, -1), 1);
    }
  }
  public void setEyePosition(PVector pos, float alphaEWMA) {    
    //pos.normalize();
    ////pos.mult(200);    
    //pos.x*=300;
    //pos.x-=200;    
    //pos.y*=400;
    ////pos.y-=200;
    pos.z*=0.3;
    pos.z=-pos.z;    
    pos.x-=actualCameraWidth/2;
    pos.x=-pos.x;
    pos.y-=actualCameraHeight/2;
    PVector previousPosition=PVectorFromVec(this.eyePosition);
    //pos=EWMA(previousPosition,pos,alphaEWMA);
    pos.x=EWMA(previousPosition.x, pos.x, alphaEWMA);
    pos.y=EWMA(previousPosition.y, pos.y, alphaEWMA);
    pos.z=EWMA(previousPosition.z, pos.z, alphaEWMA/3);
    this.eyePosition=VecFromPVector(pos);
    //println("pos:"+pos);
    updatePosition();
  }

  public void setEyeDirection(PVector dir, float alphaEWMA) {      
    Vec previousRotation=this.eyeRotation;
    Vec currentRotation=directionToEulerAngles(VecFromPVector(dir), upVector);
    this.eyeRotation=EWMA(previousRotation, currentRotation, alphaEWMA);
    updateRotation();
  }

  public Vec directionToEulerAngles(Vec dir, Vec up) {        
    // these values are named and calculated according to airplane flight conventions
    float pitch=asin(-dir.y());  
    float heading=atan2(dir.x(), dir.z());

    /* 
     Equations:
     cos(bank) = dot(up0,up)/(abs(up0)*abs(up))
     sin(bank) = dot(wing0,up)/(abs(wing0)*abs(up))
     */
    Vec wing0=new Vec(-dir.z(), dir.x(), 0);
    Vec up0=new Vec();
    Vec.cross(wing0, dir, up0);

    float bank=atan((Vec.dot(up0, up)/Vec.dot(wing0, up))*(up0.magnitude()/(wing0.magnitude())));
    bank=0; // ignore bank angle
    return new Vec(pitch, heading, bank);
  }

  public Quat eulerAnglesToQuat(Vec eulerAngles) {
    Quat q=new Quat();     
    q.fromEulerAngles(eulerAngles);
    return q;
  }

  public void updatePosition() {
    scene.eyeFrame().setPosition(this.eyePosition);
  }

  public void updateRotation() {    
    scene.eyeFrame().setRotation(eulerAnglesToQuat(this.eyeRotation));    

println(this.eyeRotation);  }
}