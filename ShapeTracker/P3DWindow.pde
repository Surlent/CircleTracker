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
  Vec eyePosition=new Vec();
  Quat eyeOrientation=new Quat();
  
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
    //toggleFirstPerson();
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
  }
  
  public void setEyePosition(PVector pos){
    pos.normalize();
    pos.mult(100);
    pos.x-=100;
    pos.x=-pos.x;
    pos.z=-pos.z;
    pos.x=round(pos.x);
    pos.y=round(pos.y);
    pos.z=round(pos.z);
    PVector previousPosition=new PVector(this.eyePosition.x(),this.eyePosition.y(),this.eyePosition.z());
    pos=EWMA(previousPosition,pos,0.4);
    this.eyePosition.setX(pos.x);
    this.eyePosition.setY(pos.y);
    this.eyePosition.setZ(pos.z);          
    println("pos:"+pos);
    updatePosition();
  }
  
  public void updatePosition(){
    scene.eyeFrame().setPosition(eyePosition);
  }
  
  public void updateDirection(){
  }
}