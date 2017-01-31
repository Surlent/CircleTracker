// Whether to use the webcam to obtain an image
boolean usecam = true;

boolean detecting, tracking=false;

P3DWindow app;

// The webcam we'll be using if usecam is True
Capture cam;  

// Name of the image file if usecam is false
String imagename = "equidistantcircles2.png";

// Starting values for color picker
float baseHue=180;
float baseSaturation=100;
float baseBrightness=50;
float hueConfidenceInterval=0.3;
float saturationConfidenceInterval=0.4;
float brightnessConfidenceInterval=0.3;//0.6;

// Limits circles being tracked
float minCircleRadius=5;
float maxCircleRadius=1000;
float minCircleArea=50;
float maxCircleArea=10000;
// Camera size
String cameraSize="640x480";

// Camera dimensions obtained on recording
int actualCameraWidth;
int actualCameraHeight;

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
float minSquarePerimeter=DiscreteSquarePerimeter(20);
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
int overlapDistanceX=5; // Should be set to 0 if no space between pixels is allowed
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