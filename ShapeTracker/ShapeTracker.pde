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
      if (detectionButton.isPressed())
      {
        CreateComponents();
      }
      if (detectionButton.isPressed()&&trackingButton.isPressed())
      {
        //FindSquares();
        FindCircles();                   
        tracker.setTracking(true);
        tracker.setTrackedObject(foundObjects);
        tracker.setCircleTrackingBounds();        
        tracker.update();
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
}