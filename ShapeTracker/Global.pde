// Whether to use the webcam to obtain an image
boolean usecam = false;

// The webcam we'll be using if usecam is True
Capture cam;  

// Name of the image file if usecam is false
String imagename = "shapes.jpg";

// Camera size
String cameraSize="640x480";

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


// Connected components in the current image
Components comp = new Components ();
// Filtered components
Components foundComp=new Components();
// Image to be processed
PImage img; 

// Screen ratios for drawing
float ratioX=1;
float ratioY=1;;

// Determines whether components are being tracked
boolean tracking=false;

// Sets minimum distances for components to be considered overlappingg
int overlapDistanceX=0; // Should be set to 0 if no space between pixels is allowed
int overlapDistanceY=1; // Should be set to 1 if no space between pixels is allowed

// Limits circles being tracked
float minCirclePerimeter=DiscreteCirclePerimeter(5);
float maxCirclePerimeter=DiscreteCirclePerimeter(100);

// Limit squares being tracked
float minSquarePerimeter=DiscreteSquarePerimeter(10);
float maxSquarePerimeter=DiscreteSquarePerimeter(200);
// Color array for drawing the components
color pallette [] = { color (random(255),random(255),random(255)) };

// This is the function that tells whether a pixel is of 
// the desired color
float rightHueLower=180;
float rightHueUpper=220;
float rightSaturationLower=0.5;
float rightSaturationUpper=1;
float rightBrightnessLower=0.3;
float rightBrightnessUpper=1;

boolean HasRightColor (color c) {
  colorMode(HSB,360,100,100);
  float hue=hue(c); 
  float saturation=saturation(c);
  float brightness=brightness(c);
  boolean hueFilter=(hue>=rightHueLower&&hue<=rightHueUpper);
  boolean saturationFilter=saturation>=rightSaturationLower&&saturation<=rightSaturationUpper;
  boolean brightnessFilter=brightness>=rightBrightnessLower&&brightness<=rightBrightnessUpper;
  colorMode(RGB,255);
  return hueFilter&&brightnessFilter&&saturationFilter;
}


// Rectangles to be tracked on the screen
ArrayList<Rectangle> trackingBounds;

void CreateComponents()
{    
    if (tracking)
    {
      comp = new Components (img,trackingBounds);
    }
    else
    {
      comp=new Components(img);
    }
}

// Obtains a list of segments of pixel ranges in line y of the given
// image containing pixels of the 'right' color
SegmentList SegmentRow (PImage img, int y,Rectangle r) {
  SegmentList result = new SegmentList ();
  int x0,x;
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
  return SegmentRow(img,y,new Rectangle(0,0,img.width,img.height));
}

// This function is not symmetrical in relation to a and b
boolean NearEqual(float a,float b,float delta,float factor)
{
  return abs(a-b*factor)<=delta;
}
boolean NearEqual(float a,float b,float delta)
{
  return NearEqual(a,b,delta,1);
}

// Fills the pallette with n colors, maintaining the ones already present
void FillPallette (int n) {
  int m = pallette.length;
  if (n > m)  {
    pallette = (color []) expand(pallette, n);
    for (int i = m; i < n; i++) {
       pallette [i] = color(random(255), random(255), random (255));
    }
  }
}

void DrawDebugInfo()
{    
    println ("Total Found Size:"+((foundComp!=null)?(foundComp.size()):(0)));
    println ("Total Size:"+((comp!=null)?(comp.size()):(0)));
}