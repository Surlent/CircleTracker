import processing.video.*;

void setup() {    
  if (usecam) {
    StartCamera();
  } else {
    img = loadImage(imagename);
    if (img!=null)
    {
      DrawControls();
    } else
    {
      exit();
    }
  }
  
  app=new P3DWindow();
}

// Triggers control bar resize on mouse wheel motion
void mouseWheel(MouseEvent event) {
  wheelCount = event.getCount();
}


void draw() {
  if (usecam)
  {
    if (cam.available() == true) {      
      cam.read();
      img=cam;
      if (!resized)
      {
        println("Camera loaded");
        DrawControls();
        resized=true;
      }
    }
  }  
  UpdateButtons();
  UpdateSliders();  

  if (((frameCounter)<=fps/desiredFPS&&(fps>desiredFPS))||(fps<=desiredFPS))
  {  
    if (img!=null)
    {
      image (img, 0, 0);
      if (detecting)
      {
        CreateComponents();
      }
      if (detecting&&tracking)
      {
        //FindSquares();
        FindCircles();                   
        tracker.setTracking(true);
        tracker.setTrackedObject(foundObjects);
        tracker.update();
        tracker.setCircleTrackingBounds();                
        // (
      }
      else{
        tracker.setTracking(false);
      }
      if (detectionButton.isPressed()||trackingButton.isPressed())
      {
        //DrawSquareMarkers();
        DrawCircleMarkers();
        DrawDebugInfo();
      }
    }
  } 
  frameCounter++; 
  if (frameCounter>desiredFPS)
  {
    frameCounter=1;
  }
  if (tracker.tracking&&tracker.hasCoordinates){   
    app.setEyePosition(tracker.position);
    //app.setEyePosition(0,0,100);    
  }
  
}