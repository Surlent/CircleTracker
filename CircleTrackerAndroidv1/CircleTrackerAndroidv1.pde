import ketai.camera.*;

int time;
// Whether to use the webcam to obtain an image
boolean usecam = true;

// Connected components in the current image
Components comp = new Components ();

// Filtered components
Components foundComp=new Components();

// The Android camera we'll be using if usecam is True
KetaiCamera cam;  
int camWidth=176,camHeight=144;
// Name of the image file if usecam is false
String imagename = "shapes.jpg";
// Image to be processed. Can also represent the camera
PImage img; 

// Rectangles to be tracked on the screen
ArrayList<Rectangle> trackingBounds=new ArrayList<Rectangle>();

// Determines whether to track components
boolean tracking=false;
// Sets minimum distances for components to be considered overlappingg
int overlapDistanceX=0;
int overlapDistanceY=1;

// Limits circles being tracked
float minCirclePerimeter=DiscreteCirclePerimeter(1);
float maxCirclePerimeter=DiscreteCirclePerimeter(50);

// Color array for drawing the components
color pallette [] = { color (random(255),random(255),random(255)) };



void setup() {
//colorMode(HSB);
//size(displayWidth,displayHeight);
  if (usecam) {
      orientation(LANDSCAPE);
      imageMode(CENTER);
      cam = new KetaiCamera(this,camWidth,camHeight,30);
      //Collection<? extends String> cameras=cam.list();
      cam.manualSettings();
      cam.setCameraID(1);
  } else {
    img = loadImage(imagename);
    //trackingRectangle=new Rectangle(0,0,img.width,img.height);
   // size(img.width,img.height);
  }
  //background (200);
  if (!usecam)
  {
    CreateComponents();
    FindCircles();
    DrawMarkers();
//    DrawDebugInfo();
  }
  
}

void draw() {
  if (usecam)
  {
    if (!cam.isStarted())
    {
      cam.start();
      ratioX=(float)width/(float)camWidth;
      ratioY=(float)height/(float)camHeight;
      println("rX:"+ratioX+",rY:"+ratioY);
    }
  }
  if (img!=null)
  {
    CreateComponents();
    FindCircles();
    DrawMarkers();
   // DrawDebugInfo();
  }  
}

void onCameraPreviewEvent()
{
  cam.read();
  img=cam;
  image (img, width/2, height/2,width,height);
}

// start/stop camera preview by tapping the screen
void mousePressed()
{
  if (cam.isStarted())
  {
    cam.stop();
  }
  else
    cam.start();
}
