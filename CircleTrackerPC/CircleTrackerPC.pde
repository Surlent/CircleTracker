import processing.video.*;

int time;
// Whether to use the webcam to obtain an image
boolean usecam = true;

// The webcam we'll be using if usecam is True
Capture cam;  

// Name of the image file if usecam is false
String imagename = "arcadebubbles.jpg";

// Camera size
String cameraSize="640x480";

// Frames per second, if available for current camera size
int fps;
int desiredFPS=10;

// Sliders
HScrollBar hueSlider;
HScrollBar saturationSlider;
HScrollBar brightnessSlider;
Button detectionButton; // Activates detection of connected components
Button trackingButton; // Activates tracking of circles
float wheelCount; // Tracks motion in mouse wheel

void setup() {    
  if (usecam) {
    String[] cameras = Capture.list();

    if (cameras.length == 0) {
      println("There are no cameras available for capture.");
      exit();
    } else {
      // Allow window to resize to camera resolution
      if (surface != null) {
        surface.setResizable(true);
      }
      
      // Chooses the camera
      String chosenCamera="";
      
      // Works only if fps and size information is embedded      
      for(String s:cameras)
      {
        //println(s);
        if (s.indexOf("size="+cameraSize)!=-1)
        {
          if (chosenCamera=="")
          {
            chosenCamera=s;
          }
          if (s.indexOf("fps="+desiredFPS)!=-1)
          {
            chosenCamera=s;
            break;
          }
        }
      }
      // Attempts to force given size and fps
      if(chosenCamera==""){        
        chosenCamera=cameras[0]+",size="+cameraSize+",fps="+desiredFPS;
      }
      int fpsIndex=chosenCamera.indexOf("fps=")+4;
      println(chosenCamera); 
      fps=Integer.parseInt(chosenCamera.substring(fpsIndex));
      
      
      // The camera can be initialized directly using an 
      // element from the array returned by list():
      cam = new Capture(this, chosenCamera);
      cam.start();
     println("Camera loading..."); 
    }
  } else {
    img = loadImage(imagename);
    if(img!=null)
    {
      surface.setSize((int)(img.width*1.5),img.height);
      hueSlider = new HScrollBar((img.width*1.1), (img.height*0.2), (img.width*0.3), (img.height*0.03), 1,0,0,0,100,4,0.3); // Initializes slider
      saturationSlider = new HScrollBar((img.width*1.1), (img.height*0.4), (img.width*0.3), (img.height*0.03), 1,1,hueSlider.getHue(),hueSlider.getSaturation(),hueSlider.getBrightness(),4,0.3); // Initializes slider
      brightnessSlider = new HScrollBar((img.width*1.1), (img.height*0.6), (img.width*0.3), (img.height*0.03), 1,2,hueSlider.getHue(),hueSlider.getSaturation(),hueSlider.getBrightness(),4,0.3); // Initializes slider
      float buttonWidth=img.width*0.11;
      detectionButton = new Button((img.width*1.1)+((img.width*0.3)/2-buttonWidth)/2, (img.height*0.8), buttonWidth, (img.height*0.05),"Detect",color(255,255,255),color(130,130,130),color(0,0,0));
      trackingButton = new Button((img.width*1.1)+(img.width*0.3)/2+((img.width*0.3)/2-(buttonWidth))/2, (img.height*0.8), buttonWidth, (img.height*0.05),"Track",color(255,255,255),color(130,130,130),color(0,0,0));
    }
    else
    {
      exit();
    } 
  }
  //background (200);
  if (!usecam)
  {
    
    //CreateComponents();
    //FindCircles();
    //DrawMarkers();
//    DrawDebugInfo();
  }
  
}

// Triggers control bar resize
void mouseWheel(MouseEvent event) {
  wheelCount = event.getCount();  
}

boolean resized=false;
int frameCounter=1;
void draw() {
  if (usecam)
  {
    if (cam.available() == true) {      
      cam.read();
      img=cam;
      if (!resized)
      {
        println("Camera loaded");
        surface.setSize((int)(img.width*1.5),img.height);
        //hueSlider = new HScrollBar((int)(img.width*1.1), (int)(img.height*0.2), (int)(img.width*0.3), (int)(img.height*0.03), 1); // Initializes slider
        hueSlider = new HScrollBar((img.width*1.1), (img.height*0.2), (img.width*0.3), (img.height*0.03), 1,0,360,100,100,4,0.3); // Initializes slider
        saturationSlider = new HScrollBar((img.width*1.1), (img.height*0.4), (img.width*0.3), (img.height*0.03), 1,1,hueSlider.getHue(),hueSlider.getSaturation(),hueSlider.getBrightness(),4,0.3); // Initializes slider
        brightnessSlider = new HScrollBar((img.width*1.1), (img.height*0.6), (img.width*0.3), (img.height*0.03), 1,2,hueSlider.getHue(),hueSlider.getSaturation(),hueSlider.getBrightness(),4,0.3); // Initializes slider
        float buttonWidth=img.width*0.11;
        detectionButton = new Button((img.width*1.1)+((img.width*0.3)/2-buttonWidth)/2, (img.height*0.8), buttonWidth, (img.height*0.05),"Detect",color(255,255,255),color(130,130,130),color(0,0,0));
        trackingButton = new Button((img.width*1.1)+(img.width*0.3)/2+((img.width*0.3)/2-(buttonWidth))/2, (img.height*0.8), buttonWidth, (img.height*0.05),"Track",color(255,255,255),color(130,130,130),color(0,0,0));
        resized=true;    
      }
    }
  }
  if (detectionButton!=null)
  {
    boolean detectionButtonPressed=detectionButton.isPressed();
    detectionButton.update();
    if (detectionButton.isPressed()!=detectionButtonPressed)
    {
      detectionButton.setText((detectionButton.isPressed())?("Undetect"):("Detect"));
      println("Detection "+((detectionButton.isPressed()==true)?("started"):("stopped")));
      if(!detectionButton.isPressed())
      {
        trackingButton.pressed=false;          
        foundComp=null;
        trackingBounds=null;
        tracking=false;
      } 
    }
    detectionButton.display();  
  }
  if (trackingButton!=null)
  {
    if (detectionButton.isPressed())
    {
      boolean trackingButtonPressed=trackingButton.isPressed();
      trackingButton.update();
      if (trackingButton.isPressed()!=trackingButtonPressed)
      {
        trackingButton.setText((trackingButton.isPressed())?("Untrack"):("Track"));
        println("Tracking "+((trackingButton.isPressed()==true)?("started"):("stopped")));
       if(!trackingButton.isPressed())
       {
          foundComp=null;
          trackingBounds=null;
          tracking=false;
       } 
      }
    }
    trackingButton.display();  
  }
  if (hueSlider!=null)
  { 
    hueSlider.setSaturation(saturationSlider.getSaturation());
    hueSlider.setBrightness(brightnessSlider.getBrightness());
    hueSlider.update();
    hueSlider.display();
    saturationSlider.setHue(hueSlider.getHue());
    saturationSlider.setBrightness(brightnessSlider.getBrightness());
    saturationSlider.update();
    saturationSlider.display();
    brightnessSlider.setSaturation(saturationSlider.getSaturation());
    brightnessSlider.setHue(hueSlider.getHue());
    brightnessSlider.update();
    brightnessSlider.display();
    rightHueLower=hueSlider.getLowerValue();
    rightSaturationLower=saturationSlider.getLowerValue();
    rightBrightnessLower=brightnessSlider.getLowerValue();
    rightHueUpper=hueSlider.getUpperValue();
    rightSaturationUpper=saturationSlider.getUpperValue();
    rightBrightnessUpper=brightnessSlider.getUpperValue();
    //println("lowerHue:"+rightHueLower+",upperHue:"+rightHueUpper+",lowerSaturation:"+rightSaturationLower+",upperSaturation:"+rightSaturationUpper+",lowerBrightness:"+rightBrightnessLower+",upperBrightness:"+rightBrightnessUpper);
  }
  if (((frameCounter)<=fps/desiredFPS&&(fps>desiredFPS))||(fps<=desiredFPS))
  {  
    if (img!=null)
    {
      image (img, 0, 0);
      if(detectionButton.isPressed())
      {
        CreateComponents();
      }
      if(detectionButton.isPressed()&&trackingButton.isPressed())
      {
        FindCircles();
      }
      if (detectionButton.isPressed()||trackingButton.isPressed())
      {
        DrawMarkers();
        //DrawDebugInfo(); 
      }
    }
  } 
  frameCounter++; 
  if(frameCounter>desiredFPS)
  {
    frameCounter=1;
  }
}