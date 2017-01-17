// Whether to use the webcam to obtain an image
boolean usecam = true;

P3DWindow win;

// The webcam we'll be using if usecam is True
Capture cam;  

// Name of the image file if usecam is false
String imagename = "equidistantcircles2.png";

// Starting values for color picker
float baseHue=180;
float baseSaturation=100;
float baseBrightness=100;
float colorConfidenceInterval=0.3;

// Limits circles being tracked
float minCircleRadius=10;
float maxCircleRadius=1000;

// Camera size
String cameraSize="640x480";

// Area of camera frame
int cameraArea;

// Frames per second, if available for current camera size
int fps;
int desiredFPS=10;

boolean resized=false;
int frameCounter=1;

// Sliders
HScrollBar hueSlider;
HScrollBar saturationSlider;
HScrollBar brightnessSlider;
Button detectionButton; // Activates detection of connected components
Button trackingButton; // Activates tracking of circles
float wheelCount; // Tracks motion in mouse wheel

// Limit squares being tracked
float minSquarePerimeter=DiscreteSquarePerimeter(10);
float maxSquarePerimeter=DiscreteSquarePerimeter(200);

// Connected components in the current image
Components connectedComponents;

// Filtered components
Trackable foundObjects;

// Keeps track of information about found objects
Tracker tracker = new Tracker();

// Image to be processed
PImage img; 

// Screen ratios for drawing
float ratioX=1;
float ratioY=1;

// Sets minimum distances for components to be considered overlappingg
int overlapDistanceX=0; // Should be set to 0 if no space between pixels is allowed
int overlapDistanceY=1; // Should be set to 1 if no space between pixels is allowed

// Color array for drawing the components
color pallette [] = { color (random(255), random(255), random(255)) };

// This is the function that tells whether a pixel is of 
// the desired color
float rightHueLower;//=180;
float rightHueUpper;//=220;
float rightSaturationLower;//=0.5;
float rightSaturationUpper;//=1;
float rightBrightnessLower;//=0.3;
float rightBrightnessUpper;//=1;

boolean HasRightColor (color c) {
  colorMode(HSB, 360, 100, 100);
  float hue=hue(c); 
  float saturation=saturation(c);
  float brightness=brightness(c);
  boolean hueFilter=(hue>=rightHueLower&&hue<=rightHueUpper);
  boolean saturationFilter=saturation>=rightSaturationLower&&saturation<=rightSaturationUpper;
  boolean brightnessFilter=brightness>=rightBrightnessLower&&brightness<=rightBrightnessUpper;
  colorMode(RGB, 255);
  return hueFilter&&brightnessFilter&&saturationFilter;
}


// Rectangles to be tracked on the screen


void CreateComponents()
{    
  if (tracker.isTracking())
  {
    if (foundObjects.size()>=3){
      connectedComponents=new Components(img, tracker.getTrackingBounds());
    }
    else{
      connectedComponents=new Components(img);
    }
  } else
  {
    connectedComponents=new Components(img);
  }  
}

// Obtains a list of segments of pixel ranges in line y of the given
// image containing pixels of the 'right' color
SegmentList SegmentRow (PImage img, int y, Rectangle r) {
  SegmentList result = new SegmentList ();
  int x0, x;
  x0 = 0;
  boolean inside = false;
  for (x = (int)r.getX(); x < r.getX()+r.getWidth(); ++x) {
    boolean right = HasRightColor (img.get(x, y));
    if (right != inside) {
      if (inside) {
        result.add (new Segment (y, x0, x-1));
      } else {
        x0 = x;
      }
      inside = right;
    }
  }
  if (inside) {
    result.add (new Segment (y, x0, x-1));
  }
  return result;
}

SegmentList SegmentRow (PImage img, int y) {
  return SegmentRow(img, y, new Rectangle(0, 0, img.width, img.height));
}

// This function is not symmetrical in relation to a and b
boolean NearEqual(float a, float b, float delta, float factor)
{
  return abs(a-b*factor)<=delta;
}
boolean NearEqual(float a, float b, float delta)
{
  return NearEqual(a, b, delta, 1);
}

// Fills the pallette with n colors, maintaining the ones already present
void FillPallette (int n) {
  int m = pallette.length;
  if (n > m) {
    pallette = (color []) expand(pallette, n);
    for (int i = m; i < n; i++) {
      pallette [i] = color(random(255), random(255), random (255));
    }
  }
}

// Chooses a camera
String ChooseCamera(String[] cameras) {
  String chosenCamera="";

  // Works only if fps and size information is embedded      
  for (String s : cameras)
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
  if (chosenCamera=="") {        
    chosenCamera=cameras[0]+",size="+cameraSize+",fps="+desiredFPS;
  }
  String[] sizeInfo=cameraSize.split("x");
  int cameraWidth=Integer.parseInt(sizeInfo[0]);
  int cameraHeight=Integer.parseInt(sizeInfo[1]);
  cameraArea=cameraWidth*cameraHeight;
  println(cameraArea);
  return chosenCamera;
}

// Starts chosen camera
void StartCamera() {
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    // Allow window to resize to camera resolution
    if (surface != null) {
      surface.setResizable(true);
    }      
    String chosenCamera=ChooseCamera(cameras);
    int fpsIndex=chosenCamera.indexOf("fps=")+4;
    println(chosenCamera);
    fps=Integer.parseInt(chosenCamera.substring(fpsIndex));

    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, chosenCamera);
    cam.start();    
    println("Camera loading...");
  }
}

// Draw an arrow from p1 to p2
void Arrow(PVector p1, PVector p2) {
  float x1=p1.x;
  float y1=p1.y;
  float x2=p2.x;
  float y2=p2.y;
  line(x1, y1, x2, y2);
  pushMatrix();
  translate(x2, y2);
  float a = atan2(x1-x2, y2-y1);
  rotate(a);
  line(0, 0, -10, -10);
  line(0, 0, 10, -10);
  popMatrix();
} 

// Draw an arrow from p2 to p1
void ReverseArrow(PVector p1,PVector p2){
  Arrow(p2,p1);
}

float DecreasingFunction(float radius){
  return 1/radius;
}

float IncreasingFunction(float radius){
  return 0.1*log(radius);
}

void DrawDebugInfo()
{      
  println ("Components Size:"+((connectedComponents!=null)?(connectedComponents.size()):(0)));
  println ("Objects Size:"+((foundObjects!=null)?(foundObjects.size()):(0)));
  int i=0;
  if (trackingButton.isPressed()) {
    for (SegmentList sl : foundObjects) {
      float x=sl.getCentroidX();
      float y=sl.getCentroidY();
      println("i="+i+",x="+x+",y="+y);
      point(x, y);      
      i++;
    }
    PVector trackerPosition=tracker.getPosition();       
    i=0;
    for(PVector p:tracker.trackedObject.componentCentroids){
      Arrow(trackerPosition,p);             
      //println("DirVector"+i+":"+PVector.sub(trackerPosition,p).mult(IncreasingFunction(tracker.trackedObject.componentAreas.get(i))));
      //println("Area:"+tracker.trackedObject.componentAreas.get(i));
      i++;
    }
    stroke(255,255,255);
    Arrow(trackerPosition,PVector.add(trackerPosition,tracker.trackedObject.direction.mult(100)));
    ellipse(trackerPosition.x,trackerPosition.y,10,10);
    println("Position:"+tracker.x);
    println("Direction:"+tracker.dx);
  }
}